# dotfiles

エディタ環境だけをまとめた個人用 dotfiles です。Neovim、Ghostty、Zellij、Zsh、Starship、Sheldon の設定を含みます。

言語ランタイム（Node.js、Python、Rust など）や言語サーバーはここでは管理しません。必要になったら、プロジェクトごとに追加してください。

## 構成

| ディレクトリ | リンク先 |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `ghostty/config` | macOS: `~/Library/Application Support/com.mitchellh.ghostty/config`<br>Linux: `~/.config/ghostty/config` |
| `zellij/config.kdl`, `layouts/`, `plugins/` | `~/.config/zellij/` |
| `zsh/.zshrc` | `~/.zshrc` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `sheldon/plugins.toml` | `~/.config/sheldon/plugins.toml` |

## 導入

```bash
brew bundle
./install.sh
sheldon lock
```

`./install.sh --dry-run --yes` を実行すると、変更内容だけを確認できます。既存のファイルは `<target>.backup.<timestamp>.<pid>` に退避されます。

## Neovim

- プラグインは lazy.nvim で管理し、`nvim/lazy-lock.json` でバージョンを固定しています。
- LSP は共通設定（キーマップ、補完、診断）だけを持ち、サーバーは含みません。`:Mason` からサーバーをインストールすると、mason-lspconfig が自動で有効にします。
- Treesitter の初期パーサーは `lua`、`vim`、`vimdoc`、`query`、`markdown`、`markdown_inline` だけです。他の言語のパーサーは `:TSInstall <lang>` で追加します。

## マシン固有の設定

`zsh/.zshrc.local.example` を参考に `~/.zshrc.local` を作成します。mise などのバージョンマネージャーを使う場合は、ここで有効にします。
