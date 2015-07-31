(TeX-add-style-hook
 "1"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("ctexart" "paper=a4")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("babel" "english")))
   (TeX-run-style-hooks
    "latex2e"
    "ctexart"
    "ctexart10"
    "fontspec"
    "caption"
    "xeCJK"
    "amsmath"
    "tocvsec2"
    "extarrows"
    "chngpage"
    "adjustbox"
    "clrscode"
    "listings"
    "fontenc"
    "babel"
    "amsfonts"
    "amsthm"
    "amssymb"
    "enumerate"
    "framed"
    "floatflt"
    "graphics"
    "graphicx"
    "picins"
    "lipsum"
    "sectsty"
    "wrapfig"
    "fancyhdr"
    "enumitem")
   (TeX-add-symbols
    '("horrule" 1)
    "n")
   (LaTeX-add-environments
    "denselist")
   (LaTeX-add-counters
    "newlist")))

