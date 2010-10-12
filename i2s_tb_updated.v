`include "i2s.v"

module i2s_tb;
 
reg mck, data_in, reset;
reg [23:0] test_vector = 24'h888888;


wire [23:0] data_out;
wire [4:0] count;
wire lrck, bck, sck;
 
initial begin
  $dumpfile ("i2s_tb.vcd");
  $dumpvars (1, i2s_tb);
  $monitor ("mck=%b,sck=%b,bck=%b,lrck=%b,data_in=%b,data_out=%h,test_vector=%h", mck, sck, bck, lrck, data_in, data_out, test_vector);
  mck = 0;
  reset = 1;
  test_vector = 24'h888888;
  data_in = test_vector[23];

  //#6 data_in = 1;
  #4 reset = 0;
  #1030 test_vector = 24'hF0F0F0;
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


clk_div c0(reset, mck, sck, bck, lrck);
 
i2s_recv r0(lrck,bck,data_in,data_out);
 
endmodule
