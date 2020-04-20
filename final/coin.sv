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


module  coin (	input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]   keycode, 				 // Accept the last received key 
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic  is_coin,             // Whether current pixel belongs to ball or background
               output logic  is_black,
               output logic [15:0] frame_counter
				);
    
    
    parameter [9:0] Coin_Size = 10'd10;        // Ball size
    parameter [5:0] Coin_Number = 6'd2;       // the number of coins in the background
    parameter [16:0] frame_counter_max =16'd2047 ;
	
	parameter [9:0] earth_height = 10'd410; 	 //Define the earth line
    parameter [9:0] obstacle_height = 10'd390; 
    parameter [9:0] pitfall_height = 10'd439; 
	parameter [9:0] Screen_max = 10'd639;     // Rightmost point on the X axis of the screen
    parameter [9:0] Coin_Height_Diff = 10'd200;
	 
    logic [9:0] Coin_X_Pos[Coin_Number]; // the X position on the screen
    logic [9:0] Coin_Y_Pos[Coin_Number]; // the Y position on the screen
    logic [15:0] Coin_frame[Coin_Number]; // the actual coin position in the whole background 
    
 //   logic [9:0] Coin_X_Pos3, Coin_Y_Pos3;
    logic is_coin_check[Coin_Number]; //check which coin the pixel belongs
    logic [5:0] sum_coin; //check if the pixel is in the coin 
	logic [15:0] frame_counter_in;
    logic [9:0] height[frame_counter_max+Screen_max];

    

    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            frame_counter <= 16'd0;
        end

        else
        begin
			frame_counter <=frame_counter_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    always_comb
    begin
        for (int i=0; i<300; i++) begin
			height[i] = earth_height;
		end

        for (int i=300; i<340; i++) begin
            height[i] = pitfall_height;
        end

        for (int i=340; i<800;i++) begin
            height[i] = earth_height;
        end

        for (int i=800; i<860;i++) begin
            height[i] = obstacle_height;
        end

        for (int i=840; i<frame_counter_max+Screen_max;i++) begin
            height[i] = earth_height;
        end
        
//        for (int i=0; i< Coin_Number;i++) begin
//            Coin_frame[i] = 16'd400 * i;
//        end
			Coin_frame[0] = 16'd400;
			Coin_frame[1] = 16'd820;
    end
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        frame_counter_in = frame_counter;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
                // Increment the frame_counter by 1 if it is less than frame_counter_max;
                // or start from the beginning again
			    frame_counter_in = frame_counter + 16'd1;
			    if(frame_counter + 16'd1 == frame_counter_max) 
				    frame_counter_in = 16'd0;

        end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */


    // int DistX, DistY, Size;
    // assign Coin_X_Pos = Coin_frame[1]-frame_counter;
    // assign Coin_Y_Pos = 200;
    // assign DistX = DrawX - Coin_X_Pos;
    // assign DistY = DrawY - Coin_Y_Pos;
    // assign Size = Coin_Size;

    int DistX[Coin_Number], DistY[Coin_Number], Size;
    assign Size = Coin_Size;

    always_comb begin 
        for (int i=0; i< Coin_Number;i++) begin
            Coin_X_Pos[i] = Coin_frame[i]-frame_counter;
            Coin_Y_Pos[i] = 10'd300;
            DistX[i] = DrawX - Coin_X_Pos[i];
            DistY[i] = DrawY - Coin_Y_Pos[i];
            
            if ( ( DistX[i]*DistX[i] + DistY[i]*DistY[i]) <= (Size*Size) ) 
                is_coin_check[i] = 1'b1;
            else
                is_coin_check[i] = 1'b0;
            
        end
		  sum_coin = 6'd0;
		  for  (int i=0; i< Coin_Number;i++) begin
                sum_coin  = sum_coin + is_coin_check[i];
          end
    end


    assign Size = Coin_Size;
    always_comb begin

    //Judge whether the pixel is black
        if (DrawY>=height[frame_counter+DrawX]) //get the height threshold  
            is_black = 1'b1;
        else
            is_black = 1'b0;
         

        if (sum_coin > 0)
            is_coin = 1'b1;
        else
            is_coin = 1'b0;
        
        // if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
        //            is_coin = 1'b1;
        // else
        //            is_coin = 1'b0;

//        for (int i=0; i< Coin_Number;i++) begin
//            if (Coin_frame[i] < (Screen_max+frame_counter) && Coin_frame[i]>frame_counter)
//            begin
//                Coin_X_Pos = Coin_frame[i] - frame_counter;
//                Coin_Y_Pos =  earth_height - Coin_Height_Diff; 
//                DistY = DrawY - Coin_Y_Pos;
//                DistX = DrawX - Coin_X_Pos;
//                if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
//                    is_coin = 1'b1;
//                else
//                    is_coin = 1'b0;
//            end
//            else
//					Coin_X_Pos = 10'd0;
//					Coin_Y_Pos = 10'd0;
//					DistY = DrawY - Coin_Y_Pos;
//               DistX = DrawX - Coin_X_Pos;
//               is_coin = 1'b0;
//        end

    end
    
endmodule
