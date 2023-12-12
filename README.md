
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LanduseHanneProblem

<!-- badges: start -->
<!-- badges: end -->

The goal of LanduseHanneProblem is to …

1.  Sets:

- $Cells,$: Vertex set of the spatial graph. LandusesLanduses: Name of
  possible land uses.

2.  Parameters:

\-$Richness_{c,l}$: Number of species in each cell $c$ for each land use
$l$.

\-$PhyloDiversity_{c,l}$: Phylogenetic diversity in each cell $c$ for
each land use $l$.

\-$SuitabilityLanduse_{c,l}$: Suitability for each cell $c$ in each land
use $l$.

\-$TransitionCost{c,l}$: Cost of transforming a cell $c$ to land use
$l$.

- $b$: Budget.

3.  Decision Variables:

\-$LanduseDecision_{c, l}$: Binary decision variable indicating whether
land use $l$ is chosen for cell $c$.

4.  Objective Function:

$\text{Maximize } \text{ConservationIndex} = \sum_{l \in \text{Landuses}} \sum_{c \in \text{Cells}} \text{LanduseDecision}_{l,c} \cdot \text{Richness}_{l,c} \cdot \text{PhyloDiversity}_{l,c}$

Constraints:

- Proportional Use Constraint:

$\text{Subject to ProportionalUse}_{c}: \sum_{l \in \text{Landuses}} \text{LanduseDecision}_{l,c} \cdot \text{SuitabilityLanduse}_{l,c} = 1 \quad \forall c \in \text{Cells}$

- Budget Constraint:

$\text{Subject to Budget}: \sum_{l \in \text{Landuses}} \sum_{c \in \text{Cells}} \text{LanduseDecision}_{l,c} \cdot \text{TransitionCost}_{l,c} = b$

Here, $LanduseDecision_{c, l}$ is a binary decision variable that is 1
if land use $l$ is chosen for cell $c$ and 0 otherwise. The objective
function aims to maximize the conservation index, which is the product
of richness, phylogenetic diversity, and the decision variable.

The Proportional Use constraint ensures that for each cell, the sum of
the decision variables weighted by suitability is equal to 1,indicating
that exactly one land use is chosen for each cell.

The Budget constraint ensures that the total cost of transitioning cells
to their chosen land uses does not exceed the budget $b$

This model can be solved using linear programming techniques to find the
optimal land-use decisions that maximize the conservation index within
the given budget.

All this is summarized in this code for ampl

``` bash
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
```

## Problem generation