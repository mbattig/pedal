// must add reset
// clear data rdy line???
module i2s_recv(lrck, bck, data_in, data_out);

  input  lrck, bck, data_in;
  output [23:0] data_out;

  wire lrck, bck, data_in;
  reg [23:0] data_out;// = 24'h00000;
  reg [23:0] internal = 24'h00000; 
  reg [4:0] count = 5'b00000;
  
  // shift in data from serial bus.  
  // when we have received 24 bits clock this data to data_out
  always @ (posedge bck) begin
    internal = internal << 1;
    internal[0] = data_in;
    count = count + 1;
    if (count == 24) data_out = internal; // shifted in 24 bits, so clcok to output... if i2s might be able to switch to 25 to be compliant???
  end
  
  // clear count signal when frame is over.
  always @ (posedge lrck or negedge lrck) begin
    count = 5'b00000;
  end

endmodule

// module to handle the clock division for communication.
module clk_div(reset, mck, scki, bck, lrck);

    input reset, mck;
    output scki, bck, lrck;
    output [9:0] count;

    reg scki, bck, lrck;
    reg [1:0] state;
    reg [9:0] count;
    wire reset, mck;

    parameter init = 1;
    parameter steady_state =2;
    parameter counter_reset = 0;

    // handles state of the clock divider module
    always @ (reset) begin
        if (reset) begin
            state = 0;  // reset state
        end
        else begin
            state = 1;  // start-up state       
        end
    end

    // count control state machine
    always @ (state) begin
        case (state)
            init:  // coming out of reset
                count = 10'b0;
            steady_state:  // running at steady state
                count = 10'b0;   
            default: // reset
                count = 10'b0;
        endcase
     end

    // state control
    always @ (posedge mck) begin
        if (state == 2) count = count + 1;
        else if (state == 1) state = steady_state;  // transition from start-up to running state
        else count = 0;
    end  

    // bit clock (bck) = 3.072 MHz = 64*fs = 2^6 * 48 kHz = 49 MHz / 15.95  
    always @ (count[3]) bck = count[3] & !reset;
    
    // system clock (scki) = 24.5 MHz = 512*fs = 2^9 * 48 kHz = 49 MHz / 2
    always @ (count[0]) scki = count[0] & !reset;   

    // frame clock (lrck) = 48 kHz = fs = 49 MHz / 1020.8
    always @ (count[9]) lrck = count[9] & !reset;


endmodule
