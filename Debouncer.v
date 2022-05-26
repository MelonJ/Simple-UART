`timescale 1ns / 1ps

module Debouncer(Enable, clk, reset, Enable_out);

input Enable, clk, reset;
output Enable_out;

//set initial state to 000
reg[2:0]state = 3'b000;
reg Enable_out;

wire Enable, clk, reset;

always@(posedge clk) 
begin

if(Enable)
    begin
    
        //state machine that will act as a debouncer
        case(state)
        
        //initial state
        3'b000 : 
        if(Enable == 1'b1) //if the button is pressed
            begin
                state <= 3'b001; //go to next state
                Enable_out <= 1'b0; //button out is still 0
            end
        
        //second state    
        3'b001 : 
        if(Enable == 1'b1) //if the button is STILL pressed 
            begin
                state <= 3'b000; //go back to initial state
                Enable_out <= 1'b1; //but button out is now 1
            end
        else
            begin
                state <= 3'b000; //otherwise the button is no longer pressed so go back to initial state
                Enable_out <= 1'b0; //and button out is now 0
            end
             
       endcase
    end

//else statement needed if button in is 0    
else

begin
    
    Enable_out <= 1'b0; //set button out to 0
    
end

end
    
endmodule
