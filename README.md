## Overview

The two datasets are related to red and white variants of the Portuguese "Vinho Verde" wine. The goal is to model wine quality based on physicochemical tests, and the datasets can be viewed as classification or regression tasks. Due to privacy and logistic issues, only physicochemical (inputs) and sensory (the output) variables are available (e.g. there is no data about grape types, wine brand, wine selling price, etc.). The classes are ordered and not balanced (i.e. there are much more normal wines than excellent or poor ones). The original data was provided in a publication about modeling the quality of wine by Paulo Cortez from the University of Minho, which has been made available at the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality). For more information about classifying the quality of wine, refer to a Paul Cortez's [publication](https://www.sciencedirect.com/science/article/pii/S0167923609001377?via%3Dihub). 

Datasets: [Red Wine Data](https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv) [82 KB] and [White Wine Data](https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv) [258 KB]

## Variable Descriptions
- `**ID:**` An ID number for the observed wine.
- `fx_acidity:` The fixed acidity, which is a measurement of the fixed acids in the wine. Most of the acids involved with wine are fixed acids.
- `vol_acidity:` The volatile acidity, which is a measurement of the volatile acids in the wine. At higher levels, volatile acids can lead to an unpleasant, vinegar taste.
- `citric_acid:` The amount of citric acid in the wine. Citric acids are usually found in small quantities, and they are known to add a sweet, citrous flavor to wine.
- `resid_sugar:` The amount of residual sugars in the wine. Residual sugars refer to the remaining sugars after fermentation. You will rarely find wines with less than 1 gram/liter of residual sugars, and wines with greater than 45 grams/liters of residual sugars are considered sweet.
- `chlorides:` The amount of chlorides in the wine. Chlorides are known to add a salty taste to wine.
- `free_sulf_d:` The amount of free sulfur dioxides in the wine. The free form of SO2 exists in equilibrium between molecular SO2 (as a dissolved gas) and bisulfite ion, which prevents microbial growth and the oxidation of wine. In low concentrations, SO2 is mostly undetectable in wine, but at free SO2 concentrations, over 50 ppm, SO2 becomes evident to the nose and to the taste of wine.
- `tot_sulf_d:` The amount of total sulfur dioxides in the wine, which is a measurement of both free and bounded forms of SO2.
- `density:` The density of the wine, which is primarily determined by the concentration of alcohol, sugar, glycerol, and other dissolved solids. The density of wine is similar to the density of water, depending on the percent of alcohol and sugar contents.
- `pH:` The pH level of the wine, which describes how acidic or basic a wine is on a scale from 0 (very acidic) to 14 (very basic). Most wines are between 3-4 on the pH scale.
- `sulph:` The amount of sulfur dioxide in the wine, which is a wine additive that can contribute to sulfur dioxide gas (S02) levels, and act as an antimicrobial and an antioxidant.
- `alcohol:` The alcohol content, or ABV, in the wine. 
- `quality:` The quality of the wine that is represented as a score between 0 and 10, and is calculated based on sensory data.
- `class:` The class that the wine is considered.
