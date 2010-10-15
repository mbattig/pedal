`include "i2s.v"

module i2s_tb;
 
reg mck, data_in, reset;
reg [23:0] test_vector = 24'h888888;


wire [23:0] decoded,internal;
wire [4:0] count;
wire lrck, bck, sck;
wire data_out;
 
initial begin
  $dumpfile ("i2s_tb.vcd");
  $dumpvars (1, i2s_tb);
  $monitor ("mck=%b,sck=%b,bck=%b,lrck=%b,data_in=%b,decoded=%h,test_vector=%h, data_out=%b", mck, sck, bck, lrck, data_in, decoded, test_vector, data_out);
  mck = 0;
  reset = 1;
  test_vector = 24'h888888;
  data_in = test_vector[23];

  //#6 data_in = 1;
  #4 reset = 0;
  #1000 test_vector = 24'hF0F0F0;
  #1024 test_vector = 24'h1f3af0;
  #1024 test_vector = 24'h123456;
  #1024 test_vector = 24'h612345;
  //#120 data_in = 0;
  #1024 $finish;
end

// Generate Main Clk 
always begin
  #1 mck = !mck;    
end
/*
// shift out the data onto the data_in line
// mimics an i2s send
always @ (negedge bck) begin
  if (!reset) begin
    //data_in = test_vector[23];
    test_vector = test_vector<<1;
  end
end
// make sure the data in line is accurate
always @ (sck) begin
  if (!reset) begin
    //data_in = test_vector[23];
    data_in = test_vector[23];
  end
  else data_in = 0;
end
*/

clk_div c0(mck, sck, bck, lrck);
 
i2s_rx r0(bck,lrck,data_out,decoded);

i2s_tx s0(bck,lrck,test_vector, data_out);
 
endmodule
