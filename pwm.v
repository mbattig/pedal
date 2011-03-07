module pwm(clk, sample, out);

    input [23:0] sample;
    input clk;
    output out;

    reg out;
    reg [7:0] count = 8'h00;
    wire [23:0] sample;
    wire clk;

    always @ (posedge clk) begin
        count = count + 1;
    end

endmodule
