# PCA & Multivariate Analysis of Global Life–Work Balance (R)

This repository presents a multivariate statistical analysis of the **Global Life–Work Balance Index 2025** using **Principal Component Analysis (PCA)** implemented in R.
  
---
  
## 🎯 Project Objectives  

This project applies Principal Component Analysis (PCA) to the Global Life–Work Balance Index 2025 to explore the multivariate structure underlying international differences in life–work balance outcomes.
  
The specific objectives are to:  

1. Reduce dimensionality of the life–work balance indicators while retaining the dominant sources of variation across countries.  
  
2. Identify and interpret the main latent dimensions (PC1–PC4) driving differences in life–work balance using scree plots, biplots, and loadings.  
  
3. Assess regional patterns by investigating how countries from different world regions are distributed in PCA space.  
  
4. Compare global and regional structures by repeating the PCA for European countries only.  
  
5. Evaluate the role of healthcare systems in shaping life–work balance outcomes within Europe.  
  
6. Provide interpretable visual and numerical outputs that support evidence-based conclusions rather than purely descriptive plots.  

This analysis follows reproducible research practices, with all figures and tables generated directly from the R scripts included in this repository.
  
---
  
## Repository Structure

pca-life-work-balance-r  
│  
├── README.md  
│  
├── data/  
│   └── raw/  
│       └── global_life_work_balance.csv  
│  
├── scripts/  
│   ├── part_a_global_pca_region.R  
│   └── part_b_europe_pca_healthcare.R  
│  
├── outputs/  
│   ├── figures/    
│   │   ├── global/  
│   │   └── europe/  
│   └── tables/    
│   │   ├── global/  
│   │   └── europe/  
│  
├── .gitignore  
│   
└── pca-life-work-balance-r.Rproj  

data/raw/ # Raw dataset  
scripts/ # R scripts for PCA analysis  
outputs/ # Generated figures and tables  
  
---
  
## Scripts  
- `part_a_global_pca_region.R`  
  Global PCA using all quantitative variables with regional interpretation.

- `part_b_europe_pca_healthcare.R`  
  PCA restricted to European countries, analysing the effect of healthcare systems.
  
---
  
## Methods
- Data cleaning using `tidyverse`
- PCA using `prcomp()` with scaling
- Visualisation using `ggplot2`, `ggfortify`, and `GGally`
  
---
  
## Data Source
Global Life–Work Balance Index 2025  
Source: https://remote.com/resources/research/global-life-work-balance-index
  
---
  
## Reproducibility
All figures and tables can be reproduced by running the scripts from the project root.

 

