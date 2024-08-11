module s_array_init(
    input clk,
    input reset,
    input start_count,
    output wire [7:0] array_address,
    output wire [7:0] data,
    output wire write_enable,
    output wire finish
);

logic [7:0] counter;

typedef enum logic [1:0] {  
    idle = 2'b0_1,
    start = 2'b1_0
} stateType;
    
stateType state = idle;

// output logic
assign data = counter;
assign array_address = counter;
assign write_enable = state[1];
assign finish = state[0];

// state transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= idle;
    end else begin
        case(state)
            idle: begin
                counter <= 8'b0;
                if (start_count) begin
                    state <= start;
                end else begin
                    state <= idle;
                end
            end
            start: begin
                if (counter == 8'hff) begin
                    state <= idle;
                end else begin
                    counter <= counter + 8'b1; 
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

endmodule