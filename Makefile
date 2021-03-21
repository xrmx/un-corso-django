all:
	mdbook build

serve:
	mdbook serve

clean:
	mdbook clean

ci-build:
	curl -L https://github.com/rust-lang/mdBook/releases/download/v0.4.7/mdbook-v0.4.7-x86_64-unknown-linux-gnu.tar.gz | tar xvz
	./mdbook build
