# Comandos importantes

# Criacao dos badges
#devtools::install_github("rmhogervorst/badgecreatr")
badgeplacer(
                         status = "active",
                         githubaccount = "bendeivide",
                         githubrepo = "midrangeMCP"
                         )
badgecreatr::minimal_badges()

# Criando a website do pacote
usethis::use_pkgdown() # Primeiro comando
# use_pkgdown(): creates a pkgdown config file,
#    adds relevant files or directories
#    to .Rbuildignore and .gitignore, and builds
#    favicons if your package has a logo
pkgdown::build_site()


#Travis:
# travis::browse_travis_token()
# i Querying API token...
# > Opening URL <https://travis-ci.com/account/preferences>.
# i Call `usethis::edit_r_environ()` to open ~/.Renviron and store
# the API key as env var `R_TRAVIS_COM` (or `R_TRAVIS_ORG` if you
#                                        are using the '.org' endpoint). Example: `R_TRAVIS_COM = <key>`
#
# The API key can alternatively be stored in ~/.travis/config.yml.
# This is only suggested if you previously used the Travis CI CLI
# tool.
#
# See `?travis::browse_travis_token()` for details.


# Gerar o token do github
usethis::browse_github_token()
#'https://github.com/settings/tokens/new?scopes=repo,gist,user:email&description=R:GITHUB_PAT'
usethis::edit_r_environ()

# Badge codcov
badge_codecov(ghaccount = "bendeivide", ghrepo = "midrangeMCP", branch = "master")


# Inserir funcoes ou arquivos no .Rbuildignore
usethis::use_build_ignore("R/testing_widgets")

# Update cran-comments.md
usethis::use_cran_comments()

# Versao do pacote
usethis::use_release_issue()
# Current version is 3.2.
# Which part to increment? (0 to exit)
#
# 1: major --> 4.0
# 2: minor --> 3.3
# 3: patch --> 3.2.1
# 4:   dev --> 3.2.0.9000

#API's - verificar
Sys.getenv("R_TRAVIS")
Sys.setenv


# Configurar o TRAVIS
https://sahirbhatnagar.com/blog/2020/03/03/creating-a-website-for-your-r-package/


# Antes de iniciar a construcao da website do
#  pacote
require(devtools)
use_readme_rmd()
use_news_md()
use_vignette("test")
##
require(pkgdown)
use_github_links(overwrite = TRUE)



