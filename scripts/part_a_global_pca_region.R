
# Part A (Task 1a): Global PCA using all quantitative variables
# Includes: drop_na(), scree plot, biplots (PC1–PC2, PC2–PC3), loadings (PC1–PC4)
# Investigates Region effect in PCA plots
# Input: data/raw/global_life_work_balance.csv


# output folders
fig_dir = "outputs/figures/global"
tab_dir = "outputs/tables/global"

dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tab_dir, recursive = TRUE, showWarnings = FALSE)


# import & clean the dataset
library(tidyverse)
global_balance = read_csv('data/raw/global_life_work_balance.csv')
# data inspection
#nrow(global_balance)
#colnames(global_balance)
# removing nulls from data
global_balance=drop_na(global_balance)
#nrow(global_balance)
# Sort dataset by descending order of Rank
global_balance = arrange(global_balance,Rank)
#global_balance
# defining our quatitative subset
global_balance_sub = select(global_balance, -"Country", 
                            -"Capital", 
                            -"Region", 
                            -"HealthcareSystem", 
                            -"Rank",
                            -"Score")
# Check range of each variable to check if scaling required
summary(global_balance_sub)



# Carry out PCA
pca_results = prcomp(global_balance_sub, scale.=TRUE) # notice the dot
#pca_results
# Inspecting PCA outputs
#pca_results$sdev
#pca_results$rotation
#pca_results$center
#pca_results$scale
#pca_results$x
# Linking individual PCA coordinates with categorical variables 
pca_scores_categorised = as.data.frame(pca_results$x) %>%
  mutate(Region = global_balance$Region, 
         HealthcareSystem = global_balance$HealthcareSystem, 
         Country = global_balance$Country)
#pca_scores_categorised
# Reshaping the data frame for plotting

longer_pca_scores_reg = pivot_longer(select(pca_scores_categorised, 
                                            -HealthcareSystem, 
                                            - Country), -Region,names_to="PCA",values_to="PCA_value")
#longer_pca_scores_reg


# PCA scree plot
library(ggfortify)

variance_new = (pca_results$sdev)^2
#variance_new
variance_explained = variance_new/sum(variance_new)
#variance_explained

variance_df = data.frame(
  PCA = paste0("PC", 1:length(variance_explained)),
  variance_explained = variance_explained,
  PC_num = 1:length(variance_explained))
#variance_df
#outputs/tables/partA_variance_explained.csv
write_csv(variance_df, file.path(tab_dir, "partA_variance_explained.csv"))


p_partA_scree_global = ggplot(variance_df, aes(x=PC_num,y=100*variance_explained)) + 
                              geom_col() + ggtitle ("Global Screeplot")


#outputs/figures/partA_scree_global.png

ggsave(filename = file.path(fig_dir, "partA_scree_global.png"),
       plot = p_partA_scree_global,
       width = 8, height = 5, dpi = 300)

########################################################

# PCA regional scree plot
library(stringr)
pca_df = as.data.frame(pca_results$x)
pca_df$Region = global_balance$Region
#pca_df
long_pca_region = pivot_longer(pca_df, -Region,names_to="PCA",values_to="PCA_value")
#long_pca_region
long_pca_region = long_pca_region %>% 
  mutate(PCA_value_sq = PCA_value^2)
#long_pca_region
regional_contrib = long_pca_region %>%
  mutate(PCA_value_sq = PCA_value^2) %>%
  group_by(PCA) %>%
  mutate(total_variance_pc = sum(PCA_value_sq)) %>%
  group_by(PCA, Region, total_variance_pc) %>%
  summarise(region_variance = sum(PCA_value_sq), .groups = "drop") %>%
  mutate(
    region_share = region_variance / total_variance_pc,
    PC_number = as.integer(str_extract(PCA, "\\d+")))
regional_contrib = left_join(regional_contrib, variance_df, by = "PCA") %>% mutate(weighted_contribution = region_share * variance_explained)

#regional_contrib
library(ggplot2)
p_partA_region_contribution_pc = ggplot(regional_contrib, 
                                  aes(x = PC_number, 
                                      y = weighted_contribution*100,
                                      fill = Region)) +
                                      geom_col() + 
                                      ggtitle("Regional contribution per PC")


#outputs/figures/partA_scree_regional.png

ggsave(filename = file.path(fig_dir, "partA_region_contribution_pc.png"),
                            plot = p_partA_region_contribution_pc,
                            width = 10, height = 6, dpi = 300)

####################################################################


####################################################################

