# Install required packages (if not already installed)
install.packages(c("BiocManager", "ggplot2"))
BiocManager::install(c("TCGAbiolinks", "DESeq2", "clusterProfiler", "org.Hs.eg.db", "EnhancedVolcano"))

# Load libraries
library(TCGAbiolinks)
library(DESeq2)
library(clusterProfiler)
library(org.Hs.eg.db)
library(EnhancedVolcano)
library(ggplot2)

# Query TCGA data for Lung Adenocarcinoma (LUAD)
query <- GDCquery(
  project = "TCGA-LUAD",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "HTSeq - Counts"
)

# Download the data
GDCdownload(query)

query <- GDCquery(
  project = "TCGA-LUAD",
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts"
)

GDCdownload(query)

# Ensure `GDCprepare()` is correctly used
data <- GDCprepare(query)
class(data)  # Should return "SummarizedExperiment"


# Extract raw count matrix
counts <- assay(data)  

# Extract clinical metadata
clinical <- colData(data)

# Select only Primary Tumor and Normal Tissue samples
sample_types <- clinical$definition
tumor_samples <- which(sample_types == "Primary solid Tumor")
normal_samples <- which(sample_types == "Solid Tissue Normal")

# Subset counts and metadata
counts_filtered <- counts[, c(tumor_samples, normal_samples)]
metadata_filtered <- clinical[c(tumor_samples, normal_samples), ]

# Create DESeq2 dataset
dds <- DESeqDataSetFromMatrix(
  countData = counts_filtered,
  colData = metadata_filtered,
  design = ~ definition  # Comparing Tumor vs. Normal
)

# Run differential expression analysis
dds <- DESeq(dds)

# Get results with adjusted p-value cutoff of 0.05
res <- results(dds, alpha = 0.05)

# Convert results to a data frame
res_df <- as.data.frame(res)
res_df <- na.omit(res_df)  # Remove NA values

# Save DEGs as CSV
write.csv(res_df, "DEGs_LUAD.csv")


# Define threshold for significant DEGs
deg_threshold <- 0.05  
res_df$Significant <- ifelse(res_df$padj < deg_threshold & abs(res_df$log2FoldChange) > 1, "Yes", "No")

# Create a Volcano Plot
EnhancedVolcano(res_df,
                lab = rownames(res_df),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 0.05,
                FCcutoff = 1,
                title = "Volcano Plot of DEGs in LUAD",
                subtitle = "Tumor vs. Normal"
)
# Install biomaRt if not installed
if (!requireNamespace("biomaRt", quietly = TRUE))
  BiocManager::install("biomaRt", force = TRUE)

# Load biomaRt
library(biomaRt)

mart <- useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")
# Test if mart was created successfully
listAttributes(mart)[1:5,]

# Convert Ensembl IDs to Gene Symbols
converted_genes <- getBM(
  attributes = c("ensembl_gene_id", "hgnc_symbol"),
  filters = "ensembl_gene_id",
  values = gene_list,  # Replace with your actual Ensembl ID list
  mart = mart
)

head(rownames(res_df))  # Check the first few Ensembl IDs
length(rownames(res_df))  # Make sure it's not empty

# Remove version numbers (everything after the dot)
gene_list <- gsub("\\..*", "", rownames(res_df))

# Check if version numbers were removed
head(gene_list)

library(biomaRt)

# Connect to Ensembl biomart
mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", 
                dataset = "hsapiens_gene_ensembl",
                host = "https://www.ensembl.org")

# Convert Ensembl Gene IDs to HGNC Symbols
converted_genes <- getBM(
  attributes = c("ensembl_gene_id", "hgnc_symbol"),
  filters = "ensembl_gene_id",
  values = gene_list,  # Now without version numbers
  mart = mart
)

# Remove empty values
converted_genes <- converted_genes[converted_genes$hgnc_symbol != "", ]
converted_genes <- converted_genes[!is.na(converted_genes$hgnc_symbol), ]

# Update gene_list with valid HGNC symbols
gene_list <- converted_genes$hgnc_symbol

# Check converted symbols
head(gene_list)
length(gene_list)  # Should be greater than 0


library(org.Hs.eg.db)

# Convert Gene Symbols to ENTREZ IDs
entrez_ids <- mapIds(org.Hs.eg.db, 
                     keys = gene_list, 
                     column = "ENTREZID", 
                     keytype = "SYMBOL", 
                     multiVals = "first")

# Remove any NA values
entrez_ids <- na.omit(entrez_ids)

# Check results
head(entrez_ids)
length(entrez_ids)  # Should be greater than 0

# Perform GO enrichment analysis
ego <- enrichGO(gene = entrez_ids, 
                OrgDb = org.Hs.eg.db, 
                keyType = "ENTREZID", 
                ont = "BP", 
                pAdjustMethod = "BH", 
                pvalueCutoff = 0.05)

# Save GO results
write.csv(as.data.frame(ego), "GO_Enrichment_Results_LUAD.csv")

# Visualize top 10 enriched GO terms
barplot(ego, showCategory = 10, title = "Top 10 Enriched GO Terms in LUAD")

#Comparison of Key Gene Mutations in Lung Adenocarcinoma (LUAD)
library(TCGAbiolinks)

#Mutation-Based Survival Analysis in LUAD
# Query mutation data for LUAD
query_mutation <- GDCquery(
  project = "TCGA-LUAD",
  data.category = "Simple Nucleotide Variation",
  data.type = "Masked Somatic Mutation",
  workflow.type = "Aliquot Ensemble Somatic Variant Merging and Masking"
)

# Download and prepare mutation data
GDCdownload(query_mutation)
mutation_data <- GDCprepare(query_mutation)

ls("package:dplyr")  # List all functions in dplyr
mutation_binary <- mutation_status %>%
  group_by(Tumor_Sample_Barcode, Hugo_Symbol) %>%
  dplyr::summarise(Mutated = 1, .groups = "drop") %>%  # Explicitly use dplyr
  tidyr::pivot_wider(names_from = Hugo_Symbol, values_from = Mutated, values_fill = list(Mutated = 0))

# View the transformed mutation data
head(mutation_binary)


