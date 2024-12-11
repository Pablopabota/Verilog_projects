module shiftreg 
#(
    parameter NB_LEDS = 4
)
(
    output [NB_LEDS-1:0]    o_led,
    input                   i_valid,
    input                   i_reset,
    input                   clock
);

    reg [NB_LEDS-1:0] shiftreg;

    always @(posedge clock) begin
        if (i_reset) begin
            shiftreg <= { {NB_LEDS-1{1'b0}} , 1'b1 }; // Pongo el ultimo bit en 1
        end
        else if (i_valid) begin
            // Forma larga de armar un "buffer circular"
            // shiftreg <= shiftreg << 1;
            // shiftreg [0] <= shiftreg[3];

            //Si pongo los LSB significativos como los MSB
            // y pongo el MSB como el LSB logro el mismo efecto de corrimiento
            shiftreg <= { shiftreg[2:0], shiftreg[3]}; 
        end
        else begin
            shiftreg <= shiftreg;
        end

        assign o_led = shiftreg;

    end

endmodule