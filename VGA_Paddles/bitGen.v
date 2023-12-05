//bit gen from VGA lab
// ECE 3710 - University of Utah, Fall 2023 - Ryan Ma
// VGA: bitGen2
// Using VGA specifications to produce a solid fill output to a VGA compatible monitor.


module bitGen( input clk,
					input reset,
					input bright,   //asserted if the pixel is in bright region
					input [9:0] hCount, vCount, //horizontal and vertical counts
					input up, down, right, left,       //inputs switches-set1
					input up2, down2, right2, left2,       //inputs switches-set2
					output reg[7:0] rgb_out_red,
					output reg[7:0] rgb_out_green,
					output reg[7:0] rgb_out_blue);	//rgb value of the pixel @ hCount,vCount
			
	parameter ON = 8'b11111111;
	parameter OFF = 8'b00000000;
	
	
	///for paddle
	// maximum x, y values in display area
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
	
	// create refresh tick
    wire refresh_tick;
    assign refresh_tick = ((hCount == 481) && (vCount == 0)) ? 1 : 0; // start of vsync(vertical retrace)
	
	
	
	/// PADDLE-1
    // paddle horizontal boundaries
    parameter X_PAD_L = 600;
    parameter X_PAD_R = 603;    // 4 pixels wide
    // paddle vertical boundary signals
    wire [9:0] y_pad_t, y_pad_b;
	 // paddle horizontal boundary signals
    wire [9:0] x_pad_left, x_pad_right;
    parameter PAD_HEIGHT = 72;  // 72 pixels high
	 parameter PAD_WIDTH = 4;  //   4 pixels wide
    // register to track top boundary and buffer
    reg [9:0] y_pad_reg;
	 reg [9:0] y_pad_next;
	 // register to track right boundary and buffer
    reg [9:0] x_pad_reg;
	 reg [9:0] x_pad_next;
	 
	 /// PADDLE-2
    // paddle horizontal boundaries
    parameter X_PAD_L2 = 600;
    parameter X_PAD_R2 = 603;    // 4 pixels wide
    // paddle vertical boundary signals
    wire [9:0] y_pad_t2, y_pad_b2;
	 // paddle horizontal boundary signals
    wire [9:0] x_pad_left2, x_pad_right2;
    parameter PAD_HEIGHT2 = 72;  // 72 pixels high
	 parameter PAD_WIDTH2 = 4;  //   4 pixels wide
    // register to track top boundary and buffer
    reg [9:0] y_pad_reg2;
	 reg [9:0] y_pad_next2;
	 // register to track right boundary and buffer
    reg [9:0] x_pad_reg2;
	 reg [9:0] x_pad_next2;
	 
	 
	 
    // paddle moving velocity when a button is pressed
    parameter PAD_VELOCITY = 3;     // change to speed up or slow down paddle movement
	 
	
	
	  // Register Control
    always @(posedge clk)
        if(!reset) begin
            y_pad_reg <= 225;
				x_pad_reg <=3;
				y_pad_reg2 <= 225;
				x_pad_reg2 <=630;
        end
        else begin
            y_pad_reg <= y_pad_next;
				x_pad_reg <= x_pad_next;
				y_pad_reg2 <= y_pad_next2;
				x_pad_reg2 <= x_pad_next2;
        end
	
	 // paddle-1 
    assign y_pad_t = y_pad_reg;                             // paddle top position
    assign y_pad_b = y_pad_t + PAD_HEIGHT - 1;              // paddle bottom position
	 assign x_pad_left = x_pad_reg;                             // paddle left position
    assign x_pad_right= x_pad_left + PAD_WIDTH;              // paddle right position
    wire pad_on;
	 assign pad_on = (x_pad_left <= hCount) && (hCount <= x_pad_right) &&     // pixel within paddle boundaries
                    (y_pad_t <= vCount) && (vCount <= y_pad_b);
	  
	//paddle-2
	assign y_pad_t2 = y_pad_reg2;                             // paddle top position
    assign y_pad_b2 = y_pad_t2 + PAD_HEIGHT2 - 1;              // paddle bottom position
	 assign x_pad_left2 = x_pad_reg2;                             // paddle left position
    assign x_pad_right2= x_pad_left2 + PAD_WIDTH2;              // paddle right position
    wire pad_on2;
	assign pad_on2 = (x_pad_left2 <= hCount) && (hCount <= x_pad_right2) &&     // pixel within paddle boundaries
                    (y_pad_t2 <= vCount) && (vCount <= y_pad_b2);
						  
	// Paddle Control
    always @* begin
        y_pad_next = y_pad_reg;     // no move
		  x_pad_next = x_pad_reg;     // no move
		  y_pad_next2 = y_pad_reg2;     // no move
		  x_pad_next2 = x_pad_reg2;     // no move
        if(refresh_tick) begin
				//paddle 1
            if(up==0 & (y_pad_t > PAD_VELOCITY) & (y_pad_next > PAD_WIDTH+5))
                y_pad_next = y_pad_reg - PAD_VELOCITY;  // move up
            else if(down==0 & (y_pad_b < (Y_MAX - PAD_VELOCITY)))
                y_pad_next = y_pad_reg + PAD_VELOCITY;  // move down
				else if(left==0 & (X_PAD_L < (X_PAD_L + PAD_VELOCITY)) & (x_pad_next >= (PAD_WIDTH)))
					x_pad_next = x_pad_reg - PAD_VELOCITY;   //move left
				else if(right==0 & (X_PAD_L > PAD_VELOCITY) & (x_pad_next < 300))
					x_pad_next = x_pad_reg + PAD_VELOCITY;   //move right
					
				//paddle 2
				else if(up2==0 & (y_pad_t2 > PAD_VELOCITY) & (y_pad_next2 > PAD_WIDTH+5))
                y_pad_next2 = y_pad_reg2 - PAD_VELOCITY;  // move up
            else if(down2==0 & (y_pad_b2 < (Y_MAX - PAD_VELOCITY)))
                y_pad_next2 = y_pad_reg2 + PAD_VELOCITY;  // move down
				else if(left2==0 & (X_PAD_L2 < (X_PAD_L2 + PAD_VELOCITY)) & (x_pad_next2 >= (320)))
					x_pad_next2 = x_pad_reg2 - PAD_VELOCITY;   //move left
				else if(right2==0 & (X_PAD_L2 > PAD_VELOCITY) & (x_pad_next2 < X_MAX - (PAD_WIDTH+3)))
					x_pad_next2 = x_pad_reg2 + PAD_VELOCITY;   //move right
			end
			else begin
				y_pad_next = y_pad_reg;     // no move
				y_pad_next = y_pad_reg;     // no move
				y_pad_next2 = y_pad_reg2;     // no move
				x_pad_next2 = x_pad_reg2;     // no move
			end
    end					  
	
	
	always@(*) begin
		if(bright) begin
			if(hCount < 640 && vCount < 480) begin
				if(pad_on) begin
					rgb_out_red = ON; 
					rgb_out_green = OFF; 
					rgb_out_blue = OFF; 
				end
				else if(pad_on2) begin
					rgb_out_red = OFF; 
					rgb_out_green = ON; 
					rgb_out_blue = OFF; 	
				end
				
				else begin
					//display white background
					rgb_out_red = ON; 
					rgb_out_green = ON;
					rgb_out_blue = ON; 
				end
					
			end
			else begin //out of display region
				rgb_out_red = OFF;
				rgb_out_green = OFF;
				rgb_out_blue = OFF;
			end
		end
		else begin //bright is NOT asserted
			rgb_out_red = OFF;
			rgb_out_green = OFF;
			rgb_out_blue = OFF;
		end
	end		
					
endmodule 