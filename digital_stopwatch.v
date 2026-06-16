`include "tick_divider/tick_divider.v"
module digital_stopwatch #(parameter TICK_DIV = 10^4)(input clk,
                 input rst,
                 input start_stop,
                 input lap,
                 input clear,
                 output reg running,
                 output reg lap_active,
                 output reg [15:0] time_count,
                 output reg [15:0] lap_count,
                 output reg [1:0] state_dbg
                );
  
  wire tick_en;
  
  tick_divider #(.TICK_DIV(TICK_DIV)) tdr(.clk(clk),
                                          .rst(rst),
                                          .tick_en(tick_en)
                                         );
  
  reg [1:0] state, nxt_state;
  
  localparam [1:0] S_STOPPED = 2'b00,
  				   S_RUNNING = 2'b01,
  				   S_LAP_HELD = 2'b10;
  
  //state transition
  
  always@(posedge clk) begin
    if(rst)
      state <= S_STOPPED;
    else if(tick_en)
      state <= nxt_state;
  end
  
  //transition logic
  
  always@(*) begin
    case(state)
      S_STOPPED: 
        begin
          if(start_stop)
            nxt_state = S_RUNNING;
          else
            nxt_state = S_STOPPED;
        end
      
      S_RUNNING: 
        begin
          if(!start_stop)
            nxt_state = S_STOPPED;
          else if(lap)
            nxt_state = S_LAP_HELD;
          else
            nxt_state = S_RUNNING;
        end
      
      S_LAP_HELD:
        begin
          if(!start_stop)
            nxt_state = S_STOPPED;
          else if(!lap)
            nxt_state = S_RUNNING;
        end
      
      default: begin
        nxt_state = S_STOPPED;
      end
    endcase
  end
  
  //counter
  always@(posedge clk) begin
    if(rst| clear) begin
      time_count <= 16'd0;
      lap_count <= 16'd0;
    end
    else if(running && tick_en) begin
      time_count <= time_count + 1;
    end
  end
  
  //output logic
  always@(*) begin
    if(state == S_STOPPED) begin
      state_dbg = S_STOPPED;
      running = 0;
      lap_active = 0;
      time_count = 0;
      lap_count = 0;
    end
    else if(state == S_RUNNING) begin
      state_dbg = S_RUNNING;
      running = 1;
      lap_active = 0;
      lap_count = 0;
    end
    else if(state == S_LAP_HELD) begin
      state_dbg = S_LAP_HELD;
      running = 1;
      lap_active = 1;
      lap_count = time_count;
    end
    else begin
      state_dbg = 2'b11; //invalid state
      running = 0;
      lap_active = 0;
    end
  end
  
  
endmodule
