# PCA & Multivariate Analysis of Global Life–Work Balance (R)

This repository presents a multivariate statistical analysis of the **Global Life–Work Balance Index 2025** using **Principal Component Analysis (PCA)** implemented in R.
  
---
  
## Project Overview
The analysis investigates:
- Global patterns in life–work balance using PCA
- Regional structure and variance contributions
- A focused comparison of European countries with emphasis on healthcare systems

The project follows reproducible research practices with clear separation of data, scripts, and outputs.
  
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
│       ├── global/  
│       └── europe/  
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

 

