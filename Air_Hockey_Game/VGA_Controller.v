
// 12/4/2023
// Ryan Ma
// ECE 3710 - University of Utah, Fall 2023
// VGA: VGA_Controller/Driver
// Using VGA specifications to produce signal constraints for a 640x480 @60Hz resolution monitor display.


module VGA_Controller(input clk, clear, //system clock and clear
							 output hSync, //VGA signal interface
							 output vSync,
							 output wire bright,  //assert when the pixel is bright
							 output reg[9:0] hCount,
							 output reg[9:0] vCount  //hCount and vCount tell where on the screen
							 );	
							
// hSync and VSync are asserted low (should be high when not active)
// hCount = 0-639, vCount = 0 - 480
// bright to show which pixel, set to on or all colors off when not driving screen (in a section of the screen)

///VGA Timing
reg vEnable;

///Clock Divider
wire clk_25; //25MHz clock
Clock_divider clock_25(.clock_in(clk), .clock_out(clk_25)); //clock divider using input of 50MHz

///counter and sync generate
//horizontal counter
always@(posedge clk_25, negedge clear)
	if(clear == 0) begin
		hCount<=0;//clear count when clear is asserted
		//hSync<=1;
	end
	else begin
		hCount <= hCount + 1'b1;
		//hSync <= 1;
		//if((hCount > (640+16)) && (hCount < (640+16+96))) begin
			//hSync <= 0;
		//end
		//else 
		if(hCount == 800) begin //when it reaches the end of the line of horizontal
			vEnable <=1;
			hCount <=0;
			
		end
		else begin
			vEnable <=0; //reset to zero when not in range or above range
		end
	end

//vertical counter (increment when H count reaches 800 counts)
always@(posedge clk_25, negedge clear)
	if(clear == 0) begin
		vCount<=0;//clear count when clear is asserted
		//vSync<=1;
	end
	else begin
		if(vEnable) begin
			//if((vCount > (480+10)) && (vCount < (480+10+2))) begin
				//vSync <= 0;
			//end
			//else 
			if(vCount == 521) begin //only count to 1 after horizontal completes 800 counts
				vCount <=0;
				
			end
			else begin 
				vCount <= vCount + 1'b1;
				//vSync <= 1;
			end

		end
	end

//end counter and sync generate

assign hSync = ~((hCount > (640+16)) && (hCount < (640+16+96))); //active for 96 clocks (active low)
assign vSync = ~((vCount > (480+10)) && (vCount < (480+10+2))); //active for 2 clocks (active low)
assign bright = ((hCount < 640) && (vCount < 480)); //within display area (active high)
							
endmodule 