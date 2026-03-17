module DMR_delay_chain #(
    parameter int unsigned NUM_DELAYS = 0,
    parameter type data_t = logic
) (
    input   logic   clk_i,
    input   logic   rst_ni,
    input   data_t  inputs_i,
    output  data_t  outputs_o
);

    data_t [NUM_DELAYS-1:0] r_inputs;

    generate
        for (genvar i=0; i<NUM_DELAYS; i++) begin
            always_ff @(posedge clk_i, negedge rst_ni) begin
                if (rst_ni == 1'b0) begin
                    r_inputs[i]  <= '0;
                end else if (i==0) begin
                    r_inputs[i]  <= inputs_i;
                end else begin
                    r_inputs[i]  <= r_inputs[i-1];
                end
            end
        end
    endgenerate

    assign outputs_o = r_inputs[NUM_DELAYS-1];
    
endmodule