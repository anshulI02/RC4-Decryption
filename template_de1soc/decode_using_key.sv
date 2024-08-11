module decode_using_key(
    input clk,
    input reset,
    input start,
    input [23:0] secret_key
);

// s_memory signals
logic [7:0] s_memory_address, s_memory_data, s_memory_q;
logic s_memory_write_enable;

// s_memory_controller signals 
logic init_start, init_finish;
logic [7:0] init_address, init_data;
logic init_write_enable;

logic shuffle_start, shuffle_finish;
logic [7:0] shuffle_address, shuffle_data;
logic shuffle_write_enable;

logic decode_start, decode_finish;
logic [7:0] decode_address, decode_data;
logic decode_write_enable;

logic [1:0] select_task;

// Encryted_Message_ROM signals
logic [7:0] encrypted_message_address, encrypted_message_q;

// Decrypted_Message_RAM signals
logic [7:0] decrypted_message_address, decrypted_message_data, decrypted_message_q;
logic decrypted_message_write_enable;

s_memory s_memory_inst(
    .address(s_memory_address),
    .clock	(clk),
    .data	(s_memory_data),
    .wren	(s_memory_write_enable),
    .q		(s_memory_q)
);

Decrypted_Message_RAM Decrypted_Message_RAM_inst(
    .address    (decrypted_message_address),
    .clock      (clk),
    .data       (decrypted_message_data),
    .wren       (decrypted_message_write_enable),
    .q          (decrypted_message_q)
);

Encrypted_Message_ROM Encrypted_Message_ROM_inst(
    .address    (encrypted_message_address),
    .clock      (clk),
    .q          (encrypted_message_q)
);

s_array_init s_array_init_inst(
    .clk		  (clk),
    .reset		  (reset),
    .start_count  (init_start),
    .array_address(init_address),
    .data	      (init_data),
    .write_enable (init_write_enable),
    .finish		  (init_finish)
);

s_array_shuffle s_array_shuffle_inst(
    .clk           (clk),
    .start_shuffle (shuffle_start),
    .reset         (reset),
    .secret_key    (secret_key),
    .q             (s_memory_q),
    .memory_address(shuffle_address),
    .data          (shuffle_data),
    .write_enable  (shuffle_write_enable),
    .finish        (shuffle_finish)
);

decode decode_inst(
    .clk  (clk),
    .reset(reset),
    .start(decode_start),

    .s_memory_address	  (decode_address),
    .s_memory_data	      (decode_data), 
    .s_memory_write_enable(decode_write_enable),
    .s_memory_q	          (s_memory_q),

    .encrypted_memory_address(encrypted_message_address),
    .encrypted_memory_q	     (encrypted_message_q),

    .decrypted_memory_address     (decrypted_message_address), 
    .decrypted_memory_data        (decrypted_message_data), 
    .decrypted_memory_write_enable(decrypted_message_write_enable),

    .finish(decode_finish)
);
                      
s_memory_controller s_memory_controller_inst(
    .init_address     (init_address),
    .init_data        (init_data),
    .init_write_enable(init_write_enable),

    .shuffle_address     (shuffle_address),
    .shuffle_data        (shuffle_data),
    .shuffle_write_enable(shuffle_write_enable),

    .decode_address     (decode_address),
    .decode_data        (decode_data),
    .decode_write_enable(decode_write_enable),

    .select_task(select_task),

    .output_address     (s_memory_address),
    .output_data        (s_memory_data),
    .output_write_enable(s_memory_write_enable)
);

decode_using_key_controller decode_using_key_controller_inst(
    .clk  (clk),
    .reset(reset),
    .start(start),

    .init_finish   (init_finish),
    .shuffle_finish(shuffle_finish),
    .decode_finish (decode_finish),

    .init_start   (init_start),
    .shuffle_start(shuffle_start),
    .decode_start (decode_start),
 
    .select_task(select_task)
);

endmodule