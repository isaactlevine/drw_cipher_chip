`default_nettype none
`timescale 1ns/1ps

module tb (
    input clk,
    input rst,
    input [3:0] challenge,
    output [7:0] encoded_char
);

    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    wire [7:0] inputs = {2'b0, challenge, rst, clk};
    wire [7:0] outputs;
    assign encoded_char = outputs;

    meriac_tt02_play_tune meriac_tt02_play_tune(
        .io_in  (inputs),
        .io_out (outputs)
    );

endmodule
