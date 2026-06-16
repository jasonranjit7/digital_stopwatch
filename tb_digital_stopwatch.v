module digital_stopwatch_tb #(parameter TICK_DIV = 4)();
  reg clk,rst,start_stop,lap,clear;
  wire running, lap_active;
  wire [15:0] time_count, lap_count;
  wire [1:0] state_dbg;
  
  
  //DUT instantiation
  digital_stopwatch #(.TICK_DIV(TICK_DIV)) DUT(.clk(clk),
                .rst(rst),
                .start_stop(start_stop),
                .lap(lap),
                .clear(clear),
                .running(running),
                .lap_active(lap_active),
                .time_count(time_count),
                .lap_count(lap_count),
                .state_dbg(state_dbg)
               );
  
  //clk gen
  initial begin
    clk = 0;
    forever #20 clk = ~clk;
  end
  
  //task for running
  task run;
    input s;
    input l;
    input c;
    begin
      start_stop = s;
      lap = l;
      clear = c;
      repeat(10)@(posedge clk);
    end
  endtask
  
  initial begin
    $dumpfile("stopwatch.vcd");
    $dumpvars(0,digital_stopwatch_tb.DUT);
    rst = 1;
    repeat(5)@(posedge clk);
    rst = 0;
    $monitor("running = %b, state = %b, lap active =%b, clear = %b, lap_count = %b, time = %0t",DUT.running, state_dbg, lap_active, clear, lap_count, $time);
    run(1,0,0);
    run(1,0,0);
    run(1,0,1);
    run(1,0,0);
    run(1,0,0);
    run(1,1,0);
    run(0,1,0);
    $finish();
  end
      
  
endmodule

