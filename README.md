# step-git-tag
Wercker Step to commit git tag

## wecker.yml

```
deploy:
    steps:
    - cashrewards/git-tag:
        name: git tag example
        tag: v1.3
```

