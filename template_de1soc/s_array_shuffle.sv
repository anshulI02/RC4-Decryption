module s_array_shuffle(
    input clk,
    input reset,
    input start_shuffle,
    input [23:0] secret_key,
    input [7:0] q,
    output [7:0] memory_address,
    output [7:0] data,
    output write_enable,
    output finish
);

logic [7:0] i, j, store_i, store_j; 
logic i_enable, j_enable, store_i_enable, store_j_enable;
logic i_reset, j_reset;

logic [7:0] secret_key_i_mod_keylength;

// address & data control signals -> mainly for swapping s[i] and s[j]
logic address_select, data_select;

typedef enum logic [9:0] {
    idle            = 10'b0_0_1_0_0_0_0_0_0_0,  
    store_i_address = 10'b0_0_0_0_0_0_0_0_0_0,
    read_s_i        = 10'b0_0_0_0_0_1_0_0_0_0,
    update_j        = 10'b0_0_0_0_0_0_1_0_0_0, 
    store_j_address = 10'b0_0_0_1_0_0_0_0_0_0,  // address_select enable 
    read_s_j        = 10'b0_0_0_0_1_0_0_0_0_0,
    store_s_i       = 10'b0_1_1_0_0_0_0_0_0_0,  // write_enable, address_select = 0, data_select = 1 -> s[i] = s[j]
    store_s_j       = 10'b0_1_0_1_0_0_0_0_0_0,  // write_enable, address_select = 1, data_select = 0 -> s[j] = s[i]
    update_i        = 10'b0_0_0_0_0_0_0_1_0_0,
    finished        = 10'b1_0_0_0_0_0_0_0_1_1
}stateType;

stateType state = idle;

// output logic
assign i_reset          = state[0];
assign j_reset          = state[1];
assign i_enable         = state[2]; // enable signal to update the value of i
assign j_enable         = state[3]; // enable signal to update the value of j
assign store_i_enable   = state[4]; // enable signal to allow the memory to update the value at address i 
assign store_j_enable   = state[5]; // enable signal to allow the memory to update the value at address j
assign address_select   = state[6];		
assign data_select      = state[7];
assign write_enable     = state[8];
assign finish           = state[9];

assign memory_address = address_select ? j : i ;
assign data = data_select ? store_j : store_i;
    
// state transition logic
always @(posedge clk) begin
    if (reset) begin
        state <= idle;
    end else begin
        case(state)
            idle: begin
                if (start_shuffle) begin
                    state <= store_i_address;
                end else begin
                    state <= idle;
                end
            end
            store_i_address: begin
                state <= read_s_i;
            end
            read_s_i: begin
                state <= update_j  ;
            end
            update_j  : begin
                state <= store_j_address;
            end
            store_j_address: begin
                state <= read_s_j;
            end
            read_s_j: begin
                state <= store_s_i;
            end
            store_s_i: begin
                state <= store_s_j;
            end
            store_s_j: begin
                state <= update_i   ;
            end
            update_i   : begin
                if (i == 8'hff) begin
                    state <= finished;
                end else begin
                    state <= store_i_address;
                end
            end
            finished: begin
                state <= idle;
            end            
            default: begin
                state <= idle;
            end
        endcase
    end
end

// update value at address i
always_ff @(posedge clk) begin
    if (store_i_enable) begin
        store_i <= q;
    end
end

// update value at address j
always_ff @(posedge clk) begin
    if (store_j_enable) begin
        store_j <= q;
    end
end

// update value of i
always_ff @(posedge clk) begin
    if (reset | i_reset) begin
        i <= 8'b0;
    end
    else if (i_enable) begin
        i <= i + 8'b1;
    end
end

// update value of j
always_ff @(posedge clk) begin
    if (reset | j_reset) begin
        j <= 8'b0;
    end
    else if (j_enable) begin
        j <= j + store_i + secret_key_i_mod_keylength;
    end
end

always_comb begin
    case (i % 8'd3)
        8'd0: secret_key_i_mod_keylength = secret_key[23:16];
        8'd1: secret_key_i_mod_keylength = secret_key[15:8];
        8'd2: secret_key_i_mod_keylength = secret_key[7:0];
        default: secret_key_i_mod_keylength = 8'b0;
    endcase
end

endmodule