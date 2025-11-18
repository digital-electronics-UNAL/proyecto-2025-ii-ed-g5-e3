module enviaDatos (
	input DI,
	input enviando,
	input CLK,
	output DO,
	output CLKimpr
);

reg [63:0] serialPara1;
reg [63:0] serialPara2;
reg [8:0] cuentaBits;
reg enable;

reg CLK200khz;
reg [7:0] cCLK;

reg [9:0] cCLKimpr;
reg enableCLKimpr; 

reg enviando2;

wire x;
and(x, enableCLKimpr, ~CLK200khz);
assign CLKimpr = x;
assign DO = serialPara2[0];

initial begin
    serialPara1='b0;
    serialPara2 ='b0;
	enable = 0;
	cuentaBits = 0;
	CLK200khz = 0;
	cCLK = 0;
	enableCLKimpr = 0;
	cCLKimpr = 0;
	enviando2=0;
end

always @(posedge CLK) begin
	if (cCLK >= 125) begin
		cCLK <= 0;
		CLK200khz <= ~CLK200khz;
	end else begin
		cCLK <= cCLK + 1;
	end
end

always @(posedge CLK200khz) begin
	enviando2 = enviando;
	//recibe los datos
    if (enviando && !enviando2) begin
        serialPara1 <= {DI, serialPara1[63:1]};
        cuentaBits  <= cuentaBits + 1;
    end
    
	if (cuentaBits==64) begin//si se llena se lo manda al otro en paralelo
		enable=1; 
		enableCLKimpr=1;
		cuentaBits=0;
	end
	
	if (enable) begin
		serialPara2 <= serialPara1;
		enable =0;//se pone de una en serie
	end
	else begin
		serialPara2 <= serialPara2 >> 1;
	end
	//cuando se mandan los datos se hace junto al CLKimpr 
	if (enableCLKimpr) begin
		if (cCLKimpr>=384) begin
			cCLKimpr=0;
			enableCLKimpr=0;
		end else begin
			cCLKimpr<=cCLKimpr+1;
		end
	end
end

endmodule