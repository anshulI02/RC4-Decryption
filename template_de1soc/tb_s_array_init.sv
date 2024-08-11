`timescale 1ns / 1ps

module tb_s_array_init();

    // Testbench Signals
    reg clk;
    reg reset;
    reg start_count;
    wire [7:0] array_address;
    wire [7:0] data;
    wire write_enable;
    wire finish;

    // Instantiate the Module
    s_array_init dut(
        .clk(clk),
        .reset(reset),
        .start_count(start_count),
        .array_address(array_address),
        .data(data),
        .write_enable(write_enable),
        .finish(finish)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock, period = 10ns
    end

    // Initial Conditions
    initial begin
        reset = 1;
        start_count = 0;
        #15;  // Wait 15ns to deassert reset
        reset = 0;
    end

    // Test Sequence
    initial begin
        // Ensure reset works
        #10;  // Wait for a few clock cycles
        assert(finish == 1'b0) else $error("Error: Finish should be low during reset");

        // Start the memory initialization process
        #10;
        start_count = 1;
        #10;  // Apply start pulse
        start_count = 0;

        // Check if the module goes through all addresses
        wait (finish == 1'b1);
        #100;  // Wait extra time after finish
        assert(array_address == 8'hFF && data == 8'hFF) else $error("Error: Final address/data not reached correctly.");

        // Additional checks can be added here
        $display("Test completed successfully.");
        $finish;
    end

endmodule
