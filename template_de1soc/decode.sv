module decode(
	input clk,
    input reset,
	input start,	
	output logic[7:0] s_memory_address,
	output logic[7:0] s_memory_data, 
	output logic s_memory_write_enable,
	input [7:0] s_memory_q,	
	output logic [4:0] encrypted_memory_address,
	input [7:0] encrypted_memory_q,	
	output logic [4:0] decrypted_memory_address,
	output logic [7:0] decrypted_memory_data, 
	output logic decrypted_memory_write_enable,
	output logic finish
);

logic [7:0] i = 0, j = 0, store_i = 0 , store_j = 0, f = 0;
logic [4:0] k = 0;
logic [1:0] s_address_select;
logic i_reset, i_enable, j_reset, j_enable, k_reset, k_enable; 
logic store_i_enable, store_j_enable, f_enable, s_data_select;

//state encoding
typedef enum logic [14:0] {
    idle 				    = 15'b1_000_000_000_00_0_0_0,
    update_i 			    = 15'b0_000_100_000_00_0_0_0,
    set_s_i_address 	    = 15'b0_000_000_000_00_0_0_0,
    read_s_i 			    = 15'b0_000_000_100_00_0_0_0,
    update_j 			    = 15'b0_000_010_000_00_0_0_0,
    set_s_j_address 		= 15'b0_000_000_000_01_0_0_0,
    read_s_j			    = 15'b0_000_000_010_00_0_0_0,
    store_s_i 			    = 15'b0_000_000_000_01_0_1_0,
    store_s_j 			    = 15'b0_000_000_000_00_1_1_0,
    set_f_address 		    = 15'b0_000_000_000_11_0_0_0,
    read_f 			        = 15'b0_000_000_001_00_0_0_0,
    store_decrypted_message = 15'b0_000_000_000_00_0_0_1,
    update_k 			    = 15'b0_000_001_000_00_0_0_0,
    finished 			    = 15'b1_111_000_000_00_0_0_0
}stateType;

stateType state = idle;

// output logic
assign finish = state[14];
assign i_reset = state[13]; 
assign j_reset = state[12]; 
assign k_reset = state[11];
assign i_enable = state[10];
assign j_enable = state[9];
assign k_enable = state[8];
assign store_i_enable = state[7];
assign store_j_enable = state[6];
assign f_enable = state[5];
assign s_address_select = state[4:3];
assign s_data_select = state[2];
assign s_memory_write_enable = state[1]; 
assign decrypted_memory_write_enable = state[0];

assign decrypted_memory_data = f ^ encrypted_memory_q;
assign encrypted_memory_address = k;
assign decrypted_memory_address = k;

always_ff @(posedge clk)
	if (reset) begin
		state <= idle;
    end else begin
		case (state)
			idle: begin
                if (start) begin
                    state <= update_i;
                end
            end
			update_i: begin
                state <= set_s_i_address;
            end
			set_s_i_address: begin
                state <= read_s_i;
            end
			read_s_i: begin
                state <= update_j;
            end
			update_j: begin
                state <= set_s_j_address;
            end
			set_s_j_address: begin
                state <= read_s_j;
            end
			read_s_j: begin
                state <= store_s_i;
            end
			store_s_i: begin
                state <= store_s_j;
            end
			store_s_j: begin
                state <= set_f_address;
            end
			set_f_address: begin
                state <= read_f;
            end
			read_f: begin
                state <= store_decrypted_message;
            end
			store_decrypted_message: begin
                state <= update_k;
            end
			update_k: begin
                if (k == 8'd31) begin
                    state <= finished;
                end else begin
                    state <= update_i;
                end
            end
			finished: begin
                state <= idle;
            end
		endcase
    end

//update i value
always_ff @(posedge clk) begin
	if (reset | i_reset)
		i <= 8'b0;
	else if (i_enable)
		i <= i + 8'b1;
end

//update j value
always_ff @(posedge clk) begin
	if (reset | j_reset)
		j <= 8'b0;
	else if (j_enable)
		j <= j + store_i;
end

//update k value
always_ff @(posedge clk) begin
	if (reset | k_reset)
		k <= 5'b0;
	else if (k_enable)
		k <= k + 5'b1;
end

//update f value
always_ff @(posedge clk) begin
	if (f_enable)
		f <= s_memory_q;
end

//update si value
always_ff @(posedge clk) begin
	if (store_i_enable)
		store_i <= s_memory_q;
end

//update sj value
always_ff @(posedge clk) begin
	if (store_j_enable)
		store_j <= s_memory_q;
end

//select signals for s_memory_address
always_comb
	case (s_address_select)
		2'b00 : s_memory_address = i;
		2'b01 : s_memory_address = j;
		2'b11 : s_memory_address = store_i + store_j;
		default : s_memory_address = 8'b0;
	endcase
	
//select signals for s_memory_data	
always_comb
	case (s_data_select)
		1'b0 : s_memory_data = store_i;
		1'b1 : s_memory_data = store_j;
		default : s_memory_data = 8'b0;
	endcase

endmodule