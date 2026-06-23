# digital_stopwatch
A Verilog digital stopwatch with an FSM-driven counter with start/stop, lap-hold, and clear control, built around a parameterized clock divider so it can run from a 50 MHz FPGA clock or a fast simulation clock.

## Repository structure
```
design/
  digital_stopwatch.v               top-level FSM + counter module
  tb_digital_stopwatch.v            self-checking testbench
  stopwatch.vcd                     simulation waveform dump
  stopwatch_wave.png                waveform screenshot
  tick_divider/
    tick_divider.v                  parameterized clock divider
    tb_tick_divider.v               testbench for the divider
    tick_divider_wave.png           waveform screenshot
fpga/
  digital_stopwatch_top.v           board-level wrapper
  digital_stopwatch_constraint.xdc  pin and clock constraints
  digital_stopwatch_bitstream.bit   generated bitstream (Vivado v2025.2)
  reports/
    digital_stopwatch_utilization_synth.rpt   post-synthesis resource usage
    digital_stopwatch.vds                     Vivado synthesis log
  sta/
    digital_stopwatch_timing_summary_routed.rpt   post-route timing report
  power/
    digital_stopwatch_power_routed.rpt            post-route power report
```

## `digital_stopwatch`
A 3-state Moore FSM (`S_STOPPED`, `S_RUNNING`, `S_LAP_HELD`) driving a 16-bit time counter.

**Parameters**
- `TICK_DIV` (default `50_000_000`) — divides the input clock down to the counting tick; the default value produces a 1-tick-per-second update from a 50 MHz board clock.

**Ports**
| Signal | Dir | Width | Description |
|---|---|---|---|
| `clk` | in | 1 | System clock |
| `rst` | in | 1 | Resets FSM state and counters |
| `tick_rst` | in | 1 | Resets the tick divider |
| `start_stop` | in | 1 | Toggles between running and stopped |
| `lap` | in | 1 | Captures/releases the lap-held display |
| `clear` | in | 1 | Clears the time and lap counters |
| `time_count` | out | 16 | Running count, or the held lap value while in `S_LAP_HELD` |

**Behavior**
- `S_STOPPED` — counter idle, output held at 0, waits for `start_stop`.
- `S_RUNNING` — `time_count` increments on every tick from the divider.
- `S_LAP_HELD` — `time_count` displays the value captured at the moment `lap` was asserted, while the underlying counter keeps advancing in the background. A second `lap` pulse returns to `S_RUNNING` without losing the running count.
- `clear` zeroes both the time and lap counters and is sampled in the same always block as `rst`.

## `tick_divider`
A free-running divider that pulses `tick_en` once every `TICK_DIV` clock cycles, used to generate the stopwatch's counting tick from the system clock.

## Verification
`tb_digital_stopwatch.v` is a self-checking testbench with reusable tasks (`start`, `lapping`, `clearing`, `wait_ticks`) that drive the DUT through start, lap, and clear sequences and check the FSM state after each transition. Waveforms are dumped to `stopwatch.vcd` for inspection in GTKWave.

## FPGA implementation
The design was synthesized and implemented in Vivado v2025.2 for a Xilinx Artix-7 part (`xc7a35tftg256-1`), with pin assignments defined in `fpga/digital_stopwatch_constraint.xdc`.

**Resource utilization (post-synthesis)**
| Resource | Used | Available | Utilization |
|---|---|---|---|
| Slice LUTs | 33 | 20,800 | 0.16% |
| Slice Registers (FF) | 65 | 41,600 | 0.16% |
| Bonded IOBs | 22 | 170 | 12.94% |
| BUFGCTRL | 1 | 32 | 3.13% |
| Block RAM | 0 | 50 | 0.00% |
| DSPs | 0 | 90 | 0.00% |

All 65 registers are clock-enabled synchronous resets (FDRE) — no latches inferred.

**Timing (post-route)**

The XDC defines only pin assignments, no create clock constraint. No I/O delay constraints are specified, so Vivado reports WNS = `inf` with 0 failing endpoints across 171 analyzed paths — all internal register-to-register paths close comfortably within the 20 ns clock period.

**Power (post-route)**
| Component | Power (W) |
|---|---|
| Total on-chip | 2.385 |
| Dynamic | 2.307 |
| Device static | 0.078 |
| I/O | 2.020 |
| Slice logic | 0.106 |
| Signals | 0.181 |
| Junction temperature | 36.6 °C |

The I/O power dominates because input switching activity for the button pins was not provided during analysis (confidence level: Low). Actual I/O power in deployment will be substantially lower given slow-switching mechanical inputs.

## Running the testbench
Both design files are plain Verilog and can be run with any standard simulator, e.g. Icarus Verilog:

```bash
iverilog -o sim design/digital_stopwatch.v design/tick_divider/tick_divider.v \
         design/tb_digital_stopwatch.v
vvp sim
gtkwave stopwatch.vcd
```
