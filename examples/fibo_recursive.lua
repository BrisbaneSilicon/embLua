--[[
        Demonstrate Fibonacci Sequence calculated via recursion (very slow in Lua)

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "Fibonacci Sequence Recursive (slow) Example"


-- Program configuration

n = 10


-- Helper functions

function FiboRecursive(n)
    if (n == 1) then
        return 1;
    end
    if (n == 0) then
        return 0;
    end
--
    return FiboRecursive(n-1) + FiboRecursive(n-2);
end


-- Main program begin

print("Program begin: "..main_program_name)


-- Calculate Fibonacci

fibo_n = FiboRecursive(n)

print("Fibo("..n.."): "..fibo_n)


-- Ends

print("Program end: "..main_program_name)
