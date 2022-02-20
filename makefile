GIT := git

.PHONY: init
init:
	${GIT} config --local commit.template "./commit.template"
