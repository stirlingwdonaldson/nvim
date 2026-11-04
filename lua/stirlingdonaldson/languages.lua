-- Shared language tooling used by startup and scripts/install-tools.sh.
return {
	servers = {
		"vtsls", "tailwindcss", "pyright", "jdtls", "clangd", "cmake",
		"lua_ls", "gopls", "rust_analyzer", "bashls", "jsonls", "yamlls", "html", "cssls", "dockerls",
	},
	parsers = {
		"bash", "c", "css", "dockerfile", "go", "html", "javascript", "json", "lua", "markdown",
		"markdown_inline", "python", "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
	},
	mason_packages = {
		"vtsls", "tailwindcss-language-server", "pyright", "jdtls", "clangd", "cmake-language-server",
		"lua-language-server", "gopls", "rust-analyzer", "bash-language-server", "json-lsp",
		"yaml-language-server", "html-lsp", "css-lsp", "dockerfile-language-server",
		"prettier", "stylua", "black", "ruff", "clang-format", "cmakelang", "google-java-format",
		"gofumpt", "goimports", "shfmt", "cpplint", "cmakelint", "eslint_d",
	},
}
