`include "i2s.v"
`include "pwm.v"
//NOTES: 
//  mck = generated externally @ 49 MHz
//  bck = generated by clk_div @ 3.072 MHz
//  lrck= generated by clk_div @ 8 kHz
//  scki= generated by clk_div @ 24.5 MHz ... not used?? change into pwm clock?

module peddle(data_in, mck, data_out, lrck, bck);

    input data_in, mck;
    output data_out, lrck, bck;

    wire scki, data_in, mck, data_out, lrck, bck;
    wire [23:0] sample;
    wire [4:0] count;

    //need an i2s_rx(bck,lrck,data_in,data_out)
    i2s_rx r0(bck, lrck, data_in, sample);

    //need clk_div(mck,scki,bck,lrck)
    clk_div c0(mck,scki,bck,lrck);

    pwm p0(scki,sample,data_out,count);

    //need buffers

endmodule
