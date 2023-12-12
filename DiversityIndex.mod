set Cells;   # vertex set of the spacial graph
set Landuses; # Name of possible Landuses

param Richness {Landuses, Cells}; # Number of species in each cell for each landuse
param PhyloDiversity {Landuses,Cells}; # Phylogenetic diversity in each cell for each landuse
param SuitabilityLanduse {Landuses,Cells} ; #suitability for each cell in each Landuses
param TransitionCost {Landuses, Cells}; # Cost of transforming a cell to this landuse
param b; #budget

var LanduseDecision {l in Landuses, c in Cells} binary; # decision on which landuse to use for cell Cell

maximize ConsevartionIndex:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c]*Richness[l,c]*PhyloDiversity[l,c];

subj to PropotionalUse{c in Cells}:
  sum{l in Landuses} LanduseDecision[l,c]*SuitabilityLanduse[l,c] = 1;

subj to Budget:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c]*TransitionCost[l,c] = b;