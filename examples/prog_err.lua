--[[
        Demonstrate a programming error.

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]

if true then
--
    local a_string = "blahblahblah"
    local oops_not_allowed = a_string..false
        -- NOTE: not allowed!!
--
end