# PCA biplot (PC1 & PC2)
library(ggfortify)
p_partA_biplot_pc1_pc2_region = autoplot(pca_results, data = global_balance,
         label=TRUE, label.size=2.5, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,loadings.label.size=2.5 , colour="Region")+
  ggtitle("PC1 vs PC2")+
  coord_fixed(ratio=18.95/33.06) # these numbers come from the plot

#outputs/figures/partA_biplot_pc1_pc2_region.png
ggsave(filename = file.path(fig_dir, "partA_biplot_pc1_pc2_region.png"),
       plot = p_partA_biplot_pc1_pc2_region,
       width = 10, height = 7, dpi = 300)



####################################################################

# PCA biplot (PC2 & PC3)
library(ggfortify)
p_partA_biplot_pc2_pc3_region = autoplot(pca_results, data = global_balance,
         label=TRUE, label.size=2.5, shape=FALSE,x = 2, y = 3,
         loadings=TRUE, loadings.label=TRUE, loadings.label.size=2.5, colour="Region")+
  ggtitle("PC2 vs PC3")+
  coord_fixed(ratio=10.9/18.95) # these numbers come from the plot
#pca_results

#outputs/figures/partA_biplot_pc2_pc3_region.png


ggsave(filename = file.path(fig_dir, "partA_biplot_pc2_pc3_region.png"),
       plot = p_partA_biplot_pc2_pc3_region,
       width = 10, height = 7, dpi = 300)

#loadings
#view(global_balance)




# PCA loadings plot
loadings = as.data.frame(pca_results$rotation[,1:4])

#outputs/tables/partA_loadings_pc1_pc4.csv
write_csv(loadings, file.path(tab_dir, "partA_loadings_pc1_pc4.csv"))


loadings$Symbol = row.names(loadings)
loadings = gather(loadings, key='Component', value='Weight', -Symbol)

p_partA_loadings_pc1_pc4 = ggplot(loadings, aes(x=Symbol,y=Weight)) +
  geom_bar(stat='identity') +
  facet_grid(Component~.)+ coord_flip()

# outputs/figures/partA_loadings_pc1_pc4.png
ggsave(filename = file.path(fig_dir, "partA_loadings_pc1_pc4.png"),
       plot = p_partA_loadings_pc1_pc4,
       width = 10, height = 9, dpi = 300)

#################################################################


# regional loadings plot

#library(tidyverse)

# Define regions
region_list = c("Africa", "Asia", "Americas", "Europe")

# Empty list to store long-format loadings
all_region_loadings = list()

# Loop through each region
for (region_name in region_list) {
  
  # Subset and clean data for the region
  regional_dataset = global_balance %>%
    filter(Region == region_name) %>%
    drop_na() %>%
    select(-"Country", -"Capital", -"Region", -"HealthcareSystem", -"Rank", -"Score")
  
  # PCA
  pca_results2 = prcomp(regional_dataset, scale. = TRUE)
  
  # stand loading plot code
  loadings = as.data.frame(pca_results2$rotation[, 1:4])
  loadings$Symbol = rownames(loadings)
  loadings = gather(loadings, key = 'Component', value = 'Weight', -Symbol)
  loadings$Region = region_name  # Adding region column and fill it with same region name
  
  # Store in the predefined list
  all_region_loadings[[region_name]] = loadings
  }
# Combine all regions into one table
combined_loadings = bind_rows(all_region_loadings)

# Plot all regions together
partA_region_contribution_pc = ggplot(combined_loadings, aes(x = Symbol, y = Weight, fill = Region)) +
  geom_bar(stat = 'identity', position = "dodge") +
  facet_wrap(Component~.) +
  coord_flip() +
  ggtitle("Regional PCA Loadings (PC1–PC4)")
       

#outputs/figures/partA_region_contribution_pc.png

ggsave(filename = file.path(fig_dir, "partA_regional_loadings_pc1_pc4.png"),
       plot = partA_region_contribution_pc,
       width = 12, height = 12, dpi = 300)


# Scatter matrix including PCs
library(GGally)
global_balance_sub_SM = global_balance_sub %>%
  mutate(PC1=pca_results$x[,1],
         PC2=pca_results$x[,2],
         PC3=pca_results$x[,3],
         PC4=pca_results$x[,4]) %>%
  relocate(PC1,PC2,PC3,PC4)
pc_df_scat_matrix = ggpairs(global_balance_sub_SM)

ggsave(
  filename = file.path(fig_dir, "partA_scatter_matrix_with_PCs.png"),
  plot = pc_df_scat_matrix,
  width = 12,
  height = 12,
  dpi = 300
)






