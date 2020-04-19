//-------------------------------------------------------------------------
//    Color_Mapper.sv Spring 2020										 --
//    Adapted from Color_Mapper.sv, lab8                                 --
//    Map the pixel with a color                                         --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input is_stickman, is_ground,    // Whether current pixel belongs to the stickman or background
                       input [3:0] status,              // Game status {waiting, playing, win, lose}
                       input [9:0] DrawX, DrawY,        // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color
    always_comb
    begin

        // status = {waiting, playing, win, lose}
        unique case (status)

            // waiting
            4'b1000:
            begin
                Red = 8'h00;
                Green = 8'h00;
                Blue = 8'h80;
            end

            // win
            4'b0010:
            begin
                Red = 8'h80;
                Green = 8'h00;
                Blue = 8'h00;
            end

            // lose
            4'b0001:
            begin
                Red = 8'h00;
                Green = 8'h80;
                Blue = 8'h00;
            end

            // playing
            4'b0100:
            begin
                if (is_stickman == 1'b1) 
                begin
                    Red = 8'h00;
                    Green = 8'h00;
                    Blue = 8'h00;
                end

                else if (is_ground == 1'b1)
                begin
                    Red = 8'h40;
                    Green = 8'h40;
                    Blue = 8'h40;
                end

                else 
                begin
                    Red = 8'h4f; 
                    Green = 8'h4f;
                    Blue = 8'h7f - {1'b0, DrawX[9:3]};
                end
            end

            default: 
				begin
					 Red = 8'h00;
                Green = 8'h00;
                Blue = 8'h00;
				end

        endcase

    end 
    
endmodule
