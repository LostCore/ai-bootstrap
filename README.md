# ai-bootstrap

Personal bootstrap for a new machine: shared agent instructions, the Claude Code statusline, the personal skills, and the plugin setup to replay.

Everything here is meant to be linked from the home directory rather than copied, so that a `git pull` in this repository immediately updates the live configuration.

## 1. AGENTS.md

`AGENTS.md` holds the general instructions that every agent must follow (writing style, commit rules, engineering standards).

The goal is to keep a single source of truth and expose it under the two filenames different tools look for: `~/.claude/CLAUDE.md` for Claude Code, and `~/AGENTS.md` for agents that follow the AGENTS.md convention.

```bash
mkdir -p ~/.claude
ln -sfn "$PWD/AGENTS.md" ~/.claude/CLAUDE.md
ln -sfn "$PWD/AGENTS.md" ~/AGENTS.md
```

Run the commands from the root of this repository, since `$PWD` is used to build an absolute symlink target.

If `~/.claude/CLAUDE.md` or `~/AGENTS.md` already exist as regular files, back them up first: `ln -sfn` replaces them without asking.

The content of `AGENTS.md` was inspired by Kun Chen ([talk on YouTube](https://www.youtube.com/watch?v=iQyg-KypKAA)).

## 2. statusline-command.sh

`statusline-command.sh` renders the Claude Code statusline: the first line mirrors the colored `PS1` from `~/.bashrc`, the second line shows model, context window usage, session cost and duration, and the Claude.ai 5h/7d rate limits.

```bash
ln -sfn "$PWD/statusline-command.sh" ~/.claude/statusline-command.sh
chmod +x "$PWD/statusline-command.sh"
```

The script depends on `jq`, which must be available in `$PATH`.

The symlink alone does not enable the statusline: Claude Code must be pointed at it, either with `/statusline` or by adding this entry to `~/.claude/settings.json`.

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-command.sh"
  }
}
```

## 3. Plugin bootstrap

`claude-plugins-bootstrap.md` documents the marketplaces, the plugins, and the language server binaries that make up the working setup.

Open it and run the commands you actually want on this machine: the `/plugin install ...` slash commands go into a Claude Code session, the `npm install -g ...` commands go into a shell.

Language server plugins (`*-lsp`) do not ship their binary, so each one has to be paired with its `npm install -g` counterpart, otherwise `/plugin` reports `Executable not found in $PATH`.

See [claude-plugins-bootstrap.md](claude-plugins-bootstrap.md) for the full list and the exact order.

## 4. Skills

`skills/` holds the personal Claude Code skills, one directory per skill, each with its own `SKILL.md`.

Claude Code discovers user level skills in `~/.claude/skills/<name>/SKILL.md`, so each skill directory is linked individually instead of linking the whole `skills/` folder.

That way `~/.claude/skills` can still host skills that are not meant to be versioned here, without them ending up in this repository.

```bash
mkdir -p ~/.claude/skills
for skill in "$PWD"/skills/*/; do
  ln -sfn "${skill%/}" ~/.claude/skills/"$(basename "$skill")"
done
```

Run the loop again after adding a new skill to the repository, since a fresh directory needs its own symlink.

## License

Released under the [MIT License](LICENSE).
