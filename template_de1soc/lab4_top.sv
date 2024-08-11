module lab4_top (
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

// clock and reset signals
wire clk = CLOCK_50;
wire reset_n = ~KEY[3];

wire decode_start = ~KEY[0];

assign LEDR = SW;

decode_using_key decode_using_key_inst(
    .clk	   (clk),
    .reset	   (reset_n),
    .start	   (decode_start),
    .secret_key({14'b0, SW})
);

endmodule