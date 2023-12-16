
// ECE 3710 - University of Utah, Fall 2023 - Ryan Ma
// VGA: Bit Generation for pattern and Collision Calculations
// Using VGA specifications to produce display objects and calculate collision detections.


module bitGen( input clk,
					input reset,
					input bright,   //asserted if the pixel is in bright region
					input [9:0] hCount, vCount, //horizontal and vertical counts
					input [7:0] keyboard_in,
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
    parameter PAD_VELOCITY = 2;     // change to speed up or slow down paddle movement
	 
	 
	 
	 ///ball items
	 parameter SQUARE_SIZE = 11;             // width of square sides in pixels
    parameter SQUARE_VELOCITY_POS = 1;      // set position change value for positive direction
    parameter SQUARE_VELOCITY_NEG = -1;     // set position change value for negative direction  
	
	 // square boundaries and position
    wire [9:0] sq_x_l, sq_x_r;              // square left and right boundary
    wire [9:0] sq_y_t, sq_y_b;              // square top and bottom boundary
    
    reg [9:0] sq_x_reg, sq_y_reg;           // regs to track left, top position
    wire [9:0] sq_x_next, sq_y_next;        // buffer wires
    
    reg [9:0] x_delta_reg, y_delta_reg;     // track square speed
    reg [9:0] x_delta_next, y_delta_next;   // buffer regs  
	 
	wire				Paddle_Hit;
	wire				Paddle_1_Hit;
	wire				Paddle_2_Hit;
	
	reg game_reset;
	reg left_win;
	reg right_win;
	
	
	  // Register Control
    always @(posedge clk)
        if((!reset) || (keyboard_in == 8'h76) || game_reset) begin
		  //paddles
            y_pad_reg <= 211;
				x_pad_reg <=3;
				y_pad_reg2 <= 211;
				x_pad_reg2 <=614;
		  //ball
				sq_x_reg <= 310;
            sq_y_reg <= 210;
            x_delta_reg <= 10'h002;
            y_delta_reg <= 10'h002;
        end
        else begin
			//paddles
            y_pad_reg <= y_pad_next;
				x_pad_reg <= x_pad_next;
				y_pad_reg2 <= y_pad_next2;
				x_pad_reg2 <= x_pad_next2;
			//ball
				sq_x_reg <= sq_x_next;
            sq_y_reg <= sq_y_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
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
	



	///sqaure/ball
	// square boundaries
   assign sq_x_l = sq_x_reg;                   // left boundary
   assign sq_y_t = sq_y_reg;                   // top boundary
   assign sq_x_r = sq_x_l + SQUARE_SIZE ;//- 1;   // right boundary
   assign sq_y_b = sq_y_t + SQUARE_SIZE ;//- 1;   // bottom boundary
    
   // square status signal
   wire sq_on;
   assign sq_on = (sq_x_l <= hCount) && (hCount <= sq_x_r) &&
                   (sq_y_t <= vCount) && (vCount <= sq_y_b);
                   
   // new square position
   assign sq_x_next = (refresh_tick) ? sq_x_reg + x_delta_reg : sq_x_reg;
   assign sq_y_next = (refresh_tick) ? sq_y_reg + y_delta_reg : sq_y_reg;
	
	// Paddle Control
    always @* begin
			///paddles
        y_pad_next = y_pad_reg;     // no move
		  x_pad_next = x_pad_reg;     // no move
		  y_pad_next2 = y_pad_reg2;     // no move
		  x_pad_next2 = x_pad_reg2;     // no move
		  
		  
	

		  
        if(refresh_tick) begin
				

				//paddle 1
            if((keyboard_in == 8'h1D)  & (y_pad_t > PAD_VELOCITY) & (y_pad_next > PAD_WIDTH+5))
                y_pad_next = y_pad_reg - PAD_VELOCITY;  // move up
            else if((keyboard_in == 8'h1B)  & (y_pad_b < (Y_MAX - PAD_VELOCITY)))
                y_pad_next = y_pad_reg + PAD_VELOCITY;  // move down
				else if((keyboard_in == 8'h1C)  & (X_PAD_L < (X_PAD_L + PAD_VELOCITY)) & (x_pad_next >= (PAD_WIDTH)))
					x_pad_next = x_pad_reg - PAD_VELOCITY;   //move left
				else if((keyboard_in == 8'h23)  & (X_PAD_L > PAD_VELOCITY) & (x_pad_next < 300))
					x_pad_next = x_pad_reg + PAD_VELOCITY;   //move right
					
				//paddle 2
				else if((keyboard_in == 8'h75)  & (y_pad_t2 > PAD_VELOCITY) & (y_pad_next2 > PAD_WIDTH+5))
                y_pad_next2 = y_pad_reg2 - PAD_VELOCITY;  // move up
            else if((keyboard_in == 8'h72)  & (y_pad_b2 < (Y_MAX - PAD_VELOCITY)))
                y_pad_next2 = y_pad_reg2 + PAD_VELOCITY;  // move down
				else if((keyboard_in == 8'h6B)  & (X_PAD_L2 < (X_PAD_L2 + PAD_VELOCITY)) & (x_pad_next2 >= (320)))
					x_pad_next2 = x_pad_reg2 - PAD_VELOCITY;   //move left
				else if((keyboard_in == 8'h74)  & (X_PAD_L2 > PAD_VELOCITY) & (x_pad_next2 < (X_MAX - PAD_WIDTH -10)))
					x_pad_next2 = x_pad_reg2 + PAD_VELOCITY;   //move right
				
						
				else begin
					y_pad_next = y_pad_reg;     // no move
					x_pad_next = x_pad_reg;     // no move
					y_pad_next2 = y_pad_reg2;     // no move
					x_pad_next2 = x_pad_reg2;     // no move
				end
			end
			else begin
				y_pad_next = y_pad_reg;     // no move
				x_pad_next = x_pad_reg;     // no move
				y_pad_next2 = y_pad_reg2;     // no move
				x_pad_next2 = x_pad_reg2;     // no move
				
			end
			
    end


//collision logic
	always@(*) begin
	
			  ///ball items
		  x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
		  game_reset = 0;
		  left_win = 0;
		  right_win = 0;
		  
		  //ballcollision with wall - bouncing
				if(sq_y_t < 7)                         // collide with top display edge
					y_delta_next <= SQUARE_VELOCITY_POS;      // change y direction(move down)
				else if(sq_y_b > (Y_MAX-10))                     // collide with bottom display edge
					y_delta_next <= SQUARE_VELOCITY_NEG;      // change y direction(move up)
				else if(sq_x_l < 10)                         // collide with left display edge
					x_delta_next <= SQUARE_VELOCITY_POS;      // change x direction(move right)
				else if(sq_x_r > (X_MAX-10))                     // collide with right display edge
					x_delta_next <= SQUARE_VELOCITY_NEG;
		  
			///ball collision with paddles
				//paddle 1-brown
				else if((sq_x_l <= (x_pad_left+PAD_WIDTH)) && (sq_y_t >= y_pad_t) && (sq_y_b <= y_pad_b))             // ball left edge collide with pad 1 right edge (moving in negative direction)
					x_delta_next <= SQUARE_VELOCITY_POS; 	 	// change ball direction to positive direction
				else if((sq_x_r >= (x_pad_next)) && (sq_x_l < (x_pad_left+1)) && (sq_y_t >= y_pad_t) && (sq_y_b <= y_pad_b))              // ball right edge collide with pad 1 left edge (moving in positive direction)	
					x_delta_next <= SQUARE_VELOCITY_NEG;			//change ball direction to negative direction
				
				//paddle2-brown
				else if((sq_x_l == x_pad_next2+2) && (sq_y_t >= y_pad_t2) && (sq_y_b <= y_pad_b2) ) 				 // ball left edge collide with pad 2 right edge (moving in negative direction)
					x_delta_next <= SQUARE_VELOCITY_POS; 		//change ball direction to positive direction
				else if((sq_x_r == x_pad_next2) && (sq_y_t >= y_pad_t2) && (sq_y_b <= y_pad_b2))      		// ball right edge collide with pad 2 left edge (moving in positive direction)
					x_delta_next <= SQUARE_VELOCITY_NEG;			//change ball direction to negative direction
				
			///ball collision with goals (red area)
				//left goal
				else if(sq_x_l == 26 && sq_y_t >= 207 && sq_y_t <= 277) begin
					
					x_delta_next <=0;
					y_delta_next <=0;
					right_win<=1;
				end
				
				//right goal
				else if(sq_x_l >= 605 && sq_y_t >= 207 && sq_y_t <= 277) begin
					x_delta_next <=0;
					y_delta_next <=0;
					left_win <= 1;
				end
					
				else
					//ball-no collision
				x_delta_next <= x_delta_next;
		
	end
	
	
	
	//display output/drawing on screen
	always@(*) begin
		if(bright) begin
			if(hCount < 640 && vCount < 480) begin
				if(pad_on) begin
					rgb_out_red = 8'b10100001; 
					rgb_out_green = 8'b00000100; 
					rgb_out_blue = OFF; 
				end
				else if(pad_on2) begin
					rgb_out_red = 8'b10100001; 
					rgb_out_green = 8'b00000100; 
					rgb_out_blue = OFF; 	
				end
				else if(sq_on) begin
					rgb_out_red = OFF; 
					rgb_out_green = OFF; 
					rgb_out_blue = OFF; 	
				end
				//borders
				else if(hCount > 0 && hCount < 639 && vCount < 10) begin //top border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 0 && hCount < 639 && vCount > 472 && vCount < 480) begin //bottom border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 0 && hCount < 10 && vCount >0 && vCount <206) begin //left upper border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 0 && hCount < 10 && vCount >275 && vCount <480) begin //left lower border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 625 && hCount < 640 && vCount > 0 && vCount <206) begin //right upper border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 625 && hCount < 640 && vCount > 275 && vCount <480) begin //right lower border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				///middle line/divider
				else if(hCount > 305 && hCount < 312 && vCount > 0 && vCount <480) begin //right lower border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				
				
				//goals
				//left goal 
				else if(hCount > 0 && hCount < 20 && vCount > 205 && vCount <211) begin //left upper goal border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 19 && hCount < 27 && vCount > 205 && vCount < 280) begin //left goal right border-red
					rgb_out_red = ON;
					rgb_out_green = OFF;
					rgb_out_blue = OFF; 
				end
				else if(hCount > 0 && hCount < 20 && vCount > 274 && vCount < 280) begin //left goal lower border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				
				//right goal 
				else if(hCount > 614 && hCount < 640 && vCount > 205 && vCount <211) begin //right upper goal border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				else if(hCount > 607 && hCount < 615 && vCount > 205 && vCount < 280) begin //right goal left border-red
					rgb_out_red = ON;
					rgb_out_green = OFF;
					rgb_out_blue = OFF; 
				end
				else if(hCount > 614 && hCount < 640 && vCount > 274 && vCount < 280) begin //right goal lower border-blue
					rgb_out_red = OFF;
					rgb_out_green = OFF;
					rgb_out_blue = ON; 
				end
				///display if left or right player win after hitting a goal
				//display Win on left side
				else if(left_win) begin 
					///'W'
				    if(hCount > 65 && hCount < 75 && vCount > 30 && vCount < 101) begin//left part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 74 && hCount < 85 && vCount > 99 && vCount < 106) begin//small part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 82 && hCount < 90 && vCount > 90 && vCount < 106) begin//middle part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 89 && hCount < 95 && vCount > 99 && vCount < 106) begin//small part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 94 && hCount < 103 && vCount > 30 && vCount < 101) begin//right part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 ///I
					 else if(hCount > 112 && hCount < 121 && vCount > 30 && vCount < 101) begin//I
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 
					 ///N
					 else if(hCount > 127 && hCount < 137 && vCount > 30 && vCount < 101) begin//left part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 136 && hCount < 142 && vCount > 50 && vCount < 61) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 141 && hCount < 147 && vCount > 60 && vCount < 71) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 146 && hCount < 152 && vCount > 70 && vCount < 82) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 151 && hCount < 159 && vCount > 30 && vCount < 101) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 
					 else begin
						rgb_out_red = ON;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
						
				end
				//display Win on right side
				else if(right_win) begin 
					///'W'
				    if(hCount > 405 && hCount < 415 && vCount > 30 && vCount < 101) begin//left part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 414 && hCount < 425 && vCount > 99 && vCount < 106) begin//small part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 422 && hCount < 430 && vCount > 90 && vCount < 106) begin//middle part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 429 && hCount < 435 && vCount > 99 && vCount < 106) begin//small part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 434 && hCount < 443 && vCount > 30 && vCount < 101) begin//right part of 'w'
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 ///I
					 else if(hCount > 452 && hCount < 461 && vCount > 30 && vCount < 101) begin//I
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 
					 ///N
					 else if(hCount > 467 && hCount < 477 && vCount > 30 && vCount < 101) begin//left part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 476 && hCount < 482 && vCount > 50 && vCount < 61) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 481 && hCount < 487 && vCount > 60 && vCount < 71) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 486 && hCount < 492 && vCount > 70 && vCount < 82) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 else if(hCount > 491 && hCount < 499 && vCount > 30 && vCount < 101) begin//middle part of N
						rgb_out_red = OFF;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
					 
					 else begin
						rgb_out_red = ON;
						rgb_out_green = ON;
						rgb_out_blue = ON;
					 end
						
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