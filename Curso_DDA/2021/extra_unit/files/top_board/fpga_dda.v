/*-----------------------------------------------------------------------------
-- Archivo       : fpga_dda.v
-- Organizacion  : EAMTA 2019
-------------------------------------------------------------------------------
-- Descripcion   : Top level de implementacion
-------------------------------------------------------------------------------
-- Autor         : Ariel Pola
-------------------------------------------------------------------------------*/

module fpga
  (
   out_leds_rgb0,
   out_leds_rgb1,
   out_leds_rgb2,
   out_leds_rgb3,
   out_leds,
   out_tx_uart,
   in_rx_uart,
   in_reset,
   i_sw,
   clk100
   );

   ///////////////////////////////////////////
   // Parameter
   ///////////////////////////////////////////
   parameter NB_GPIOS              = 32;
   parameter NB_LEDS               = 4;

   ///////////////////////////////////////////
   // Ports
   ///////////////////////////////////////////
   output wire [NB_LEDS - 1 : 0]                     out_leds;
   output [3 - 1 : 0]                                out_leds_rgb0;
   output [3 - 1 : 0]                                out_leds_rgb1;
   output [3 - 1 : 0]                                out_leds_rgb2;
   output [3 - 1 : 0]                                out_leds_rgb3;

   output wire                                       out_tx_uart;
   input wire                                        in_rx_uart;
   input wire                                        in_reset;
   input wire [3     : 0]                            i_sw;
   input                                             clk100;

   ///////////////////////////////////////////
   // Vars
   ///////////////////////////////////////////
   wire [NB_GPIOS                 - 1 : 0]           gpo0;
   wire [NB_GPIOS                 - 1 : 0]           gpi0;

   wire                                              locked;

   wire                                              soft_reset;
   wire                                              clockdsp;

   //////////////////////////////////////////////////////////////
   // Descomentar en caso de incluir el VIO
   wire                                              fromHard;
   wire [3  : 0]                                     fromVio;
   
   ///////////////////////////////////////////
   // MicroBlaze
   ///////////////////////////////////////////
   //design_1
   microBlaze
     u_micro
       (.clock100         (clockdsp    ),  // Clock aplicacion
        .gpio_rtl_tri_o   (gpo0        ),  // GPIO
        .gpio_rtl_tri_i   (gpi0        ),  // GPIO
        .reset            (in_reset    ),  // Hard Reset
        .sys_clock        (clk100      ),  // Clock de FPGA
        .o_lock_clock     (locked      ),  // Senal Lock Clock
        .usb_uart_rxd     (in_rx_uart  ),  // UART
        .usb_uart_txd     (out_tx_uart )   // UART
        );

   ///////////////////////////////////////////
   // Leds
   ///////////////////////////////////////////
   assign out_leds[0] = locked;
   assign out_leds[1] = ~in_reset;
   assign out_leds[2] = gpo0[12];
   assign out_leds[3] = gpo0[13];

   assign out_leds_rgb0[0] = gpo0[0];
   assign out_leds_rgb0[1] = gpo0[1];
   assign out_leds_rgb0[2] = gpo0[2];

   assign out_leds_rgb1[0] = gpo0[3];
   assign out_leds_rgb1[1] = gpo0[4];
   assign out_leds_rgb1[2] = gpo0[5];

   assign out_leds_rgb2[0] = gpo0[6];
   assign out_leds_rgb2[1] = gpo0[7];
   assign out_leds_rgb2[2] = gpo0[8];

   assign out_leds_rgb3[0] = gpo0[9];
   assign out_leds_rgb3[1] = gpo0[10];
   assign out_leds_rgb3[2] = gpo0[11];

   assign gpi0[31 : 4] = {28{1'b0}};
   assign gpi0[3  : 0] = (fromHard) ? i_sw : fromVio; // Descomentar en caso de incluir el VIO
  //  assign gpi0[3  : 0] = i_sw; // Comentar en caso de incluir el VIO

   ///////////////////////////////////////////
   // Descomentar en caso de incluir el VIO
   
   vio
   u_vio
   (.clk_0        (clockdsp),
    .probe_in0_0  ({gpo0[2] ,gpo0[1] ,gpo0[0]}),
    .probe_in1_0  ({gpo0[5] ,gpo0[4] ,gpo0[3]}),
    .probe_in2_0  ({gpo0[8] ,gpo0[7] ,gpo0[6]}),
    .probe_in3_0  ({gpo0[11],gpo0[10],gpo0[9]}),
    .probe_out0_0 (fromHard),
    .probe_out1_0 (fromVio)
    );
    


endmodule // fpga
