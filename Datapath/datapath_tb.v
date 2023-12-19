`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg [3:0] ra, rb;
    reg clk, im_mux, pc_mux, ir_mux;
    reg [15:0] pc, immediate, instruction;
    reg [7:0] OP;
    reg regwrt, reset, memtoreg, pcen, regdst, branch, jump, jal;
    reg [1:0] alusrcb;
    reg [2:0] alucont;
    reg [15:0] memdata;

    // Outputs
    wire [4:0] flag;
    wire zero;
    wire [15:0] adr, writedata;
    wire [15:0] ALU_output, IR_output;

    // Instantiate the Unit Under Test (UUT)
    datapath uut (
        .ra(ra), 
        .rb(rb), 
        .clk(clk), 
        .im_mux(im_mux), 
        .pc_mux(pc_mux), 
        .ir_mux(ir_mux), 
        .pc(pc), 
        .immediate(immediate), 
        .instruction(instruction), 
        .OP(OP), 
        .regwrt(regwrt), 
        .reset(reset), 
        .memtoreg(memtoreg), 
        .pcen(pcen), 
        .regdst(regdst), 
        .branch(branch), 
        .jump(jump), 
        .jal(jal), 
        .alusrcb(alusrcb), 
        .alucont(alucont), 
        .memdata(memdata), 
        .flag(flag), 
        .zero(zero), 
        .adr(adr), 
        .writedata(writedata), 
        .ALU_output(ALU_output), 
        .IR_output(IR_output)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz Clock
    end

    // Test stimuli
    initial begin
        // Initialize Inputs
        ra = 0;
        rb = 0;
        im_mux = 0;
        pc_mux = 0;
        ir_mux = 0;
        pc = 0;
        immediate = 0;
        instruction = 0;
        OP = 0;
        regwrt = 0;
        reset = 1;
        memtoreg = 0;
        pcen = 0;
        regdst = 0;
        branch = 0;
        jump = 0;
        jal = 0;
        alusrcb = 0;
        alucont = 0;
        memdata = 0;

        // Wait for global reset
        #100;
        reset = 0;

        ra = 4'b0010;
        rb = 4'b0011;
        OP = 8'b00000001; // Example op code
        #20;


        // add more test cases here

        // End simulation
        #1000;
        $finish;
    end
      
endmodule
