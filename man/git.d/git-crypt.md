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

