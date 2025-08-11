--[[
        Demonstrate Fibonacci Sequence calculated without recursion (fast in Lua)

        NOTE: stray, beginning of line '--' comments improve
        code readability while still allowing user to copy-paste
        the entire program into the REPL.
--]]


main_program_name = "Fibonacci Sequence Non-Recursive Example"


-- Program configuration

n = 30


-- Helper functions

function FiboNonRecursive(n)
    a = 0
    b = 1
    c = (n >> 1)
    for i=1,c do
        a=a+b
        b=a+b
    end
--
    if (n & 1) == 1 then
        return b;
    else
        return a;
    end
end



-- Main program begin

print("Program begin: "..main_program_name)


-- Calculate Fibonacci

fibo_n = FiboNonRecursive(n)

print("Fibo("..n.."): "..fibo_n)


-- Ends

print("Program end: "..main_program_name)
