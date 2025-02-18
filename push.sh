git add . && git commit -m "update" && git log --oneline
# git add .
# git commit -m "update"
# git log --oneline

git rebase -i HEAD~2

git push -u origin main --force && git log --oneline

git push -u origin main
git log --oneline