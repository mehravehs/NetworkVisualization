# NetworkVisualization

Copyright 2018 Mehraveh Salehi
This code is released under the terms of the GNU GPL v2. This code
is not FDA approved for clinical use; it is provided
freely for research purposes. If using this in a publication
please reference this properly via the following bibtex:
@misc{Salehi2018,
  author = {Salehi, Mehraveh},
  title = {Network Visualization},
  year = {2018},
  publisher = {GitHub},
  journal = {GitHub repository},
  doi = {10.5281/zenodo.1214901}
  hrl = {\url{https://github.com/mehravehs/NetworkVisualization}},
}

This code provides a framework for the network visualization of functional connectivity matrices

1- The first input ('M') is a pre-calculated n x c x p x p matrix containing group-level connectivity matrices
   for all conditions and scan sessions, where n = number of re-scans for each condition, 
   c = number of conditions, and p = number of nodes in the chosen brain atlas.
   Each element (nn,cc,i,j) in these matrices represents the correlation between the BOLD timecourses
   of nodes i and j during a single fMRI session nn with condition cc. 

2- The second input ('networks') is the p x 1 vector of node-to-network allegiances. Each element (i) in this vector shows the network that node i is assigned to.


