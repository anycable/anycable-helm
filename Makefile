.PHONY: prepare refresh build release

repository:
	git worktree add repository gh-pages

prepare: repository

refresh: prepare
	cd repository/ && git pull --rebase --stat

# Replace this rule with whatever builds your project
build: prepare refresh
	helm package -d repository/ anycable-go
	helm repo index --url https://helm.anycable.io/ --merge repository/index.yaml repository/

release: build
	cd repository/ && \
	git add --all && \
	git commit -m "Release all charts to gh-pages via 'make release'" && \
	git push origin gh-pages
