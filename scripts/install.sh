#! /bin/bash
PLUGINPATH=/tmp/nvim/site/pack/vendor/opt
rm -rf $PLUGINPATH
mkdir -p $PLUGINPATH
cd $PLUGINPATH

git clone --depth 1 https://github.com/kyazdani42/nvim-web-devicons

git clone --depth 1 https://github.com/vim-airline/vim-airline
git clone --depth 1 https://github.com/itchyny/lightline.vim
git clone --depth 1 https://github.com/shadmansaleh/lualine.nvim
git clone --depth 1 https://github.com/windwp/windline.nvim
git clone --depth 1 https://github.com/famiu/feline.nvim
git clone --depth 1 https://github.com/NTBBloodbath/galaxyline.nvim
git clone --depth 1 https://github.com/echasnovski/mini.nvim
git clone --depth 1 https://github.com/tamton-aquib/staline.nvim
git clone --depth 1 https://github.com/adelarsq/neoline.vim
