`include "quiz2_lib.v"

module bs_gnrt_n_rbtr #(
    parameter drvr = 4,
    parameter pckg_sz = 16,
    parameter broadcast = {8{1'b1}}
) (
    input clk,
    input rst,
    input pndng [drvr-1:0],
    output push [drvr-1:0],
    output pop [drvr-1:0],
    input [pckg_sz-1:0] D_pop [drvr-1:0],
    output [pckg_sz-1:0] D_push [drvr-1:0]
);

    // Señales internas
    wire BUS;
    wire bs_bsy, trn_chng;

    genvar index;
    generate
        for (index = 0; index < drvr; index = index + 1) begin: ctrllr_
            bus_ctrllr #(
                            .drvr(drvr),
                            .pckg_sz(pckg_sz),
                            .broadcast({8{1'b1}}),
                            .ntrfs_ID(8'dindex)
                        )(
                            .clk(clk),
                            .rst(rst),
                            .bs_bsy(bs_bsy),
                            .BUS(BUS),
                            .trn_chng(trn_chng),
                            .pndng( pndng[index] ),
                            .push( push[index] ),
                            .pop( push[index] ),
                            .D_pop( [pckg_sz-1:0] D_pop [index] ),
                            .D_push( [pckg_sz-1:0] D_push [index] )
                        );
        end
    endgenerate

endmodule