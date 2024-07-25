function checkout-pr -d "Checkout selected pull request"
  gh api 'repos/:owner/:repo/pulls' |
  jq --raw-output '.[] | "#\(.number) \(.title)"' |
  fzf |
  sed -E 's/^#([0-9]+).*/\1/' |
  xargs gh pr checkout
end