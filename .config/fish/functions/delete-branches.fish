function delete-branches -d "Delete selected branches"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf --prompt "Delete: " --multi |
  sed "s/ ->.*//" | # fix branch aliases such as: "master -> main"
  xargs git branch -D
end