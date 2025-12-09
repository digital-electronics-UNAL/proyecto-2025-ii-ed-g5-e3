`timescale 1ns/1ps
`include "enviaDatosRX.v"
`include "RX.v"
`include "enviaDatos.v"
`include "latch.v"
`include "RETO.v"
`include "moverMotor.v"
`include "lcd1602_Proy.v"
`include "Motor.v"
`include "pwm.v"

module tb_enviandoDatos();

    reg Rx_tb;
    reg CLK_tb;
    wire INA_tb;
    wire INA2_tb;
    wire INB_tb;
    wire INB2_tb;
    wire DO_tb;
    wire CLKimpr_tb;
    wire LAT_tb;
    wire STB_tb;

    RETO uut(
        .INA(INA_tb),
        .INB(INB_tb),
        .INA2(INA2_tb),
        .INB2(INB2_tb),
        .Rx(Rx_tb),
        .CLK(CLK_tb),
        .DO(DO_tb),
        .CLKimpr(CLKimpr_tb),
        .LAT(LAT_tb),
        .STB(STB_tb)
    );

    initial begin
        CLK_tb=0;
        forever #10 CLK_tb=~CLK_tb;
    end

    integer paquete=0;
    integer bytei=0;

    initial begin
        Rx_tb = 1;
        #104166;

        for (paquete = 0; paquete < 7; paquete = paquete + 1) begin
            for (bytei = 0; bytei < 32; bytei = bytei + 1) begin

                Rx_tb = 0; #104166;

                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;
                Rx_tb = 1; #104166;

                Rx_tb = 1; #104166;
            end
        end

        #104166;
    end

    initial begin: TEST_CASE
        $dumpfile("tb_RETO.vcd");
        $dumpvars(-1, uut);
        #428800000 $finish;
    end

endmodule