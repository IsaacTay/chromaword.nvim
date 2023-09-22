if exists('g:loaded_chromaword')
  finish
endif

let g:loaded_chromaword = 1

command! ChromaWordHighlight lua require('chromaword').enable()
command! ChromaWordDisable lua require('chromaword').disable()
command! ChromaWordToggle lua require('chromaword').toggle()
