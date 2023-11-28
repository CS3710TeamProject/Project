///ALU and control for CR16 processor
//ECE 3710
//oparates on 16 bit 2's complement for signed and unsigned numbers
module ALU_Data (ra, rb, clk, im_mux, pc_mux, pc, immediate, OP, regwrt, flag, ALU_output);

input [3:0] ra, rb;
input clk, im_mux, pc_mux;
input [15:0] pc;
input [15:0] immediate;
input [7:0] OP;
input regwrt;
output [4:0] flag;
output wire [15:0] ALU_output;

wire [15:0] A, B, imm_out, pc_out;
wire [4:0] Flags;

// TODO - get the values in registers ra and rb from the regfile, insert the value of register ra in A and rb in B.
regfile regFile(.clk(clk), .regwrite(regwrt), .ra1(ra), .ra2(rb), .wd(ra), .rd1(A), .rd2(B)); 


mux2 pcc_mux(.d0(A), .d1(pc), .s(pc_mux), .y(pc_out));
// selects the register value input or immediate value, if control is 0 register, 1 immediate.
mux2 imm_mux(.d0(B), .d1(immediate), .s(im_mux), .y(imm_out));

ALU main(.A(pc_out), .B(imm_out),.Op(OP), .Flags(flag), .Output(ALU_output));

endmodule 
