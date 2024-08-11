module s_array_shuffle_tb();

logic clk, start_shuffle, reset;
logic [23:0] secret_key;
logic [7:0] q;

logic [7:0] memory_address;
logic [7:0] data;
logic write_enable, finish;

s_array_shuffle    DUT(    clk,
                            start_shuffle,
                            reset,
                            secret_key,
                            q,
                            // output
                            memory_address,
                            data,
                            write_enable,
                            finish);

// clock
initial begin
		clk = 0; #10;
		forever begin
			clk = 1; #10;
			clk = 0; #10;
		end
end

// logic
initial begin
		reset = 1;
		start_shuffle = 0;
		q = 8'd0;
		secret_key = 24'h249;
		#10;
        	start_shuffle = 1;
		reset = 0;
		#100;
		#200;
		$stop;
end

endmodule