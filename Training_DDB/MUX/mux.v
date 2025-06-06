module mux21_nbits #(
    parameter BITS = 8
) (
    input                   os,
    input       [BITS-1:0]  data_0,
    input       [BITS-1:0]  data_1,
    output      [BITS-1:0]  data_out
);

    assign data_out = (os == 1)? data_1 : data_0;

endmodule