module i2s_recv( mck, lrck, bck, data_in, data, count, rdy);
  input  mck, lrck, bck, data_in;
  output [23:0] data;
  output [4:0] count;
  output rdy;
  wire mck, lrck, bck, data_in;
  reg [23:0] data, internal;
  reg [4:0] count;
  reg rdy;

  // initialize outputs
  initial begin
    data = 24'h00000;
    count = 5'b00000;
    rdy = 1'b0;
  end


  // shift in data from serial bus.  
  // If we have 24 bits, signal data rdy and output
  always @ (posedge bck) begin
    internal = internal << 1;
    internal[0] = data_in;
    count = count + 1;
    if (count > 23) begin
      rdy = 1'b1;
    end
  end
  
  // when data rdy output data
  always @ (posedge rdy) data = internal;
  
  // clear data rdy and cout signals when  frame is over.
  always @ (posedge lrck or negedge lrck) begin
    count = 5'b00000;
    rdy = 1'b0;
  end

endmodule

module clk_div(en, mck, scki, bck, lrck, count);
    // fs = 47.8kHz => 2^10 divider = 1024
    input en, mck;
    output scki, bck, lrck;
    output [9:0] count;
    reg scki, bck, lrck;
    reg [9:0] count;
    wire en;

    initial begin
        count = 0;
        lrck = 0;
        bck = 0;
    end

    always @ (posedge mck) begin
        if (en) begin
            scki = 1'b1;
            count = count + 1;
        end
        else begin
            scki = 1'b0;
            count = 0;
            
        end
        if (count == 10'h3ff) lrck = !lrck;
    end

        always @ (posedge count[3] ) bck = !bck;

endmodule
