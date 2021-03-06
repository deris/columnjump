" columnjump - カーソル位置と同一列の次の文字列（列方向の）まで移動する
" Version: 0.1.0
" Copyright (C) 2011-2017 deris0126
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

" Public API {{{1

" カーソル位置と同一列の次の文字列（列方向の）まで移動する（上方に向かって）
function! columnjump#backward(mode_p) "{{{2
  return columnjump#jump(-1, a:mode_p)
endfunction
"}}}

" カーソル位置と同一列の次の文字列（列方向の）まで移動する（下方に向かって）
function! columnjump#forward(mode_p) "{{{2
  return columnjump#jump(1, a:mode_p)
endfunction
"}}}

"}}}

" Private {{{1

" カーソル位置と同一列の次の文字列（列方向の）まで移動する
"  direct_pが0より大きければ下方に向かって
"  上記以外であれば上方に向かって移動する
function! columnjump#jump(direct_p, mode_p) "{{{2
  " 仮想編集を有効にする
  let s:save_virtualedit = &virtualedit
  let &virtualedit = 'all'

  " wrap を無視するかどうかの設定
  let s:ignore_wrapped_lines = get(g:, 'columnjump_ignore_wrapped_lines', 0)

  try
    if a:mode_p == 'v'
      normal! gv
    elseif (a:mode_p == 'o') && (g:columnjump_linewise_when_omap != 0)
      normal! V
    endif

    for i in range(v:count1)
      if s:is_end_of_jump(a:direct_p)
        break
      endif

      let l:next_line = line('.')
      if a:direct_p > 0
        let l:next_line += 1
      else
        let l:next_line -= 1
      endif

      let l:cur_virtcol  = virtcol('.')
      " カーソル位置の文字
      let l:cur_char  = s:get_character_under_cursor()

      " spaceをskipするかしないか
      let l:skip_space = s:is_space(l:cur_char)

      let cur_pos = getpos('.')
      let prev_pos = []
      while cur_pos != prev_pos
        silent! foldopen!
        if a:direct_p > 0
          execute 'normal! ' . (s:ignore_wrapped_lines ? 'j' : 'gj')
        else
          execute 'normal! ' . (s:ignore_wrapped_lines ? 'k' : 'gk')
        endif

        " 移動前のスクリーン桁位置に移動
        exe 'normal! ' . l:cur_virtcol . '|'

        if s:is_end_of_jump(a:direct_p)
          break
        endif

        let l:wk_char  = s:get_character_under_cursor()
        if l:skip_space == 1
          if !s:is_space(l:wk_char)
            " spaceをskipするモードでspaceでは
            " なくなったらループを抜ける
            break
          endif
        else
          if s:is_space(l:wk_char)
            " 移動前がspaceでなくてspaceまで移動した場合
            if (g:columnjump_stop_every_edge != 0) && l:next_line != line('.')
              " すべてのエッジで止まるオプションが有効だった場合
              if a:direct_p > 0
                execute 'normal! ' . (s:ignore_wrapped_lines ? 'k' : 'gk')
              else
                execute 'normal! ' . (s:ignore_wrapped_lines ? 'j' : 'gj')
              endif
              break
            endif
            " spaceをskipするモードに移行
            let l:skip_space = 1
          endif
        endif

        let prev_pos = cur_pos
        let cur_pos = getpos('.')
      endwhile
    endfor
  finally
    if exists('s:last_line')
      unlet s:last_line
    endif
    let &virtualedit = s:save_virtualedit
  endtry

  " とりあえず一律0を返す
  return 0
endfunction
"}}}

function! s:is_space(char_p) "{{{2
  " 以下の場合をスペースとして判定する
  " ' ' :空白の場合
  " '\t':タブの場合
  " ''  :仮想位置（文字がない位置）だった場合
  return a:char_p == ' '
    \ || a:char_p == "\t"
    \ || a:char_p == ''
endfunction
"}}}

function! s:get_character_under_cursor() "{{{2
  return matchstr(getline('.'), '.', col('.') - 1)
endfunction
"}}}

function! s:is_end_of_jump(direct_p) "{{{2
  let line = line('.')
  if !exists('s:last_line')
    let s:last_line = line('$')
  endif

  return (a:direct_p <= 0 && line <= 1) ||
        \(a:direct_p > 0 && line >= s:last_line)
endfunction
"}}}

"}}}

" __END__ "{{{1
" vim: foldmethod=marker
