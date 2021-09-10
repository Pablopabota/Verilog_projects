module sugerido1 (
    input       [2:0]   i_data1,
    input       [2:0]   i_data2,
    input       [1:0]   i_sel,
    output reg  [5:0]   o_data,
    input               i_rst_n,
    input               clk,
    output reg          o_overflow
);
    // variables internas
    reg     [6:0] sum;     // 7 bits
    reg     [3:0] mux1;    // 4 bits
    reg     [3:0] data12;  // 4 bits

    assign data12 = { 1'b0, i_data1 } + { 1'b0, i_data2 };

    // Resuelvo el primer multiplexor
    always @(*) begin
        case(i_sel)
            0: mux1 <= { 1'b0, i_data2 };
            1: mux1 <= data12;
            2: mux1 <= { 1'b0, i_data1 };
            default: mux1 <= {4{1'bz}};
        endcase
    end

    // Resuelvo el segundo sumador
    assign sum = {2'b00, mux1} + o_data;

    // Resuelvo salida y reset asincrono
    always @(posedge clk or negedge i_rst_n) begin
        // Reset asincrono
        if(~i_rst_n) begin
            o_data <= {6{1'b0}};
            o_overflow <= 1'b0;
        end
        else begin
            o_data <= sum[5:0];
            o_overflow <= sum[6];
            if(sum[6]) begin
                $display("[%g] Ocurre overflow", $time);
            end
        end
    end

endmodule