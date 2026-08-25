# Claude Code - Plugin bootstrap

Quick guide to reconfigure Claude Code from scratch with the plugins and language servers already installed.

## Marketplaces

| Marketplace | Add command |
| :--- | :--- |
| `claude-plugins-official` | Already present by default at startup |
| `claude-community` | `/plugin marketplace add anthropics/claude-plugins-community` |

## Installed plugins

| Plugin | Marketplace | Purpose | Required binary | Binary install command |
| :--- | :--- | :--- | :--- | :--- |
| `typescript-lsp` | `claude-plugins-official` | TypeScript/JS code intelligence | `typescript-language-server` | `npm install -g typescript typescript-language-server` |
| `pyright-lsp` | `claude-plugins-official` | Python code intelligence | `pyright-langserver` | `pip install pyright` (or `npm install -g pyright`) |
| `php-lsp` | `claude-plugins-official` | PHP code intelligence | `intelephense` | `npm install -g intelephense` |
| `security-guidance` | `claude-plugins-official` | Automatic security review of Claude's changes | - (no binary) | - |
| `quickdesign` | `claude-community` | AI media generation (UGC video, image edit, upscale) | - (no binary) | - |

## Install commands (in order)

```
/plugin install typescript-lsp@claude-plugins-official
/plugin install pyright-lsp@claude-plugins-official
/plugin install php-lsp@claude-plugins-official
/plugin install security-guidance@claude-plugins-official

/plugin marketplace add anthropics/claude-plugins-community
/plugin install quickdesign@claude-community
```

After each installation (or batch of installations):

```
/reload-plugins
```

## Binaries to install separately (summary)

```bash
npm install -g typescript typescript-language-server
pip install pyright                 # or: npm install -g pyright
npm install -g intelephense
```

## npm commands (in order)

All binaries via npm, in the order the corresponding plugins were installed:

```bash
npm install -g typescript typescript-language-server
npm install -g pyright
npm install -g intelephense
```

## Notes

- The LSP plugins (`*-lsp`) **do not install the language server binary**: it must be paired manually.
- The binary must be resolvable via `$PATH` in the process that starts Claude Code (a project-local installation in `node_modules/.bin` is not enough, unless that path is added to `$PATH`).
- If a plugin shows up as `Executable not found in $PATH` in the **Errors** tab of `/plugin`, check the installation of the corresponding binary.
- Plugin installation scopes: user (CLI default), project (shared via `.claude/settings.json`), local (only yours, for this repo).
