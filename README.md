# ghit
Building a Git client from scratch in Haskell, following the Building Git book as reference

So far only the commands `git init` and `git commit` have been implemented.
It uses Cabal as the build tool and HSpec as the testing framework.

## Requirements:
- GHC > 8.0
- Cabal

## Building:
`make compile`

## Current features:
### Init Example:
`make init`

### Commit Example:
`make commit`

## Testing:
`make spec`
