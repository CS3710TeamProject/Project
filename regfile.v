// The register file - in this case it's 8 bits wide, and
// only 8 registers deep. It's dual-ported so there 
// are two read ports, but only one write port. 
//
// This will likely get compiled into a block RAM by 
// Quartus, so it can be initialized with a $readmemb function.
// In this case, all the values in the ram.dat file are 0
// to clear the registers to 0 on initialization
module regfile #(parameter WIDTH = 16, REGBITS = 4)  //4 register bits to address the 16 registers
                (input                clk, 
                 input                regwrite, 
                 input  [REGBITS-1:0] ra1, ra2, // using ra1 as read and write
                 input  [WIDTH-1:0]   wd, 
                 output [WIDTH-1:0]   rd1, rd2);

   reg  [WIDTH-1:0] RAM [(1<<REGBITS)-1:0]; //16 spots of 16 size registers of temp values
	
	initial begin
   $display("Loading register file");
   // Using a relative path instead of hardcoding
   $readmemb("C:\\intelFPGA_lite\\18.1\\ECE3710_ALU_RF\\reg-alu.dat", RAM); //16 lines of 16-bit 0s
   $display("done with RF load in");
end

	// dual-ported register file
   // read two ports combinationally
   // write third port on rising edge of clock
   always @(posedge clk)
      if (regwrite) RAM[ra1] <= wd;
   
	// register 0 is hardwired to 0
   assign rd1 = ra1 ? RAM[ra1] : 0;
   assign rd2 = ra2 ? RAM[ra2] : 0;
endmodule


// detect all 0's on the ALU output. 
module zerodetect #(parameter WIDTH = 16)
                   (input [WIDTH-1:0] a, 
                    output            y);
   assign y = (a==0);
endmodule	

// various flop (register) and mux definitions. 
module flop #(parameter WIDTH = 16)
             (input                  clk,
              input      [WIDTH-1:0] d, 
              output reg [WIDTH-1:0] q);

   always @(posedge clk)             
	  q <= d;
endmodule

module flopr #(parameter WIDTH = 16)
             (input                  clk, reset,
              input      [WIDTH-1:0] d, 
              output reg [WIDTH-1:0] q);

   always @(posedge clk)
      if   (~reset) q <= 0;
      else q <= d;
endmodule

module flopen #(parameter WIDTH = 16)
               (input                  clk, en,
                input      [WIDTH-1:0] d, 
                output reg [WIDTH-1:0] q);

   always @(posedge clk)
      if (en) q <= d;
endmodule

module flopenr #(parameter WIDTH = 16)
                (input                  clk, reset, en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
   always @(posedge clk)
      if      (~reset) q <= 0;
      else if (en)     q <= d;
endmodule

module mux2 #(parameter WIDTH = 16)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

   assign y = s ? d1 : d0; 
endmodule

module mux4 #(parameter WIDTH = 16)
             (input      [WIDTH-1:0] d0, d1, d2, d3,
              input      [1:0]       s, 
              output reg [WIDTH-1:0] y);

   always @(*)
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule 