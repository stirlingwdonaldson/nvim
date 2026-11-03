# Shared Neovim configuration

The Mac and VM use the same configuration and plugin lockfile through the
parent dotfiles repository. Neovim 0.12 or newer is required. Run
`./scripts/install-tools.sh` after installing the system prerequisites below;
it installs missing Mason packages and Tree-sitter parsers and builds
Telescope's native fzf extension. `tests/smoke.lua` checks key mappings,
parsers, native completion, formatters, and safe Prolog formatting.
`tests/lsp.lua` starts Python, Prolog, CMake and Java language servers in a
temporary project. `tests/plugins.lua` opens the main navigation interfaces,
and `tests/typst.lua` starts a preview without opening a browser.

## System prerequisites

Both machines need Git, curl, Node.js and npm, Python 3, Go, Java 21 or newer,
Rust's `rustfmt`, `make`, a C compiler, `fzf`, `rg`, `lazygit`, and SWI-Prolog.
Install `lsp_server` with `swipl -q -g 'pack_install(lsp_server,[interactive(false)]),halt'`.
Oil handles trash through its platform-specific adapter. If Python 3.14 or
later is the only Python available, install Python
3.12 as `python3.12` on PATH: Mason's CMake language server requires <3.14.
For example, `uv python install 3.12` installs a user-local interpreter.

The installer pins `pygls` to 1.3.1 in Mason's isolated CMake language-server
virtual environment if that server cannot start. This works around the
server's incompatible dependency declaration; rerun the installer if you
update or reinstall that Mason package.

For the optional `gen.nvim` command lookup, install Ollama and pull
`qwen2.5-coder:1.5b` on each machine. The plugin starts a local Ollama server
when invoked. Typst preview's automatic Safari/window arrangement is macOS
only; Linux preview opening depends on the local display and browser setup.

## Verify

```sh
./scripts/install-tools.sh
nvim --headless '+luafile tests/smoke.lua' +qa
nvim --headless '+luafile tests/lsp.lua' +qa
nvim --headless '+luafile tests/plugins.lua' +qa
nvim --headless '+luafile tests/typst.lua' +qa
```

Plugin revisions are locked in `nvim-pack-lock.json`; use Neovim's
`vim.pack.update(nil, { target = 'lockfile' })` when synchronizing an existing
installation. The installer does not install or configure system packages,
Ollama models, machine credentials, or Java/Go project runtimes.
