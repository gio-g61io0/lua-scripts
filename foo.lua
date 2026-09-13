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
}
return M


