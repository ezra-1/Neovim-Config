local M = {
	"vyfor/cord.nvim",
}

function M.config()
	require("cord").setup({
		display = {
			theme = "void",
		},

		idle = {
			enabled = true,
			timeout = 300000, -- 5 minutes
		},
	})
end

return M
