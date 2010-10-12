`include "i2s.v"
// NOTES:
// clocks in on odd time units
// make all data changes on even units

module i2s_tb;
 
reg mck, data_in;
reg [23:0] test_vector = 24'h888888;


wire [23:0] data_out;
wire [4:0] count;
wire data_rdy, lrck, bck, sck;
 
initial begin
  $dumpfile ("i2s_tb.vcd");
  $dumpvars (1, i2s_tb);
  $monitor ("mck=%b,lrck=%b,bck=%b,data_in=%b,data_out=%h,count=%d,data_rdy=%b,test_vector=%h", mck, lrck, bck, data_in, data_out, count, data_rdy, test_vector);
  mck = 0;
  lrck = 0;
  data_in = 0;
  
  //#6 data_in = 1;
  //#120 data_in = 0;
  #240 $finish;
end

// Generate Main Clk 
always begin
  #1 mck = !mck;    
end

always @ (posedge lrck or negedge lrck) begin
  test_vector = 24'h888888;
  data_in = test_vector[23];
end

always begin
  data_in = test_vector[23];
  #2 test_vector = test_vector<<1;
end


// Generate Frame clk
always begin
  #60 lrck = !lrck;
end

 
i2s_recv r0(mck,lrck,bck,data_in,data_out, count, data_rdy);
 
endmodule
