# Economic drivers of conflict: How commodity prices affect civil war in Colombia

This repository contains the code files used for my master thesis. It is meant to help replicate the findings. Due to privacy and capacity reasons, I did not upload all underlying data for my analysis but rather the code used for its preprocessing and some of the preprocessed tables.

The repository is organized as follows:

## [DATA](https://github.com/anasan00/MT_Sanchez_Acosta/tree/main/DATA)
This folder contains all files used for the preprocessing of the data. The preprocessing file should be run as follows:  

1. The [data collection](https://github.com/anasan00/MT_Sanchez_Acosta/blob/main/DATA/DataCollection.ipynb) notebook gathers the preprocessed information from the different data sources. These sources are organized in folders, where almost each folder contains a file with help functions and a notebook that processes the information.  
2. After collection, the [validation and missing filling](https://github.com/anasan00/MT_Sanchez_Acosta/blob/main/DATA/ValidationMissingfillinsDV.ipynb) notebook compares my data with the data from Dube and Vargas for the overlapping years and uses their data to fill in missing values if possible.  
3. The [preparation](https://github.com/anasan00/MT_Sanchez_Acosta/blob/main/DATA/DataPreparation.ipynb) notebook computes interaction terms and delivers the base for the analysis.  
4. Lastly, the [Stata script](https://github.com/anasan00/MT_Sanchez_Acosta/blob/main/DATA/Preprocessing.do) handles some last steps and produces necessary `.dta` files for the analyses.  

## [ANALYSIS](https://github.com/anasan00/MT_Sanchez_Acosta/tree/main/ANALYSIS)
This folder contains different codes used for the analysis as well as [output tables](https://github.com/anasan00/MT_Sanchez_Acosta/tree/main/ANALYSIS/Tables), [graphs](https://github.com/anasan00/MT_Sanchez_Acosta/tree/main/ANALYSIS/Graphs), and [maps](https://github.com/anasan00/MT_Sanchez_Acosta/tree/main/ANALYSIS/Maps%20production%20levels). The order is not relevant as each file analyzes separate aspects.  

The names of the files should be self-explanatory.
