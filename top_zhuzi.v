/**************************************************************
@File    :   top.v
@Time    :   2025/07/03 14:20:33
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   顶层模块
**************************************************************/
module top_pulse_filter (
    input              clk_20m        , //20MHz 时钟
    input              rst_n          , //全局复位
    input  [31:0]      pulse_raw      , //原始32路脉冲输入
    input  [15:0]      filter_coeff   , //滤波周期数（单位：10ns，即1 clk）
    output [31:0]      pulse_filtered   //滤波后的输出脉冲
);

    //实例化滤波模块
    pulse_filter_32ch u_pulse_filter_32ch (
        .clk_20m     (clk_20m       ),
        .rst_n       (rst_n         ),
        .pulse_in    (pulse_raw     ),
        .filter_cfg  (filter_coeff  ),
        .pulse_out   (pulse_filtered)
    );

endmodule