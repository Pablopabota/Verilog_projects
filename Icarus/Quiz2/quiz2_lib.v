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
    data,    // Datos de entrada de largo n
    q,   // Datos de salida de largo n
    rst
);
    input clk, rst;
    input [bits-1:0] data;

    output reg [bits-1:0] q;

    always @(posedge clk or negedge rst) begin // Siempre que recibo un flanco de clk
        if (~rst) begin
            q <= 0;
        end
        else begin
            q <= data;
        end
    end

endmodule

module NTRFS_CTRL_N_rbtr #(
    parameter size = 16,
    parameter m = 8,
    parameter brdcast = 8,
    parameter ntrfs_id = 8
) (
    clk,
    bs_bsy,
    bs_grnt,
    trn_chng,
    rst,
    rst_r,
    d_in,
    ps_r,
    en_r,
    pnding,
    pop,
    push,
    en_w,
    ps_w,
    rst_w
);
    // Entradas
    input clk, bs_bsy, trn_chng, rst;
    input [size-1:0] d_in, pnding;

    //Salidas
    output reg bs_grnt, rst_r, ps_r, en_r, pop, push, en_w, ps_w, rst_w;

    //Cables para interconexión
    wire clk_cntr;

    wire rst_cntr_w;                            //Cables para el primer counter
    wire [size-1:0]count;

    wire count_cmpr;                            //Salida del comparador con pckg_lngth

    wire bs_rqst;
    wire bs_bsy_pre;
    wire [1:0] s_ds_w;
    wire c_w;
    wire rst;

    wire Trn_chng_nthng_t_snd;                  // Cables para la OR inferior izquierda
    wire Trn_chng_pre;

    wire trn_chng;

    wire pnding;                                // Cables del MUX a la entrada de la write_sm
    wire and_cw;

    wire rdi;                                   // Cable de salida del la read state machine (read_sm)

    wire bs_bsy;                                // Cable de salida del tri_buff inferior

    wire rst_cntr_r;
    wire s_cmp;
    wire c_r;
    wire [1:0] s_ds_r;

    wire or_cr;                                 // Cables del MUX a la entrada de la read_sm
    wire rd_cmp_out;
    wire and_cr; 

    wire bdcst;                                 // Cable de la OR a la entrada del MUX a la entrada de la read_sm

    wire clk_cntr_1;                            // Cable para la AND que va al segundo counter

    wire count_1;                               // Cable del segundo counter

    wire d_in;                                  // Cables del MUX a la salida del comparador
    wire rd_cmp_a;

    wire rd_cmp_b;                              // Cable del comparador arriba a la derecha de la read_sm

    wire c_a;                                   // Cable de la AND a la entrada del Arbiter State machine (Arbtr_sm)

    wire cnt_rbtr;                              // Cable del counter to m-1 (counter_to)

    wire cmpr;                                  // Cable del comparador a la entrada del Flip-Flop (ff)
    
    // Registros internos
    reg [3:0] in_nm_wsm;                        // Registros para los datos de entrada de los muxes
    reg [3:0] in_nm_rsm;
    reg [1:0] in_nm_a;
    reg [1:0] in_nm_b; 
    
    always @(*) begin
        in_nm_wsm [0] = and_cw;                 // Para el Mux a la entrada de la write_sm
        in_nm_wsm [1] = count_cmpr;
        in_nm_wsm [2] = pnding;
        in_nm_wsm [3] = 1'bz;

        in_nm_rsm [0] = and_cr;                 // Para el Mux a la entrada de la read_sm
        in_nm_rsm [1] = or_cr;
        in_nm_rsm [2] = rd_cmp_out;
        in_nm_rsm [3] = 1'bz;

        in_nm_a [0] = d_in;                     // Para el Mux de rd_cmp_a
        in_nm_a [1] = count_1; 

        in_nm_b [0] = ntrfs_id;                 // Para el Mux de rd_cmp_b
        in_nm_b [1] = size-1;
    end

    //Instanciación de módulos
    andn and_counter_1 (                        // AND a la entrada del primer counter
        .a (clk),
        .b (en_w),
        .o (clk_cntr)
    ); 

    counter_n #(                                 // Primer counter
        .bits (size)
    ) counter_1 (
        .clk (clk_cntr),
        .rst (rst_cntr_w),
        .count (count)
    );

    comprn #(                                   // Comparador de pckg_lngth
        .bits(size)
    ) compr_pckg (
        .A(count),
        .B(size),
        .O(count_cmpr)
    );

    write_sm wsm (                              //Write State Machine
        .clk (clk),
        .rst_cntr_w (rst_cntr_w),
        .rst_w (rst_w),
        .bs_rqst (bs_rqst),
        .ps_w (ps_w),
        .en_w (en_w),
        .pop (pop),
        .c_w (c_w),
        .s_ds_w(s_ds_w),
        .bs_bsy_pre(bs_bsy_pre),
        .rst(rst)
    );

    orn or_wsm (                                // Or inferior izquierda
        .a (rst_w),
        .b (Trn_chng_nthng_t_snd),
        .o (Trn_chng_pre)
    );

    tri_buf trn_buff (                          // Tri-state buffer inferior izquierdo
        .a(Trn_chng_pre),
        .b(trn_chng),
        .en(bs_grnt)
    );

    muxnm # (                                   // Mux a la entrada de la write_sm
        . bits (1),
        . depth (4)
    ) mux_wsm (
        .ctrl (s_ds_w),
        .in_nm (in_nm_wsm),
        .out_n (c_w)
    );

    andn and_wsm (                              // AND entre la read_sm y la write_sm
        .a (rdi),
        .b (bs_grnt),
        .o (and_cw)
    );

    tri_buf bs_buff (                           // Tri-state buffer inferior al medio
        .a(bs_bsy_pre),
        .b(bs_bsy),
        .en(bs_grnt)
    );

    read_sm rsm (                               // Read State Machine
        .clk (clk),
        .rdi (rdi),
        .push (push),
        .en_r (en_r),
        .ps_r (ps_r),
        .rst_r (rst_r),
        .rst_cntr_r (rst_cntr_r),
        .s_cmp (s_cmp),
        .c_r (c_r),
        .s_ds_r (s_ds_r),
        .rst (rst)
    );

    muxnm #(                                    // Mux a la entrada de la read_sm
        .bits (1),
        .depth (2)
    ) mux_rsm (
        .ctrl (s_ds_r),
        .in_nm (in_nm_rsm),
        .out_n (c_r)
    );

    orn or_rsm (                                // OR en la entrada del MUX de la read_sm
        .a (rd_cmp_out),
        .b (bdcst),
        .o (or_cr)
    );

    andn and_rsm (                              // AND en la entrada del MUX de la read_sm                            
        .a (bs_bsy),
        .b (bs_grnt),
        .o (and_cr)
    );

    andn and_arbrt (                            // AND a la entrada del arbtr_sm
        .a (bs_grnt),
        .b (~bs_rqst),
        .o (c_a)
    );

    arbtr_sm arbtr (                            // Arbiter state machine
        .clk (clk),
        .Trn_chng_nthng_t_snd (Trn_chng_nthng_t_snd),
        .c_a (c_a),
        .rst (rst)
    );

    counter_to #(                               // Counter 0 to m-1
        .max_val (m-1)
    ) cntr_to_m (
        .clk (clk),
        .rst (rst),
        .count (cnt_rbtr)
    );

    d_ff_n #(                                   // Flip-flop tipo D
        .bits (1)
    ) d_ff (
        .clk(clk),
        .data (cmpr),
        .q (bs_grnt),
        .rst (rst)
    );

    comprn #(                                   // Comparador de ntrfs_id
        .bits ($clog2(ntrfs_id))
    ) cmpr_din (
        .A (ntrfs_id),
        .B (cnt_rbtr),
        .O (cmpr)

    );

    comprn #(                                   // Comparador arriba a la derecha de la read_sm
        .bits (1)
    ) cmpr_ab (
        .A (rd_cmp_a),
        .B (rd_cmp_b),
        .O (rd_cmp_out)
    );

    muxnm #(                                    // Mux de entrada al comparador cmpr_ab
        .bits (1)                               // REVISAR!!!!!
    ) mux_a (
        .ctrl (s_cmp),
        .in_nm (in_nm_a),
        .out_n (rd_cmp_a)
    );

    muxnm #(                                    // Mux de entrada al comparador cmpr_ab por el lado de pckg_lngth-1
        .bits ($clog2(size))                    // REVISAR!!!!!
    ) mux_b (
        .ctrl (s_cmp),
        .in_nm (in_nm_b),
        .out_n (rd_cmp_b)
    );

    comprn #(                                   // Comparador con Brdcast
        .bits ($clog2(brdcast))
    ) cmpr_brdcst (
        .A (d_in),
        .B (brdcast),
        .O (bdcst)
    );

    andn and_counter_2 (                        // AND a la entrada del segundo counter
        .a (clk),
        .b (en_r),
        .o (clk_cntr_1)
    );

    counter_n #(                                // Segundo Counter
        .bits ($clog2(brdcast))
    ) cnt (
        .clk (clk_cntr_1),
        .rst (rst_cntr_r),
        .count (count_1)
    );

