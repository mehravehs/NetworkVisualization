# Copyright 2018 Mehraveh Salehi
# This code is released under the terms of the GNU GPL v2. This code
# is not FDA approved for clinical use; it is provided
# freely for research purposes. If using this in a publication
# please reference this properly via the following bibtex:
# @misc{Salehi2018,
#   author = {Salehi, Mehraveh},
#   title = {Network Visualization},
#   year = {2018},
#   publisher = {GitHub},
#   journal = {GitHub repository},
#   doi = {10.5281/zenodo.1214901}
#   hrl = {\url{https://github.com/mehravehs/NetworkVisualization}},
# }
#
# This code provides a framework for the network visualization of functional connectivity matrices
#
# 1- The first input ('M') is a pre-calculated n x c x p x p matrix containing group-level connectivity matrices
#    for all conditions and scan sessions, where n = number of re-scans for each condition, 
#    c = number of conditions, and p = number of nodes in the chosen brain atlas.
#    Each element (nn,cc,i,j) in these matrices represents the correlation between the BOLD timecourses
#    of nodes i and j during a single fMRI session nn with condition cc. 
#
# 2- The second input ('networks') is the p x 1 vector of node-to-network allegiances. Each element (i) in this vector shows the network that node i is assigned to.
#

rm(list = ls())
library(igraph)
library(networkD3)
library(R.matlab)


# ------------ INPUTS -------------------

# M is the average of connectivity matrices on all subejcts, saved as a .mat file.
# M has size n x c x p x p, where:
# n is the number of scnas for each condition (e.g. 2 in the movie data set),
# c is the number of conditions (e.g. 3 in the movie data set, representing inscapes, ocean, and rest), and
# p is the number of nodes or parcels (e.g. 181 in the movie data set, or 268 in Shen atlas)
# We read matrix M (the variable's name in MATLAB) here:
M <- readMat('PATH_TO_CONNECTIVITY_MATRIX.mat')$M
M_size <- dim(M)

# networks is the node-to-network assignment vector.
# networks has size p x 1, where p is the number of parcels or nodes (e.g. 181).
# Every element #i in this vector shows the network that node #i is assigned to.
networks <- readMat('/Users/Mehraveh/Documents/MATLAB/OtherCollaborations/Tamara/networks.mat')$networks
# The network names
labels<-c('Visual','SMN','DAN','VAN',
          'Limbic','FPN','DMN','None')
members <- labels[networks]


# ----------- ANALYSIS -----------------

# the condition number to visualize (e.g. 1 or 2 or 3 in the movie data set)
condition <- readline(cat("Which condition to visualize? Choose a number between 1 to", M_size[2]))
condition<-as.numeric(condition)

# the re-scan number to visualize within the condition (e.g. 1 or 2 in the  movie data set)
num <- readline(cat("Which scan within condition", condition, "to visualize? Choose a number between 1 to", M_size[1]))
num<-as.numeric(num)

# number of nodes or parcels (e.g. 181 in the movie data set)
parcel <- M_size[3] 

# data is the connectivity matrix for the specified condition and scan number 
data<-M[num,condition,,]

# Removing the diagonal elements and thresholding the connectivity matrix into the top 10% of the edges
data <- data-diag(diag(data))  
data<-(data>quantile(data, 0.9))*data


# Making the graph
g <- graph.adjacency(data, weighted=T, mode = "undirected")
# removing loops from the graph
g <- simplify(g)

# Visualizing the graph with size of nodes proporional to the degree of nodes
karate_d3 <- igraph_to_networkD3(g, group = members)
karate_d3$nodes$nodesize <- matrix(1,dim(data)[1],1)
karate_d3$nodes$nodesize = (rowSums(data)-data[1,1])*5

# Coloring nodes according to their network allegiances and coloring all edges as gray

A<-JS("d3.scaleOrdinal()
    .domain(['Visual','SMN','DAN','VAN',
      'Limbic','FPN','DMN','None'])
      .range(['#B336B2','#4D8BC9','#00A633','#FF2DEC','#F9FFCD','#F99E34','#FF6960','#000000']);")
ValjeanCols = ifelse(1:nrow(karate_d3$links), "#CCC","#bf3eff")


# Visualization on the browser
view<-getOption("viewer")
options(viewer = NULL)

karate_d3$links$value = karate_d3$links$value*2
forceNetwork(Links = karate_d3$links, Nodes = karate_d3$nodes, 
           Source = 'source', Target 
           = 'target', Value='value',
           NodeID = 'name', Group = 'group',zoom = TRUE,
           colourScale = A,
           fontSize = 0,opacity = 1, linkColour = ValjeanCols,
           bounded=F,opacityNoHover = 1,Nodesize = 'nodesize',legend = TRUE)

