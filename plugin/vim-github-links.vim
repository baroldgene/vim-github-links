
" My function to create github links for the current line of code
function! GithubLink()
  let git_branch = system("git status | awk '/On branch/ {print $3}'| ruby -e 'print gets.strip'")
  let repo_name = system("http_true=$(git remote -v|grep http >/dev/null;echo $?); if [ $http_true == 0 ]; then git config --get remote.origin.url | ruby -e \"print gets.gsub(/.*@/, '').gsub('.git', '').strip\"; else git config --get remote.origin.url | ruby -e \"print gets.gsub(/.*@/, '').gsub(':', '/').gsub('.git', '').strip\"; fi")
  let filename = bufname("%")
  let linenumber = line(".")
  let url = 'https://' . repo_name . '/blob/' . git_branch . '/' . filename . "#L" . linenumber
  let output = system('pbcopy', url)
  return url
endfunction

command! GithubLink call s:GithubLink()

nnoremap <leader>gl :echo GithubLink()<cr>
