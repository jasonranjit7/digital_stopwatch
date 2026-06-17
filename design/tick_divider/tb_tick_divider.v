module tb_tick_div #(parameter TICK_DIV = 4)();
  reg clk,rst;
  wire tick_en;
  
  tick_divider #(.TICK_DIV(TICK_DIV)) DUT(.clk(clk),
                   .rst(rst),
                   .tick_en(tick_en)
                  );
  
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  
  initial begin
    rst = 1;
    repeat(2)@(posedge clk);
    rst = 0;
    $dumpfile("tb.vcd");
    $dumpvars(0);
              
    #1000
    $finish();
  end
endmodule
