`timescale 1ns/1ps
`include "moverMotor.v"
`include "Motor.v"
`include "pwm.v"

module tb_RX();

    reg CLK_tb;
    reg STB_tb;
    wire INA_tb;
    wire INA2_tb;
    wire INB_tb;
    wire INB2_tb;

    moverMotor uut(
        .CLK(CLK_tb),
        .STB(STB_tb),
        .INA(INA_tb),
        .INA2(INA2_tb),
        .INB(INB_tb),
        .INB2(INB2_tb)
    );

    initial begin
        CLK_tb = 0;
        forever #10 CLK_tb = ~CLK_tb;  // Periodo = 20ns
    end

    initial begin
        STB_tb=0;#10;
        STB_tb=1;#100;
        STB_tb=0;#100;
        STB_tb=1;#100;
        STB_tb=0;#100;
        STB_tb=1;#100;
        STB_tb=0;#100;
        STB_tb=1;#100;
        STB_tb=0;#100;
        STB_tb=1;#100;
        STB_tb=0;#100;
        STB_tb=1;#100;
        STB_tb=0;#100;
    end

    initial begin: TEST_CASE
        $dumpfile("tb_moverMotor.vcd");
        $dumpvars(-1, uut);
        #150000000 $finish;
    end

endmodule