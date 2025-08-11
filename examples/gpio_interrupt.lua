--[[
        Demonstrate GPIO interrupts

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "GPIO Interrupt Example"


-- Import required functions from API

quick_import = false
    -- NOTE: change to 'true' to demonstrate
    -- faster & less code import, but this will
    -- consume more memory (importing API
    -- functionality that is unused)

if quick_import then
    import("all")
else
    import("global_interrupt_enable")
    import("global_interrupt_disable")
    import("enable_interrupt_types_for_pin")
    import("set_interrupt_types_for_pin")
    import("get_interrupts_on_pin")
    import("ack_interrupt_types_on_pin")
--
    import("reset_all_io_type_cfg")
    import("set_io_type_cfg")
--
    import("set_gpio")
    import("get_gpio")
--
    import("sleep")
    import("msleep")
end


-- Helper functions

function board_setup_msg (prefix)
    msg = prefix.." '"..main_program_name.."' requires feedback resistor"
    msg = msg .."(< 100 Ohm) between PIN"..GPIO_OUT_PIN.." and PIN"
    return msg..GPIO_IN_PIN.."."
end


-- Program configuration

GPIO_OUT_PIN = PIN2
GPIO_IN_PIN = PIN1
GPIO_IN_PIN_INTERRUPT_BITMASK = PIN1_BITMASK

LOOP_COUNT = 60
LOOP_SLEEP_MS = 500

PERFORMANCE_TEST_DURATION_MILLISEC = 1000


-- Global variables

interrupt_occurred_base_msg = "\tI] PIN"..GPIO_IN_PIN.."! Type(s): "
set_gpio_high_msg = "M] GPIO"..GPIO_OUT_PIN.." HIGH"
set_gpio_low_msg = "M] GPIO"..GPIO_OUT_PIN.." LOW"

doing_performance_test = false
intrpt_cntr = 0


-- Main program begin

print("Program begin: "..main_program_name)


print(board_setup_msg("Important!"))
sleep(1)


-- Initialise REPL mode


-- Initialise Board State

print("Initialise Board State")

global_interrupt_disable()
reset_all_io_type_cfg()
sleep(1)


-- Initialise PINS

print("Initialise I/Os")
set_io_type_cfg(GPIO_OUT_PIN, GPIO_OUT)
set_io_type_cfg(GPIO_IN_PIN, GPIO_IN)
sleep(1)


-- Confirm external board setup

print("Confirm external board setup")

set_gpio(GPIO_OUT_PIN, HIGH)
gpio_level = get_gpio(GPIO_IN_PIN)
if gpio_level ~= HIGH then
    exit(board_setup_msg("Board setup error!"))
end

set_gpio(GPIO_OUT_PIN, LOW)
gpio_level = get_gpio(GPIO_IN_PIN)
if gpio_level ~= LOW then
    exit(board_setup_msg("Board setup error!"))
end


-- Initialise Interrupts

print("Initialise Interrupts")

set_interrupt_types_for_pin(GPIO_IN_PIN, NONE)
ack_interrupt_types_on_pin(GPIO_IN_PIN, 0xFF)
    -- NOTE: acknowledge any existing interrupts
sleep(1)


-- Define Interrupt Handler

print("Define Interrupt Handler")

function interrupt_handler(interrupt_vector)
    intrpt_cntr = intrpt_cntr + 1
--
    if not doing_performance_test then
        if (interrupt_vector & GPIO_IN_PIN_INTERRUPT_BITMASK) ~= 0 then
            gpio_interrupt_vector = get_interrupts_on_pin(GPIO_IN_PIN)
            ack_interrupt_types_on_pin(GPIO_IN_PIN, gpio_interrupt_vector)
                -- NOTE: ack all interrupts that occurred
--
            -- NOTE: print GPIO interrupts that occurred
            interrupt_types_str = ""
            if (gpio_interrupt_vector & GPIO_INTRPT_RISING_EDGE) ~= 0 then
                interrupt_types_str = "R | "
            end
            if (gpio_interrupt_vector & GPIO_INTRPT_FALLING_EDGE) ~= 0 then
                interrupt_types_str = interrupt_types_str.."F | "
            end
            if (gpio_interrupt_vector & GPIO_INTRPT_LOW) ~= 0 then
                interrupt_types_str = interrupt_types_str.."L | "
            end
            if (gpio_interrupt_vector & GPIO_INTRPT_HIGH) ~= 0 then
                interrupt_types_str = interrupt_types_str.."H | "
            end
--
            print(interrupt_occurred_base_msg..interrupt_types_str..intrpt_cntr)
        else
            -- NOTE: shouldn't get here!
--
            print("\tI] Interrupted on other PIN than PIN"..GPIO_IN_PIN.." ?!")
            print("\tI] interrupt_vector:"..interrupt_vector)
        end
    end
end


-- Bind Interrupt Handler

print("Bind Interrupt Handler")

interrupt.bind(interrupt_handler)


-- Perform toggle / interrupt loop

for i=1,LOOP_COUNT do
    print("M] <sleep "..LOOP_SLEEP_MS.." ms>")
    msleep(LOOP_SLEEP_MS)
--
    if (i % 6) == 0 then
        print(set_gpio_high_msg)
        set_gpio(GPIO_OUT_PIN, HIGH)
    elseif (i % 3) == 0 then
        print(set_gpio_low_msg)
        set_gpio(GPIO_OUT_PIN, LOW)
    end
--
    if i == 10 then
        print("M] Global interrupt enable")
        global_interrupt_enable()
    elseif i == 20 then
        print("M] Enable only falling edge interrupt on GPIO"..GPIO_IN_PIN)
        set_interrupt_types_for_pin(GPIO_IN_PIN, GPIO_INTRPT_FALLING_EDGE)
    elseif i == 35 then
        print("M] Enable also rising edge interrupt on GPIO"..GPIO_IN_PIN)
        enable_interrupt_types_for_pin(GPIO_IN_PIN, GPIO_INTRPT_RISING_EDGE)
    elseif i == 50 then
        print("M] Enable only VCC and GND interrupt on GPIO"..GPIO_IN_PIN)
        set_interrupt_types_for_pin(GPIO_IN_PIN, GPIO_INTRPT_HIGH | GPIO_INTRPT_LOW)
    elseif i == LOOP_COUNT then
        set_interrupt_types_for_pin(GPIO_IN_PIN, NONE)
        sleep(1)
--
        print("M] Perform performance test")
        set_gpio(GPIO_OUT_PIN, LOW)
        intrpt_cntr = 0
        doing_performance_test = true
        set_interrupt_types_for_pin(GPIO_IN_PIN, GPIO_INTRPT_LOW)
        msleep(PERFORMANCE_TEST_DURATION_MILLISEC)
    end
end


-- End Program

global_interrupt_disable()

perf_res_msg = (intrpt_cntr / PERFORMANCE_TEST_DURATION_MILLISEC).." kHz"
print("Peformance results: "..perf_res_msg)
print("Program end: "..main_program_name)
