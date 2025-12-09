module pwm (
    input CLK,
    input [7:0] duty,
    output reg pwmOut
);

reg [16:0] counter = 0;
reg [31:0] duty_scaled;

always @(posedge CLK) begin
    duty_scaled <= duty * 17'd390;

    if (counter >= 17'd99999)
        counter <= 0;
    else
        counter <= counter + 1;

    pwmOut <= (counter < duty_scaled);
end

endmodule