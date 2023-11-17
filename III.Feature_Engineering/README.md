# K-Means Clustering for Social Science Research Council

This project utilizes the K-Means clustering algorithm to group data into distinct clusters based on their inherent patterns (Variable Category). The goal is to classify similar data points together, which can provide valuable insights into the data's underlying structure and offer actionable recommendations. 

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
3. [Usage](#usage)
4. [Results](#results)
5. [Contributing](#contributing)
6. [License](#license)
7. [Acknowledgements](#acknowledgements)

## Introduction

We were given the task to improve user experience in the Data2go.nyc website by recommending related variables a user may have missed, by suggesting another variable that is closely related the one selected. K-means is the best approach for this.

## Getting Started

### Folder Description and Checkpoints
- data_cleaning : this contains the initial dataset we pulled from data2go nyc's website. We had to clean the data by extracting only the data we needed

- feature-engineering : this contains how we transformed the clean data into something the model could use. We vectorized our variable/indicator column and one-hot-encoded our categories.

- data-vis-kmeans-clustering : this is where all the final findings are stored. If you're only interested in the results and clustering of the data, please refer to this

- model1&2Data-r : Our first approach on pulling data from census.gov. This idea is then scrapped instead utilizing the data2go.nyc dataset instead 

### Prerequisites

- pip install numpy
- pip install pandas
- pip install scikit-learn
- pip install matplotlib
- pip install seaborn


### Installation

Instructions on how to get the development environment running. For example:

1. Clone the repository:
    ```bash
    git clone https://github.com/your_username/kmeans-project.git
    ```

2. Install the required packages:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

Instructions on how to use the script or application. Include example commands or scripts if necessary.

```bash
python kmeans_clustering_script.py --input your_data.csv
