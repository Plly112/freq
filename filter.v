/**************************************************************
@File    :   filter.v
@Time    :   2025/07/03 14:05:47
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   脉冲去抖滤波器
             当输入值持续变化超过设定的滤波系数时才更新输出,除毛刺
**************************************************************/
module pulse_filter_32ch (
    input              clk_20m   , // 20MHz 时钟
    input              rst_n     , // 低电平复位
    input      [31:0]  pulse_in  , // 原始输入脉冲信号
    input      [15:0]  filter_cfg, // 滤波周期数配置（单位：时钟周期）
    output reg [31:0]  pulse_out   // 滤波后的输出信号
);
    integer i;

    reg [31:0]         stable_val;          // 当前稳定值
    reg [21:0]         cnt [31:0];          // 每通道计数器（支持200ms × 20MHz = 4,000,000周期）

    always @(posedge clk_20m or negedge rst_n) begin
        if (!rst_n) begin
            pulse_out   <= 32'd0;
            stable_val  <= 32'd0;
            for (i = 0; i < 32; i = i + 1)
                cnt[i] <= 22'd0; //所有通道的滤波计数器清零
        end

        else begin
            for (i = 0; i < 32; i = i + 1) begin
                if (pulse_in[i] != stable_val[i]) begin //当前输入值和稳定值不同,变化/毛刺
                    // 输入值变化，开始计数
                    if (cnt[i] >= filter_cfg) begin //计数器达到设定的滤波时间
                        stable_val[i] <= pulse_in[i]; //判定为稳定变化,更新输出
                        cnt[i]        <= 22'd0;
                    end 

                    else begin
                        cnt[i] <= cnt[i] + 1;
                    end
                end

                else begin
                    cnt[i] <= 22'd0; // 输入值稳定，清零
                end
            end
            pulse_out <= stable_val; //每个周期都将稳定值更新到输出端口
        end
    end

endmodule