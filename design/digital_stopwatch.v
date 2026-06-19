`include "tick_divider/tick_divider.v"
//set divider parameter to 5x10^7 to make clock period 1s for fpga board of freq 50MHz
module digital_stopwatch #(parameter TICK_DIV = 50000000)(input clk,
                 input rst, 
                 input tick_rst,	
                 input start_stop,
                 input lap,
                 input clear,
                 output reg [15:0] time_count
                );

  wire tick_en;
  
  reg [15:0] time_c;
  reg [15:0] lap_c;

  tick_divider #(.TICK_DIV(TICK_DIV)) tdr(.clk(clk),
                                          .rst(tick_rst),
                                          .tick_en(tick_en)
                                         );
  
  reg [1:0] state, nxt_state;
  
  localparam [1:0] S_STOPPED = 2'b00,
  				   S_RUNNING = 2'b01,
  				   S_LAP_HELD = 2'b10;
  
  //state transition
  always@(posedge tick_en) begin
    if(rst)
      state <= S_STOPPED;
    else
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
          if(start_stop | clear)
            nxt_state = S_STOPPED;
          else if(lap)
            nxt_state = S_LAP_HELD;
          else
            nxt_state = S_RUNNING;
        end
      
      S_LAP_HELD:
        begin
          if(start_stop|clear)
            nxt_state = S_STOPPED;
          else if(lap)
            nxt_state = S_RUNNING;
          else
            nxt_state = S_LAP_HELD;
        end
      
      default: begin
        nxt_state = S_STOPPED;
      end
    endcase
  end
  
  
  //counter
  always@(posedge tick_en) begin
    if(rst| clear) begin
      time_c <= 16'd0;
      lap_c <= 16'd0;
    end
    else begin
      if(state == S_RUNNING && nxt_state == S_LAP_HELD) begin
      	lap_c <= time_c + 1;
      end
      if(state == S_RUNNING || state == S_LAP_HELD)
      	time_c <= time_c + 1;
    end
  end
  
  //output logic
  always@(*) begin
    time_count = time_c;
    case(state)
      S_STOPPED: begin
        time_count = 0;
      end
      S_RUNNING: begin
        time_count = time_c;
      end
      S_LAP_HELD: begin
        time_count = lap_c;
      end
      default: begin
        time_count = time_c;
      end
    endcase
  end
  
endmodule