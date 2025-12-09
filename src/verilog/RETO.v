module RETO(
    input Rx,
    input CLK,
    output INA,
    output INA2,
    output INB,
    output INB2,
    output DO,
    output LAT,
    output STB,
    output CLKimpr
);

wire DI;
wire enviando;

wire DO_;
wire CLKimpr_;
wire STB_;

assign DO=DO_;
assign CLKimpr=CLKimpr_;
assign STB=STB_;

RX r1(
    .CLK(CLK),
    .Rx(Rx),
    .DI(DI),
    .enviando(enviando)
);

enviaDatos ed1(
    .DI(DI),
    .enviando(enviando),
    .CLK(CLK),
    .DO(DO_),
    .CLKimpr(CLKimpr_)
);

LATSTB l(
    .DO(DO_),
    .CLKimpr(CLKimpr_),
    .CLK(CLK),
    .LAT(LAT),
    .STB(STB_)
);

moverMotor mt(
    .STB(STB_),
    .CLK(CLK),
    .INA(INA),
    .INA2(INA2),
    .INB(INB),
    .INB2(INB2)
);

LCD1602_controllerP lcd(
    .clk(CLK),
    .reset(1'b1),
    .ready_i(1'b1)
);

endmodule