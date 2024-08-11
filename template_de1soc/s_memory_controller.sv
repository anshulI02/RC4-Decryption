module s_memory_controller(
    input [7:0] init_address, 
    input [7:0] init_data, 
    input init_write_enable,

    input [7:0] shuffle_address, 
    input [7:0] shuffle_data, 
    input shuffle_write_enable,

    input [7:0] decode_address, 
    input [7:0] decode_data, 
    input decode_write_enable,

    input [1:0] select_task,

    output [7:0] output_address,
    output [7:0] output_data,
    output output_write_enable
);

typedef enum logic [1:0] {
    init    = 2'b01,
    shuffle = 2'b10,
    decode  = 2'b11
}stateType;

stateType state = init;

always_comb begin
    case(select_task)
        init: begin
            output_address = init_address;
            output_data = init_data;
            output_write_enable = init_write_enable;
        end
        shuffle: begin
            output_address = shuffle_address;
            output_data = shuffle_data;
            output_write_enable = shuffle_write_enable;
        end
        decode: begin
            output_address = decode_address;
            output_data = decode_data;
            output_write_enable = decode_write_enable;
        end            
        default: begin
            output_address = 8'b0;
            output_data = 8'b0;
            output_write_enable = 1'b0;
        end
    endcase
end

endmodule