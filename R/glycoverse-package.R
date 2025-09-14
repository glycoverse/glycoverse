#' @keywords internal
"_PACKAGE"

# Suppress R CMD check note
# Namespace in Imports field not imported from: PKG
#   All declared Imports should be used.
ignore_unused_imports <- function() {
  glyclean::auto_clean
  glydet::derive_traits
  glyenzy::all_enzymes
  glyexp::experiment
  glymotif::have_motif
  glyparse::auto_parse
  glyread::read_pglyco3
  glyrepr::glycan_structure
  glystats::gly_pca
  glyvis::plot_heatmap
}