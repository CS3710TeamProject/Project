//alu_board testbench

`timescale 1ns/10ps //every delay is 1ns with 10ps of accuracy

module tb_ALU_board();

	//inputs
	reg [3:0] ra; //switch input set 1
	reg [3:0] rb; //switch input set 2
	reg clk;
	reg rst;
	reg add_b;
	reg sub_b;
	//output
	wire [7:0] ALU_output;
	


	alu_board UUT(.clock(clk), .reset(rst), .ra1(ra), .ra2(rb), .add_button(add_b), .sub_button(sub_b), .led_out(ALU_output));
	
	
	//intialize inputs
	initial begin
		ra <= 4'b0000;
		rb <= 4'b0000;
		clk <= 0;
		rst <= 0;
		add_b <= 1;
		sub_b <= 1; 
		//#25 rst=1;
	
	end
	
	//clock generate -50MHz(50ns period)
	always begin
		#10 clk= ~clk;
	end
	
	
	always@(posedge clk) begin
		
		/// Perform an add
		ra <= 4'b0001;
		rb <= 4'b0001;
		#500;
		add_b <= 1'b0;
		
		
		
		
	end

endmodule 