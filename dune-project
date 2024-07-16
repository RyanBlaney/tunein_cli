(lang dune 3.16)

(name tunein_cli)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Ryan Blaney")

(maintainers "Ryan Blaney")

(license LICENSE)

(documentation https://github.com/RyanBlaney/tunein_cli)

(package
 (name tunein_cli)
 (synopsis "A command line script for playing TuneIn Radio stations locally.")
 (description "A command line script for playing TuneIn Radio stations locally. This is the main logic that I will be basing off my TuneIn TUI (Terminal User Interace) application on.")
 (depends 
   ocaml 
   dune
   cohttp-lwt-unix
   xmlm
   lwt)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
