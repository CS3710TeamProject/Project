module FSM_cpu
(
	input clk, reset,
	input [2:0] instr_type,
	output reg PC_enable, ir_en, regwrite, reg_read, bram_en, link_en
);

	reg [3:0] state; 
	reg [3:0] nextState;
	reg pc_check;
	
	parameter [3:0] S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000;
	always @(negedge clk) begin
		state <= nextState;
	end
	
	always @(posedge clk, negedge reset)begin
		if (reset == 0)
			nextState <= S0;
		else
		begin
			case(state)
				S0: nextState <= S1;
				S1: 
					if(instr_type == 3'b000)
						nextState <= S2;
					else if(instr_type == 3'b001) 
						nextState <= S3;
					else if(instr_type == 3'b010) 
						nextState <= S4;
					else if (instr_type == 3'b011)
						nextState <= S6;
					else if (instr_type == 3'b100)
						nextState <= S7;
					else if (instr_type == 3'b101)
						nextState <= S8;
					else
					nextState <= S0;
				S2: nextState <= S0;
				S3: nextState <= S6; 
				S4: nextState <= S5;
				S5: nextState <= S0;
				S6: nextState <= S0;
				S7: nextState <= S0;
				S8: nextState <= S0;
			default: nextState <= S0;
			endcase
			end
		end
		
		
		
	always @(state)
	begin
	pc_check = instr_type !=3'b101;
		case (state)
			 S0: begin PC_enable = 0; regwrite = 0; ir_en = 1; reg_read = 0; bram_en = 0; link_en = 0; end // alu will write back to reg not bram 
			 S1: begin PC_enable = pc_check; regwrite = 0; ir_en = 0; reg_read = 0; bram_en = 0; link_en = 0; end // decode
			 S2: begin PC_enable = 0; regwrite = 1; ir_en = 0; reg_read = 0; bram_en = 0; link_en = 0; end // execute
			 S3: begin PC_enable = 0; regwrite = 0; ir_en = 0; reg_read = 1; bram_en = 1; link_en = 0; end //STORE
			 S4: begin PC_enable = 0; regwrite = 0; ir_en = 0; reg_read = 1; bram_en = 0; link_en = 0; end //LOAD
			 S5: begin PC_enable = 0; regwrite = 1; ir_en = 0; reg_read = 0; bram_en = 0; link_en = 0; end // store data to regfile
			 S6: begin PC_enable = 0; regwrite = 0; ir_en = 0; reg_read = 0; bram_en = 0; link_en = 0; end // Jump
			 S7: begin PC_enable = 0; regwrite = 0; ir_en = 0; reg_read = 0; bram_en = 0; link_en = 0; end // Branch
			 S8: begin PC_enable = 0; regwrite = 1; ir_en = 0; reg_read = 1; bram_en = 0; link_en = 1; end // JAL
		endcase
end
	
endmodule
