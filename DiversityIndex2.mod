set Cells;   # vertex set of the spacial graph
set Landuses; # Name of possible Landuses
set E within {Cells,Cells};   # Connections between cells

param Richness {Landuses, Cells}; # Number of species in each cell for each landuse

param PhyloDiversity {Landuses,Cells}; # Phylogenetic diversity in each cell for each landuse

param TransitionCost {Landuses, Cells}; # Cost of transforming a cell to this landuse

param b; #budget

param SpatialContiguityBonus; # Bonus for adjacent cells with the same landuse

var LanduseDecision {l in Landuses, c in Cells} binary; # decision on which landuse to use for cell

maximize ConservationIndex:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c]*Richness[l,c]*PhyloDiversity[l,c] +
  SpatialContiguityBonus * sum{(i,j) in E, l in Landuses} LanduseDecision[l,i] * LanduseDecision[l,j];


subj to PropotionalUse{c in Cells}:
  sum{l in Landuses} LanduseDecision[l,c] <= 1;

# Ensure that at least one cell is selected for each land use
subj to MinimumCellPerLandUse{l in Landuses}:
  sum{c in Cells} LanduseDecision[l, c] >= 1;

subj to Budget:
  sum{l in Landuses, c in Cells} LanduseDecision[l,c]*TransitionCost[l,c] = b;

#subj to SpatialContiguityConstraint{(i,j) in E, l in Landuses}:
#  LanduseDecision[l,i] + LanduseDecision[l,j] <= 1; limit the number of #different landuses next to each #other
