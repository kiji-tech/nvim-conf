vim.o.ff = "unix" -- 改行コードをLFで開く
vim.o.number = true -- 行番号の表示（相対表示）
vim.o.autowrite = true -- 自動保存

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- タブのサイズを4文字に変更
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- シンタックスハイライトを有効化
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- カラースキームを設定（テーマプラグインが読み込まれる前に基本設定）
vim.o.termguicolors = true -- 24bitカラーを有効化

