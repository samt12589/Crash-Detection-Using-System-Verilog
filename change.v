module change(clk,rst,sensout, trig,distf,distm,distl,disbar,hor_sync,ver_sync,red,green,blue);
input clk,rst,sensout;
output trig;
wire [8:0] distance;
output [9:0] disbar;

output [7:0] distf;
output [7:0] distm;
output [7:0] distl;

// Display variables and outputs
output hor_sync;
output ver_sync;
output [3:0] red;
output [3:0] green;
output [3:0] blue;

reg [10:0] dispf;
reg [10:0] dispm;
reg [10:0] displ;

wire gb_road;

// modules for sending sound waves and receiving any object waves reflected back
sendSignal(clk, rst, trig);
recieveSignal(clk,rst,sensout, distance);

// Converting the distance received into different bits for the 7-segment display
always @(posedge clk, posedge rst)
begin
dispf = (distance/100);
dispm = (distance-((dispf)*100))/10;
displ = ((distance - ((dispf))*100)) - dispm * 10;		
end
assign distf = 
    (dispf == 8'h9) ? 8'b10011000:
    (dispf == 8'h8) ? 8'b10000000:
    (dispf == 8'h7) ? 8'b11111000:
    (dispf == 8'h6) ? 8'b10000010:
    (dispf == 8'h5) ? 8'b10010010:
    (dispf == 8'h4) ? 8'b10011001:	//4
    (dispf == 8'h3) ? 8'b10110000: //3
    (dispf == 8'h2) ? 8'b10100100: //2
    (dispf == 8'h1) ? 8'b11111001: //1

	 8'b11000000;
	 
assign distl = 
	 
	 (dispm == 8'h9) ? 8'b10011000:
    (dispm == 8'h8) ? 8'b10000000:
    (dispm == 8'h7) ? 8'b11111000:
    (dispm == 8'h6) ? 8'b10000010:
    (dispm == 8'h5) ? 8'b10010010:
    (dispm == 8'h4) ? 8'b10011001:	//4
    (dispm == 8'h3) ? 8'b10110000: //3
    (dispm == 8'h2) ? 8'b10100100: //2
    (dispm == 8'h1) ? 8'b11111001: //1

	 8'b11000000;
	 
assign distm = 
	 
	 (displ == 8'h9) ? 8'b10011000:
    (displ == 8'h8) ? 8'b10000000:
    (displ == 8'h7) ? 8'b11111000:
    (displ == 8'h6) ? 8'b10000010:
    (displ == 8'h5) ? 8'b10010010:
    (displ == 8'h4) ? 8'b10011001:	//4
    (displ == 8'h3) ? 8'b10110000: //3
    (displ == 8'h2) ? 8'b10100100: //2
    (displ == 8'h1) ? 8'b11111001: //1

	 8'b11000000;
	 
assign disbar = 
    (distance > 8'd45) ? 	9'b0000000001:
    (distance > 8'd40) ? 	9'b0000000011:
    (distance > 8'd35) ? 	9'b0000000111:
    (distance > 8'd30) ? 	9'b0000001111:
    (distance > 8'd25) ? 	9'b0000011111:
    (distance > 8'd20) ? 	9'b0000111111:	//4
    (distance > 8'd15) ? 	9'b0001111111: //3
    (distance > 8'd10) ? 	9'b0011111111: //2
    (distance > 8'd5) ? 	9'b0111111111: //1

	 9'b1111111111;
	 
assign gb_road = (distance > 16)? 0:1;

Project(.clk(clk), .color_select(gb_road), .o_hsync(hor_sync), .o_vsync(ver_sync), .o_red(red), .o_blue(blue), .o_green(green));
	 
endmodule
