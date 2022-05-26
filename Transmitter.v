`timescale 1ns / 1ps

module Transmitter(clk, reset, Tx_Enable, Data, TxD);

input clk, reset, Tx_Enable;
input [7:0] Data;
output TxD;

reg TxD; //data that is being sent
reg [9:0] shifter; //shifter that shall keep track of the serialized bits that will be sent (10 total)
reg [9:0] TxD_counter; //keeps track of how many bits have been sent
reg [13:0] BaudRate_Counter; //the BaudRate counter size is determined by the clock (100 MHZ) / the baudrate (9600)
reg current_state, next_state;
reg clear, load, shift;

parameter [13:0] BaudRate = 10415; //what the counter must come up to
parameter IDLE = 0, TRANSMIT = 1; //states that the module could be in

always@(posedge clk or posedge reset) begin

    if(reset) //if reset, set all counters back to 0
        begin
            TxD_counter <= 0; 
            BaudRate_Counter <= 0;
        end
        
    else
        begin
            if(BaudRate_Counter == BaudRate) begin
                BaudRate_Counter <= 0; //baud counter should reset 
                next_state <= TRANSMIT; //the next state should be the transmit
                                
                if(load) 
                    begin
                        shifter <= {1'b1, Data, 1'b0}; //the shifter recieves the data to be sent plus the start bit (1) and the stop bit (0)
                        load <= 0;
                    end
                    
                if(clear)
                    begin 
                        TxD_counter <= 0;
                        clear <= 0;
                    end
                    
                if(shift) begin
                    shifter <= shifter>>1;
                    TxD_counter <= TxD_counter + 1;
                    shift <= 0;
                end
                             
            end
            
            else
                BaudRate_Counter <= BaudRate_Counter + 1;
           
        end
                          
                          
end

always@(posedge clk) begin

    if(reset) current_state = IDLE;
    
    else current_state = next_state;
    
end

always@(current_state) begin
    
    case(current_state)
        
        IDLE: 
            begin
                if(Tx_Enable) begin
                    load <= 1;
                    shift <=0;
                    clear <=0;
                    next_state <= TRANSMIT;
                end
                
                else next_state <= IDLE;
                
            end
            
        TRANSMIT:
            begin
                if(TxD_counter == 10)
                    begin
                        next_state <= IDLE;
                        clear <= 1;
                    end
                    
                 else
                    begin
                        next_state <= TRANSMIT;
                        TxD <= shifter[0];
                        shift <= 1;
                    
                    end
                    
              end
                    
        endcase

end

 
endmodule
