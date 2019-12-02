### git-crypt 

# initial
```bash
git-crypt init 
git-crypt add-gpg-user --trusted USER_ID 
```

# add file in .gitattributes
```
*.txt filter=git-crypt diff=git-crypt 
```

#  git add . && git commit -m "message" && git push

# lock & unlock
git-crypt lock && git-crypt unlock


=== git-crypt status - посмотреть какие файлы закриптованны

## Последовательность действий при замене ключа
git crypt init
git crypt add-gpg-user
vim .gitattributes (add 3 files there)
git add (those 3 files)
git commit
git crypt status (shows 2 files encrypted and 1 not encrypted)
