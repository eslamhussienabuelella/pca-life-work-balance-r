# Part B (Task 1b): Europe-only PCA using all quantitative variables
# Includes: drop_na(), scree plot, biplots (PC1–PC2, PC2–PC3), loadings (PC1–PC4)
# Investigates HealthcareSystem effect in PCA plots
# Input: data/raw/global_life_work_balance.csv (filtered to Region == "Europe")



# output folders
fig_dir = "outputs/figures/europe"
tab_dir = "outputs/tables/europe"

dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tab_dir, recursive = TRUE, showWarnings = FALSE)

# import & clean the dataset
library(tidyverse)
global_balance = read_csv('data/raw/global_life_work_balance.csv') %>% 
  filter(Region == "Europe")
#view(global_balance)

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
global_balance_sub = select(global_balance,
                            -"Country", 
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

longer_pca_scores_health = pivot_longer(select(pca_scores_categorised, -Region, - Country), -HealthcareSystem,names_to="PCA",values_to="PCA_value")
#longer_pca_scores_health


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
write_csv(variance_df, file.path(tab_dir, "partB_variance_explained.csv"))

#variance_df
p_partB_scree_europe = ggplot(variance_df, aes(x=PC_num,y=100*variance_explained)) +
  geom_col() + ggtitle ("Screeplot for European countries")


ggsave(filename = file.path(fig_dir, "partB_scree_europe.png"),
       plot = p_partB_scree_europe,
       width = 8, height = 5, dpi = 300)




########################################################

# PCA health scree plot
library(stringr)
pca_df = as.data.frame(pca_results$x)
pca_df$HealthcareSystem = global_balance$HealthcareSystem
#pca_df
long_pca_health = pivot_longer(pca_df, -HealthcareSystem,names_to="PCA",
                               values_to="PCA_value")
#long_pca_health
long_pca_health = long_pca_health %>% 
  mutate(PCA_value_sq = PCA_value^2)
#long_pca_health
health_contrib = long_pca_health %>%
  mutate(PCA_value_sq = PCA_value^2) %>%
  group_by(PCA) %>%
  mutate(total_variance_pc = sum(PCA_value_sq)) %>%
  group_by(PCA, HealthcareSystem, total_variance_pc) %>%
  summarise(health_variance = sum(PCA_value_sq), .groups = "drop") %>%
  mutate(
    health_share = health_variance / total_variance_pc,
    PC_number = as.integer(str_extract(PCA, "\\d+")))
health_contrib = left_join(health_contrib, variance_df, by = "PCA") %>% mutate(weighted_contribution = health_share * variance_explained)
#health_contrib
library(ggplot2)
p_partB_health_contribution_pc = ggplot(health_contrib, 
                                aes(x = PC_number, y = weighted_contribution*100,
                                fill = HealthcareSystem)) +
                                geom_col() + ggtitle("Health contribution per PC")



ggsave(filename = file.path(fig_dir, "partB_health_contribution_pc.png"),
       plot = p_partB_health_contribution_pc,
       width = 10, height = 6, dpi = 300)



####################################################################


####################################################################

# PCA biplot (PC1 & PC2)
library(ggfortify)
p_partB_biplot_pc1_pc2_health = autoplot(pca_results, data = global_balance,
         label=TRUE, label.size=2.5, shape=FALSE,
         loadings=TRUE, loadings.label=TRUE,
         loadings.label.size=3, colour="HealthcareSystem")+
  ggtitle("PC1 vs PC2")+
  coord_fixed(ratio=14.33/46.78)+ # these numbers come from the plot
  theme(legend.position = "bottom")
ggsave(filename = file.path(fig_dir, "partB_biplot_pc1_pc2_health.png"),
       plot = p_partB_biplot_pc1_pc2_health,
       width = 10, height = 7, dpi = 300)
####################################################################

# PCA biplot (PC2 & PC3)
library(ggfortify)
p_partB_biplot_pc2_pc3_health = autoplot(pca_results, data = global_balance,
         label=TRUE, label.size=2.5, shape=FALSE,x = 2, y = 3,
         loadings=TRUE, loadings.label=TRUE, colour="HealthcareSystem")+
  ggtitle("PC2 vs PC3")+
  coord_fixed(ratio=11.17/14.33) # these numbers come from the plot
#pca_results
#loadings
#global_balance


ggsave(filename = file.path(fig_dir, "partB_biplot_pc2_pc3_health.png"),
       plot = p_partB_biplot_pc2_pc3_health,
       width = 10, height = 7, dpi = 300)


# PCA loadings plot
loadings = as.data.frame(pca_results$rotation[,1:4])
write_csv(loadings, file.path(tab_dir, "partB_loadings_pc1_pc4.csv"))

loadings$Symbol = row.names(loadings)
loadings = gather(loadings, key='Component', value='Weight', -Symbol)

p_partB_loadings_pc1_pc4 = ggplot(loadings, aes(x=Symbol,y=Weight)) +
  geom_bar(stat='identity') +
  facet_grid(Component~.)+ coord_flip()
ggsave(filename = file.path(fig_dir, "partB_loadings_pc1_pc4.png"),
       plot = p_partB_loadings_pc1_pc4,
       width = 10, height = 9, dpi = 300)


#################################################################


# regional loadings plot

#library(tidyverse)

# Define regions
health_list = c("Universal government funded health system", 
                "Public insurance system")

# Empty list to store long-format loadings
all_health_loadings = list()

# Loop through each region
for (health_name in health_list) {
  
  # Subset and clean data for the region
  regional_dataset = global_balance %>%
    filter(HealthcareSystem == health_name) %>%
    drop_na() %>%
    select(-"Country", -"Capital", -"Region", -"HealthcareSystem", -"Rank", -"Score")
  
  # PCA
  pca_results2 = prcomp(regional_dataset, scale. = TRUE)
  
  # stand loading plot code
  loadings = as.data.frame(pca_results2$rotation[, 1:4])
  loadings$Symbol = rownames(loadings)
  loadings = gather(loadings, key = 'Component', value = 'Weight', -Symbol)
  loadings$Health = health_name  # Adding region column and fill it with same region name
  
  # Store in the predefined list
  all_health_loadings[[health_name]] = loadings
  }
# Combine all regions into one table
combined_loadings = bind_rows(all_health_loadings)
combined_loadings
# Plot all regions together
partB_health_contribution_pc = ggplot(combined_loadings, aes(x = Symbol, y = Weight, fill = Health)) +
  geom_bar(stat = 'identity', position = "dodge") +
  facet_wrap(Component~.) +
  coord_flip() +
  ggtitle("Health impact PCA Loadings (PC1–PC4)")
       
ggsave(filename = file.path(fig_dir, "partB_health_loadings_pc1_pc4.png"),
       plot = partB_health_contribution_pc,
       width = 12, height = 12, dpi = 300)
# Scatter matrix including PCs
library(GGally)
global_balance_sub_SM = global_balance_sub %>%
  mutate(PC1=pca_results$x[,1],
         PC2=pca_results$x[,2],
         PC3=pca_results$x[,3],
         PC4=pca_results$x[,4]) %>%
  relocate(PC1,PC2,PC3,PC4)
pc_df_scat_matrixB = ggpairs(global_balance_sub_SM)

pc_df_scat_matrixB
ggsave(
  filename = file.path(fig_dir, "partB_scatter_matrix_with_PCs.png"),
  plot = pc_df_scat_matrixB,
  width = 12,
  height = 12,
  dpi = 300)







