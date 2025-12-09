module Motor(
    input mover,
    input CLK,
    output INA,
    output INA2,
    output INB,
    output INB2
);

//registros pa contadores
parameter STEP_FREQ_DIV = 375000-1; //los 50MHz toca bajarlos (50M/(2*125))
reg [7:0] duty;//duty, va de 0 a 255
reg CLKint; 
reg [$clog2(STEP_FREQ_DIV-1):0] counter;

//registros pa la maquina de estados
reg [3:0] PASO;
reg sentido;

//registros pa el duty de cada motor y cables pa las salidas
reg [7:0] dutyA;
reg [7:0] dutyA2;
reg [7:0] dutyB;
reg [7:0] dutyB2;
wire pwmINA;
wire pwmINA2;
wire pwmINB;
wire pwmINB2;
assign INA = pwmINA;
assign INA2 = pwmINA2;
assign INB = pwmINB;
assign INB2 = pwmINB2;


initial begin
    counter = 'b0;
    CLKint = 0;
    sentido=1;
    duty = 180;
end

always @(posedge CLK) begin
    if (counter>=STEP_FREQ_DIV) begin
        counter<=0;
        CLKint<=~CLKint;
    end
    else begin  
        counter <= counter+1;
    end
end

initial begin
    //A,A2,B,B2
    PASO = 4'b0000;
end

//separé los estados de las salidas, entonces acá están solo los estados
always @(posedge CLKint) begin
    if (mover) begin
        case(PASO)
            4'b0000: PASO=4'b0001;//prender el motor si estaba en ceros
            4'b0001: PASO=(sentido) ? 4'b0101 : 4'b1001;
            4'b0101: PASO=(sentido) ? 4'b0100 : 4'b0001;
            4'b0100: PASO=(sentido) ? 4'b0110 : 4'b0101;
            4'b0110: PASO=(sentido) ? 4'b0010 : 4'b0100;
            4'b0010: PASO=(sentido) ? 4'b1010 : 4'b0110;
            4'b1010: PASO=(sentido) ? 4'b1000 : 4'b0010;
            4'b1000: PASO=(sentido) ? 4'b1001 : 4'b1010;
            4'b1001: PASO=(sentido) ? 4'b0001 : 4'b1000;
            //default: PASO=4'b0000;
        endcase
    end
    else begin
        PASO<=4'b0000;
    end
end

//y por acá las salidas
always @(*) begin
    case(PASO)
        //A,A2,B,B2
        4'b0001: begin
            dutyA =0;
            dutyA2 =0;
            dutyB =0;
            dutyB2 = duty; end
        4'b0101: begin
            dutyA  = 0;
            dutyA2 = duty;
            dutyB  = 0;
            dutyB2 = duty; end
        4'b0100: begin 
            dutyA  = 0;
            dutyA2 = duty;
            dutyB  = 0;
            dutyB2 = 0; end
        4'b0110: begin
            dutyA  = 0;
            dutyA2 = duty;
            dutyB  = duty;
            dutyB2 = 0; end
        4'b0010: begin 
            dutyA  = 0;
            dutyA2 = 0;
            dutyB  = duty;
            dutyB2 = 0; end
        4'b1010: begin 
            dutyA  = duty;
            dutyA2 = 0;
            dutyB  = duty;
            dutyB2 = 0; end
        4'b1000: begin 
            dutyA  = duty;
            dutyA2 = 0;
            dutyB  = 0;
            dutyB2 = 0; end
        4'b1001: begin 
            dutyA  = duty;
            dutyA2 = 0;
            dutyB  = 0;
            dutyB2 = duty; end
        4'b0000: begin 
            dutyA  = 0;
            dutyA2 = 0;
            dutyB  = 0;
            dutyB2 = 0; end
        //default: begin
        //    dutyA  = 0;
        //    dutyA2 = 0;
        //    dutyB  = 0;
        //    dutyB2 = 0; end
    endcase
end

//le asigno el pwm a cada salida
pwm p1(
    .CLK(CLK), 
    .duty(dutyA), 
    .pwmOut(pwmINA)
);

pwm p2(
    .CLK(CLK), 
    .duty(dutyA2), 
    .pwmOut(pwmINA2)
);

pwm p3(
    .CLK(CLK), 
    .duty(dutyB), 
    .pwmOut(pwmINB)
);

pwm p4(
    .CLK(CLK), 
    .duty(dutyB2), 
    .pwmOut(pwmINB2)
);
endmodule