endmodule

module parallel_serial (
    input S_in,
    input P_in,
    input sel_P_S,
    output S_out,
    output P_out
);

    tri_buf serial(.a(S_in), .b(S_out), .en(~sel_P_S));
    tri_buf parallel_in (.a(P_in), .b(S_out), .en(sel_P_S));
    assign P_out = S_in;
    
endmodule

module serializer #(
    parameter pckg_sz = 32
) (
    input sel_p_s,
    input s_in,
    input rst,
    input clk,
    input [pckg_sz-1:0] P_in,
    output s_out,
    output [pckg_sz-1:0] P_out
);

    wire [pckg_sz-1:0] q;
    wire [pckg_sz-1:0] d;

    d_ff_n #(pckg_sz) dff (.data(d), .clk(clk), .rst (rst), .q(q));

    genvar i;
    generate
        for (i=0; i < pckg_sz-1; i = i+1)
            begin : bt
            parallel_serial pts (.S_in (q[i]), .P_in (P_in[i+1]), .sel_P_S(sel_p_s), .S_out (d[i+1]), .P_out (P_out[i]));
        end
    endgenerate

    assign d[0] = (sel_p_s)? P_in[0]: s_in;
    assign s_out = ~(sel_p_s)? q[pckg_sz-1]: 1'bz;
    assign P_out [pckg_sz-1] = q[pckg_sz-1];
