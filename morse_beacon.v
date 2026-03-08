// Morse beacon module with buzzer output

module morse_beacon(
    input logic clk,
    input logic reset,
    input logic [7:0] led_data,
    output logic buzzer_pwm
);

    // Parameters for tone generator
    parameter int BUZZER_FREQ = 80000000; // 800 Hz
    logic [15:0] tone_counter;
    logic buzzer_state;

    // State machine for morse signal
    typedef enum {IDLE, SYMBOL_ON, SYMBOL_OFF, CHARACTER_ON, CHARACTER_OFF} state_t;
    state_t current_state, next_state;

    // Tone generator logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            tone_counter <= 0;
            buzzer_state <= 0;
        end else begin
            if (tone_counter < (BUZZER_FREQ / 2)) begin
                tone_counter <= tone_counter + 1;
            end else begin
                tone_counter <= 0;
                buzzer_state <= ~buzzer_state; // Toggle buzzer state
            end
        end
    end

    assign buzzer_pwm = (current_state == SYMBOL_ON) ? buzzer_state : 0;

    // State machine implementation
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE:      next_state = (led_data != 0) ? SYMBOL_ON : IDLE;
            SYMBOL_ON: next_state = (/* condition to change to SYMBOL_OFF */) ? SYMBOL_OFF : SYMBOL_ON;
            SYMBOL_OFF: next_state = (/* condition to change to CHARACTER_ON */) ? CHARACTER_ON : SYMBOL_OFF;
            CHARACTER_ON: next_state = (/* condition to change to CHARACTER_OFF */) ? CHARACTER_OFF : CHARACTER_ON;
            CHARACTER_OFF: next_state = (led_data == 0) ? IDLE : CHARACTER_ON;
            default:    next_state = IDLE;
        endcase
    end

endmodule
