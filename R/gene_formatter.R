format_genes <- function(gene_string) {
  cleaned_gene_string <- gsub("\\s+", " ", gene_string)
  gene_names <- unlist(strsplit(trimws(cleaned_gene_string), " "))
  return(gene_names)  # Just return raw gene names
}

