//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  score_keep ( input      Clk,                // 50 MHz clock
                                Reset,              // Active-high reset signal
                                frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]   keycode, 				 // Accept the last received key 
                    input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [15:0]  frame_counter, 		 // Accept from background
                    output logic  is_score,             // Whether current pixel belongs to ball or background
                    output logic  is_board
              );
    
	parameter [9:0] Board_Width = 10'd160;   //Define the width of the score keeping board
	parameter [9:0] Board_Height = 10'd100;   //Define the height of the score keeping board
	parameter [9:0] Board_X_Pos = 10'd0;   //Define the lenth of the score keeping board
	parameter [9:0] Board_Y_Pos = 10'd0;   //Define the lenth of the score keeping board
    parameter [9:0] Score1_X_Pos = 10'd30; //the most significant digit number (leftupmost position)
    parameter [9:0] Score1_Y_Pos = 10'd10;
    parameter [9:0] Score2_X_Pos = 10'd90; //the least significant digit number (leftupmost position)
    parameter [9:0] Score2_Y_Pos = 10'd10;


    parameter [7:0] unit_distance = 8'd60; // Score = frame_counter/unit_distance

    parameter [4:0] Text_Height = 5'd16;        // Height of the single score
    parameter [3:0] Text_Width = 4'd8;          // Width of the single score
    
    logic [7:0] Score, Score_in;                     //the score (survice distance)
    logic score_on;                //Tell whether the pixel belongs to score1 or score2 font
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Score = 8'd0;
        end
        else
        begin
            Score = Score_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Score_in = Score;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Score_in = frame_counter/unit_distance;
            Score_in = 8'd1; //test
        end
    end
    
    // Compute whether the pixel corresponds to rectangular board 
    
    always_comb begin
        if ( DrawX >= Board_X_Pos && DrawX < Board_X_Pos + Board_Width &&
             DrawY >= Board_Y_Pos && DrawY < Board_Y_Pos + Board_Height ) 
            is_board = 1'b1;
        else
            is_board = 1'b0;
    end    


    //Compute whether the pixel belongs to the score font.
    /* Since the dividers are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are divided. */

    int Scaled_X,scaled_Y; //the scaled difference betweent th epixel and the origin of score
    assign Scaled_X = (DrawX-Score1_X_Pos)/5;
    assign Scaled_Y = (DrawY-Score1_Y_Pos)/5;
    // assign DistX = DrawX - Ball_X_Pos;
    // assign DistY = DrawY - Ball_Y_Pos;
    // assign Size = Ball_Size;
    logic [10:0]sprite_adress;
    logic [7:0] sprite_data;

     always_comb begin
        if ( DrawX >=Score1_X_Pos && DrawX < Score1_X_Pos + Text_Width*5 &&
             DrawY >=Score1_Y_Pos && DrawY < Score1_Y_Pos + Text_Height*5) 
        begin    
            score_on = 1'b1;
            Scaled_X = (DrawX-Score1_X_Pos)/5;
            Scaled_Y = (DrawY-Score1_Y_Pos)/5;
            sprite_adress = Scaled_Y + Text_Height* 8'h30;
        end
        else if ( DrawX >=Score2_X_Pos && DrawX < Score2_X_Pos + Text_Width*5 &&
             DrawY >=Score2_Y_Pos && DrawY < Score2_Y_Pos + Text_Height*5) 
        begin
            score_on = 1'b1;
            Scaled_X = (DrawX-Score2_X_Pos)/5;
            Scaled_Y = (DrawY-Score2_Y_Pos)/5;
            sprite_adress = Scaled_Y + Text_Height* 8'h31;
            
        end
        else 
        begin
            score1_on = 1'b0;
            score2_on = 1'b0;
            sprite_adress = 10'b0;
        end
    end
    font_rom myscore(.addr(sprite_adress),.data(sprite_data));

    always_comb begin
        if (score_on==1'b1 && sprite_data[Scaled_X]== 1'b1)
            is_score = 1'b1;
        else
            is_score = 1'b0;
    end 

endmodule
