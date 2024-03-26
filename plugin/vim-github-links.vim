" My function to create github links for the current line of code
function! GithubLink()
  let git_branch = system("git status | awk '/On branch/ {print $3}'| ruby -e 'print gets.strip'")
  let repo_name = system("git config --get remote.origin.url | ruby -e \"print gets.gsub(/https?:\\/\\//, '').gsub(/.*@/, '').gsub(':', '/').gsub('.git', '').strip\"")
  let root_directory = system("git rev-parse --show-toplevel")
  let filepath = bufname("%")
  let filename = substitute(filepath, root_directory, "", "g")
  let linenumber = line(".")
  if repo_name =~ 'bitbucket.org'
    let url = 'https://' . repo_name . '/src/' . git_branch . '/' . filename . "#L" . linenumber
  else
    let url = 'https://' . repo_name . '/blob/' . git_branch . '/' . filename . "#L" . linenumber
  endif
  let output = system('pbcopy', url)
  return url
endfunction


command! GithubLink call s:GithubLink()

nnoremap <leader>gl :echo GithubLink()<cr>
