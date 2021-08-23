module read_sm (
    clk,
    rdi,
    push,
    en_r,
    ps_r,
    rst_r,
    rst_cntr_r,
    s_cmp,
    c_r,
    s_ds_r,
    rst
);
    // Entradas
    input clk, c_r, rst;

    // Salidas
    output reg rdi, push, en_r, ps_r, rst_r, rst_cntr_r, s_cmp;
    output reg [1:0] s_ds_r;

    // Registros internos
    reg [2:0] cur_e, fut_e;

    // Constantes
    parameter R = 3'b000, W = 3'b001, RD = 3'b011, CK = 3'b111, SV = 3'b110, WT = 3'b101;

    // Logica de estado siguiente
    always @(*) begin
        case (cur_e)
            R: begin    // Estado reset
                fut_e = W;
            end
            W: begin
                fut_e = c_r? RD : W;
            end
            RD: begin
                fut_e = c_r? CK : RD;
            end
            CK: begin
                fut_e = c_r? SV : WT;
            end
            SV: fut_e = R;
            WT: fut_e = R;
            default: fut_e = R;
        endcase
    end

    // Refrescamiento de estado
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            cur_e <= R;
        end
        else begin
            cur_e <= fut_e;
        end
    end

    // Logica de salida
    always @(*) begin
        case (cur_e)
            R: begin    // Estado reset
                rdi <= 0; push <= 0; en_r <= 0; ps_r <= 0; 
                rst_r <= 1; rst_cntr_r <= 1; s_cmp <= 1; s_ds_r <= 0;
            end
            W: begin
                rdi <= 1; push <= 0; en_r <= 0; ps_r <= 0; 
                rst_r <= 0; rst_cntr_r <= 0; s_cmp <= 1; s_ds_r <= 0;
            end
            RD: begin
                rdi <= 0; push <= 0; en_r <= 1; ps_r <= 0; 
                rst_r <= 0; rst_cntr_r <= 0; s_cmp <= 1; s_ds_r <= 2;
            end
            CK: begin
                rdi <= 0; push <= 0; en_r <= 0; ps_r <= 1; 
                rst_r <= 0; rst_cntr_r <= 0; s_cmp <= 0; s_ds_r <= 1;
            end
            SV: begin
                rdi <= 0; push <= 1; en_r <= 0; ps_r <= 1; 
                rst_r <= 0; rst_cntr_r <= 0; s_cmp <= 0; s_ds_r <= 0;
            end
            WT: begin
                rdi <= 0; push <= 0; en_r <= 0; ps_r <= 1; 
                rst_r <= 0; rst_cntr_r <= 0; s_cmp <= 0; s_ds_r <= 0;
            end
            default: begin
                rdi <= 0; push <= 0; en_r <= 0; ps_r <= 0; 
                rst_r <= 1; rst_cntr_r <= 1; s_cmp <= 1; s_ds_r <= 0;                
            end
        endcase
    end

endmodule

module write_sm (
    clk,
    rst_cntr_w,
    rst_w,
    bs_rqst,
    ps_w,
    en_w,
    pop,
    c_w,
    s_ds_w,
    bs_bsy_pre,
    rst
);
    // Entradas
    input clk, c_w, rst;

    // Salidas
    output reg rst_cntr_w, rst_w, bs_rqst, ps_w, en_w, pop, bs_bsy_pre;
    output reg [1:0] s_ds_w;

    // Registros internos
    reg [2:0] cur_e, fut_e;

    // Constantes
    parameter R = 3'b000, CK = 3'b001, LD = 3'b011, RQS = 3'b111, W2 = 3'b010, W = 3'b101, WRT = 3'b100;

    // Logica de estado siguiente
    always @(*) begin
        case(cur_e)
            R: begin
                fut_e <= CK;
            end
            CK: begin
                fut_e <= c_w? LD : CK;
            end
            LD: begin
                fut_e <= RQS;
            end
            RQS: begin
                fut_e <= W;
            end
            W: begin
                fut_e <= c_w? W2 : W;
            end
            W2: begin
                fut_e <= WRT;
            end
            WRT: begin
                fut_e <= c_w? R : WRT;
            end
            default: fut_e <= R;
        endcase
    end

    // Refrescamiento de estado
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            cur_e <= R;
        end
        else begin
            cur_e <= fut_e;
        end
    end

    // Logica de salida
    always @(*) begin
        case (cur_e)
            R: begin    // Estado reset
                pop <= 0; en_w <= 0; ps_w <= 1; rst_w <= 1; 
                rst_cntr_w <= 1; s_ds_w <= 2; bs_rqst <= 0; bs_bsy_pre <= 0;
            end
            CK: begin
                pop <= 0; en_w <= 0; ps_w <= 1; rst_w <= 0; 
                rst_cntr_w <= 0; s_ds_w <= 2; bs_rqst <= 0; bs_bsy_pre <= 0;
            end
            LD: begin
                pop <= 0; en_w <= 1; ps_w <= 1; rst_w <= 0; 
                rst_cntr_w <= 1; s_ds_w <= 0; bs_rqst <= 0; bs_bsy_pre <= 0;
            end
            RQS: begin
                pop <= 1; en_w <= 0; ps_w <= 0; rst_w <= 0; 
                rst_cntr_w <= 1; s_ds_w <= 0; bs_rqst <= 1; bs_bsy_pre <= 0;
            end
            W: begin
                pop <= 0; en_w <= 0; ps_w <= 0; rst_w <= 0; 
                rst_cntr_w <= 0; s_ds_w <= 0; bs_rqst <= 1; bs_bsy_pre <= 0;
            end
            W2: begin
                pop <= 0; en_w <= 0; ps_w <= 0; rst_w <= 0; 
                rst_cntr_w <= 0; s_ds_w <= 0; bs_rqst <= 1; bs_bsy_pre <= 1;
            end
            WRT: begin
                pop <= 0; en_w <= 1; ps_w <= 0; rst_w <= 0; 
                rst_cntr_w <= 0; s_ds_w <= 1; bs_rqst <= 1; bs_bsy_pre <= 1;
            end
            default: begin
                pop <= 0; en_w <= 0; ps_w <= 1; rst_w <= 1; 
                rst_cntr_w <= 1; s_ds_w <= 2; bs_rqst <= 0; bs_bsy_pre <= 0;             
            end
        endcase
    end

