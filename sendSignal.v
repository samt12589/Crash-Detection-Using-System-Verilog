module sendSignal(clk, rst, trig);

input clk,rst;
output reg trig;

parameter S0=2'b00,S1=2'b01,S2=2'b10;
parameter trigV=500,periodV=3000000;

reg [31:0] trigC, periodC; //trigger and period counter
reg [1:0] state;

always @ (posedge clk, posedge rst) begin
	if(rst) state<=S0; //if reset goes back to S0 state
	else case(state) // else, looks at which state

				S0:begin
						trig<=0;
						trigC<=0;
						periodC<=0;
						state<=S1;
					end

				S1: begin
						trig<=1;
						trigC<=trigC+1;
						periodC<=periodC+1;
						if(trigC<trigV) state<=S1; //trig counter vs trig value remains the same as long as trigc < trigv
						else state<=S2; //changing the state
					end
				S2: begin 
						trig<=0;
						periodC<=periodC+1;
						if(periodC<periodV) state<=S2;
						else state<=S0;
					end

				default:
					state<=S0;
				endcase
end
endmodule