endmodule

module bus_ctrllr #(
    parameter drvr = 4,
    parameter pckg_sz = 16,
    parameter broadcast = {8{1'b1}},
    parameter ntrfs_ID = {8{1'b0}}
) (
    input clk,
    input rst,

    inout bs_bsy,
    inout BUS,
    inout trn_chng,

    input pndng,
    output push,
    output pop,
    output [pckg_sz-1:0] D_push,
    input [pckg_sz-1:0] D_pop
);

    // Señales internas
    wire input_serial_clk;
    wire output_serial_clk;
    wire en_r, en_w;
    wire ps_r, ps_w;
    wire rst_r, rst_w;
    wire bus_pre_w;
    wire bs_grnt;

    andn input_and_clk (
        .a(clk),
        .b(en_r),
        .o(input_serial_clk)
    );

    andn output_and_clk (
        .a(clk),
        .b(en_w),
        .o(output_serial_clk)
    );

    // Serializador de entrada
    serializer #(.pckg_sz(pckg_sz)) input_serializer (
    .sel_p_s(ps_r),     // cte, que pasa de serial a paralelo
    .s_in(BUS),
    .rst(rst_r),
    .clk(input_serial_clk),
    // .P_in(),        // No se usa
    // .s_out(),       // No se usa
    .P_out(D_push)
    );

    // Controlador del BUS
    NTRFS_CTRL_N_rbtr #(
    .size(pckg_sz),
    .m(drvr),
    .brdcast(broadcast),
    .ntrfs_id(ntrfs_ID)
    )
    bs_control (
    .clk(clk),
    .bs_bsy(bs_bsy),
    .bs_grnt(bs_grnt),
    .trn_chng(trn_chng),
    .rst(rst),
    .rst_r(rst_r),
    .d_in(D_push),
    .ps_r(ps_r),
    .en_r(en_r),
    .pnding(pndng),
    .pop(pop),
    .push(push),
    .en_w(en_w),
    .ps_w(ps_w),
    .rst_w(rst_w)
    );

    // Serializador de salida
    serializer #(.pckg_sz(pckg_sz)) output_serializer (
    .sel_p_s(ps_w),     // cte, que pasa de serial a paralelo
    // .s_in(),        // No se usa
    .rst(rst_w),
    .clk(output_serial_clk),
    .P_in(D_pop),
    // .P_out(),           // No se usa
    .s_out(bus_pre_w)
    );

    tri_buf bus_out (
    .a(bus_pre_w), 
    .b(BUS), 
    .en(bs_grnt)
    );

endmodule