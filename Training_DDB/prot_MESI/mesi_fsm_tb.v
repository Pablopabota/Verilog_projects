`timescale 100ns/1ns
`include "mesi_fsm.v"

module mesi_fsm_tb;

    // Señales de entrada
    reg clk_tb, pw_tb, pr_tb, bw_tb, br_tb, s_tb;
    reg rst_tb;

    // Señales de salida
    wire [1:0] state_tb;

    // Constantes
    parameter M = 2'b00, E = 2'b01, S = 2'b11, I = 2'b10;

    // Señal de validacion
    reg [1:0] estados [$];
    reg [1:0] predicted_estados [$];
    reg [1:0] estados_vm = I;

    mesi_fsm uut (
    // Señales de entrada
    .clk(clk_tb), 
    .pw(pw_tb), 
    .pr(pr_tb), 
    .bw(bw_tb), 
    .br(br_tb), 
    .s(s_tb),
    .rst(rst_tb),
    // Señales de salida
    .state(state_tb)
    );

    initial begin
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("mesi_fsm_tb.vcd");
        $dumpvars(2, mesi_fsm_tb);
        // $monitor("");
        $display("arranca");
        clk_tb = 0;
        rst_tb = 0;
    end

    always #1 clk_tb = !clk_tb;
    // always #100 $finish;
    
    always @(clk_tb) begin
        if ($time > 100) begin
            $display("finalizo");         
            // if (estados == estados_vm) begin
            //     $display("correcto");                
            // end
            // else begin
            //     $display("todo mal y anda a saber que..");
            // end
            $finish;
        end
    end

    always @(*) begin
        if ($time > 2) begin
            rst_tb = 1;
        end
        if ($time%3 == 0) begin
            pw_tb = !pw_tb;
        end
        if ($time%5 == 0) begin
            pr_tb = !pr_tb;
        end
        if ($time%7 == 0) begin
            bw_tb = !bw_tb;
        end
        if ($time%11 == 0) begin
            br_tb = !br_tb;
        end
        if ($time%13 == 0) begin
            $display("cambia s_tb");
            s_tb = !s_tb;
        end
    end

    always @(state_tb) begin
        $display("corro funcion");
        mesi_vm(pw_tb, pr_tb, bw_tb, br_tb, s_tb, rst_tb);
        estados.push_front(state_tb);
        $display("tome datos");
    end

    function void mesi_vm(bit pw, pr, bw, br, s, rst);
        $display("en la funcion");
        predicted_estados.push_front(estados_vm);
        case (estados_vm)
            M: begin
                if ( (pw || pr) && !bw && !br && !s) begin
                    estados_vm = M;
                end
                else if ( !pw && !pr && !bw && br && !s) begin
                    estados_vm = S;
                end
                else if ( !pw && !pr && bw && !br && !s) begin
                    estados_vm = I;
                end
            end
            E: begin
                if ( !pw && pr && !bw && !br && !s) begin
                    estados_vm = M;
                end
                else if ( !pw && !pr && !bw && br && !s) begin
                    estados_vm = S;
                end
                else if ( !pw && !pr && bw && !br && !s) begin
                    estados_vm = I;
                end
                else if ( pw && !pr && !bw && !br && !s) begin
                    estados_vm = M;
                end
            end
            S: begin
                if ( (pw || pr) && !bw && !br && !s) begin
                    estados_vm = S;
                end
                else if ( !pw && !pr && bw && !br && !s) begin
                    estados_vm = I;
                end
                else if ( pw && !pr && !bw && !br && !s) begin
                    estados_vm = E;
                end
            end
            I: begin
                if ( !pw && pr && !bw && !br && s) begin
                    estados_vm = S;
                end
                else if ( !pw && !pr && (bw || br) && !s) begin
                    estados_vm = I;
                end
                else if ( !pw && pr && !bw && !br && !s) begin
                    estados_vm = E;
                end
                else if ( pw && !pr && !bw && !br && !s) begin
                    estados_vm = E;
                end
            end
        endcase
        $display("fin de funcion");
    endfunction

endmodule