--[[
        Demonstrate UART Rx and UART Rx interrupts
--]]


main_program_name = "UART Rx and UART Rx Interrupt Example"


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
    import("uart_rx_char")
--
    import("sleep")
    import("msleep")
end

-- Program configuration

UART_RX_PIN = PIN2
UART_RX_PIN_INTERRUPT_BITMASK = PIN2_BITMASK

LOOP_COUNT = 1000
LOOP_SLEEP_MS = 20


-- Main program begin

print("Program begin: "..main_program_name)
sleep(1)


-- Initialise Board State

print("Initialise Board State")

global_interrupt_disable()
reset_all_io_type_cfg()
sleep(1)


-- Initialise PINS

print("Initialise I/Os")
set_io_type_cfg(UART_RX_PIN, UART_IN)
sleep(1)


-- Initialise Interrupts

print("Initialise Interrupts")

set_interrupt_types_for_pin(UART_RX_PIN, NONE)
ack_interrupt_types_on_pin(UART_RX_PIN, 0xFF)
    -- NOTE: acknowledge any existing interrupts
sleep(1)


-- Define Interrupts Handler

print("Define Interrupt Handler")

function interrupt_handler(interrupt_vector)
    if (interrupt_vector & UART_RX_PIN_INTERRUPT_BITMASK) ~= 0 then
            -- NOTE: no need to get interrupt vector, as
            -- there is only one for UART RX (UART_RX_INTRPT_DATA_AVAILABLE)
            -- NOTE: no need to ACK, as interrupt will clear
            -- automatically when the RX dat is read
--
        int_vec = get_interrupts_on_pin(UART_RX_PIN)
        if (int_vec & UART_RX_INTRPT_DATA_AVAILABLE) == 0 then
            -- NOTE: don't really need to do this...
            msg = "\t[Interrupt] PIN"..UART_RX_PIN.." interrupt vector "
            print(msg.."doesn't contain 'UART_RX_INTRPT_DATA_AVAILABLE' ?!")
        end
--
        print("\t[Interrupt] UART RX: '"..uart_rx_char(UART_RX_PIN).."'")
    else
        -- NOTE: shouldn't get here!
--
        print("\t[Interrupt] Interrupted on other PIN than PIN"..UART_RX_PIN.." ?!")
        print("\t[Interrupt] interrupt_vector:"..interrupt_vector)
    end
end
interrupt.bind(interrupt_handler)


-- Perform output toggle loop

for i=1,LOOP_COUNT do
    if (i % 100) == 0 then
        print("[Main Loop] <tick>")
    end
    if i == 150 then
        print("[Main Loop] Global interrupt enable")
        global_interrupt_enable()
    end
    if i == 250 then
        print("[Main Loop] Enable RX data received interrupt on UART"..UART_RX_PIN)
        set_interrupt_types_for_pin(UART_RX_PIN, UART_RX_INTRPT_DATA_AVAILABLE)
    end
--
    msleep(LOOP_SLEEP_MS)
end


-- End Program

global_interrupt_disable()

print("Program end: "..main_program_name)
