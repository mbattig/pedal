`include "i2s.v"
// NOTES:
// clocks in on odd time units
// make all data changes on even units

module clk_div_tb;

reg reset, mck;
wire scki, bck, lrck;
//wire [9:0] count;
 
initial begin
    $dumpfile ("clk_div_tb.vcd");
    $dumpvars (1, clk_div_tb);
    $monitor ("mck=%b, scki=%b, bck=%b,lrck=%b", mck, scki, bck, lrck);
    mck = 0;
    reset = 1;
    #4 reset = 0;
    #4 reset = 1;
    #1 reset = 0;
    #50 reset = 1;
    #4  reset =0;
    //#50000 $finish;
    #40000 $finish;
end

// Generate Main Clk 
always begin
    #1 mck = !mck;
end

clk_div c0( mck, scki, bck, lrck);//,reset);
 
endmodule
