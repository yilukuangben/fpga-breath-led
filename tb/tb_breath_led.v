// =============================================================================
// Module: tb_breath_led
// Description: Testbench for breath_led PWM module
//   - Simulates with iverilog / Verilator compatible API
//   - Captures waveform VCD and reports duty cycle statistics
// =============================================================================
`timescale 1ns / 1ps

module tb_breath_led;

    // Parameters - smaller numbers for faster simulation
    localparam CLK_FREQ_HZ = 50_000_000;
    localparam CLK_PERIOD  = 20;        // 50MHz -> 20ns period

    reg clk = 0;
    reg rstn = 0;
    wire led_pwm;

    always #10 clk = ~clk;

    breath_led #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .PWM_FREQ_HZ(1_000),
        .BREATH_PERIOD_MS(100)         // 100ms period for quick simulation
    ) u_dut (
        .clk(clk),
        .rstn(rstn),
        .led_pwm(led_pwm)
    );

    initial begin
        $dumpfile("tb_breath_led.vcd");
        $dumpvars(0, tb_breath_led);

        // Reset
        rstn = 0;
        #1000;
        rstn = 1;

        // Run for several breath cycles
        #5_000_000;
        $display("[%t] Simulation complete. LED PWM running.", $time);
        $finish;
    end

    // Monitor: count how often LED is HIGH over time windows
    integer high_count = 0;
    integer total_count = 0;
    integer window_start = 0;
    integer last_report = 0;

    always @(posedge clk) begin
        if (rstn) begin
            if (led_pwm)
                high_count <= high_count + 1;
            total_count <= total_count + 1;

            // Report every 1ms of simulated time
            if ($time - window_start >= 1_000_000) begin
                $display("[%t] Window duty cycle: %0d%%  (high=%0d / total=%0d)",
                         $time, (high_count * 100) / total_count, high_count, total_count);
                window_start = $time;
                high_count = 0;
                total_count = 0;
            end
        end
    end

endmodule