module LATSTB(
    input  CLKimpr,
    input  CLK,
    input  DO,
    output reg LAT,
    output reg STB
);

reg [9:0] numDatos;
reg [2:0] paquete;
reg termine;

reg lat_toggle;

reg lat_sync0;
reg lat_sync1;
reg lat_sync1_d;
reg lat_event;

reg [5:0] cLAT;
reg enableLAT;

reg [6:0] cSTB;
reg enableSTB;

reg [9:0] posicion;

initial begin
    numDatos    = 0;
    paquete     = 0;
    termine     = 0;
    lat_toggle  = 0;
    lat_sync0   = 0;
    lat_sync1   = 0;
    lat_sync1_d = 0;
    lat_event   = 0;
    LAT         = 0;
    enableLAT   = 0;
    cLAT        = 0;
    STB         = 0;
    enableSTB   = 0;
    cSTB        = 0;
    posicion      = 0;
end

always @(*) begin
    case (paquete)
        3'd0: posicion = 10'd64;
        3'd1: posicion = 10'd128;
        3'd2: posicion = 10'd192;
        3'd3: posicion = 10'd256;
        3'd4: posicion = 10'd320;
        3'd5: posicion = 10'd384;
        default: posicion = 10'd64;
    endcase
end

always @(posedge CLKimpr) begin

    if (numDatos == posicion) begin
        if (!termine) begin
            termine    <= 1;
            lat_toggle <= ~lat_toggle;
        end
    end

    if (numDatos == 10'd384) begin
        numDatos <= 0;
        termine  <= 0;

        if (paquete == 3'd5)
            paquete <= 0;
        else
            paquete <= paquete + 1;
    end
    else begin
        numDatos <= numDatos + 1;
    end
end

always @(posedge CLK) begin
    lat_sync0   <= lat_toggle;
    lat_sync1   <= lat_sync0;
    lat_event   <= (lat_sync1 != lat_sync1_d);
    lat_sync1_d <= lat_sync1;

    if (lat_event)
        enableLAT <= 1;

    if (enableLAT) begin
        LAT <= 1;
        if (cLAT == 6'd10) begin
            LAT       <= 0;
            enableLAT <= 0;
            cLAT      <= 0;
            enableSTB <= 1;
        end
        else
            cLAT <= cLAT + 1;
    end

    if (enableSTB) begin
        STB <= 1;
        if (cSTB == 7'd50) begin
            STB <= 0;
            enableSTB <= 0;
            cSTB <= 0;
        end
        else
            cSTB <= cSTB + 1;
    end
end

endmodule
