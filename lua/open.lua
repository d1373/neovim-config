local function open_link()
	local url = ""

	-- If in visual mode, grab selection
	if vim.fn.mode():match("[vV]") then
		-- Get visual selection
		local _, csrow, cscol, cerow, cecol = unpack(vim.fn.getpos("'<"))
		_, cerow, cecol = unpack(vim.fn.getpos("'>"))

		-- Correct order if selection backwards
		if csrow > cerow or (csrow == cerow and cscol > cecol) then
			csrow, cerow = cerow, csrow
			cscol, cecol = cecol, cscol
		end

		-- Extract selection text
		local lines = vim.fn.getline(csrow, cerow)
		if #lines == 1 then
			url = string.sub(lines[1], cscol, cecol)
		else
			lines[1] = string.sub(lines[1], cscol)
			lines[#lines] = string.sub(lines[#lines], 1, cecol)
			url = table.concat(lines, "\n")
		end
	else
		-- Normal mode: expand to full URL under cursor
		local line = vim.fn.getline(".")
		local col = vim.fn.col(".")
		local start_pos, end_pos = nil, nil

		-- Pattern to match URLs
		for s, e in line:gmatch("()https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;%%=]+()") do
			if col >= s and col <= e then
				start_pos, end_pos = s, e
				break
			end
		end

		if start_pos and end_pos then
			url = string.sub(line, start_pos, end_pos - 1)
		end
	end

	-- Trim spaces/newlines
	url = url:gsub("%s+", "")

	if url:match("^https?://") then
		local open_cmd
		if vim.fn.has("mac") == 1 then
			open_cmd = "open"
		elseif vim.fn.has("unix") == 1 then
			open_cmd = "xdg-open"
		elseif vim.fn.has("win32") == 1 then
			open_cmd = "start"
		else
			print("Unsupported OS")
			return
		end
		vim.fn.jobstart({ open_cmd, url }, { detach = true })
	else
		print("No valid URL found")
	end
end

-- Normal + visual mode mapping
vim.keymap.set({ "n", "v" }, "<M-b>", open_link, { desc = "Open link in browser" })
