module moverMotor(
    input STB,
    input CLK,
    output INA,
    output INA2,
    output INB,
    output INB2
);

reg [3:0] cSTB=0;
reg [7:0] cMotor = 0;
reg enableMotor = 0;

reg STB2 =0;
reg detSTB = 0;

always @(posedge CLK) begin
    STB2=STB;
    detSTB=(STB&~STB2);//chambonada
end

always @(posedge CLK) begin
    if (!enableMotor) begin
        if (detSTB) begin
            if (cSTB==5) begin
                cSTB=0;
                enableMotor =1;
            end else begin
                cSTB=cSTB+1;
            end
        end
    end
end

always @(posedge CLK) begin
    if (enableMotor) begin
        if (cMotor==100) begin
            cMotor=0;
            enableMotor= 0;  
        end else begin
            cMotor=cMotor+1;
        end
    end
end

Motor m(
    .mover(enableMotor),
    .CLK(CLK),
    .INA(INA),
    .INA2(INA2),
    .INB(INB),
    .INB2(INB2)
);

endmodule