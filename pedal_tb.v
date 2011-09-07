`include "pedal.v"
// NOTES:


module pedal_tb;
 
reg mck;
reg [23:0] sample = 24'hffffff; // 50 %

wire out, i2s_data, lrck, bck;
 
initial begin
  $dumpfile ("pedal_tb.vcd");
  $dumpvars (1, pedal_tb);
  $monitor ("mck=%b,bck=%b,lrck=%b,sample=%h,i2s_data=%b,pwm=%b",mck,bck,lrck,sample,i2s_data,out);
  mck = 0;
  
  #4000 sample = 24'hBfffff;
  #4000 sample = 24'h7fffff;
  #4000 sample = 24'h3fffff;
  #4000 sample = 24'h000000;
  #4000 $finish;
end

// Generate Main Clk 
always begin
  #1 mck = !mck;    
end


i2s_tx pcm1808(bck,lrck,sample,i2s_data);
 
pedal p0(i2s_data, mck, out, lrck, bck);
 
endmodule
