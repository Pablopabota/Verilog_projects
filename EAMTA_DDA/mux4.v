module mux4 #(
    parameter WIDTH = 8
) (
    input       [WIDTH-1:0]  din1, din2, din3, din4,
    input       [1:0]  select,
    output reg  [WIDTH-1:0]  dout
);

    always @(*) begin
        case(select)
            0: begin
                dout <= din1;
            end
            1: begin
                dout <= din2;
            end
            2: begin
                dout <= din3;
            end
            3: begin
                dout <= din4;
            end
        endcase
    end
endmodule
