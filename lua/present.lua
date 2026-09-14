local function create_float(width, height)
	local editor_width = vim.o.columns
	local editor_height = vim.o.lines

	-- Default to 80% of the current screen
	width = width or math.floor(editor_width * 0.8)
	height = height or math.floor(editor_height * 0.8)

	-- Center the window
	local row = math.floor((editor_height - height) / 2)
	local col = math.floor((editor_width - width) / 2)

	-- Create a buffer for the floating window
	local buf = vim.api.nvim_create_buf(false, true)

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
	})

	return buf, win
end

local _ = create_float()

local M = {}

M.setup = function() end

--- @class present.Slides
--- @fields slides string[]

---@param lines string[]
---@return present.Slides
local parse_slides = function(lines)
	local slides = { slides = {} }
	local separator = "^#"
	local current_slides = {}

	for _, line in ipairs(lines) do
		print(line, "find:", line:find(separator), "|")
		if line:find(separator) then
			if #current_slides > 0 then
				table.insert(slides.slides, current_slides)
			end
			current_slides = {}
		end
		table.insert(current_slides, line)
	end

	table.insert(slides.slides, current_slides)
	return slides
end

M.start_presentation = function(opts)
	opts = opts or {}

	local current_slide = 0
	opts.bufnr = opts.bufnr or 0

	local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)

	local parsed = parse_slides(lines)

	local float, win = create_float()

	vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[1])

	vim.keymap.set("n", "p", function()
		current_slide = math.max(current_slide - 1, 0)
		vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[current_slide])
	end, { buffer = float })

	vim.keymap.set("n", "n", function()
		current_slide = math.min(current_slide + 1, #parsed.slides)
		vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[current_slide])
	end, { buffer = float })

	vim.keymap.set("n", "q", function()
		vim.nvim_win_close(win, true)
	end, { buffer = float })
end

M.start_presentation({ bufnr = 137 })

return M
