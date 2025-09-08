### Quick Action
### 1.async latest commit
git pull origin main
# or
git fetch origin # or git fetch --all
git reset --hard origin/main
git pull origin main
# or
git pull origin main --rebase

### 2.write docs

### 3.submit
# Linux / MacOS
git add . && git commit -m "update" && git push && git log --oneline
git add . && git commit -m "update"
git add . && git commit -m "local update" && git log --oneline
# Windows
git add . ; git commit -m "update" ; git push ; git log --oneline
git add . ; git commit -m "update"
git add . ; git commit -m "local update" ; git log --oneline

### steps
git add .
git commit -m "update"
git commit -m "local update"
git log --oneline
git rebase -i HEAD~2
git push -u origin main
git push origin main
git push
git push origin main --force
git push --force
git pull origin main

# 修改最新的一次commit信息
git commit --amend
