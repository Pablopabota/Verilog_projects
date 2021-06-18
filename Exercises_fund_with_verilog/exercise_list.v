// 2.60 Write Verilog code to implement the circuit in Figure 2.32a using the gate-level primitives (and(), or(), xor()).
module exercise_2_60 (x1, x2, x3, f);
    input x1, x2, x3;
    output f;

    and(y1, ~x1, ~x2, x3);
    and(y2, ~x1, x2, ~x3);
    and(y3, x1, ~x2, ~x3);
    and(y4, x1, x2, x3);
    or (f, y1, y2, y3, y4);

endmodule
// 2.61 Repeat Problem 2.60 for the circuit in Figure 2.32b.
module exercise_2_61 (x1, x2, x3, f);
    input x1, x2, x3;
    output f;

    or(y1, x1, x2, x3);
    or(y2, ~x1, ~x2, x3);
    or(y3, ~x1, x2, ~x3);
    or(y4, x1, ~x2, ~x3);

    and(f, y1, y2, y3, y4);

endmodule

// 2.62 Write Verilog code to implement the function f (x1, x2, x3) = SUM m(1, 2, 3, 4, 5, 6) using the
// gate-level primitives. Ensure that the resulting circuit is as simple as possible.

// 2.63 Write Verilog code to implement the function f (x1, x2, x3) = SUM m(0, 1, 3, 4, 5, 6) using the
// continuous assignment.

// 2.64 (a) Write Verilog code to describe the following functions
// f1 = x1x3 + x2x3 + x3x4 + x1x2 + x1x4
// f2 = (x1 + x3) · (x1 + x2 + x4) · (x2 + x3 + x4)
// (b) Use functional simulation to prove that f1 = f2.
module exercise_2_64_a (x1, x2, x3, x4, f1);
    input x1, x2, x3, x4;
    output f1;

    and(y1, x1, x3);
    and(y2, x2, x3);
    and(y3, x3, x4);
    and(y4, x1, x2);
    and(y5, x1, x4);

    or(f1, y1, y2, y3, y4, y5);

endmodule

// 2.65 Consider the following Verilog statements
// f1 = (x1 & x3) | (∼x1 & ∼x3) | (x2 & x4) | (∼x2 & ∼x4);
// f2 = (x1 & x2 & ∼x3 & ∼x4) | (∼x1 & ∼x2 & x3 & x4) |
// (x1 & ∼x2 & ∼x3 & x4) | (∼x1 & x2 & x3 & ∼x4);
// (a) Write complete Verilog code to implement f1 and f2.
// (b) Use functional simulation to prove that f1 = f2.