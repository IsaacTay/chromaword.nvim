if exists('g:loaded_chromaword')
  finish
endif

let g:loaded_chromaword = 1

" command! ChromaWordToggle lua require('chromaword').toggle()
command! ChromaWordHighlight lua require('chromaword').enable()
