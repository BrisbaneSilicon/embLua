limit = 111111111;
for i = 1,100 do
    foo = math.random(limit)
    foo_div = foo / 1.12345
    print("foo: "..foo.."\tfoo_div: "..foo_div)
end
