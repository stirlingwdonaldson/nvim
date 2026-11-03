#!/bin/sh
# Install editor-managed dependencies after installing the system tools in README.md.
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
for tool in nvim git npm node python3 go java rustfmt make cc curl fzf rg swipl; do
  command -v "$tool" >/dev/null 2>&1 || { printf 'Missing system dependency: %s\n' "$tool" >&2; exit 1; }
done
nvim_data=${XDG_DATA_HOME:-"$HOME/.local/share"}/nvim
if ! "$nvim_data-deps/node_modules/.bin/tree-sitter" --version 2>/dev/null | grep -q '^tree-sitter 0\.25\.'; then
  npm install --prefix "$nvim_data-deps" tree-sitter-cli@0.25.10
fi
export NVIM_INSTALLING_TOOLS=1 NVIM_SETUP_REPO="$repo_dir"
nvim --headless '+lua local ok, err = pcall(dofile, vim.env.NVIM_SETUP_REPO .. "/scripts/install-tools.lua"); if not ok then io.stderr:write(tostring(err) .. "\n"); vim.cmd("cquit 1") end' +qa
# cmake-language-server 0.1.11 allows pygls 2, but imports its removed 1.x API.
# Repair only Mason's isolated environment if its executable fails to start.
cmake_lsp="$nvim_data/mason/bin/cmake-language-server"
if ! "$cmake_lsp" --help >/dev/null 2>&1; then
  if [ ! -x "$nvim_data/mason/packages/cmake-language-server/venv/bin/python" ]; then
    nvim --headless '+MasonInstall --force cmake-language-server' +qa
  fi
  "$nvim_data/mason/packages/cmake-language-server/venv/bin/python" -m pip install 'pygls==1.3.1'
  "$cmake_lsp" --help >/dev/null
fi
make -C "$nvim_data/site/pack/core/opt/telescope-fzf-native.nvim"
