`timescale 1ns/1ns  // Escala de tiempos
`include "hello.v"  // Incluimos archivos

module hello_tb;    // Se crea el modulo

    reg A;  // Se usa el tipo 'reg' para entradas
    wire B; // Se usa el tipo 'wire' para salidas

    hello uut(A,B); // Se crea la unidad bajo prueba (Unit Under Test)

    initial begin
        
        // Se configuran los archivos en donde se imprimen las señales
        $dumpfile("hello_tb.vcd");
        $dumpvars(0, hello_tb);

        // Se lleva a cabo la prueba
        A = 0;  // Cambio el calor de la entrada
        #20;    // Espero 20 ns (configurado al principio)

        A = 1;
        #20;

        A = 0;
        #20;

        $display("Test complete");  // Imprimo algo en consola/pantalla
    end

endmodule

// Para ejecutar la prueba se corren los siguientes comandos:
// iverilog -o hello_tb.vvp hello_tb.v  --> Esto sintetizar el testbench y lo guarda en el archivo *.vvp
// vvp .\hello_tb.vvp                   --> Este comando efectivamente ejecuta la simulacion, crea un archivo *.vcd
// gtkwave                              --> Ejecuta el visualizador de señales, se debe cargar el archivo *.vcd para verla