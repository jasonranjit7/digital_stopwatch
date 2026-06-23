module tick_divider #(parameter TICK_DIV = 3)(input clk,
                                              input rst,
                                              output reg tick_en
                                             );
  
  reg [($clog2(TICK_DIV))-1:0] count;
  
  always@(posedge clk) begin
    if(rst) begin
      count <= 0;
      tick_en<=0;
    end
    else if(count == TICK_DIV-1) begin
      count <= 0;
      tick_en <= ~tick_en;
    end
    else begin
      count <= count + 1;
    end
  end
  
endmodule