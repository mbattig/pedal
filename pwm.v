module pwm(clk, sample, out, count);

    input [23:0] sample;
    input clk;
    output out;
    output [4:0] count;  // 5 bits wide. take out later

    reg out;
    reg [4:0] count = 5'b0;
    reg [23:0] sample_holder;
    wire [23:0] sample;
    wire clk;

    always @ (posedge clk) begin
        count = count + 1;
        sample_holder = sample;
        if ((sample_holder>>19) > count) begin//*524288) begin
            out = 1;
        end
        else begin
            out = 0;
        end
    end

endmodule
