--[[
        Demonstrate GPIO Out toggle (and LED - as it's GPIO1)

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "GPIO OUT Toggle Rate Example"


-- Import required functions from API

quick_import = true
    -- NOTE: change to 'false' to demonstrate
    -- more code import functions, but this will
    -- consume less memory (importing only API
    -- functionality that is used)

if quick_import then
    import("all")
else
    import("reset_all_io_type_cfg")
    import("set_io_type_cfg")
--
    import("set_gpio")
--
    import("sleep")
    import("msleep")
end

-- Program configuration

GPIO_OUT_PIN = 1
LOOP_COUNT = 12


-- Main program begin

print("Program begin: "..main_program_name)


-- Initialise PINS

print("Initialise PINs")

reset_all_io_type_cfg()
set_io_type_cfg(GPIO_OUT_PIN, GPIO_OUT)

msleep(500)

print("Set GPIO"..GPIO_OUT_PIN.." HIGH")
set_gpio(GPIO_OUT_PIN, HIGH)
sleep(1)

print("Set GPIO"..GPIO_OUT_PIN.." LOW")
set_gpio(GPIO_OUT_PIN, LOW)
sleep(1)

-- Perform output toggle loop

for i=1,LOOP_COUNT do
    print("Toggle GPIO"..GPIO_OUT_PIN)
    set_gpio(GPIO_OUT_PIN, TOGGLE)
    msleep(500)
end

sleep(1)

print("Program end: "..main_program_name)
