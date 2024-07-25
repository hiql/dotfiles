function checkout-branch -d "Checkout selected branch"
  git branch |
  rg -v '\*' |
  cut -c 3- |
  fzf --prompt "Checkout: " |
  sed "s/ ->.*//" | # fix branch aliases such as: "master -> main"
  xargs git checkout
end