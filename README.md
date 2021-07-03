# ghit
Building a Git client from scratch in Haskell, following the Building Git book as reference. Very much a WIP

So far only the commands `git init` and `git commit` have been implemented.
It uses Cabal as the build tool and HSpec as the testing framework.

## Requirements:
- GHC > 8.0
- Cabal

## Building:
`make compile`

## Current features:
### Init Example:
```
❯ ./dist/build/jit-exec/jit-exec init
Initialized empty Jit repository in /home/jamesvaughan/Desktop/git
```

### Commit Example:
```
❯ export GIT_AUTHOR_EMAIL="email@email.com"
❯ export GIT_AUTHOR_NAME="First Last"
❯ echo "Test commit" | ./dist/build/jit-exec/jit-exec commit
[(root-commit) 277730d13b55f4c3ac166f6aa80c2cda7037b0a8] Test commit
```

## Testing:
`make spec`
