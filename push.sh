### Quick Action
### 1.async latest commit
git pull origin main

### 2.write docs

### 3.submit
# Linux / MacOS
git add . && git commit -m "update" && git push -u origin main && git log --oneline
git add . && git commit -m "update"
# Windows
git add . ; git commit -m "update" ; git push -u origin main ; git log --oneline
git add . ; git commit -m "update"

### steps
git add .
git commit -m "update"
git log --oneline
git rebase -i HEAD~2
git push -u origin main
git push -u origin main --force
git pull origin main

# 修改最新的一次commit信息
git commit --amend
