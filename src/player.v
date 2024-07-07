`default_nettype none

module meriac_tt02_play_tune (
    input [7:0] io_in,
    output [7:0] io_out
);
    
    wire clk = io_in[0];
    wire reset = io_in[1];
    wire [3:0] challenge = io_in[5:2];

    wire [15:0] encoded_char;
    wire [7:0] puf_response;

    artistic_puf_cipher_asic artistic_puf_cipher_asic (
        .clock(clk),
        .reset(reset),
        .challenge(challenge),
        .encoded_char(encoded_char),
        .puf_response(puf_response)
    );

    // Output the lower 8 bits of encoded_char
    assign io_out[7:0] = encoded_char[7:0];

endmodule
