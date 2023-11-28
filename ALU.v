module ALU(A, B, Op, Flags, Output);

input [15:0] A,B; // 16-bits Inputs
input [7:0] Op;	// Op-code selection

// Flags[0] - the Carry bit
// Flags[1] - The Low flag is set by comparison operations. L is set to 1 if the Rdest operand is less than the Rsrc operand when they are both interpreted as unsigned numbers.
// Flags[2] - The Flag bit is used by arithmetic operations to signal arithmetic overflow. 
// Flags[3] - the Z bit is set by the comparison operation. It is set to 1 if the two operands are equal, and is cleared otherwise
// Flags[4] - The Negative bit is set by the comparison operation. It is set to 1 if the Rdest operand is less than the Rsrc operand when both are considered to be signed integers.
output reg [4:0] Flags;
output reg [15:0] Output;	// ALU output

reg [15:0] cmp_temp;

// Parameters:
parameter ADD = 	8'b00000101;
parameter SUB =  	8'b00001001;
parameter OR = 	8'b00000010;
parameter AND = 	8'b00000001;
parameter XOR = 	8'b00000011;
parameter CMP = 	8'b00001011;
parameter MOV = 	8'b00001101;
parameter LSH = 	8'b10000100;
parameter ASHU = 	8'b10000110;
parameter NOT	=	8'b00000111;


always @(A, B, Op)
	begin
		case(Op)
		ADD: 
		begin		
			Output	= A + B;
			Flags[0] = Output[15];
			Flags[1] = 0;
			Flags[2] = 0;
			Flags[3] = (Output == 0);
			Flags[4] = Output[15];
		end
		SUB:
		begin
			Output = A - B; 
			Flags[0] = Output[15];
			Flags[1] = 0;
			Flags[2] = 0;
			Flags[3] = (Output == 0);
			Flags[4] = Output[15];
		end
		OR: 
		begin
			Output = A | B;
			Flags[0] = 0;
			Flags[1] = 0;
			Flags[2] = 0;
			Flags[3] = (Output == 0);
			Flags[4] = 0;
		end
		
		AND:
			begin
				Output = A & B;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = (Output == 0);
				Flags[4] = 0;
			end
			
		XOR:
			begin
				Output = A ^ B;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = (Output == 0);
				Flags[4] = 0;
			end
			
		CMP:
		begin
			//Add for flag checks
			cmp_temp = A + B;
			Output = B;
			Flags[0] = 0;
			//if Rdest operand < Rsrc as UNSIGNED numbers
			if(B < A)
				Flags[1] = 1;
			else
				Flags[1] = 0;
			//arithmetic overflow
			if((A[15] == 0 && B[15] == 0 && cmp_temp[15] == 1) ||
				A[15] == 1 && B[15] == 1 && cmp_temp[15] == 0) 
				Flags[2] = 1;
			else
				Flags[2] = 0;
			//if two operands are equal, cleared otherwise
			if(A == B)
				Flags[3] = 1;
			else
				Flags[3] = 0;				
			//Negative bit as SIGNED numbers
			if($signed(B) < $signed(A))
				Flags[4] = 1;
			else
				Flags[4] = 0;
		end
		
		LSH:
		begin	
				// if negative
				if(B[15] == 1)
					Output = A >> (~B + 1);
				else
					Output = A << B;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = (Output == 0);
				Flags[4] = 0;
		end
		
		ASHU:
		begin	
				if(B[15] == 1)
					Output = $signed(A) >>> (~B + 1);
				else
					Output = $signed(A) <<< B;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = (Output == 0);
				Flags[4] = 0;
		end
		
		NOT:
		begin	
				Output = ~A;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = 0;
				Flags[4] = 0;
		end
		
		
		
		MOV:
		begin	
				Output = A;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = 0;
				Flags[4] = 0;
		end
		
		default:
			begin
				Output = 16'b0;
				Flags[0] = 0;
				Flags[1] = 0;
				Flags[2] = 0;
				Flags[3] = 0;
				Flags[4] = 0;
			end
		endcase
	end
endmodule 