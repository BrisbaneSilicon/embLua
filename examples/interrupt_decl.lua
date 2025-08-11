--[[
        Demonstrate Interrupt Declaration
--]]


local main_program_name = "Interrupt Declaration Example"


-- Declare Interrupts


print("Declare Interrupt")

function interrupt(vector)
    print("interrupted!!")
end

-- enable_interrupt_types_for_pin(GPIO_IN_PIN, 0xFF)
-- global_interrupt_enable()
-- sleep(1)

print("Program end: "..main_program_name)
