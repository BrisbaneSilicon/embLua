--[[
        Demonstrate error program nested
--]]


local main_program_name = "Error Program Nested Example"


-- Dependencies

local unused_unassigned = run_program("prog_err.lua")


-- NOTE: we won't get here!


print("Program end: "..main_program_name)