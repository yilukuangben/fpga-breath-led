# FPGA Breath LED

A simple PWM-based "breathing LED" controller written in Verilog. The LED brightness gradually fades in and out, creating a smooth breathing effect.

## Features

- Pure Verilog (no vendor IP required)
- Parameterized clock frequency, PWM frequency, and breath period
- Triangle-wave duty cycle ramp for smooth fade in/out
- Single combinational output, easy to integrate

## Project Structure

```
fpga-breath-led/
├── rtl/
│   └── breath_led.v          # Main PWM module
├── tb/
│   └── tb_breath_led.v       # Self-checking testbench
├── constraints/
│   └── breath_led.xdc        # Xilinx pin constraints (example)
└── docs/
    └── design_spec.md        # Detailed design notes
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `CLK_FREQ_HZ` | 50000000 | System clock frequency (Hz) |
| `PWM_FREQ_HZ` | 1000 | PWM output frequency (Hz) |
| `BREATH_PERIOD_MS` | 2000 | One full breath cycle (ms) |

## Quick Start

### Simulation (Icarus Verilog)

```bash
cd tb
iverilog -o sim.vvp tb_breath_led.v ../rtl/breath_led.v
vvp sim.vvp
```

### Synthesis (Xilinx Vivado)

1. Create a new RTL project
2. Add `rtl/breath_led.v` as a design source
3. Override parameters if needed (e.g. `CLK_FREQ_HZ = 100000000` for 100MHz boards)
4. Add `constraints/breath_led.xdc` for your board
5. Generate bitstream and flash

## How It Works

The module uses two counters:

1. **PWM counter** — runs at `CLK_FREQ_HZ`, divides down to `PWM_FREQ_HZ`
2. **Breath counter** — increments/decrements the duty cycle threshold every PWM period, forming a triangle wave over `BREATH_PERIOD_MS`

Output is HIGH when `pwm_cnt < breath_cnt`, producing a duty cycle that smoothly varies between 0% and 100%.

## Tested On

- Icarus Verilog 11.0
- Xilinx Artix-7 (xc7a35t)

## License

MIT

## Author

xiao-a (FPGA Design Expert)