module DMR_delay_chain #(
    parameter int unsigned NUM_DELAYS = 0,
    parameter type data_t = logic
) (
    input   logic   clk_i,
    input   logic   rst_ni,
    input   logic   en_i,
    input   logic   setback_i,
    input   logic   en_timing_diversity_i,
    input   data_t  inputs_i,
    output  logic   setback_o,
    output  data_t  outputs_o
);

    data_t [NUM_DELAYS-1:0] r_inputs;
    logic r_en;
    logic [NUM_DELAYS-1:0] r_setback;

    generate
        for (genvar i=0; i<NUM_DELAYS; i++) begin
            always_ff @(posedge clk_i, negedge rst_ni) begin
                if (rst_ni == 1'b0) begin
                    r_inputs[i]  <= '0;
                    r_setback[i] <= '0;
                end else if (i==0) begin
                    r_inputs[i]  <= inputs_i;
                    r_setback[i] <= setback_i;
                end else begin
                    r_inputs[i]  <= r_inputs[i-1];
                    r_setback[i] <= r_setback[i-1];
                end
            end
        end
    endgenerate

    always_ff @( posedge clk_i, negedge rst_ni ) begin
        if (rst_ni == 1'b0) begin
            r_en <= 1'b0;
        end if ((setback_i == 1'b1) & (en_timing_diversity_i == 1'b1)) begin
            if (en_i == 1'b1) begin
                r_en <= 1'b1;
            end else begin
                r_en <= 1'b0;
            end
        end
    end

    assign outputs_o = r_en ? r_inputs[NUM_DELAYS-1] : inputs_i;
    assign setback_o = r_setback[NUM_DELAYS-1];
    
endmodule