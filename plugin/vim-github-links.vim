" My function to create github links for the current line of code
function! GithubLink()
  let repo_name = system("git config --get remote.origin.url | ruby -e \"print gets.gsub(/https?:\\/\\//, '').gsub(/.*@/, '').gsub(':', '/').gsub('.git', '').strip\"")
  let root_directory = system("git rev-parse --show-toplevel")
  let filepath = bufname("%")
  let filename = substitute(filepath, root_directory, "", "g")
  let linenumber = line(".")
  if repo_name =~ 'bitbucket.org'
    let git_branch = system("git rev-parse --short HEAD | ruby -e 'print gets.strip'")
    let url = 'https://' . repo_name . '/src/' . git_branch . '/' . filename . "#lines-" . linenumber
  else
    let git_branch = system("git status | awk '/On branch/ {print $3}'| ruby -e 'print gets.strip'")
    let url = 'https://' . repo_name . '/blob/' . git_branch . '/' . filename . "#L" . linenumber
  endif
  let output = system('pbcopy', url)
  return url
endfunction

function! GithubLinkRange() range
  let repo_name = system("git config --get remote.origin.url | ruby -e \"print gets.gsub(/https?:\\/\\//, '').gsub(/.*@/, '').gsub(':', '/').gsub('.git', '').strip\"")
  let root_directory = system("git rev-parse --show-toplevel")
  let filepath = bufname("%")
  let filename = substitute(filepath, root_directory, "", "g")

  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]"'")

  if repo_name =~ 'bitbucket.org'
    let git_branch = system("git rev-parse --short HEAD | ruby -e 'print gets.strip'")
    let url = 'https://' . repo_name . '/src/' . git_branch . '/' . filename . "#lines-" . line_start . ":" . line_end
  else
    let git_branch = system("git status | awk '/On branch/ {print $3}'| ruby -e 'print gets.strip'")
    let url = 'https://' . repo_name . '/blob/' . git_branch . '/' . filename . "#L" . line_start . "-L" . line_end
  endif
  let output = system('pbcopy', url)
  return url
endfunction


command! GithubLink call s:GithubLink()
command! -range=% GithubLinkRange <line1>,<line2>call GithubLinkRange()

nnoremap <leader>gl :echo GithubLink()<cr>
xnoremap <leader>gl :<C-U>echo GithubLinkRange()<cr>
