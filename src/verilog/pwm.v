module pwm (
    input CLK,           // 50 MHz
    input [7:0] duty,    // 0–255
    output reg pwmOut
);

reg [9:0] counter = 0;
reg [5:0] prescaler = 0; // divide el clk 50 veces aprox

initial begin
    pwmOut=0;
end

always @(posedge CLK) begin
    if (prescaler == 49) begin
        prescaler <= 0;

        if (counter == 1023)
            counter <= 0;
        else
            counter <= counter + 1;

        pwmOut <= (counter < {duty,2'b00});
    end else begin
        prescaler <= prescaler + 1;
    end
end

endmodule