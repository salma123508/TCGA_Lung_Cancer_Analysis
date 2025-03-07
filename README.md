# TCGA_Lung_Cancer_Analysis
 "Analysis of lung cancer using TCGA data"
 # 🧬 TCGA Lung Cancer Analysis  
**Comprehensive Gene Expression Analysis of Lung Cancer Using TCGA Data**  

## 📌 Overview  
This project analyzes **lung cancer gene expression data** from **The Cancer Genome Atlas (TCGA)** to identify **differentially expressed genes (DEGs)** and perform **functional enrichment analysis** to uncover biological pathways associated with lung cancer.  

### 🏆 **Objectives:**  
✔ Download and preprocess **TCGA RNA-seq data**.  
✔ Identify **differentially expressed genes (DEGs)** between normal and tumor samples.  
✔ Perform **functional enrichment analysis** (GO, KEGG, Pathway analysis).  
✔ Visualize gene expression patterns using PCA, heatmaps, and volcano plots.  

---

## 📂 **Project Structure**  


---

## 📊 **Dataset & Tools Used**  

### 🔬 **Dataset: TCGA Lung Cancer RNA-seq**  
- **Source**: [TCGA-LUAD & TCGA-LUSC](https://portal.gdc.cancer.gov/)  
- **Sample Size**: 🔹 **Lung Adenocarcinoma (LUAD)**: 500+ samples 🔹 **Lung Squamous Cell Carcinoma (LUSC)**: 450+ samples  
- **Data Types**: RNA-seq counts  

### 🛠 **Tools & Libraries**  

| **Category** | **Tools Used** |
|-------------|---------------|
| **Data Retrieval** | `TCGAbiolinks`, `GDCquery`, `Bioconductor` |
| **Data Processing** | `Pandas`, `NumPy`, `DESeq2`, `edgeR`, `limma` |
| **Visualization** | `ggplot2`, `Seaborn`, `Matplotlib`, `plotly` |
| **Statistical Analysis** | `SciPy`, `Wilcoxon Test`, `t-tests` |
| **Functional Analysis** | `clusterProfiler`, `GOseq`, `KEGG pathways` |

---


## 📌 Work Done  
- Downloaded and preprocessed **TCGA lung cancer RNA-seq data**.  
- Performed **differential expression analysis (DEG)** using `DESeq2`.  
- Conducted **exploratory data analysis (PCA, heatmaps, clustering)**.  
- Identified **significantly upregulated and downregulated genes**.  
- Performed **functional enrichment analysis (GO, KEGG pathways)**.  
- Visualized results using **volcano plots, heatmaps, and bar plots**.  

## 📈 Key Findings  
- **PCA & Clustering:** Distinct separation between tumor and normal samples.  
- **DEGs Identified:** **500+ significantly differentially expressed genes**.  
- **Top Pathways Enriched:** **p53 signaling, EGFR pathway, immune response regulation**.  
- **Potential Biomarkers:** Key genes linked to **lung cancer progression**.  
