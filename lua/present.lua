local function create_float(width, height)
	local editor_width = vim.o.columns
	local editor_height = vim.o.lines

	-- Default to 80% of the current screen
	width = width or editor_width
	height = height or editor_height

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
		style = "minimal",
		border = "rounded",
	})
	return buf, win
end

local M = {}

M.setup = function() end

--- @class present.Slides
--- @field slides present.Slide[]

--- @class present.Slide
--- @field title string
--- @field body string[]

---@param lines string[]
---@return present.Slides
local parse_slides = function(lines)
	local slides = { slides = {} }
	local separator = "^#"
	local current_bodies = {}
	local title = ""

	for _, line in ipairs(lines) do
		if line:find(separator) then
			if #current_bodies > 0 then
				table.insert(slides.slides, { title = title, body = current_bodies })
			end
			title = line
			current_bodies = {}
		else
			table.insert(current_bodies, line)
		end
	end

	table.insert(slides.slides, { title = title, body = current_bodies })
	return slides
end

M.start_presentation = function(opts)
	opts = opts or {}

	local current_slide = 1
	opts.bufnr = opts.bufnr or 0

	local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)

	local parsed = parse_slides(lines)
	vim.print(parsed)

	local float, win = create_float()

	vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[current_slide])

	vim.print("parsed slides length", #parsed.slides)

	vim.keymap.set("n", "p", function()
		current_slide = math.max(current_slide - 1, 1)
		vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[current_slide])
	end, { buffer = float })

	vim.keymap.set("n", "n", function()
		current_slide = math.min(current_slide + 1, #parsed.slides)
		vim.api.nvim_buf_set_lines(float, 0, -1, false, parsed.slides[current_slide])
	end, { buffer = float })

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = float })

	local restore = {
		cmdheight = {
			original = vim.o.cmdheight,
			present = 0,
		},
	}
	for option, config in pairs(restore) do
		vim.opt[option] = config.present
	end

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = float,
		callback = function()
			for option, config in pairs(restore) do
				vim.opt[option] = config.original
			end
		end,
	})
end

local scratch_buffer = vim.api.nvim_create_buf(true, true)
local test_md = [[
#Hello

This is the first line

#World

This is the second line
#Test

This is the third line

]]
local lines = vim.split(test_md, "\n", { plain = true })

vim.api.nvim_buf_set_lines(scratch_buffer, 0, -1, false, lines)
vim.keymap.set("n", "<leader>x", function()
	M.start_presentation({ bufnr = scratch_buffer })
end)

return M
