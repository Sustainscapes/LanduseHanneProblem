library(terra)
library(prioritizr)

## PRIORITIZATION TEST FOR VILHELMSBORG

## funny way to get there - instead just go directly from the agriculture map (see ENMEval_basemap_clean)

Vilhelmsborg_template <- rast("O:/Nat_Sustain-tmp/DenmarkPlantPresences/Vilhemsborg/OpenWetRich/abies_alba.tif")

agr <- rast("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Habitat_Ref_Map/RF_predict_binary_WetRich_thresh_5.tif") |> 
  crop(Vilhelmsborg_template)

agr[!is.na(agr)] <- 1


## Loading biodiversity metric rasters: 

SummaryVilhelmsborg <- readRDS("O:/Nat_Sustain-tmp/DenmarkPlantPresences/Vilhemsborg/Raw/SummaryVilhemsborg.rds")

df_Vilhelm <- as.data.frame(SummaryVilhelmsborg)

habitats <- unique(df_Vilhelm[,1])

PD_load <- list()
richness_load <- list()

for (i in 1:length(habitats)){
  
  temp_richness <- rast(paste0("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Prioritization/Vilhelmsborg_test/richness_",habitats[i],".tif"))
  temp_PD <- rast(paste0("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Prioritization/Vilhelmsborg_test/PD_",habitats[i],".tif"))
  
  richness_load[i] <- temp_richness
  PD_load[i] <- temp_PD
  
}

richness_habitats <- rast(richness_load)
names(richness_habitats) <- habitats
PD_habitats <- rast(PD_load)
names(PD_habitats) <- habitats

## Setting up management zones for prioritization 

## Loading suitability rasters

suitabilities.names <- c("DryPoor","DryRich","WetPoor","WetRich")
suitabilities <- list()

for (i in 1:length(suitabilities.names)){
  
  temp <- rast(paste0("O:/Nat_Sustain-proj/_user/HanneNicolaisen_au704629/Data/Habitat_Ref_Map/RF_predict_binary_",suitabilities.names[i],"_thresh_5.tif")) |> 
    crop(Vilhelmsborg_template)
  
  suitabilities[i] <- ifel(temp == 0, NA, 1)
  
}

zones <- c(suitabilities[[2]],suitabilities[[3]],
           suitabilities[[4]],suitabilities[[2]],
           suitabilities[[3]],suitabilities[[4]])

names(zones) <- habitats

## Setting up features

features <- zones("zone 1" = richness_habitats[[1]],
                "zone 2" = richness_habitats[[2]],
                "zone 3" = richness_habitats[[3]],
                "zone 4" = richness_habitats[[4]],
                "zone 5" = richness_habitats[[5]],
                "zone 6" = richness_habitats[[6]])

p_test <-
  problem(zones, features) %>%
  add_max_utility_objective(100) %>%
  add_binary_decisions() %>%
  add_default_solver(gap = 0, verbose = FALSE)

# solve problem
s_test <- solve(p_test)

# plot solution
plot(category_layer(s2), main = "solution", axes = FALSE)
