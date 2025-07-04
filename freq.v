/**************************************************************
@File    :   lyh.v
@Time    :   2025/07/01 11:35:52
@Author  :   liyuanhao 
@EditTool:   VS Code 
@Font    :   UTF-8 
@Function:   频率检测
             通过测量相邻两个脉冲上升沿之间(一个周期)的时钟周期来计算输入脉冲信号的频率
**************************************************************/
module freq_detector(
    input             clk               ,
    input             rst_n             ,
    input             pulse_in          , //输入脉冲信号
    output reg [31:0] freq                //输出计算得到的频率值
);

localparam CLK_FREQ = 20000000;  //时钟频率，20MHz

//频率上限,防止无效高频
localparam CLK_300MHz = 300000;//300kHz在1秒内的脉冲数,脉冲个数=频率*时间,300*10^3*1

reg [31:0] freq_reg = 0; //频率寄存器

// 两个寄存器用于脉冲输入的边沿检测，以及一个中间信号 rising_edge 表示是否检测到上升沿
reg  pulse_in_d1, pulse_in_d2;
wire rising_edge;

// == 脉冲上升沿检测（0 -> 1）
always @(posedge clk or negedge rst_n) begin
     if (!rst_n) begin
         pulse_in_d1 <= 1'b0;
         pulse_in_d2 <= 1'b0;
     end 

     else begin
         pulse_in_d1 <= pulse_in;
         pulse_in_d2 <= pulse_in_d1;
     end
 end

assign rising_edge = (pulse_in_d1 && !pulse_in_d2); //当pulse_in从0跳变到1时，rising_edge被置为1，代表检测到一个脉冲周期起点

reg [31:0]PULSE_ticks = 0;     //脉冲周期间的时钟周期数(即时间间隔)

//初始化
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        PULSE_ticks <= 0;
    end

    else begin

    PULSE_ticks <= PULSE_ticks + 1; //脉冲周期间的时钟周期数不为0,加1

        if(rising_edge)begin  //脉冲上升沿
            PULSE_ticks <= 1; //脉冲上升沿到来表示第一个周期开始
            freq_reg <= CLK_FREQ / PULSE_ticks; //频率 = 时钟频率 / 周期时钟数
        end
    end

end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        freq <= 0;
    end

    else if(freq_reg <= CLK_300MHz)begin
        freq <= freq_reg;
    end
end

endmodule