`timescale 1ns/1ps
`include "enviaDatosRX.v"
`include "RX.v"
`include "enviaDatos.v"
`include "latch.v"

module tb_enviandoDatos();

    reg Rx_tb;
    reg CLK_tb;
    wire DO_tb;
    wire CLKimpr_tb;
    wire LAT_tb;
    wire STB_tb;

    enviaDatosRX uut(
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

        for (paquete = 0; paquete < 6; paquete = paquete + 1) begin
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
        $dumpfile("tb_enviandoDatos.vcd");
        $dumpvars(-1, uut);
        #228800000 $finish;
    end

endmodule