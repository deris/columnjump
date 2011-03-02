" columnjump - カーソル位置と同一列の次の文字列（列方向の）まで移動する
" Version: 0.0.2
" Copyright (C) 2011 deris0126
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('g:loaded_columnjump')
  finish
endif

nnoremap <silent> <Plug>(columnjump-backward)  :<C-u>call columnjump#backward('n')<CR>
nnoremap <silent> <Plug>(columnjump-forward)   :<C-u>call columnjump#forward('n')<CR>
vnoremap <silent> <Plug>(columnjump-backward)  :<C-u>call columnjump#backward('v')<CR>
vnoremap <silent> <Plug>(columnjump-forward)   :<C-u>call columnjump#forward('v')<CR>
onoremap <silent> <Plug>(columnjump-backward)  :<C-u>call columnjump#backward('o')<CR>
onoremap <silent> <Plug>(columnjump-forward)   :<C-u>call columnjump#forward('o')<CR>

let g:loaded_columnjump = 1

" __END__
" vim: foldmethod=marker
