`timescale 1ns / 1ps

module start_stop_detector(
    input wire scl,
    input wire sda,
    output reg start_cond,
    output reg stop_cond,
    output reg bus_en
    );
    
    reg start_clean;
    reg stop_clean;
    
    initial begin
        start_cond = 1'b0;
        stop_cond = 1'b0;
        bus_en = 1'b0;
        start_clean = 1'b0;
        stop_clean = 1'b0;
    end

    // If SDA fall and SCL is HIGH: START condition
    always @(negedge sda) begin
        if (scl == 1'b1) begin   // If SCL HIGH: START condition detected
            start_cond <= 'b1;
        end
    end

    // If SDA rises and SCL is HIGH: STOP condition
    always @(posedge sda) begin
        if (scl == 1'b1) begin   // If SCL HIGH: STOP condition detected
            stop_cond <= 'b1;
        end
    end

    // Flanco negativo de SCL: registrar inicio de limpieza
    always @(negedge scl) begin
        if (start_cond == 1'b1 && start_clean == 1'b0) begin
            start_clean <= 1'b1;
        end
        if (stop_cond == 1'b1 && stop_clean == 1'b0) begin
            stop_clean <= 1'b1;
        end
    end
    
    // Flanco positivo de SCL: completar limpieza
    always @(posedge scl) begin
        if (start_cond == 1'b1 && start_clean == 1'b1) begin
            start_cond <= 1'b0;
            start_clean <= 1'b0;
        end
        if (stop_cond == 1'b1 && stop_clean == 1'b1) begin
            stop_cond <= 1'b0;
            stop_clean <= 1'b0;
        end
    end

    // el enable sube si ocurre START y baja en caso de STOP
    always @(start_cond or stop_cond) begin
        if (start_cond == 1'b1) begin
            bus_en <= 1'b1;
        end
        else if(stop_cond == 1'b1) begin
            bus_en <= 1'b0;
        end
    end
    
endmodule
