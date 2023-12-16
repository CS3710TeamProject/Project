// ECE 3710 - University of Utah, Fall 2023
// Top-Level Module: PS2 controller for interface of Air Hockey Project
//	Utilizes a 50MHz input system clock and Dell ps2 keyboard for keyboard clock and data
// Toggles LED based on what key is being pressed and sends signal out for use in bitGen logic


module ps2 (
				input clock_key, 			//clock signal of keyboard
				input data_key,			//input data of keyboard
				input clock_fpga, 		//fpga clock – 50MHz
				input reset,				//fills the shift register-SIPO
				output [9:0] led,			//data output from keyboard to LED(for debug)
				output [7:0] data_out	//data output from keyboard after decode
				);
				
				
wire clock_interm;		//intermadiary clock signal = keyboard clock synchronized with fpga clock
wire [10: 0] dout;
wire out_xnor, out_and, ok;
wire data_in;
wire [3:0] count;

latch_D_ck lceas(clock_key, clock_fpga, clock_interm);
latch_D_ck ldate(data_key, clock_fpga, data_in);
	
SIPO register(data_in, clock_interm, reset ,dout, count);
xnor exclusive(out_xnor, dout[8], dout[7], dout[6], dout[5], dout[4], dout[3], dout[2], dout[1]);
and si(out_and, out_xnor, dout[9], ok);
verificare ver (clock_fpga, dout, ok, count);

//led output based on keyboard input
led_out led_output(.data_in(data_out), .led_signal(led[9:0]));

assign data_out = dout[8:1];

endmodule 
//----------------------------------------------------------

//led output based on the input key being pressed
module led_out(input [7:0] data_in,	
				   output reg[9:0] led_signal);

	always@(data_in) begin
	   if(data_in == 8'hf0) begin //break key
			led_signal=10'b0000000000;
		end
		else if(data_in == 8'h76) begin //esc key-restart game
			led_signal=10'b0000000001;
		end
		else if(data_in == 8'h29) begin //space key-start game
			led_signal=10'b0000000010;
		end
		else if(data_in == 8'h1D) begin //w key
			led_signal=10'b0000000100;
		end
		else if(data_in == 8'h1C) begin //a key
			led_signal=10'b0000001000;
		end
		else if(data_in == 8'h1B) begin //s key
			led_signal=10'b0000010000;
		end
		else if(data_in == 8'h23) begin //d key
			led_signal=10'b0000100000;
		end
		else if(data_in == 8'h75) begin //up key
			led_signal=10'b0001000000;
		end
		else if(data_in == 8'h72) begin //down key
			led_signal=10'b0010000000;
		end
		else if(data_in == 8'h6B) begin //left key
			led_signal=10'b0100000000;
		end
		else if(data_in == 8'h74) begin //right key
			led_signal=10'b1000000000;
		end
		else begin
			led_signal=10'b0000000000;
		end
	end
					
endmodule



//----------------------------------------------------
module verificare(input clock_fpga, 						//fpga clock signal
						input [10:0] data_in_parallel, 		//parallel data from SIPO register
						output reg ok, 							//indicates that the data received is correct, active on 1
						input [3:0] count							//counter from SIPO register
						);

////////internal registers///////
reg sum;
wire par_check;	//parity check

always @ (clock_fpga)
		if (count < 11)
			sum = sum + data_in_parallel[count-1]; 	//calculus of parity
		else if (count == 11)
			if (data_in_parallel[0] == 1 && data_in_parallel[10] == 0 && par_check == data_in_parallel[9])
				ok = 1; //active if the start, stop and parity bits are correct
			else 
				ok = 0;
		
assign par_check = ~sum;


endmodule 



//Latch to assign correct outputs
module latch_D_ck (input D, 
						input ck, 
						output Q);

	assign Q = (ck==1) ? D : Q;
	
endmodule

//serial in, parallel out shift register module
module SIPO ( 
			input 			din, 			//serial data in
			input 			clk, 			//clock signal
			input 			reset, 		//fills register with one's
			output [10:0]	dout, 		//parallel data out
			output [3:0] 	num			//counter for the number of shifts
			);

reg [10:0] data_out;
reg [10:0]s;
reg [3:0] count = 0;

always @ (negedge clk)
	if (reset == 0) 
		begin
			s <= 11'b111_1111_1111;
			count <= 0;
		end
	else
		begin
			s[10] <= din;
			s[9] <= s[10];
			s[8] <= s[9];
			s[7] <= s[8];
			s[6] <= s[7];
			s[5] <= s[6];
			s[4] <= s[5];
			s[3] <= s[4];
			s[2] <= s[3];
			s[1] <= s[2];
			s[0] <= s[1];
		//count the number of times the register shifts until a full new code is in the register
			if (count < 11)
				count <= count + 1;
			else 
				count = 0;
		end

assign dout = s;
assign num = count;

endmodule
