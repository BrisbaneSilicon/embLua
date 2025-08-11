--[[
        Demonstrate LED (GPIO1) fade in / out

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "LED Fade"


-- Import required functions from API

import("reset_all_io_type_cfg")
import("set_io_type_cfg")
import("set_pwm")
import("set_gpio")
import("sleep")
import("msleep_f")


-- Program configuration

PWM_PIN = 1
LOOP_COUNT = 10


-- Main program begin

print("Program begin: "..main_program_name)


-- Initialise PINS

print("Initialise PINs")

reset_all_io_type_cfg()
set_io_type_cfg(PWM_PIN, PWM)
set_io_type_cfg(PIN2, GPIO_OUT)
set_io_type_cfg(PIN3, GPIO_OUT)

sleep(1)


-- Helper functions

function is_even(x)
    return ((x & 1) == 0)
end


-- Set other LEDs to GND

set_gpio(PIN2, LOW)
set_gpio(PIN3, LOW)


-- Perform LED fade in/out

print("Begin Fade in/out")

for i=1,LOOP_COUNT do
    for j=5,PWM_MAX do
        if is_even(i) then
            set_pwm(PWM_PIN, j)
            msleep_f(100/j)
        else
            set_pwm(PWM_PIN, (PWM_MAX-j))
            msleep_f(100/((PWM_MAX+5)-j))
        end
    end
end


-- Cleanup (free memory)

main_program_name = nil

PWM_PIN = nil
LOOP_COUNT = nil

reset_all_io_type_cfg = nil
set_io_type_cfg = nil
set_pwm = nil
sleep = nil
msleep_f = nil

collectgarbage()

print("Program end")