module controle_decode(instruction_in, instruction_out, R_dest, R_src, immediate, imm_ctrl, instr_type, ls_ctrl);

input [15:0] instruction_in;
output reg [15:0] immediate;
output reg [7:0] instruction_out;
output reg [3:0] R_src;
output reg [3:0] R_dest;
output reg imm_ctrl; //0 is register, 1 is immediate for imm_ctrl
output reg [2:0] instr_type; //00 is R-Type, 01 is STORE, 10 is LOAD
output reg ls_ctrl;

assign R_dest = instruction_in[11:8];
assign R_src = instruction_in[3:0];
reg [7:0] ipad;
wire [7:0] op = {instruction_in[15:12], instruction_in[7:4]};

parameter ADD = 	8'b00000101;
parameter SUB =   8'b00001001;
parameter MUL =   8'b00001110;
parameter OR = 	8'b00000010;
parameter CMP = 	8'b00001011;
parameter AND = 	8'b00000001;
parameter XOR = 	8'b00000011;
parameter MOV = 	8'b00001101;
parameter LSH = 	8'b10000100;
parameter ASHU = 	8'b10000110;
parameter ADDI =  8'b0101xxxx;
parameter MULI =  8'b1110xxxx;
parameter SUBI =  8'b1001xxxx;
parameter CMPI = 	8'b1011xxxx;
parameter ANDI = 	8'b0001xxxx;
parameter ORI = 	8'b0010xxxx;
parameter XORI = 	8'b0011xxxx;
parameter MOVI = 	8'b1101xxxx;
parameter LSHI = 	8'b1000xxxx;
parameter LUI = 	8'b1111xxxx;
parameter LOAD =  8'b01000000;
parameter JCOND = 8'b01001100;
parameter STORE = 8'b01000100;
parameter BCOND = 8'b1100xxxx;
parameter JAL =   8'b01001000;

always @(instruction_in, op, R_src, R_dest)
	begin 
		if(op == LOAD || op == STORE)
			begin
				R_src = instruction_in[11:8];
				R_dest = instruction_in[3:0];
			end
			
		casex(op)
			ADD, SUB, OR, CMP, AND, XOR, MOV, LSH, ASHU:
				begin		
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 0;
					instruction_out = op;
					ipad = 8'b00000000; 
					immediate = 16'b0000000000000000;
				end
				
			MUL:
				begin
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 0;
					instruction_out = LSH;
					ipad = 8'b00000000;
					immediate = 16'b0000000000000000;
				end
				
			ADDI:
				begin
					instruction_out = ADD;
					if(instruction_in[7] == 1)
						ipad = 8'b11111111;
					else
						ipad = 8'b00000000;
		
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 1;
					immediate = {ipad, instruction_in[7:4], R_src};
					R_src = instruction_in[11:8];
				end
			
			MULI:
				begin
					instruction_out = MUL;
					if(instruction_in[7] == 1)
						ipad = 8'b11111111;
					else
						ipad = 8'b00000000;
					
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 1;
					immediate = {ipad, instruction_in[7:4], R_src};
				end
				
			SUBI:
				begin
					instruction_out = SUB;
					if(instruction_in[7] == 1)
						ipad = 8'b11111111;
					else
						ipad = 8'b00000000;
						
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 1;
					immediate = {ipad, instruction_in[7:4], R_src};
					R_src = instruction_in[11:8];
				end
			
			CMPI:
				begin
					instruction_out = CMP;
					if(instruction_in[7] == 1)
						ipad = 8'b11111111;
					else
						ipad = 8'b00000000;
					
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 1;
					immediate = {ipad, instruction_in[7:4], R_src};
					
				end
				
			ANDI:
				begin
					imm_ctrl = 1;
					instr_type = 3'b000;
					R_src = instruction_in[11:8];
					instruction_out = AND;
					ipad = 8'b00000000;
					immediate = {ipad, instruction_in[7:4], R_src};
				end
			
			ORI:
				begin
					imm_ctrl = 1;
					instr_type = 3'b000;
					ls_ctrl = 0;
					instruction_out = OR;
					ipad = 8'b00000000;
					immediate = {ipad, instruction_in[7:4], R_src};
				end
			
			XORI:
				begin
					imm_ctrl = 1;
					instr_type = 3'b000;
					ls_ctrl = 0;
					instruction_out = XOR;
					ipad = 8'b00000000;
					immediate = {ipad, instruction_in[7:4], R_src};
				end
				
			MOVI:
				begin
					ls_ctrl = 0;
					instr_type = 3'b000;
					imm_ctrl = 1;
					instruction_out = MOV;
					ipad = 8'b00000000;
					immediate = {ipad, instruction_in[7:4], R_src};
				end
				
			LSHI:
				begin
					imm_ctrl = 1;
					instr_type = 3'b000;
					ls_ctrl = 0;
					instruction_out = LSH;
					R_src = instruction_in[11:8];
					ipad = 8'b00000000;
					immediate = {ipad, 4'b0000, instruction_in[3:0]};
				end
				
			STORE:
				begin
					imm_ctrl = 0;
					instr_type = 3'b001;
					ls_ctrl = 0;
					instruction_out = 8'b00000000;
					ipad = 8'b00000000;
					immediate = 16'b0000000000000000;
				end
				
			LOAD:
				begin
					imm_ctrl = 0;
					instr_type = 3'b010;
					ls_ctrl = 1;
					instruction_out = 8'b00000000;
					ipad = 8'b00000000;
					immediate = 16'b0000000000000000;
				end
				
				
				//Jump conditional
		  JCOND: begin
						ls_ctrl = 0;
						instr_type = 3'b011;
						imm_ctrl = 0;
						instruction_out = JCOND;
						ipad = 8'b00000000;
						immediate = {12'b000000000000, instruction_in[11:8]}; // cond
					end	
			//Jump and link		
		  JAL: begin
					imm_ctrl = 0;
					instr_type = 3'b101;
					ls_ctrl = 1;
					instruction_out = JAL;
					ipad = 8'b00000000;
					immediate = 16'b0000000000000000;
				end
		 //Branch unconditional
		  BCOND: begin
						ls_ctrl = 0;
						instr_type = 3'b100;
						imm_ctrl = 0;
						instruction_out = BCOND;
						ipad = 8'b00000000;
						immediate = {4'b0000,instruction_in[7:0],instruction_in[11:8]}; // cond
					end
			default:
				begin
					imm_ctrl = 1;
					instr_type = 3'bxxx;
					ls_ctrl = 0;
					instruction_out = 8'b00000000;
					ipad = 8'b00000000;
					immediate = 16'b0000000000000000;
				end
		endcase
	end

endmodule 
