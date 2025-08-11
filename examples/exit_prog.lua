--[[
        Demonstrate exiting a running program / script.

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "Exit Program Example"

-- Import required functions from API

import("msleep")


-- Program configuration

PRIMARY_LOOP_COUNT = 1000000
SECONDARY_LOOP_COUNT = 5


-- Main program begin

print("Program begin: "..main_program_name)


-- Initialise PINS


-- Perform output toggle loop

for i=1,PRIMARY_LOOP_COUNT do
    for j=1,SECONDARY_LOOP_COUNT do
        print("Loop! I: "..i.. ", J: "..j)
--
        msleep(100)
        if i > 7 then
            if j > 3 then
                exit("Bye for now!")
            end
        end
    end
end


-- NOTE: won't get here!

print("Program end: "..main_program_name)
