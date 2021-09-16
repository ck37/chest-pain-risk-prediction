plot_tree = function(tree, shadow.col = "gray",
                     shadow.offset = 0.2,
                     box.palette = "auto",
                     digits = 3,
                     pal.thresh = 0.04,
                     extra = 107,
                     roundint = FALSE,
                     nn = TRUE,
                     # Adjust text size, 1.2 = 20% larger than the automatic choice.
                     tweak = 1.2, 
                     title = NULL,
                     ...) {
  prp(tree,
      shadow.col = shadow.col,
      shadow.offset = shadow.offset,
      box.palette = box.palette,
      digits = digits,
      pal.thresh = pal.thresh,
      #extra = 101,
      extra = extra,
      tweak = tweak,
      nn = nn,
      roundint = roundint,
      ...)
  if (!is.null(title)) {
    graphics::title(title, line = 3, cex = 0.8)
  }
}