# Design Specification

## Overview

`breath_led` is a PWM-based LED dimmer that produces a smooth "breathing" effect. The LED gradually brightens from off to fully on, then fades back to off, in a continuous loop.

## Architecture

```
                  +---------------+
    clk  -------->|  pwm_counter  |-- pwm_cnt (counts up every clock)
                  +---------------+
                          |
                          v
                  +---------------+
    rstn -------->| breath_counter|-- breath_cnt (triangle wave, updates
                  +---------------+   once per PWM period)
                          |
                          v
                  +---------------+
                  |  comparator   |-- led_pwm = (pwm_cnt < breath_cnt)
                  +---------------+
```

## Timing

For default parameters (50 MHz clock, 1 kHz PWM, 2000 ms breath period):

- **PWM period**: 50,000 clocks (1 ms @ 50 MHz)
- **Breath period**: 100,000,000 clocks (2 seconds)
- **Duty cycle steps**: 1000 distinct brightness levels (one per PWM period)

## Resources (Xilinx Artix-7 estimate)

| Resource | Usage |
|----------|-------|
| LUT | ~30 |
| FF | ~30 |
| BRAM | 0 |
| DSP | 0 |

## Edge Cases

- **PWM_PERIOD must be >= 1** — avoid divide-by-zero
- **$clog2 returns 1 for value of 1** — registers are sized correctly
- **Breath counter uses extra bit** — `$clog2(BREATH_TICKS) + 1` accommodates the triangle direction state

## Verification

The testbench reports duty cycle percentage every 1 ms of simulated time, confirming the breath pattern ramps correctly through 0% → 100% → 0%.