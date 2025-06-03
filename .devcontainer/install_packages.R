install.packages(
  c(
    "FSA", "languageserver", "netcomi"
  ),
  dependencies = TRUE,
  repos = "https://cloud.r-project.org",
  Ncpus = parallel::detectCores()
)
