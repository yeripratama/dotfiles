" itchyny/lightline.vim {{{
let g:lightline = {
\   'colorscheme': 'nord_subtle',
\   'active': {
\    'left' :[[ 'mode', 'paste' ],
\             [ 'readonly', 'filename', 'modified' ]],
\    'right':[[ 'filetype', 'percent', 'lineinfo' ]]
\   },
\   'tab': {
\     'active': ['tabnum'],
\     'inactive': ['tabnum']
\   },
\   'tabline': {
\     'left': [['explorer_pad', 'buffers']],
\     'right': [['gitbranch', 'smarttabs']]
\   },
\   'separator': {
\     'left': '', 'right': ''
\   },
\   'subseparator': {
\     'left': '', 'right': ''
\   },
\   'component_function': {
\     'explorer_pad': 'LightlineCocExplorerLeftpad',
\     'percent': 'LightlinePercent',
\     'lineinfo': 'LightlineLineinfo',
\     'filename': 'LightlineFilename',
\     'mode': 'LightlineMode',
\     'gitbranch': 'LightlineFugitive',
\     'readonly': 'LightlineReadonly',
\     'modified': 'LightlineModified',
\     'filetype': 'LightlineFiletype',
\   },
\   'component_expand': {
\     'buffers': 'lightline#bufferline#buffers',
\     'smarttabs': 'SmartTabsIndicator',
\     'trailing': 'lightline#trailing_whitespace#component'
\   },
\   'component_type': {
\     'buffers': 'tabsel',
\     'trailing': 'warning'
\   }
\}


function! s:trim(maxlen, str) abort
    let trimed = len(a:str) > a:maxlen ? a:str[0:a:maxlen] . '..' : a:str
    return trimed
endfunction

function! s:coc_explorer_is_open() abort
    return get(s:, 'coc_explorer_open', 0)
endfunction

function! s:coc_explorer_set_open_state(s) abort
    let s:coc_explorer_open = a:s
endfunction

autocmd BufEnter *coc-explorer* call s:coc_explorer_set_open_state(1)
autocmd BufHidden *coc-explorer* call s:coc_explorer_set_open_state(0)

function! LightlineCocExplorerLeftpad() abort
    if &co < 86
        return ''
    endif

    if s:coc_explorer_is_open()
        return printf('%-29s', '') . '⎟'
    endif

    return ''
endfunction

function! LightlinePercent() abort
    if winwidth(0) < 60
        return ''
    endif

    let l:percent = line('.') * 100 / line('$') . '%'
    return printf('%-4s', l:percent)
endfunction

function! LightlineLineinfo() abort
    if winwidth(0) < 86
        return ''
    endif

    let l:current_line = printf('%-3s', line('.'))
    let l:max_line = printf('%-3s', line('$'))
    let l:lineinfo = ' ' . l:current_line . '/' . l:max_line
    return l:lineinfo
endfunction

function! LightlineFilename() abort
    let l:maxlen = winwidth(0) - winwidth(0) / 3
    let l:relative = @%
    let l:tail = expand('%:t')
    let l:noname = '[No Name]'

    if winwidth(0) < 50
        return ''
    endif

    if winwidth(0) < 86
        return l:tail ==# '' ? l:noname : s:trim(l:maxlen, l:tail)
    endif

    return l:relative ==# '' ? l:noname : s:trim(l:maxlen, l:relative)
endfunction

function! LightlineModified() abort
    return &modified ? '●' : ''
endfunction

function! LightlineMode() abort
    let ftmap = {
                \ 'coc-explorer': 'EXPLORER',
                \ 'fugitive': 'FUGITIVE'
                \ }
    return get(ftmap, &filetype, lightline#mode())
endfunction

function! LightlineReadonly() abort
    return &readonly ? '' : ''
endfunction

function! LightlineFugitive() abort
    if exists('*fugitive#head')
        let maxlen = 20
        let branch = fugitive#head()
        return branch !=# '' ? ' '. s:trim(maxlen, branch) : ''
    endif
    return fugitive#head()
endfunction

function! LightlineFiletype() abort
    let l:icon = WebDevIconsGetFileTypeSymbol()
    return winwidth(0) > 86 ? (strlen(&filetype) ? &filetype . ' ' . l:icon : l:icon) : ''
endfunction

function! String2()
    return 'BUFFERS'
endfunction

function! SmartTabsIndicator() abort
    let tabs = lightline#tab#tabnum(tabpagenr())
    let tab_total = tabpagenr('$')
    return tabpagenr('$') > 1 ? ('TABS ' . tabs . '/' . tab_total) : ''
endfunction

" autoreload
command! LightlineReload call LightlineReload()

function! LightlineReload() abort
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

let g:lightline#trailing_whitespace#indicator = ''
" }}}
