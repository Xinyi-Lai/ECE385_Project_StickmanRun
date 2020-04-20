//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (  input               is_coin,            // Whether current pixel belongs to coin
                                                              //   calculetd by coin.sv
                        input               is_black,         //judge if the pixel belongs to ground
                        input               is_board,
                        input               is_score,
					    input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                        output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_coin == 1'b1) 
        begin
            // Red ball
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h00;
        end
        else if (is_score == 1'b1)
        begin
            Red = 8'd135;
            Green = 8'd206;
            Blue = 8'd235;
        end
        else if (is_board == 1'b1)
        begin
            Red = 8'd240;
            Green = 8'd130;
            Blue = 8'd140;
        end

        else if (is_black == 1'b1)
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        
        else 
        begin
            // Background with nice color gradient
            Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
        end
    end 
    
endmodule
