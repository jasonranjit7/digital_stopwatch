module digital_stopwatch_tb #(parameter TICK_DIV = 2)();
  reg clk,rst,tick_rst,start_stop,lap,clear;
  wire running, lap_active;
  wire [15:0] time_count, lap_count;
  wire [1:0] state_dbg;
  
  
  //DUT instantiation
  digital_stopwatch #(.TICK_DIV(TICK_DIV)) DUT(.clk(clk),
                .rst(rst),
                .tick_rst(tick_rst),
                .start_stop(start_stop),
                .lap(lap),
                .clear(clear),
                .running(running),
                .lap_active(lap_active),
                .time_count(time_count),
                .lap_count(lap_count),
                .state_dbg(state_dbg)
               );
  
  wire tick = DUT.tick_en;
  
  initial begin
    clk = 0;
    rst = 1;
    tick_rst = 1;
    start_stop = 0;
    lap = 0;
    clear = 0;
  end
  
  //clk gen
  initial begin
    forever #20 clk = ~clk;
  end
  
  task start;
    begin
      @(negedge tick);
      $display("Starting stopwatch");
      #1 start_stop = 1;
      @(posedge tick);
      #1 start_stop = 0;
    end
  endtask

  task clearing;
    begin
      @(negedge tick);
      $display("Clearing stopwatch");
      #1 clear = 1;
      @(posedge tick);
      #1 clear = 0;
    end
  endtask
  
  task lapping;
    begin
      @(negedge tick);
      $display("pressing lap button");
      #1 lap = 1;
      @(posedge tick);
      #1 lap = 0;
    end
  endtask
  
  task wait_ticks(input integer n);
    begin
      repeat(n*TICK_DIV) @(posedge clk);
    end
  endtask
  
  task test_start;
    begin
      start();
      if(state_dbg == 2'b01)
        $display("Inside running state");
      wait_ticks(5);
      lapping();
      if(state_dbg == 2'b10)
        $display("Inside lap mode");
      wait_ticks(11);
      lapping();
      if(state_dbg == 2'b01)
        $display("Inside running state");
      wait_ticks(8);
      lapping();
      if(state_dbg == 2'b10)
        $display("Inside lap mode");
      wait_ticks(11);
      clearing();
      if(state_dbg == 2'b00)
        $display("Inside idle state");
      wait_ticks(5);
    end
  endtask
  
  initial begin
    $dumpfile("stopwatch.vcd");
    $dumpvars(0,digital_stopwatch_tb.DUT);
    
    $monitor("running = %b, state = %d, lap_count = %b, time_count = %0d",DUT.running, state_dbg, lap_count, time_count);
    
    wait_ticks(5);
    tick_rst = 0;
    wait_ticks(10);
    rst = 0;
    wait_ticks(10);
    test_start();
    wait_ticks(5);
    $finish();
  end
      
  
endmodule
