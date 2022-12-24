GIT  := git
NVIM := nvim

.PHONY: init
init:
	${GIT} config --local commit.template "./commit.template"

.PHONY: convert
convert:
	$(info Convert Snippets...)
	@${NVIM} --headless -es -S "./convert.lua"
