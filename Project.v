`timescale 1ns / 1ps
module Project(
	input clk, 	// 50 MHz
	input color_select,
	output o_hsync,      // horizontal sync
	output o_vsync,	    // vertical sync
	output [3:0] o_red,   // Red 
	output [3:0] o_blue,  // blue
	output [3:0] o_green  // green
);

	reg [9:0] counter_x = 0;  // horizontal counter for timing the horizontal componenet of display
	reg [9:0] counter_y = 0;  // vertical counter for timing the vertical component of display
	reg [3:0] r_red = 0;      // to store values of red blue and green respectively
	reg [3:0] r_blue = 0;
	reg [3:0] r_green = 0;
	
	reg reset = 0;  // for the clock divider generated with built in tools.
	
	wire clk25MHz;  // to store the divided clock and pass it on
	
	// clk divider 50 MHz to 25 MHz module initialized 
	Clk_50_to_25 ip1(.areset(reset),	.inclk0(clk),	.c0(clk25MHz),	.locked());  

	
	// counter and sync generation
	always @(posedge clk25MHz)  // horizontal counter
		begin 
			if (counter_x < 799)
				counter_x <= counter_x + 1;   
			else
				counter_x <= 0;              
		end  
	
	always @ (posedge clk25MHz)  // vertical counter
		begin 
			if (counter_x == 799)  
				begin
					if (counter_y < 525)  // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
						counter_y <= counter_y + 1;
					else
						counter_y <= 0;              
				end  
		end  

	
	// hsync and vsync output assignments synchronization bits needed at the start 
	assign o_hsync = (counter_x >= 0 && counter_x < 96) ? 1:0;  // hsync high for 96 counts                                                 
	assign o_vsync = (counter_y >= 0 && counter_y < 2) ? 1:0;   // vsync high for 2 counts
	// end hsync and vsync output assignments

	// pattern generate
		always @ (posedge clk)
		begin
			// SECTION 1
			if (counter_y < 135)
				begin              
					r_red <= 4'h0;    // white -> black
					r_blue <= 4'h0;
					r_green <= 4'h0;
				end  
			// END SECTION 1
			
			// SECTION 2
			else if (counter_y >= 135 && counter_y < 205)
				begin 
					if (counter_x < 324)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 324 && counter_x < 604)
						begin 
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end
							
						end  
					else if (counter_x >= 604)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end 
					end  
			// END SECTION 2
			
			// SECTION 3
			else if (counter_y >= 205 && counter_y < 217)
				begin 
					if (counter_x < 324)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  // if (counter_x < 324)
					else if (counter_x >= 324 && counter_x < 371)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end  
					else if (counter_x >= 371 && counter_x < 383)
						begin 
							r_red <= 4'h0;    // black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 383 && counter_x < 545)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end 
					else if (counter_x >= 545 && counter_x < 557)
						begin 
							r_red <= 4'h0;    // black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 557 && counter_x < 604)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end  
					else if (counter_x >= 604)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
				end  
		// END SECTION 3
			
		// SECTION 4
			else if (counter_y >= 217 && counter_y < 305)
				begin
					if (counter_x < 324)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 324 && counter_x < 604)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							if(((counter_x >= 371 && counter_x < 375) || (counter_x >= 553 && counter_x < 557)) && (counter_y >= 293 && counter_y <305))
								begin
								r_red <= 4'h0;    // black
								r_blue <= 4'h0;
								r_green <= 4'h0;	
								end
							else 
								begin
								r_red <= 4'h0;    // green
								r_blue <= 4'h0;
								r_green <= 4'hF;
								end 
							end
					else if (counter_x >= 604)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
				end  // END SECTION 4
			
			// SECTION 5
			else if (counter_y >= 305 && counter_y < 310)
				begin
					if (counter_x < 324)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 324 && counter_x < 371)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end 
					else if (counter_x >= 371 && counter_x < 557)
						begin 
							r_red <= 4'h0;    // black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 557 && counter_x < 604)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end  
					else if (counter_x >= 604)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  	
				end  
			// END SECTION 5
			
			// SECTION 6
			else if (counter_y >= 305 && counter_y < 414)
				begin
					if (counter_x < 324)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  
					else if (counter_x >= 324 && counter_x < 604)
						 if(color_select) 
						 begin
							r_red <= 4'hF;    // red
							r_blue <= 4'h0;
							r_green <= 4'h0;
							end
						else
						begin
							r_red <= 4'h0;    // green
							r_blue <= 4'h0;
							r_green <= 4'hF;
						end 
					else if (counter_x >= 604)
						begin 
							r_red <= 4'h0;    // white -> black
							r_blue <= 4'h0;
							r_green <= 4'h0;
						end  	
				end  // END SECTION 6
			
		// SECTION 7
			else if (counter_y <= 414)
				begin              
					r_red <= 4'h0;    // white -> black
					r_blue <= 4'h0;
					r_green <= 4'h0;
				end  // END SECTION 7
		end  
						
	

	
	// color assignments
	// only output the colors if the counters are within the adressable time constraints
	assign o_red = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_red : 4'h0;
	assign o_blue = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_blue : 4'h0;
	assign o_green = (counter_x > 144 && counter_x <= 783 && counter_y > 35 && counter_y <= 514) ? r_green : 4'h0;
	// end color output assignments
	
endmodule  