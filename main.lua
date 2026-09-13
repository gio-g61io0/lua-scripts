local foo = require("foo")

local number = 5

local string = "hello world"

local crazy = [[
This is a multi line

]]
local nothing = nil

local function hello(name)
	print("Hello!",name)
end

local greet = function (name)
	print("greetings, " .. name .. "!")
end
local higher_order = function (value)
	return function (another)
		return value + another
	end
end

add_twenty = higher_order(20)

local val = add_twenty(5)

local list = {"first", 2, false, add_twenty}

print("First element is indexed 1", list[1])
print("Fourth is ", list[4](5))

local key = "Gio"

local t= {
	[key] = "My name is the key",
	["an expression"] = "An expression is used as a key",
	[function () end] = "A function is used as a key",
}
print(t["Gio"])
print(t["an expression"])

for key, value in pairs(t) do
	print(key, value)
end

for index = 1, #list do
	print(index, list[index])
end

for index, value in ipairs(list) do
	print(index, value)
end

foo.useful_function()
one, two, three = foo.multiple_values()
print(one, two, three)
print("1:", foo.packing("Hello", "world", "!", 1, 2, 3))
print("2:", foo.packing("Hello", "world", "!", 1, 2, 3), "<lost>")

