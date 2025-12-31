# TypeScript開発用プラグインガイド

このドキュメントでは、NeovimでTypeScript開発を快適にするために追加したプラグインとその使い方を説明します。

## 追加したプラグイン一覧

### 1. nvim-treesitter
**ファイル**: `lua/plugins/treesitter.lua`

シンタックスハイライトとコード解析を強化します。

**主な機能**:
- より正確なシンタックスハイライト
- インクリメンタル選択（`<C-space>`で開始）
- テキストオブジェクト（`af`で関数全体、`if`で関数内部など）

**使い方**:
- `<C-space>`: インクリメンタル選択を開始
- `af`: 関数全体を選択
- `if`: 関数内部を選択
- `ac`: クラス全体を選択
- `ic`: クラス内部を選択
- `]m`: 次の関数の開始位置へ移動
- `[m`: 前の関数の開始位置へ移動

### 2. typescript-tools.nvim
**ファイル**: `lua/plugins/typescript-tools.nvim`

TypeScript専用の機能強化プラグインです。

**主な機能**:
- 保存時にインポートの自動整理
- 未使用インポートの自動削除
- 型情報の詳細表示
- コードアクション（`fix_all`, `add_missing_imports`, `remove_unused`）

**注意**: このプラグインは既存の`ts_ls`設定と競合する可能性があります。使用する場合は、`lua/plugins/lspconfig.lua`の`ts_ls`設定をコメントアウトするか、typescript-tools.nvimのみを使用してください。

### 3. trouble.nvim
**ファイル**: `lua/plugins/trouble.lua`

LSPの診断情報を分かりやすく表示します。

**使い方**:
- `<leader>xx`: Troubleウィンドウを開く/閉じる
- `<leader>xw`: ワークスペース全体の診断情報を表示
- `<leader>xd`: 現在のファイルの診断情報を表示
- `<leader>xq`: Quickfixリストを表示
- `<leader>xl`: Locationリストを表示
- `gR`: LSPの参照を表示

### 4. conform.nvim
**ファイル**: `lua/plugins/conform.lua`

コードフォーマッター（Prettier）を統合します。

**主な機能**:
- 保存時に自動フォーマット
- PrettierによるTypeScript/JavaScriptのフォーマット
- カスタマイズ可能なフォーマット設定

**使い方**:
- `<leader>f`: 手動でフォーマット
- ファイル保存時: 自動的にフォーマット

**設定**: `lua/plugins/conform.lua`でPrettierの設定を変更できます（現在は`print-width: 100`, `single-quote: true`など）

### 5. nvim-dap (デバッガー)
**ファイル**: `lua/plugins/dap.lua`

TypeScript/JavaScriptのデバッグ機能を提供します。

**使い方**:
- `<F5>`: デバッグを開始/継続
- `<F1>`: ステップイン（関数の中に入る）
- `<F2>`: ステップオーバー（次の行へ）
- `<F3>`: ステップアウト（関数から出る）
- `<leader>b`: ブレークポイントを設定/解除
- `<leader>B`: 条件付きブレークポイントを設定
- `<leader>dr`: REPLを開く
- `<leader>dl`: 最後のデバッグセッションを再実行

**セットアップ**:
1. Masonで`node-debug2-adapter`をインストール:
   ```
   :MasonInstall node-debug2-adapter
   ```

2. デバッグ設定ファイル（`.vscode/launch.json`）を作成するか、直接デバッグを開始できます。

### 6. mason-tool-installer.nvim
**ファイル**: `lua/plugins/mason-tool-installer.lua`

必要なツールを自動インストールします。

**自動インストールされるツール**:
- `prettier`: コードフォーマッター
- `stylua`: Luaフォーマッター
- `node-debug2-adapter`: Node.jsデバッガー

## インストール方法

1. Neovimを再起動するか、以下のコマンドを実行:
   ```
   :Lazy sync
   ```

2. Masonで必要なツールをインストール:
   ```
   :Mason
   ```
   その後、必要なツールを選択してインストール

## 推奨ワークフロー

1. **コードを書く**: treesitterがシンタックスハイライトを強化
2. **保存**: conform.nvimが自動的にフォーマット
3. **エラー確認**: `<leader>xx`でTroubleを開いて診断情報を確認
4. **デバッグ**: `<F5>`でデバッグを開始
5. **型情報確認**: `K`でホバー、`gd`で定義へ移動

## トラブルシューティング

### typescript-tools.nvimとts_lsの競合
`typescript-tools.nvim`を使用する場合、`lua/plugins/lspconfig.lua`の`ts_ls`設定をコメントアウトしてください。

### Prettierが動作しない
Masonで`prettier`がインストールされているか確認:
```
:Mason
```

### デバッガーが動作しない
1. Masonで`node-debug2-adapter`がインストールされているか確認
2. Node.jsがインストールされているか確認
3. プロジェクトに`tsconfig.json`があるか確認

## その他のおすすめプラグイン

必要に応じて、以下のプラグインも検討してください:

- **eslint.nvim**: ESLint統合
- **nvim-lint**: 汎用リンター
- **nvim-spectre**: プロジェクト全体の検索・置換
- **nvim-ts-autotag**: HTML/JSXタグの自動補完
