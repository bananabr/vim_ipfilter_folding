function! MarkdownFolds()
  let currentLine = getline(v:lnum)
  if v:lnum == 1
    let g:lastFoldLevel = 0
    let g:lastLineIdx = 0
    let g:lastHead = 0
    let g:lastGroup = 0
  endif
  if match(currentLine, '^\s*#') && match(currentLine, 'head') >= 0
    let currentWords = split(currentLine, '\s')
    let currentIdxH = index(currentWords, 'head')
    let currentIdxG = index(currentWords, 'group')
    let currentHead = currentWords[currentIdxH+1]+0
    let currentGroup = currentWords[currentIdxG+1]+0
    "echom "Current index:".v:lnum.";Current Head:".currentHead.";Current Group:".currentGroup

    let lastLineIdx = g:lastLineIdx
    let g:lastLineIdx = v:lnum
    let lastLine = getline(lastLineIdx)
    let lastWords = split(lastLine, '\s')
    let lastIdxH = index(lastWords, 'head')
    let lastIdxG = index(lastWords, 'group')

    if match(currentLine, 'group') < 0
      "echom "Assigned level >1 to line ".v:lnum
      let g:lastFoldLevel = 1
      let g:lastHead = currentHead
      let g:lastGroup = 0
      return ">1"
    endif

    "echom "Last line index:".g:lastLineIdx.";Last Head:".g:lastHead.";Last Group:".g:lastGroup.";Last fold level: ".g:lastFoldLevel

    if currentGroup == g:lastGroup
      "echom "Assigned level ".">".(g:lastFoldLevel)." to line ".v:lnum
      let result = ">".(g:lastFoldLevel)
    elseif currentGroup == g:lastHead
      let g:lastFoldLevel = g:lastFoldLevel + 1
      "echom "Assigned level ".">".(g:lastFoldLevel)." to line ".v:lnum
      let result = ">".(g:lastFoldLevel)
    else
      let g:lastFoldLevel = g:lastFoldLevel - 1
      "echom "Assigned level ".">".(g:lastFoldLevel)." to line ".v:lnum
      let result = ">".(g:lastFoldLevel)
    endif
    let g:lastHead = currentHead
    let g:lastGroup = currentGroup
    return result
  else
    "echom "Assigned level ".g:lastFoldLevel." to line ".v:lnum
    return g:lastFoldLevel
  endif
endfunction

setlocal foldmethod=expr
setlocal foldexpr=MarkdownFolds()
