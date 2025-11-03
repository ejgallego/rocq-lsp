(lang dune 3.2)
; Can't bump to dune > 3.2 due to https://github.com/ocaml/dune/issues/6644

(cram enable)

(using menhir 2.1)

(name coq-lsp)

; (implicit_transitive_deps false)

; This requires Dune 3.20, let's keep it off for now until we
; understand the impact
; (implicit_transitive_deps false-if-hidden-includes-supported)
