module ALU #(
    parameter WIDTH = 8
    ) (
    input signed [WIDTH-1:0]       in1, in2,
    input [3:0]             op,
    input [0:0]             invalid_data,
    output reg signed [2*WIDTH-1:0]    out,
    output reg [0:0]            zero,
    output reg [0:0]            error
);

    always @(*) begin
        case(op)
            0: begin // Addition
                out = in1 + in2;
                error = 0;
            end
            1: begin // Substraction
                out = in1 - in2;
                error = 0;
            end
            2: begin // Multiplication
                out = in1 * in2;
                error = 0;
            end
            3: begin // Division
                if (in2 == 0 || invalid_data == 1) begin
                    error = 1;
                    out = -1;
                end
                else begin
                    out = in1 / in2;
                    error = 0;
                end
            end
            default: begin
            end
        endcase

        if (out == 0) begin
            zero = 1;
        end
        else begin
            zero = 0;
        end
    end

endmodule
