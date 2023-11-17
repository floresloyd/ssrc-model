K-Means Clustering Project
Overview
This project utilizes the K-Means clustering algorithm to group data into distinct clusters based on their inherent patterns. The goal is to classify similar data points together, which can provide valuable insights into the data's underlying structure and offer actionable recommendations.

Table of Contents
- Introduction
- Data Preprocessing
- Choosing the Optimal Number of Clusters
- Implementing K-Means Clustering
- Visualization with t-SNE
- Interpretation and Conclusion

## 1. Introduction
K-Means is an iterative clustering algorithm used to partition a dataset into a set of non-overlapping subgroups or clusters. The number of clusters is user-specified and determines how the data is segmented.

## 2. Data Preprocessing
Standardization: The data was standardized to have a mean of 0 and a standard deviation of 1. This ensures that features with larger scales do not disproportionately influence the clustering outcome.
Conversion: For optimization and accuracy purposes, the data was converted to a numpy array before feeding it into the K-Means algorithm.
## 3. Choosing the Optimal Number of Clusters
# PRE CLUSTERED DATA :
<img src="./pre-cluster.png" width="600" height="600" />

To determine the most appropriate number of clusters:

We utilized the Elbow method and the Silhouette score.
By plotting the cost (inertia) against the number of clusters, the "elbow point" where the rate of decrease sharply changes was identified as an optimal number.
The Silhouette score, which measures how close each point in one cluster is to the points in neighboring clusters, was also used to validate the chosen cluster number.

# OPTIMAL HYPER PARAMETER (# of clusters) :
<img src="./optimal-hyperparams.png" width="1000" height="600" />

## 4. Implementing K-Means Clustering
With the optimal number of clusters identified, the K-Means algorithm was applied.
The dataset was divided into 6 distinct clusters.
Each data point was labeled with a cluster label, indicating the cluster it belongs to.

## 5. Visualization with t-SNE
To visualize high-dimensional data in a 2D space, the t-SNE (t-Distributed Stochastic Neighbor Embedding) technique was used.
The t-SNE plot showed the data points colored based on their cluster assignments, providing a visual representation of how data points group together.

## 6. Interpretation and Conclusion
# CLUSTERED DATA 
<img src="./final-cluster.png" width="600" height="600" />
The visualization offered insights into the distribution and grouping of the data points.
By selecting 6 as the optimal number of clusters, we captured the primary patterns within the data. Some smaller groupings might have been integrated into larger, more dominant clusters. Therefore, recommendations or interpretations based on any data point now align with its broader cluster.



