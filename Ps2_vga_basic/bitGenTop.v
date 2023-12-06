//top level module for vga display from vga lab

// ECE 3710 - University of Utah, Fall 2023 - Ryan Ma
// VGA: bitGenTop
// Top Level for bitGen to use bitGen and VGA Controller modules to create a solid color fill @ 640x480 resolution at 60Hz on a vga
// compatible monitor.

module bitGenTop(input clk, clear,
					  input [7:0] key_in,
					  output [7:0] rgb_out_red,
					  output [7:0] rgb_out_green,
					  output [7:0] rgb_out_blue,
					  output hSync,
					  output vSync,
					  output vgaClock,
					  output wire bright, //vga blank
					  output wire vga_Sync_n);

wire [9:0] h_count;
wire [9:0] v_count;
wire bitGenClock;

bitGen switch_color (.clk(clk), .reset(clear), .bright(bright), .hCount(h_count), .vCount(v_count), 
																											.keyboard_in(key_in), 
																																.rgb_out_red(rgb_out_red), 
																																.rgb_out_green(rgb_out_green),
																																.rgb_out_blue(rgb_out_blue));


VGA_Controller UUT (.clk(clk), .clear(clear), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(h_count), .vCount(v_count));



Clock_divider clock_25(.clock_in(clk), .clock_out(vgaClock)); //clock divider using input of 50MHz to make 25Mhz clock



assign vga_Sync_n = 1'b0;


endmodule 



///clock divider for vga

// fpga4student.com: FPGA projects, VHDL projects, Verilog projects
// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA

//Utilized simple clock divider found online
module Clock_divider(clock_in,clock_out);
	input clock_in; // input clock on FPGA
	output reg clock_out; // output clock after dividing the input clock by divisor
	reg[27:0] counter=28'd0;
	parameter DIVISOR = 28'd2;
	// The frequency of the output clk_out
	//  = The frequency of the input clk_in divided by DIVISOR
	// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
	// You will modify the DIVISOR parameter value to 28'd50.000.000
	// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
	always @(posedge clock_in)
		begin
			counter <= counter + 28'd1;
 
			

			if(counter>=(DIVISOR-1))
				counter <= 28'd0;
				//clock_out=1'b0;
				//end
			//else
				//clock_out=1'b1;
				
			clock_out <= (counter==DIVISOR/2)?1'b1:1'b0;
		end
endmodule 




