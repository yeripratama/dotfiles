" this directory is to store vim-plug plugins
set runtimepath^=~/.vim-plug

" put this first because a lot of plugin mapping using <leader>
let mapleader = ","

" plugin {{{
call plug#begin('~/.vim-plug/plugged')

runtime init/plugin.vim

call plug#end()
" }}}

" plugin config {{{
runtime init/plugin-setting.vim
" }}}

" config {{{
runtime init/option.vim
runtime init/mapping.vim
runtime init/highlight.vim
" }}}