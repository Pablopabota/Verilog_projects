//! @title FPGA Files List
//! @author Advance Digital Design - Ariel Pola
//! @date 10-10-2021
//! @version Unit03 - Mapeo de Arquitecturas Dedicadas
//! @brief Transmitter filter 
//! - PRBS generator with polyphase filters and block memory for save samples
//! - PRBS generator generates a bit per 8 clock cycles

`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/include/artyc_include.v"

`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/parallel_prbs_gen/prbsx.v"

`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/debug/bram.v"
`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/debug/ram_fsm.v"
`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/debug/ram_save.v"

`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/srrc/tx_fcsg.v"
`include "C:/Users/Asus/OneDrive/Documentos/GitHub/Verilog_projects/Curso_DDA/unit3/Lab3/rtl2021/srrc/tx_srrc.v"