endmodule

module arbtr_sm (
    clk,
    Trn_chng_nthng_t_snd,
    c_a,
    rst
);
    // Entradas
    input clk, c_a, rst;

    // Salidas
    output reg Trn_chng_nthng_t_snd;

    // Registros internos
    reg cur_e, fut_e;

    // Constantes
    parameter W = 1'b0, NXT = 1'b1;

    // Logica estado siguiente
    always @(*) begin
        case(cur_e)
            W: begin
                fut_e <= c_a? NXT : W;
            end
            NXT: begin
                fut_e <= W;
            end
            default: fut_e <= W;
        endcase
    end

    // Refrescamiento de estado
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            cur_e <= W;
        end
        else begin
            cur_e <= fut_e;
        end 
    end

    // Logica de salida
    always @(*) begin
        case(cur_e)
            W: Trn_chng_nthng_t_snd <= c_a? 1'b1 : 1'b0;
            NXT:Trn_chng_nthng_t_snd <= 1'b0;
            default: Trn_chng_nthng_t_snd <= 1'b0;
        endcase
    end

endmodule

module andn (
    a,
    b,
    o
);
    input a, b;
    output reg o;

    assign o = a & b;

endmodule

module orn (
    a,
    b,
    o
);
    input a, b;
    output reg o;

    assign o = a | b;

endmodule

module counter_n #(
    parameter bits = 8
) (
    clk,
    rst,
    count
);
    input clk, rst;
    output reg [bits-1:0] count;

    initial begin
        count = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            count = 0;
        end
        else if (count == (2^bits)-1) begin
            count = 0;
        end
        else begin
            count = count + 1;
        end
    end

endmodule

module counter_to #(
    parameter max_val = 8
) (
    clk,
    rst,
    count
);
    input clk, rst;
    output reg [$clog2(max_val)-1:0] count;

    initial begin
        count = 0;
    end

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            count = 0;
        end
        else if (count == max_val) begin
            count = 0;
        end
        else begin
            count = count + 1;
        end
    end

endmodule

module comprn #(
    parameter bits = 8
) (
    A,
    B,
    O
);
    input [bits-1:0] A, B;
    output reg O;

    assign O = &(~(A ^ B));

endmodule

module tri_buf (
    a, 
    b, 
    en
);
    input a;
    output b;
    input en;

    wire a, en;
    wire b;

    assign b = (en)? a : 1'bz;

endmodule

module muxnm #(
    parameter bits = 8,     // Parametro para largo del registro
    parameter depth = 4     // Parametro para cantidad de registros
)(
    ctrl,   // Entradas de control
    in_nm,  // M entradas de N bits
    out_n   // Salida de N bits
);

    input [$clog2(depth)-1:0] ctrl; // Si debo demux DEPTH señales preciso Log_2(DEPTH) bits de control
    input [depth-1:0] [bits-1:0] in_nm ;
    output [bits-1:0] out_n;

    // A la salida tengo la entrada correspondiente al valor de ctrl
    assign out_n = in_nm[ctrl];

endmodule

// Arreglo de N Flip-Flops tipo D
module d_ff_n #(
    parameter bits = 8  // Parametro para largo del registro
)(
    clk,      // Señal de clock
    Din_n,    // Datos de entrada de largo n
    Dout_n,   // Datos de salida de largo n
    rst
);
    input clk, rst;
    input [bits-1:0] Din_n;

    output reg [bits-1:0] Dout_n;

    always @(posedge clk or negedge rst) begin // Siempre que recibo un flanco de clk
        if (~rst) begin
            Dout_n <= 0;
        end
        else begin
            Dout_n <= Din_n;
        end
    end

endmodule

module NTRFS_CTRL_N_rbtr (
    
);
    
endmodule