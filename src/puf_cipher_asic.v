`default_nettype none

module ring_oscillator #(
    parameter STAGES = 5
) (
    input enable,
    output out
);
    wire [STAGES-1:0] osc;
    assign osc[0] = enable ? ~osc[STAGES-1] : 1'b0;
    
    genvar i;
    generate
        for (i = 1; i < STAGES; i = i + 1) begin : stage
            assign osc[i] = ~osc[i-1];
        end
    endgenerate

    assign out = osc[STAGES-1];
endmodule

module artistic_puf_cipher_asic #(
    parameter NUM_RO = 16,
    parameter RO_STAGES = 5
) (
    input wire clock,
    input wire reset,
    input wire [3:0] challenge,
    output reg [15:0] encoded_char,
    output reg [7:0] puf_response
);

    wire [NUM_RO-1:0] ro_out;
    reg [7:0] ro_counters [NUM_RO-1:0];
    reg [15:0] phrase [7:0];
    reg [2:0] char_select;
    
    genvar i;
    generate
        for (i = 0; i < NUM_RO; i = i + 1) begin : ro
            ring_oscillator #(.STAGES(RO_STAGES)) ro_inst (
                .enable(1'b1),
                .out(ro_out[i])
            );
        end
    endgenerate

    initial begin
        phrase[0] = 16'h83AB; // 莫
        phrase[1] = 16'h89C1; // 见
        phrase[2] = 16'h4E4E; // 乎
        phrase[3] = 16'h9690; // 隐
        phrase[4] = 16'hFF0C; // ，
        phrase[5] = 16'h83AB; // 莫
        phrase[6] = 16'h663E; // 显
        phrase[7] = 16'h5FAE; // 微
    end

    integer j;
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (j = 0; j < NUM_RO; j = j + 1) begin
                ro_counters[j] <= 8'b0;
            end
            char_select <= 3'b0;
            encoded_char <= 16'b0;
            puf_response <= 8'b0;
        end else begin
            // Increment counters based on RO outputs
            for (j = 0; j < NUM_RO; j = j + 1) begin
                ro_counters[j] <= ro_counters[j] + ro_out[j];
            end

            // Select character and encode
            char_select <= char_select + 1;
            puf_response <= ro_counters[challenge];
            encoded_char <= phrase[char_select] ^ {puf_response, puf_response};
        end
    end

endmodule