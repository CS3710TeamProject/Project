///Physical board top level module for testing
//Ryan Ma
module alu_board(input clock,
					  input reset,
					  input [3:0] ra1, //slide switches to set the address values for commputation ra1 & ra2
					  input [3:0] ra2,
					  input add_button,
					  input sub_button,
					  output wire[7:0] led_out);
	
	//set immediate and pc values for board demo
	reg im_muxx = 1'b0;
	reg pc_muxx = 1'b0;
	reg immediate = 1'b1;
	reg regwrite = 1'b1;
	reg pc_count = 1'b0;
	wire flag;
	reg [7:0] opcode = 8'b00000000;
	
	always@(*) begin
		//change opcode for the different requested computation from buttons
		if(add_button == 0) begin
			opcode <= 8'b00000101;
		end
		else if (sub_button == 0) begin
			opcode <= 8'b00001001;
		end
		else
			opcode <= 8'b00000000;
	end
	//use main ALU call for the operations on the board
	ALU_data ALU(.ra(ra1), .rb(ra2), .clk(clock), .im_mux(im_muxx), .pc_mux(pc_muxx), .pc(pc_count), .immediate(immediate), .OP(opcode), .regwrt(regwrite), .flag(flag), .ALU_output(led_out));

endmodule 