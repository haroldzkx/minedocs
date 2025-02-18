# quick action
git add . && git commit -m "update" && git push -u origin main && git log --oneline

# steps
git add .
git commit -m "update"
git log --oneline
git rebase -i HEAD~2
git push -u origin main
git push -u origin main --force
