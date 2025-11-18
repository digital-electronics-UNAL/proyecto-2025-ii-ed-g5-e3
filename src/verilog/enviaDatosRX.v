module enviaDatosRX (
    input Rx,
    input CLK,
    output DO,
    output CLKimpr,
    output LAT,
    output STB
);

wire DI;
wire enviando;

RX r(
    .CLK(CLK),
    .Rx(Rx),
    .DI(DI),
    .enviando(enviando)
);

enviaDatos ed1(
    .DI(DI),
    .enviando(enviando),
    .CLK(CLK),
    .DO(DO),
    .CLKimpr(CLKimpr)
);

LATSTB ls(
    .DO(DO),
    .CLKimpr(CLKimpr),
    .CLK(CLK),
    .LAT(LAT),
    .STB(STB)
);

endmodule