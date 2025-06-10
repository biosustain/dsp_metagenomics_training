install.packages(
  c(
    "FSA", "languageserver", "compositions"
  ),
  dependencies = TRUE,
  repos = "https://cloud.r-project.org",
  Ncpus = parallel::detectCores()
)
