`timescale 1ns / 1ps
module tb_start_stop_detector;

  // Señales
  reg scl;
  reg sda;
  wire start_cond;
  wire stop_cond;
  wire bus_en;

  // Instancia del DUT
  start_stop_detector uut (
    .scl(scl),
    .sda(sda),
    .start_cond(start_cond),
    .stop_cond(stop_cond),
    .bus_en(bus_en)
  );

  // Clock SCL: periodo 10 ns
  always #5 scl = ~scl;

  // Tarea para generar START con tiempo de establecimiento
  task generate_start();
    begin
      sda = 1;
      @(posedge scl); // Esperamos a que SCL esté alto
      #2;             // Tiempo de establecimiento con SCL en 1
      sda = 0;        // START: SDA cae mientras SCL alto
      $display("START generado en t=%0t", $time);
      #2;            // Esperar propagación
    end
  endtask

  // Tarea para generar STOP con tiempo de establecimiento
  task generate_stop();
    begin
      sda = 0;
      @(posedge scl); // Esperamos a que SCL esté alto
      #2;             // Tiempo de establecimiento con SCL en 1
      sda = 1;        // STOP: SDA sube mientras SCL alto
      $display("STOP generado en t=%0t", $time);
      #2;            // Esperar propagación
    end
  endtask

  // Tarea para simular bits de datos (no afectan START/STOP)
  task simulate_data(int bits = 8);
    integer i;
    begin
      for (i = 0; i < bits; i++) begin
        @(negedge scl);
        sda = $random % 2;
      end
    end
  endtask

  // Test principal
  initial begin
    scl = 1;
    sda = 1;
    #10;

    repeat (3) begin
      generate_start();
      simulate_data();
      generate_stop();
//      #20;
    end

    $finish;
  end

  // Monitor
  initial begin
    $monitor("t=%0t | SCL=%b SDA=%b | START=%b STOP=%b BUS_EN=%b", 
             $time, scl, sda, start_cond, stop_cond, bus_en);
  end

endmodule