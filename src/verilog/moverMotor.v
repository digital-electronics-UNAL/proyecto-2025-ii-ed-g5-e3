module moverMotor(
    input STB,
    input CLK,
    output INA,
    output INA2,
    output INB,
    output INB2
);

reg [3:0] cSTB;
reg [$clog2(20000000):0] cMotor;
reg enableMotor;
reg STB2;
reg [1:0] magia;
wire x;
assign x=magia[0];

initial begin
    cSTB='b0;
    cMotor = 'b0;
    enableMotor = 0;
    STB2 =0;
    magia='b0;
end

always @(posedge CLK) begin 
    case (magia)
        2'b00: magia=STB ? 2'b01:2'b00;
        2'b01: magia=2'b10;
        2'b10: magia= STB? 2'b10: 2'b00;
        default: magia=2'b00;
    endcase
end

always @(posedge CLK) begin
    if (enableMotor) begin
        if (cMotor>=20000000) begin
            cMotor<=0;
            enableMotor<= 0;  
        end else begin
            cMotor<=cMotor+1;
        end
    end else begin
        if (x) begin
            if (cSTB==5) begin
                cSTB<=0;
                enableMotor <=1;
            end else begin
                cSTB<=cSTB+1;
            end
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