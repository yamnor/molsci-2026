# molsci-2026

A Typst template package designed for preparing abstracts for the Annual Meeting on Molecular Science (Japan). It follows the official layout guidelines but is an unofficial project.

[分子科学討論会](https://www.molsci.jp/forum-top/forum/)の講演要旨を作成するための Typst テンプレートです（非公式）。

<p align="center">
<img src="https://i.gyazo.com/5a17086fd308f18e861bf7c7c9bba8e3.png" width="48%">
<img src="https://i.gyazo.com/491de498e4394e06177081362a0928f3.png" width="48%">
</p>

## できること

- `typst init` で講演要旨のひな形を生成
- 和文・英文の題目・著者・所属を `meta` で一括指定（発表者は `presenter: true`、複数所属は `affil: (1, 2)` など）
- `abs` / `sec` / `refs` で【Abstract】【序】などの見出し付き本文
- `figs` で図とキャプションを配置

## 必要環境

- [Typst](https://typst.app/) 0.11 以上（`typst.toml` の `compiler` に合わせてください）
- 日本語フォント（既定は `molsci-2026.typ` 内の `heading-fonts` / `mincho-fonts`）

## ローカルパッケージとしてインストールして使う

Typst は、パッケージを **データディレクトリ** 下の  
`{data-dir}/typst/packages/{namespace}/{name}/{version}/` に置くと import できます（[Typst Packages の README（Local packages）](https://github.com/typst/packages/blob/main/README.md)）。

`{data-dir}` の目安は次のとおりです。

| OS | 既定の `{data-dir}`（例） |
| --- | --- |
| Linux | `$XDG_DATA_HOME` があればそこ、なければ `~/.local/share` |
| macOS | `~/Library/Application Support` |
| Windows | `%APPDATA%`（例: `C:\Users\<ユーザー名>\AppData\Roaming`） |

実際のパスは環境で異なるため、`typst info` を実行し **Package path** を確認してください。

このリポジトリの一式（`typst.toml`・`lib.typ`・`molsci-2026.typ`・`template/` など）を、以下のパスにコピーします。

`{data-dir}/typst/packages/local/molsci-2026/{version}/`

`version` は `typst.toml` の `[package].version`（現状 `0.1.0`）と一致させてください。`local` 名前空間に置くことで、`#import "@local/molsci-2026:0.1.0"` と `typst init "@local/molsci-2026:0.1.0"` の両方が動きます。

以下の `0.1.0` は、インストールしたバージョンに読み替えてください。

### Linux（Bash の例）

このリポジトリのルートで実行します。

```bash
VERSION=0.1.0
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local/molsci-2026/$VERSION"
mkdir -p "$DEST"
rsync -a --exclude '.git' ./ "$DEST/"
```

### macOS（Bash / zsh の例）

このリポジトリのルートで実行します。

```bash
VERSION=0.1.0
DEST="$HOME/Library/Application Support/typst/packages/local/molsci-2026/$VERSION"
mkdir -p "$DEST"
rsync -a --exclude '.git' ./ "$DEST/"
```

### Windows（PowerShell の例）

このリポジトリのルートで実行します。

```powershell
$Version = "0.1.0"
$Dest = Join-Path $env:APPDATA "typst\packages\local\molsci-2026\$Version"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item -Path (Get-Item .).FullName\* -Destination $Dest -Recurse -Force
# .git を除外したい場合は robocopy などを利用してください。
```

### インストール後の手順（`typst init`）

1. 上記いずれかでパッケージを配置する。
2. 作業用の空ディレクトリで次を実行する。

```bash
typst init "@local/molsci-2026:0.1.0"
```

3. 生成されたディレクトリへ移動する。

```bash
cd molsci-2026
```

4. `main.typ` の `meta` を編集する。

- `number` — 講演番号（例: `"1A01"`）
- `title` — `(ja: […], en: […])`
- `authors` — 著者の配列。各要素は `ja` / `en` / `affil`（番号または配列）/`presenter`（発表者なら `true`）
- `affiliations` — `(ja: [略所属], en: [英文所属])` の配列（先頭が ¹）

5. `#abs` / `#sec` / `#refs` の本文を書き換える。

6. PDF を生成する。

```bash
typst compile main.typ
```

`main.pdf` が生成されます。編集中のプレビューは `typst watch main.typ` を利用できます。

## 使い方（既存 `.typ` から import）

`local` にインストール済みの場合の最小例です。

```typst
#import "@local/molsci-2026:0.1.0": *

#let m = meta(
  number: "1A01",
  title: (
    ja: [講演題目],
    en: [Title in English],
  ),
  authors: (
    (ja: [吉田 都], en: [Miyako Yoshida], affil: 1, presenter: true),
    (ja: [豊中 花子], en: [Hanako Toyonaka], affil: 2),
  ),
  affiliations: (
    (ja: [京大院理], en: [Graduate School of Science, Kyoto University, Japan]),
    (ja: [阪大院理], en: [Graduate School of Science, Osaka University, Japan]),
  ),
)

#show: manuscript.with(..m)

#abs[
  Abstract in English (about 150 words).
]

#sec[序][
  本文…
]

#sec[方法][
  本文…
]

#sec[結果・考察][
  本文…
]

#refs[
  [1] …
]
```

## 主な API（`molsci-2026.typ` 経由で re-export）

- `meta(number:, title:, authors:, affiliations:)` — `title` は `(ja:, en:)`。`authors` は辞書の配列。`affiliations` は和文略称・英文フル表記のペアの配列。
- `manuscript(..)` / `#show: manuscript.with(..m)`
- `abs(body)` — 【Abstract】見出し付き（英文想定）
- `sec(name, body)` — 【見出し】＋本文
- `refs(body)` — 【参考文献】
- `figs(items, labels: none, caption: [], gutter: 2mm, h: auto, w: 100%)` — `labels: auto` で複数図に `(a), (b), …`

## テンプレート固有の注意点

- 複数所属は `affil: (1, 2)` のように **配列** で渡します。
- `figs` は 1 枚（文字列）でも複数枚（配列）でも利用できます。
- フォント差で見た目が変わる場合は `molsci-2026.typ` の `heading-fonts` / `mincho-fonts` を調整してください。

## ライセンス

[LICENSE](LICENSE) を参照してください（MIT）。
