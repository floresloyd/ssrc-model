# I. Data Collection.

This repository contains data and notebooks related to a data analysis project using census data from the years 2015 to 2021.

## Files and Directories

- `2015.csv` - Census data for the year 2015, pulled using R.
- `2016.csv` - Census data for the year 2016, pulled using R.
- `2017.csv` - Census data for the year 2017, pulled using R.
- `2018.csv` - Census data for the year 2018, pulled using R.
- `2019.csv` - Census data for the year 2019, pulled using R.
- `2021.csv` - Census data for the year 2021, pulled using R.

These CSV files represent the raw data as extracted from the census database for the respective years.

- `notebook.ipynb` - A Jupyter notebook that outlines the steps taken to process and clean the data from 2015-2021. This notebook is crucial for understanding the transformations applied to the raw data to create `data.csv`.

- `data.csv` - The combined and cleaned dataset compiled from the individual CSV files spanning the years 2015 to 2021. This file is not visible in the directory structure provided but is mentioned for clarity.

- `src.r` - R script used for pulling census data.

- `ssrc.py` - Python script associated with data sourcing.

- `test.py` - Python script used for testing the data extraction and processing.

## How to Use

To replicate the analysis:

1. Ensure that you have R and Python installed on your machine along with the necessary libraries.
2. Run the `src.r` script to pull the latest census data (if needed). OR Download 2015-2021 Data
3. Execute the `notebook.ipynb` to process and clean the data.


## Contributing

We welcome contributions to this project. Please fork the repository and submit a pull request for review.
