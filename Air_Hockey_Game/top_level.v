// ECE 3710 - University of Utah, Fall 2023 - Ryan Ma
// Top Level Signal Control/Connections
// Top Level to connect keyboard inputs to VGA graphics processing for output onto display

module top_level(input clk,
			  input reset,
			  input keyboard_clock,
			  input keyboard_data,
			  output [7:0] rgb_out_r,
			  output [7:0] rgb_out_g,
			  output [7:0] rgb_out_b,
			  output h_Sync,
			  output v_Sync,
			  output vga_Clock,
			  output wire bright, //vga blank
			  output wire vga_Sync_n);

wire [7:0] keyboard_out;
			  
//keyboard top level
ps2 keyboard(.clock_key(keyboard_clock), .data_key(keyboard_data), .clock_fpga(clk), .reset(reset), .data_out(keyboard_out));			  
			  
//VGA top level
bitGenTop vga(.clk(clk), .clear(reset), .key_in(keyboard_out), 
																					.rgb_out_red(rgb_out_r),
																					.rgb_out_green(rgb_out_g),
																					.rgb_out_blue(rgb_out_b),
																														.hSync(h_Sync),
																														.vSync(v_Sync),
																														.vgaClock(vga_Clock),
																														.bright(bright),
																														.vga_Sync_n(vga_Sync_n));
			  
endmodule 