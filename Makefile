compile:
	cabal build
show:
	tree .git -a
init:
	./dist/build/jit-exec/jit-exec init
commit:
	export GIT_AUTHOR_EMAIL="jamesv@riseup.net"
	export GIT_AUTHOR_NAME="James Vaughan"
	echo "Test commit" | ./dist/build/jit-exec/jit-exec commit
spec:
	cabal test --show-details=always --test-option="--color"
