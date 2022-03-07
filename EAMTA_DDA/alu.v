module ALU #(
    parameter WIDTH = 8
    ) (
    input [WIDTH-1:0]       in1, in2,
    input [3:0]             op,
    input [0:0]             invalid_data,
    output [2*WIDTH-1:0]    out,
    output [0:0]            zero,
    output [0:0]            error
);

    always @(*) begin
        case(op)
            0: begin // Addition
                out = in1 + in2;
            end
            1: begin // Substraction
                out = in1 - in2;
            end
            2: begin // Multiplication
                out = in1 * in2;
            end
            3: begin // Division
                if (in2 == 0 || invalid_data == 1) begin
                    error <= 1;
                    out <= -1;
                end
                else begin
                    out = in1 / in2;
                end
            end
            default: begin
            end
        endcase
        if (out == 0) begin
            zero = 1;
        end
    end

endmodule
