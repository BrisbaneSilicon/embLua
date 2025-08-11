--[[
        Demonstrate exit program nesting.

        NOTE: This program requires the program
        'exit_prog.lua' to be present on Lumorphix.
--]]


main_program_name = "Exit Program Nested Example"


-- Import required functions from API

import("run_program")


-- Dependencies

unused_unassigned = run_program("exit_prog.lua")


-- NOTE: we shouldn't end up here!

import("sleep")

for i=1,10 do
        print("How did I get here?!")
        sleep(2)
end

print("Program end: "..main_program_name)