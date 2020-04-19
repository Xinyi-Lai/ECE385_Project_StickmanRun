//-------------------------------------------------------------------------
//    background.sv Spring 2020											 --
//    Adapted from Ball.sv, lab8                                         --
//    Store the position, motion and shape of the ground                 --
//    Tell the ColorMapper whether this pixel is a part of the stickman  --
//-------------------------------------------------------------------------


module ground ( input  	Clk,				// 50 MHz clock
						Reset,				// Active-high reset signal
						frame_clk,			// The clock indicating a new frame (~60Hz)
				input	playing,			// Game status
				input [9:0]   DrawX, DrawY,	// Current pixel coordinates
				output [9:0]  GroundY,		// The height of the floor at where the stickman stands 
				output logic  is_ground		// Whether current pixel belongs to ball or background
				);

	parameter [12:0] frame_counter_max = 13'd4095;
	parameter [9:0] screen_Xmax = 10'd639;			// Rightmost point on the X axis of the screen
	parameter [9:0] stickman_X = 10'd100 + 10'd20;	// centerleft x position of the stickman
	
	parameter [9:0] ground_height = 10'd360;		// attitude of ground
	parameter [9:0] upstair_height = 10'd300;
	parameter [9:0] downstair_height = 10'd420;
	parameter [9:0] obstacle_height = 10'd340; 
	parameter [9:0] pitfall_height = 10'd479; 
	
	logic [11:0] frame_counter, frame_counter_in;
	logic [9:0] height[frame_counter_max + screen_Xmax];


	// Detect rising edge of frame_clk
	logic frame_clk_delayed, frame_clk_rising_edge;
	always_ff @ (posedge Clk) begin
		frame_clk_delayed <= frame_clk;
		frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	end
	// Update registers
	always_ff @ (posedge Clk)
	begin
		if (Reset || !playing)
			frame_counter <= 12'd0;
		else
			frame_counter <= frame_counter_in;
	end

	// terrain
	always_comb
	begin 
		for (int i=0; i<screen_Xmax; i++)
			height[i] = ground_height;
		for (int i=screen_Xmax; i<700; i++) 
			height[i] = pitfall_height;
		for (int i=700; i<1000;i++) 
			height[i] = ground_height;
		for (int i=1000; i<1200;i++) 
			height[i] = upstair_height;
		for (int i=1200; i<1500;i++) 
			height[i] = ground_height;
		for (int i=1500; i<2000;i++) 
			height[i] = downstair_height;
		for (int i=2000; i<3000;i++) 
			height[i] = ground_height;
		for (int i=3000; i<4000;i++) 
			height[i] = upstair_height;
		for (int i=4000; i<frame_counter_max+screen_Xmax;i++) 
			height[i] = ground_height;
	end

	// frame counter
	always_comb
	begin
		// By default, unchanged
		frame_counter_in = frame_counter;
		// Update only at rising edge of frame clock
		if (frame_clk_rising_edge)
		begin
			if(frame_counter == frame_counter_max)
				frame_counter_in = 1'd0;
			else
				frame_counter_in = frame_counter + 2'd2;
		end
	end

	// Compute whether the pixel corresponds to the ground or background
	always_comb 
	begin
		if (DrawY >= height[frame_counter+DrawX]) //get the height threshold  
			is_ground = 1'b1;
		else
			is_ground = 1'b0;
	end

	assign GroundY = height[frame_counter + stickman_X];

endmodule