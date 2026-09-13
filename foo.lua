local vector_mt = {}
local fib_mt = {
	--A function that will be called if the index queried within table is not set
	__call = function (self, ...)
		local _ = {...}
		for i, v in ipairs(self) do 
			print(i, v)
		end
		print(self)
	end,
	__index = function(self, key)
		if key < 2 then return 1 end
		print("Index" .. key .. "is not set")
		self[key] = self[key - 1] + self[key - 2]

		return self[key]
	end
}
vector_mt.__add = function (left, right)
	return setmetatable({
		left[1] + right[1],
		left[2] + right[2],
		left[3] + right[3],
	}, vector_mt)
end

local v1 = setmetatable({-1, 2, 3}, vector_mt)
local v2 = setmetatable({1, 3, 4}, vector_mt)
local _ = v1 + v2

local M = {
	useful_function = function ()
		print("This is a useful function")
	end,
	multiple_values = function ()
		return 1, 2, 3, 4 
	end,
	packing = function(...)
		local arguments = {...}
		for i, v in ipairs({...}) do
			print(i, v)
		end
		return table.unpack(arguments)
	end,
	fib_func = function (n)
		local fib_mt_rec = setmetatable({}, fib_mt)
		return fib_mt_rec[n]
	end,
	call_mt = function ()
		local fib_mt_rec = setmetatable({}, fib_mt)
		fib_mt_rec["test"] = ""
		fib_mt_rec("Hello world", "!", "Gio")
	end,

}
return M


