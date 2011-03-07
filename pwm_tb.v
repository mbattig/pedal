`include "pwm.v"
// NOTES:
// clocks in on odd time units
// make all data changes on even units

module pwm_tb;
 
reg mck;
reg [23:0] sample = 24'h800000;

wire pwm_out;
wire [4:0] count;
 
initial begin
  $dumpfile ("pwm_tb.vcd");
  $dumpvars (1, pwm_tb);
  $monitor ("mck=%b,sample=%h,count=%d,data=%b", mck,sample,count,pwm_out);
  mck = 0;
  #256 sample = 24'h000000;
  #512 sample = 24'hffffff;
  #768 sample = 24'h400000;
  #1024 $finish;
end

// Generate Main Clk 
always begin
  #1 mck = !mck;    
end
 
pwm pwm0(mck,sample,pwm_out,count);
 
endmodule
