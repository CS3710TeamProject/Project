/*module test ();

wire [7:0] data_out;
reg clock_key, clock_fpga, data_in, reset; 
wire led, new_code;

initial begin 
	clock_fpga = 0;
	forever #1 clock_fpga = ~clock_fpga;
end

/*initial begin
	clock_key = 0;
	forever #100 clock_key = ~clock_key;
end

initial begin
	reset = 0;
	#5 reset = 1;
	#5 data_in = 1; clock_key = 1;
	#5 data_in=0;		//bitul de start
	#1 clock_key=0;
	#19 data

ps2 dut (clock_key, data_in, clock_fpga, reset, led, data_out, new_code);

endmodule */


`timescale 1ns / 1ps

module testbench();

	// Inputs
	reg CLK;
	reg PS2_CLK;
	reg PS2_DATA;
	reg reset;

	// Outputs
	/*wire scan_err;
	wire [10:0] scan_code;
	wire [3:0]COUNT;
	wire TRIG_ARR;
	wire [7:0]CODEWORD;*/
	wire [15:0] data_out;
	wire new_code;
	wire [9:0] LED;

	// Instantiate the Unit Under Test (UUT)
	ps2 dut (PS2_CLK, PS2_DATA, CLK, reset, LED, data_out, new_code);
	
	/*Keyboard uut (
		.CLK(CLK), 
		.PS2_CLK(PS2_CLK), 
		.PS2_DATA(PS2_DATA), 
		.scan_err(scan_err), 
		.scan_code(scan_code),
		.TRIG_ARR(TRIG_ARR),
		.COUNT(COUNT),
		.CODEWORD(CODEWORD),
		.LED(LED)
	);*/

	/*initial begin
		CLK = 1;
		forever begin
		#1 CLK = ~CLK;
		end
	end
	*/
	
	
	
	initial begin
		// Initialize Inputs
		CLK=0;
		PS2_CLK = 1;
		PS2_DATA = 1;
		reset=1;
		#5 reset = 0;
		#5 reset = 1;
	end
	
	//clock-50MHz = 50ns period
	always begin
		#10 CLK= ~CLK;
	end
	
	always begin

		// Wait 100 ns for global reset to finish
		#100;
		
		//one key press: key--
		//each key press will send 10 bits
      #45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		// Add stimulus here-------
		
		
		#100;
		
		//second key press: key--
		
		#45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 0; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		
		#100
		//key press:
		//third key press: key--
		
		#45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 0; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		
		
	//BRAKE CODE
	
		#100;
		
		#45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#200 $stop;
	end
      
endmodule 