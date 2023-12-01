//alu_data testbench

`timescale 1ns/10ps //every delay is 1ns with 10ps of accuracy

module tb_ALU();


	reg [3:0] ra, rb;
	reg clk, im_mux, pc_mux;
	reg [15:0] pc;
	reg [15:0] immediate;
	reg [7:0] OP;
	reg regwrt;
	wire [4:0] flag;
	wire [15:0] ALU_output;



	ALU_Data UUT(.ra(ra), .rb(rb), .clk(clk), .im_mux(im_mux), .pc_mux(pc_mux), .pc(pc), .immediate(immediate), .OP(OP), .regwrt(regwrt), .flag(flag), .ALU_output(ALU_output));

	
	
	//intialize inputs
	initial begin
		ra <= 4'b0000;
		rb <= 4'b0000;
		clk <= 0;
		im_mux <=0;
		pc_mux <=0;
		pc <= 16'b0000000000000000;
	   immediate <= 16'b0000000000000000;
		OP <= 8'b00000000;
		regwrt <= 0;
	
	end
	
	//clock generate -50MHz(50ns period)
	always begin
		#10 clk= ~clk;
	end
	
	
	always@(posedge clk) begin
		/// Perform an add
		OP = 8'b00000101; 
		im_mux =1;
		pc_mux =1;
		immediate = 16'b0000000000000001;
		#20
		//expected alu_output = 1
	
	
		//Using registers (dat file)
		ra = 4'b0000;
		rb = 4'b1111;
		im_mux =1;
		pc_mux =0;
		//expected result in alu_output is 1+0 from .dat file
		#20;
		
		//test-----
		// Test SUBTRACT operation using registers
		OP = 8'b00001001; 
		ra = 4'b0010;
		rb = 4'b0001;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected value = 1 from register: 2-1=1

		// Test AND operation
		OP = 8'b00000001; 
		ra = 4'b0001;
		rb = 4'b0001;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected output = 0010

		// Test OR operation
		OP = 8'b00000010; 
		ra = 4'b0010;
		rb = 4'b0100;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected output = 0111

		// Test XOR operation
		OP = 8'b00000011; 
		ra = 4'b0100;
		rb = 4'b0011;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected output = 101 ^ 100 = 001

		// Test NOT operation
		OP = 8'b00000111; 
		ra = 4'b0010;
		rb = 4'b0011; // just an example value, rb val won't matter for NOT
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expcted output = 1111111111111100
		
		
		// Test CMP operation
		OP = 8'b00001011;
		ra = 4'b1010;
		rb = 4'b0110;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected value on alu_output: 0111
		
		//Test MOV operation
		OP = 8'b00001101;
		ra = 4'b1010;
		rb = 4'b0001;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected value on alu_output: source(a) -> dest(b) = 0000 -> 00010

		//Test LSH operation
		OP = 8'b10000100;
		ra = 4'b0010;
		rb = 4'b0001;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected value on alu_output:1100

		//Test ASHU operation
		OP = 8'b10000110;
		ra = 4'b0010;
		rb = 4'b0001;
		im_mux = 0;
		pc_mux = 0;
		#20;
		//expected value on alu_output: 1100
		
		
		
	end

endmodule 