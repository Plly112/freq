/**************************************************************
@File    :   top_freq_system.v
@Time    :   2025/07/01 12:33:44
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   顶层模块
**************************************************************/
module top_freq_test (
    input wire         clk        , // 20MHz 系统时钟
    input wire         rst_n      , // 低电平有效复位
    input wire         pulse_sig_1, // 脉冲接收引脚1
    input wire         pulse_sig_2, // 脉冲接收引脚2
    input wire         pulse_sig_3, // 脉冲接收引脚3
    input wire         pulse_sig_4, // 脉冲接收引脚4
    output wire [19:0] freq_out_1 , // 检测得到的频率1（单位：Hz）
    output wire [19:0] freq_out_2 , // 检测得到的频率2（单位：Hz）
    output wire [19:0] freq_out_3 , // 检测得到的频率3（单位：Hz）
    output wire [19:0] freq_out_4   // 检测得到的频率4（单位：Hz）
);

localparam CLK_FREQ = 20_000_000;  //时钟频率，20MHz

reg   [19:0] freq;

    freq_detector u_freq_detector_0(
        .clk      (clk          ),
        .rst_n    (rst_n        ),
        .pulse_in (pulse_sig_1  ),
        .freq     (freq_out_1   )
    );

    freq_detector u_freq_detector_1(
        .clk      (clk          ),
        .rst_n    (rst_n        ),
        .pulse_in (pulse_sig_2  ),
        .freq     (freq_out_2   )
    );

    freq_detector u_freq_detector_2(
        .clk      (clk          ),
        .rst_n    (rst_n        ),
        .pulse_in (pulse_sig_3 ),
        .freq     (freq_out_3   )
    );

    freq_detector u_freq_detector_3(
        .clk      (clk          ),
        .rst_n    (rst_n        ),
        .pulse_in (pulse_sig_4  ),
        .freq     (freq_out_4   )
    );

endmodule