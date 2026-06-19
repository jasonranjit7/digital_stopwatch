`include "../design/tick_divider/tick_divider.v"
`include "../design/digital_stopwatch.v"

module digital_stopwatch_top #(parameter TICK_DIV = 50000000)(
  
  input clk,
  input rst,
  input tick_rst,
  input start,
  input lap,
  input clear,
  output reg [15:0] count
);
  
  digital_stopwatch #(.TICK_DIV(TICK_DIV)) stopwatch(
    
    .clk(clk),
    .rst(rst),
    .tick_rst(tick_rst),
    .start(start),
    .lap(lap),
    .clear(clear),
    .count(count)
  );
  
endmodule
  
