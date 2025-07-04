`timescale 1ns / 1ns

module tb_top_freq_test;

    // 输入信号
    reg         clk               ;
    reg         rst_n             ;
    reg         pulse_sig_1 = 4'b0;
    reg         pulse_sig_2 = 4'b0;
    reg         pulse_sig_3 = 4'b0;
    reg         pulse_sig_4 = 4'b0;

    reg  [31:0] freq_set_0;
    reg  [31:0] freq_set_1;
    reg  [31:0] freq_set_2;
    reg  [31:0] freq_set_3;

    wire [19:0] freq_out_1;
    wire [19:0] freq_out_2;
    wire [19:0] freq_out_3;
    wire [19:0] freq_out_4;
    // 输出信号
    wire pulse_debug;
    wire [31:0] freq_out;

    // 例化待测模块
    top_freq_test u_top_freq_test(
        .clk         (clk         ), // 20MHz 系统时钟
        .rst_n       (rst_n       ), // 低电平有效复位
        .pulse_sig_1 (pulse_sig_1 ),
        .pulse_sig_2 (pulse_sig_2 ),
        .pulse_sig_3 (pulse_sig_3 ),
        .pulse_sig_4 (pulse_sig_4 ),
        .freq_out_1  (freq_out_1  ),
        .freq_out_2  (freq_out_2  ),
        .freq_out_3  (freq_out_3  ),
        .freq_out_4  (freq_out_4  )
    );

    // 产生 20MHz 时钟周期 = 50ns,每个半周期是 25ns
    initial clk = 0;
    always #25 clk = ~clk;

    //动态产生模拟脉冲信号
    //产生xxHz脉冲信号,每20000000/freq_set_x*25反转一次
    //20000000/freq_set_0：20MHz系统时钟下，产生目标频率所需的时钟周期数
    //*25：将每半个周期数转换为仿真延时时间
    always #(20000000/freq_set_0*25) pulse_sig_1 = ~pulse_sig_1; // 产生 xxHz 脉冲信号
    always #(20000000/freq_set_1*25) pulse_sig_2 = ~pulse_sig_2; // 产生 xxHz 脉冲信号
    always #(20000000/freq_set_2*25) pulse_sig_3 = ~pulse_sig_3; // 产生 xxHz 脉冲信号
    always #(20000000/freq_set_3*25) pulse_sig_4 = ~pulse_sig_4; // 产生 xxHz 脉冲信号

    // 仿真控制流程
    initial begin
        // 初始状态
        rst_n       = 0;
        freq_set_0  = 32'd1;  // 设置目标频率为 1Hz
        freq_set_1  = 32'd3333;
        freq_set_2  = 32'd50000;
        freq_set_3  = 32'd200000;

        pulse_sig_1 = 4'b0;
        pulse_sig_2 = 4'b0;
        pulse_sig_3 = 4'b0;
        pulse_sig_4 = 4'b0;

        // 复位
        #100;
        rst_n = 1;

        // 再模拟一会儿
        #2000000000;

        // 仿真结束
        $stop;
    end

endmodule