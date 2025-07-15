# 🐦 ZF_Neural_Decoding  
Code and analysis for **“Decoding Temporal Features of Birdsong Through Neural Activity Analysis.”**

[![Made with MATLAB](https://img.shields.io/badge/MATLAB-R2024a-orange.svg)](#requirements)
[![Built with R](https://img.shields.io/badge/R-4.4-blue.svg)](#requirements)
[![License](https://img.shields.io/github/license/amirmasoud92/ZF_Neural_Decoding.svg)](LICENSE)

---

Zebra finch vocalisations are a powerful model for understanding how the brain processes natural sounds.  
This repository contains **all analysis and figure-generation code** used in the corresponding study, organised such that each folder reproduces one main or supplementary figure.

For full methodology and results, refer to the preprint:  
📄 [doi:10.1101/2025.04.15.XXXXXX](https://doi.org/10.1101/2025.04.15.XXXXXX)

---
## 📊 Data Availability

| Type               | Location                           | Note                         |
| ------------------ | ---------------------------------- | ---------------------------- |
| Raw Neural Data    | https://doi.org/10.17617/3.UINR2V  | Not included in the repo     |
| Stimulus Audio     | https://doi.org/10.17617/3.UINR2V  | 25 kHz WAV files             |
| Decoding Results   | https://doi.org/10.17617/3.AUMDAU  | Some of the files in the repo|

## 🖼️ Figures Overview

| **Figure** | **Description**                                                                                                                                                                                                                                                     |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fig 1**  | Overview of the experimental setup, neural signal processing pipeline (LFP/MUAe), and architecture of the BiLSTM neural decoder. Also introduces the four temporal features decoded: **Song Events**, **Amplitude Envelope**, **Peak Rate**, and **Peak Envelope**. |
| **Fig 2**  | Example decoding performance from one bird and trial. Shows decoded vs. actual temporal features using LFP input. The decoder accurately reconstructs **syllable segments**, **envelopes**, and **temporal landmarks**.                                             |
| **Fig 3**  | Comparative decoding performance using LFP vs. MUAe across all birds and sessions. Highlights decoding accuracy, correlation, and variance explained. Violin plots visualize group-level trends.                                                                    |
| **Fig 4**  | Anatomical localization of decoding performance across the avian auditory pallium. Field L (primary auditory area) consistently shows higher decoding accuracy than secondary regions.                                                                              |
| **Fig 5**  | Links between **single-unit response properties** and decoding performance. Shows that high-performing ensembles are made of neurons with high mutual information and phase-locking to temporal landmarks.                                                          |
| **Fig 6**  | Visualizes internal transformations in the **BiLSTM decoder**. Principal Component Analysis and t-SNE reveal how temporal features emerge through layer-wise processing.                                                                                            |
| **Fig 7**  | Direct comparison between **real neurons** and **artificial decoder units**. Shows that both share similar clustered activity and phase-locked responses to envelope events. Overlaps in t-SNE and DBSCAN clusters confirm functional similarity.                   |


## 📁 Repository Structure

ZF_Neural_Decoding/

├── Additional Functions/ # Shared MATLAB functions and utilities

├── Figure 2/ 

├── Figure 3/ 

├── Figure 4/ 

├── Figure 5/ 

├── Figure 6/ 

├── Figure 7/ 

├── Supplementary Figures/ 

└── README.md # You are here




## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/amirmasoud92/ZF_Neural_Decoding.git
   cd ZF_Neural_Decoding

| Tool   | Version | Required Packages / Toolboxes                          |
| ------ | ------- | ------------------------------------------------------ |
| MATLAB | R2024a  | Signal Processing, Statistics & ML, Parallel Computing |
| R      | ≥ 4.4   | tidyverse, ggplot2, patchwork, janitor, R.matlab       |


Each figure folder contains both a .m and an .R script. Either will produce the relevant plots and save them in an output/ subdirectory.



📚 Citation

If you use this repository in your work, please cite:
Ahmadi A, Robotka H, Gahr M, Theunissen F (2025).  
"Decoding Temporal Features of Birdsong Through Neural Activity Analysis."  
under review. https://doi.org/10.1101/2025.04.15.XXXXXX


✉️ Contact

For questions, bug reports, or collaborations:
📧 amirmasoud.ahmadi [at] bi.mpg.de


