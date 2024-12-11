module ejercicio2 
#(
    parameter bits = 4
)
(
    input       [bits-1:0]  i_dataA,
    input       [bits-1:0]  i_dataB,
    output reg  [bits-1:0]  o_dataC,
    input       [1:0]       i_sel
);

    always @(*) begin
        case (i_sel)
            0: begin
                o_dataC = i_dataA + i_dataB;
            end
            1: begin
                o_dataC = i_dataA - i_dataB;                
            end
            2: begin
                o_dataC = i_dataA & i_dataB;                
            end
            3: begin
                o_dataC = i_dataA | i_dataB;                
            end
            default: begin
                o_dataC = {bits{1'bz}};
            end
        endcase
    end

endmodule