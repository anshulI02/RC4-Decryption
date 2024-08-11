module decode_using_key_controller(
    input clk,
    input reset,
    input start,

    input init_finish,
    input shuffle_finish,
    input decode_finish,
    
    output init_start,
    output shuffle_start,
    output decode_start,

    output [1:0] select_task
);

// define states
typedef enum logic [4:0] {
    idle            = 5'b00_0_0_0, 
    start_init      = 5'b01_0_0_1, 
    wait_init       = 5'b01_0_0_0,
    start_shuffle   = 5'b10_0_1_0,
    wait_shuffle    = 5'b10_0_0_0,
    start_decode    = 5'b11_1_0_0,
    wait_decode     = 5'b11_0_0_0
}stateType;

stateType state = idle;

// output logic
assign init_start = state[0];
assign shuffle_start = state[1];
assign decode_start = state[2];
assign select_task = state[4:3];

always @(posedge clk) begin
    if (reset) begin
        state = idle;
    end else begin
        case(state)
            idle: begin
                if (start) begin
                    state <= start_init;
                end
            end
            start_init: begin
                state <= wait_init;
            end
            wait_init: begin
                if (init_finish) begin
                    state <= start_shuffle;
                end
            end
            start_shuffle: begin
                state <= wait_shuffle;
            end
            wait_shuffle: begin
                if (shuffle_finish) begin
                    state <= start_decode;
                end
            end
            start_decode: begin
                state <= wait_decode;
            end
            wait_decode: begin
                if (decode_finish) begin
                    state <= idle;
                end
            end
            default: begin
                state <= idle;
            end 
        endcase
    end
end

endmodule