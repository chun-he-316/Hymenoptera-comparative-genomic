library(ggplot2)
library(readxl)
library(dplyr)
library(tidyverse)
library(tidygraph)
library(ggalt)  
library(igraph) 
clusters <- read_excel("3branch.expand.xlsx", sheet ="3branch.expand.plot") 
# head(clusters)
# # A tibble: 6 × 9
#   ...1           V1      V2 Cluster_exemplar X.start Y.start group     if_exemplar BP2                       
#   <chr>       <dbl>   <dbl> <chr>              <dbl>   <dbl> <chr>     <chr>       <chr>                     
# 1 OG0000028 -0.111  -0.0509 OG0000028         -0.111 -0.0509 Aganoidae yes         post-embryonic development
# 2 OG0000127  0.0432 -0.259  OG0000028         -0.111 -0.0509 Aganoidae no          post-embryonic development
# 3 OG0000157 -0.0842 -0.0739 OG0000028         -0.111 -0.0509 Cynipidae no          post-embryonic development
# 4 OG0000305 -0.0604 -0.0717 OG0000028         -0.111 -0.0509 Aganoidae no          post-embryonic development
# 5 OG0005401 -0.165   0.0146 OG0000028         -0.111 -0.0509 Cynipidae no          post-embryonic development
# 6 OG0006643 -0.0987 -0.0687 OG0000028         -0.111 -0.0509 Cynipidae no          post-embryonic development

plotConstellation <- function(clusters, term = "BP2", color = NULL, size = NULL) {
  hulls <- clusters[, 1:4] %>% dplyr::group_by(Cluster_exemplar) %>% dplyr::slice(grDevices::chull(V1, V2))
  hull_col_pal <- stats::setNames(paletteer::paletteer_d("rcartocolor::Prism", n = dplyr::n_distinct(clusters$Cluster_exemplar), type="continuous"), unique(clusters$Cluster_exemplar))
  hull_col <- hull_col_pal[hulls$Cluster_exemplar]
  if (!term %in% colnames(clusters))
    stop(paste("The term ", term, " was not found as a column name in the matrix annotations", sep = ""))
  row.names(clusters) <- clusters$Row.names
  clusters <- clusters[, -1]
  p <- internalPlot(clusters, term, hulls, hull_col, color, size)
  return(p)
}
internalPlot <- function(clusters, term, hulls, hull_col, color, size) {
  p <- ggplot2::ggplot(data = clusters, ggplot2::aes(x = V1, y = V2)) +
    ggplot2::geom_polygon(data = hulls, ggplot2::aes(x = V1, y = V2, group = Cluster_exemplar), colour = NA, fill = hull_col, alpha = 0.2, show.legend = F) +
    ggnewscale::new_scale_color() +
    ggplot2::geom_segment(data = clusters, ggplot2::aes(x = X.start, y = Y.start, xend = V1, yend = V2, color = Cluster_exemplar), lwd = 0.3, alpha = 0.4) +
    ggplot2::theme_minimal() +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank()) +
    ggplot2::scale_color_manual(values = paletteer::paletteer_d("ggthemes::excel_Crop", direction = 1, type = "continuous", n = dplyr::n_distinct(clusters$Cluster_exemplar))) +
    ggplot2::scale_x_continuous(name = "MDS1") +
    ggplot2::scale_y_continuous(name = "MDS2") +
    ggnewscale::new_scale_color()
  if (!is.null(color) & !is.null(size)) {
    p <- p + ggplot2::geom_point(data = clusters, ggplot2::aes(x = V1, y = V2, size = .data[[size]], color = .data[[color]]), alpha = 0.6)
  } else if (!is.null(color)) {
    p <- p + ggplot2::geom_point(data = clusters, ggplot2::aes(x = V1, y = V2, color = .data[[color]]), alpha = 0.6)
  } else if (!is.null(size)) {
    p <- p + ggplot2::geom_point(data = clusters, ggplot2::aes(x = V1, y = V2, size = .data[[size]]), alpha = 0.6)
  } else {
    p <- p + ggplot2::geom_point(data = clusters, ggplot2::aes(x = V1, y = V2, color = group), alpha = 0.7, size = 2.5)+ggplot2::scale_color_manual(values = c("Apoidea" = "#2CAD3F", "Aganoidae" = "#EB746A", "Cynipidae" = "#6792CD"))
  }
  p <- p +
    ggplot2::scale_size(range = c(3, 9)) +
    ggrepel::geom_label_repel(
      data = subset(clusters, if_exemplar == "yes"),
      ggplot2::aes(label = BP2, color = NULL, segment.linetype = 2),
      color = "red",
      box.padding = grid::unit(1, "lines"),
      size = 3,
      max.overlaps = 220,
      alpha = 0.7,
      direction = "both",
      force = 100
    )
  if ("wordcloud" %in% colnames(clusters)) {
    p <- p + ggrepel::geom_label_repel(
      ggplot2::aes(label = wordcloud, color = NULL, segment.linetype = 2),
      data = subset(clusters, row.names(clusters) == Cluster_exemplar),
      box.padding = grid::unit(1, "lines"),
      size = 3,
      max.overlaps = 220,
      alpha = 0.7,
      direction = "both",
      force = 100
    )
  }
  return(p)
}
print(dim(clusters))
p = plotConstellation(clusters, term = "BP2") + guides(color = guide_legend(title = "Lineage"))
p