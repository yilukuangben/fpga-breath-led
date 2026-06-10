// =============================================================================
// Module: breath_led
// Description: PWM-based breathing LED controller
//   - Generates a 1kHz PWM signal with duty cycle slowly varying from 0% to 100%
//   - Creates a smooth "breathing" effect
//   - Parameterized for easy clock frequency adjustment
// =============================================================================
module breath_led #(
    parameter CLK_FREQ_HZ = 50_000_000,   // System clock frequency
    parameter PWM_FREQ_HZ = 1_000,        // PWM output frequency
    parameter BREATH_PERIOD_MS = 2000     // One breath cycle duration
) (
    input  wire clk,        // System clock
    input  wire rstn,       // Active-low reset
    output wire led_pwm     // PWM output to LED
);

    // -------------------------------------------------------------------------
    // PWM counter: counts to (CLK_FREQ_HZ / PWM_FREQ_HZ) cycles per PWM period
    // -------------------------------------------------------------------------
    localparam PWM_PERIOD = CLK_FREQ_HZ / PWM_FREQ_HZ;
    localparam PWM_WIDTH  = $clog2(PWM_PERIOD);

    reg [PWM_WIDTH-1:0] pwm_cnt = 0;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pwm_cnt <= 0;
        else if (pwm_cnt == PWM_PERIOD - 1)
            pwm_cnt <= 0;
        else
            pwm_cnt <= pwm_cnt + 1;
    end

    // -------------------------------------------------------------------------
    // Breath counter: increments duty cycle slowly across one BREATH_PERIOD
    // Use triangle wave: ramp up 0->max, then ramp down max->0
    // -------------------------------------------------------------------------
    localparam BREATH_TICKS = (BREATH_PERIOD_MS * CLK_FREQ_HZ) / 1000;
    localparam BREATH_WIDTH = $clog2(BREATH_TICKS);

    reg [BREATH_WIDTH:0] breath_cnt = 0;   // extra bit for triangle direction
    reg direction = 1'b0;                  // 0 = ramp up, 1 = ramp down

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            breath_cnt <= 0;
            direction  <= 1'b0;
        end else if (pwm_cnt == PWM_PERIOD - 1) begin
            // Update breath once per PWM period
            if (direction == 1'b0) begin
                if (breath_cnt == BREATH_TICKS - 1) begin
                    direction  <= 1'b1;
                    breath_cnt <= breath_cnt - 1;
                end else begin
                    breath_cnt <= breath_cnt + 1;
                end
            end else begin
                if (breath_cnt == 0) begin
                    direction  <= 1'b0;
                    breath_cnt <= breath_cnt + 1;
                end else begin
                    breath_cnt <= breath_cnt - 1;
                end
            end
        end
    end

    // -------------------------------------------------------------------------
    // PWM compare: drive LED high while pwm_cnt < duty cycle threshold
    // -------------------------------------------------------------------------
    assign led_pwm = (pwm_cnt < breath_cnt);

endmodule