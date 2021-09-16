#' Extract statistics from a given rpart object.
#' Should extract:
#'  - Total leaf nodes
#'  - Total splits
#'  - Total nodes
#'  - Minimum leaf node size
tree_stats = function(tree) {
  
  # tree$frame is a data frame
  total_nodes = nrow(tree$frame)
  
  # - if tree$frame$var == "<leaf>", that row is a leaf node.
  leaf_nodes = sum(tree$frame$var == "<leaf>")
  leaf_node_sizes = tree$frame[tree$frame$var == "<leaf>", "n"]
  
  results =
    list(
      total_nodes = total_nodes,
      leaf_nodes = leaf_nodes,
      min_leaf_node_size = min(leaf_node_sizes)
  )
  
  return(results)
}