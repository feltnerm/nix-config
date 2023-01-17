-- TODO Work in progress
local alpha = require("alpha")

local header = {
  type = "text",
  val = {
    [[        _             _ _   _        ]],
    [[  _ __ | |_   _  __ _(_) |_(_)_ __   ]],
    [[ | '_ \| | | | |/ _` | | __| | '_ \  ]],
    [[ | |_) | | |_| | (_| | | |_| | | | | ]],
    [[ | .__/|_|\__,_|\__, |_|\__|_|_| |_| ]],
    [[ |_|            |___/                ]],
  }
}

local function button(sc, txt, keybind)
	local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")

	local opts = {
		position = "left",
		text = txt,
		shortcut = sc,
		cursor = 0,
		width = 44,
		align_shortcut = "right",
		hl_shortcut = "AlphaShortcuts",
		hl = "AlphaHeader",
	}
	if keybind then
		opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
	end

	return {
		type = "button",
		val = txt,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, "normal", false)
		end,
		opts = opts,
	}
end

local buttons = {
	type = "group",
	val = {
      button("LDR pf", " >fuzzy search", ":Telescope find_files<CR>"),
      button("LDR pd", " >browse folders" , ":Telescope file_browser<CR>"),
      button("LDR p", " >regex search", ":Telescope live_grep<CR>"),
	},
	opts = {
	  spacing = 0,
	},
}

local section = {
  header = header,
  buttons = buttons
}

local opts = {
  layout = {
    type = { " padding", val = 1 },
    section.header,
    type = { "padding", val = 1},
    section.buttons
  },
  opts = {
  }
}
alpha.setup(opts)

-- ez way:
--local theme = require("alpha.themes.dashboard")
--alpha.setup(theme.config)

