// ALU and control for CR16 processor
// ECE 3710
// operates on 16 bit 2's complement for signed and unsigned numbers

module enhanced_ALU_data (
    input [3:0]        ra, rb,
    input              clk, im_mux, pc_mux, ir_mux,
    input [15:0]       pc, immediate, instruction,
    input [7:0]        OP,
    input              regwrt, reset, memtoreg, pcen, regdst, branch, jump, jal,
    input [1:0]        alusrcb,
    input [2:0]        alucont,
    input [15:0]       memdata,
    output [4:0]       flag,
    output             zero,
    output [15:0]      adr, writedata,
    output wire [15:0] ALU_output,
    output wire [15:0] IR_output
);

    // Registers for MAR, MDR, and IR
    reg [15:0] MAR, MDR, IR;
    reg [3:0] opcode;
    reg [3:0] rs, rt;
    reg [7:0] immediate;

    wire [15:0] A, B, imm_out, pc_out;
    wire [4:0]  Flags;
    wire [15:0] nextpc, rd1, rd2, src1, src2;
    wire [15:0] ir_out, mar_out, mdr_out;
    wire [15:0] sign_extended_immediate;

    // TODO - get the values in registers ra and rb from the regfile, insert the value of register ra in A and rb in B.
    regfile regFile(.clk(clk), .regwrite(regwrt), .ra1(ra), .ra2(rb), .wd(ra), .rd1(A), .rd2(B));

    // muxes from ALU
    mux2 pcc_mux(.d0(A), .d1(pc), .s(pc_mux), .y(pc_out));
    mux2 imm_mux(.d0(B), .d1(immediate), .s(im_mux), .y(imm_out));

    // ALU instantiation 
    ALU main(.A(pc_out), .B(imm_out),.Op(OP), .Flags(flag), .Output(ALU_output));

    // PC update logic
    assign nextpc = (branch) ? pc + 2*memdata[15:0] :    // for branches
                    (jump) ? rd1 :                       // for jumps
                    pc + 1;                              // default case

    wire pc_update_en = pcen || branch || jump;
    flopr #(16) pcreg(clk, reset, pc_update_en, nextpc, pc);

    // Zero detection using the Z flag from ALU
    assign zero = flag[3];

    // Instruction Register Logic
    flopr #(16) ir_reg(clk, reset, ir_mux, instruction, IR);
    assign ir_out = IR;

    // Sign Extender for Immediate Values
    sign_extender signExt(.in(immediate), .out(sign_extended_immediate));

    // Memory Address Register Logic basic framework
always @(posedge clk) begin
    if (reset) begin
        MAR <= 16'b0;
    end else if (mar_load) begin
        MAR <= ALU_output; 
    end
end

    // Memory Data Register Logic basic framework
always @(posedge clk) begin
    if (reset) begin
        MDR <= 16'b0;
    end else if (mdr_read) begin
        MDR <= memdata; 
    end else if (mdr_write) begin
        MDR <= writedata; 
    end
end

    // Instruction Decoding Logic basic framework
always @(posedge clk) begin
    if (reset) begin
        // Reset logic
        opcode <= 4'b0;
        rs <= 4'b0;
        rt <= 4'b0;
        immediate <= 8'b0;
    end else if (ir_load) begin
        opcode <= IR[15:12];
        rs <= IR[11:8];
        rt <= IR[7:4];
        immediate <= IR[3:0];
    end
end

    // Final outputs 
    assign adr = ALU_output;
    assign writedata = rd2;

endmodule

    // Sign Extender Module
    module sign_extender(
    input [15:0] in,
    output [15:0] out
);
    // Sign extend logic
    assign out = { {8{in[7]}}, in[7:0] };
endmodule
