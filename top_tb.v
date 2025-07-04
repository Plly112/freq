`timescale 1ns / 1ns

module tb_top_pulse_filter;

    reg          clk_20m       ;
    reg          rst_n         ;
    reg  [31:0]  pulse_raw     ; //32路输入信号打包在一个32位总线上
    reg  [22:0]  filter_coeff  ; //周期系数
    wire [31:0]  pulse_filtered;

    // 实例化待测模块
    top_pulse_filter uut (
        .clk_20m        (clk_20m),
        .rst_n          (rst_n),
        .pulse_raw      (pulse_raw),
        .filter_coeff   (filter_coeff),
        .pulse_filtered (pulse_filtered)
    );

    // 20MHz 时钟，周期 = 50ns
    always #25 clk_20m = ~clk_20m;

    initial begin
        clk_20m      = 0;
        rst_n        = 0;
        pulse_raw    = 32'd0;
        filter_coeff = 23'd0;

        // 释放复位
        #100;
        rst_n = 1;
        filter_coeff = 23'd2000000;  // 设置为 100ms (100000000 ns / 50ns = 2000000周期)

        // == 第0通道输入初始化为低电平
        pulse_raw[0] = 0;

        // 模拟 100us 时产生一个 1us 毛刺（模拟抖动）
        #1000000;
        pulse_raw[0] = 1;

        #1000;       // 1us毛刺,1000ns

        pulse_raw[0] = 0;

        // 模拟在 300ms 时产生真正的高电平（持续不变）
        #299000000;
        pulse_raw[0] = 1;

        // 模拟时间拉长一些用于观察输出变化
        #1000000000;

        $stop;
    end

endmodule