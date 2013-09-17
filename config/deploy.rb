set :application, "NDI Database"
set :repository,  "git@github.com:parbros/ndi_lac.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "redinnovacion.org"                          # Your HTTP server, Apache/etc
role :app, "redinnovacion.org"                          # This may be the same as your `Web` server
