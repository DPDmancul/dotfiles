publish_dir := public
timestamps_dir := .timestamps
docs := README.org sitemap.org
orgs := $(filter-out $(docs), $(wildcard *.org))
emacs_pkgs := org

publish_el := elisp/publish.el
tangle_el := elisp/tangle.el

^el = $(filter %.el,$^)
EMACS.funcall = emacs --batch --no-init-file $(addprefix --load ,$(^el)) --funcall

all: publish tangle

publish: $(publish_el) $(orgs)
	$(EMACS.funcall) literate-dotfiles-publish-all

clean:
	rm -rf $(publish_dir)
	rm -rf $(timestamps_dir)

tangle: $(basename $(orgs))

%: %.org $(tangle_el)
	$(EMACS.funcall) literate-dotfiles-tangle $<

.PHONY: all clean
