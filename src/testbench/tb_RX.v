`timescale 1ns/1ps
`include "RX.v"

module tb_RX();

    reg CLK_tb;
    reg Rx_tb;
    wire DI_tb;
    wire enviando_tb;

    RX uut(
        .CLK(CLK_tb),
        .Rx(Rx_tb),
        .DI(DI_tb),
        .enviando(enviando_tb)
    );

    initial begin
        CLK_tb = 0;
        forever #10 CLK_tb = ~CLK_tb;  // Periodo = 20ns
    end

    initial begin
        Rx_tb = 1;
        #104000;

        Rx_tb = 0;
        #104000; 

        Rx_tb = 1; #104000;//bit0
        Rx_tb = 0; #104000;//bit1
        Rx_tb = 1; #104000;//bit2
        Rx_tb = 0; #104000;//bit3
        Rx_tb = 1; #104000;//bit4
        Rx_tb = 0; #104000;//bit5
        Rx_tb = 1; #104000;//bit6
        Rx_tb = 0; #104000;//bit7

        Rx_tb = 1;
        #208000;

        Rx_tb = 0;
        #104000; 

        Rx_tb = 0; #104000;//bit0
        Rx_tb = 1; #104000;//bit1
        Rx_tb = 0; #104000;//bit2
        Rx_tb = 1; #104000;//bit3
        Rx_tb = 1; #104000;//bit4
        Rx_tb = 0; #104000;//bit5
        Rx_tb = 0; #104000;//bit6
        Rx_tb = 1; #104000;//bit7

        Rx_tb = 1;
        #104000;
    end

    initial begin: TEST_CASE
        $dumpfile("tb_RX.vcd");
        $dumpvars(-1, uut);
        #2288000 $finish;
    end

endmodule