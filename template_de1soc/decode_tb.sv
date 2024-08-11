module decode_tb();

logic clk, reset, start;
logic [7:0] s_memory_q, encrypted_memory_q;
	
logic [7:0] s_memory_address, s_memory_data;
logic s_memory_write_enable;
	
logic [4:0] encrypted_memory_address, decrypted_memory_address;
logic [7:0] decrypted_memory_data;
logic decrypted_memory_write_enable;
logic finish;


 decode   DUT(	.clk            (clk),
				.start          (start),
				.reset          (reset),
				
				.s_memory_address     (s_memory_address), 
                .s_memory_data     (s_memory_data), 
				.s_memory_write_enable     (s_memory_write_enable), //state bit
				.s_memory_q        (s_memory_q),
				
				.encrypted_memory_address  (encrypted_memory_address), 
                .encrypted_memory_q     (encrypted_memory_q),
				
				.decrypted_memory_address  (decrypted_memory_address), 
                .decrypted_memory_data  (decr_mem_data), 
				.decrypted_memory_write_enable  (decrypted_memory_write_enable), //state bit
				.finish         (finish) //state bit
				);

initial begin
		clk = 0; #10;
		forever begin
			clk = 1; #10;
			clk = 0; #10;
		end
	end
	
	initial begin
		reset = 1;
		start = 1;
		s_memory_q = 8'd1;
		encrypted_memory_q = 8'b10101010;
		#15;
		reset = 0;
		#100;
		s_memory_q = 8'b11111111;
		#200;
		$stop;
	end
endmodule
