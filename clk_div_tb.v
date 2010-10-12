`include "i2s.v"
// NOTES:
// clocks in on odd time units
// make all data changes on even units

module clk_div_tb;

reg en, mck;
wire scki, bck, lrck;
wire [9:0] count;
 
initial begin
    $dumpfile ("clk_div_tb.vcd");
    $dumpvars (1, clk_div_tb);
    $monitor ("mck=%b, en=%b, scki=%b, bck=%b,lrck=%b, count=%b", mck, en, scki, bck, lrck, count);
    mck = 0;
    en = 0;
    #6 en = 1;
    #50000 $finish;
end

// Generate Main Clk 
always begin
    #1 mck = !mck;
end

clk_div c0(en, mck, scki, bck, lrck, count);
 
endmodule
