# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/).

## [1.0.0] - 2026-06-10

### Added

- Initial release of `breath_led` PWM module
- Parameterized clock frequency, PWM frequency, breath period
- Triangle-wave duty cycle ramp for smooth breathing effect
- Icarus Verilog testbench with duty cycle reporter
- Xilinx pin constraints template
- Design specification document

### Verified

- Simulated with Icarus Verilog 12.0
- Module is parameter-safe (no divide-by-zero for invalid params)