module RX (
    input CLK,
    input Rx,
    output reg DI,
    output reg enviando
);

reg IDLE;
reg [3:0] bitcounter;
reg [$clog2(5208):0] counter;
reg CLKinterno;
reg activo; 

initial begin
    CLKinterno=0;
    counter='b0;
    bitcounter='b0;
    IDLE = 1;
    DI = 0;
    enviando = 0;
    activo=0;
end

always @(posedge CLK) begin
    if (counter==5208/2) begin
        counter = 0;
        CLKinterno=~CLKinterno;
    end
    else begin
        counter = counter+1;
    end
end

always @(posedge CLKinterno) begin
    case (IDLE)
        1'b1: begin//no recibe
            DI=0;
            bitcounter=0;
            enviando=0;
            activo=0;
            if (Rx==0) begin
                IDLE = 0;
                activo=1;
            end
        end
        1'b0: begin//recibe
            if (activo) begin
                if (enviando) begin
                    enviando = 0;
                    DI=0;
                end

                bitcounter = bitcounter+1;
                if (bitcounter == 1 || bitcounter == 5) begin
                    DI = Rx;
                    enviando=1;
                end
                
                if (bitcounter==8) begin 
                    activo=0;
                end
            end else begin
                DI=0;
                enviando=0;
                bitcounter =0;
                IDLE =1;
            end
        end
    endcase
end

endmodule