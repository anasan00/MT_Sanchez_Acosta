# This script creates the maps

# load packages
library(sf)
library(ggplot2)
library(stars)
library(raster)
library(gridExtra)

# go 1 level up directory 
setwd("..")


#### Dube & Vargas data ####
# load data 
plots_DV <- st_read('ANALYSIS/Maps production levels/DV_prod.shp')
plots_DV <- st_transform(plots_DV, 4326)
fillmap <- st_read('DATA/GeoData/Municipios.shp')

#oil prduction 

# plot with custom blue color scale
oil <- ggplot() + geom_sf(data=fillmap, fill="white") + 
  geom_sf(data=plots_DV, mapping = aes(fill=oilprod88_)) +
  scale_fill_gradientn(
    colors = c("white", "lightblue", "royalblue", "navy"),
    values = scales::rescale(c(0, 0.001, 0.5, 1)),
    breaks = c(0, max(plots_DV$oilprod88_, na.rm = TRUE)/4, 
               max(plots_DV$oilprod88_, na.rm = TRUE)/2, 
               3*max(plots_DV$oilprod88_, na.rm = TRUE)/4,
               max(plots_DV$oilprod88_, na.rm = TRUE)),
    labels = scales::label_number()
  ) +
  labs(fill = "Oil Production") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),  # Remove all grid lines
    panel.background = element_rect(fill = "white"),  # Set background to white
    axis.text = element_blank(),   # Remove axis text
    axis.title = element_blank(),  # Remove axis titles
    axis.ticks = element_blank(),   # Remove axis ticks
    legend.position = c(0.1, 0.9),  # x=0.1, y=0.9 positions it in the top left
    legend.justification = c(0, 1),  # Anchor the legend at its top-left corner  # White background
    legend.box.margin = margin(6, 6, 6, 6)  # Add some margin around the legend
  )

# Coffee production 
coffee <- ggplot() + geom_sf(data=fillmap, fill="white") + 
  geom_sf(data=plots_DV, mapping = aes(fill=cofint_dv)) +
  scale_fill_gradientn(
    colors = c("white", "lightblue", "royalblue", "navy"),
    values = scales::rescale(c(0, 0.001, 0.5, 1)),
    breaks = c(0, max(plots_DV$cofint_dv, na.rm = TRUE)/4, 
               max(plots_DV$cofint_dv, na.rm = TRUE)/2, 
               3*max(plots_DV$cofint_dv, na.rm = TRUE)/4,
               max(plots_DV$cofint_dv, na.rm = TRUE)),
    labels = scales::label_number(),
    na.value = "white"
  ) +
  labs(fill = "Coffee Production") +
  theme_minimal() +
  theme(
  panel.grid = element_blank(),  # Remove all grid lines
  panel.background = element_rect(fill = "white"),  # Set background to white
  axis.text = element_blank(),   # Remove axis text
  axis.title = element_blank(),  # Remove axis titles
  axis.ticks = element_blank(),   # Remove axis ticks
  legend.position = c(0.1, 0.9),  # x=0.1, y=0.9 positions it in the top left
  legend.justification = c(0, 1),  # Anchor the legend at its top-left corner 
  legend.box.margin = margin(6, 6, 6, 6)  # Add some margin around the legend
  )

combined_plot <-grid.arrange(oil,coffee, ncol=2)
ggsave("ANALYSIS/Maps production levels/Maps/DV_maps.png", combined_plot, width = 16, height = 8, dpi = 300)


### 2020 Production level ###
plots_2020 <- st_read('ANALYSIS/Maps production levels/prod_2020.shp')

oil_2020 <- ggplot() + geom_sf(data=fillmap, fill="white") + 
  geom_sf(data=plots_2020, mapping = aes(fill=oil_produc)) +
  scale_fill_gradientn(
    colors = c("white", "lightblue", "royalblue", "navy"),
    values = scales::rescale(c(0, 0.001, 0.5, 1)),
    breaks = c(0, max(plots_2020$oil_produc, na.rm = TRUE)/4, 
               max(plots_2020$oil_produc, na.rm = TRUE)/2, 
               3*max(plots_2020$oil_produc, na.rm = TRUE)/4,
               max(plots_2020$oil_produc, na.rm = TRUE)),
    labels = scales::label_number()
  ) +
  labs(fill = "Oil Production") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),  # Remove all grid lines
    panel.background = element_rect(fill = "white"),  # Set background to white
    axis.text = element_blank(),   # Remove axis text
    axis.title = element_blank(),  # Remove axis titles
    axis.ticks = element_blank(),   # Remove axis ticks
    legend.position = c(0.1, 0.9),  # x=0.1, y=0.9 positions it in the top left
    legend.justification = c(0, 1),  # Anchor the legend at its top-left corner  # White background
    legend.box.margin = margin(6, 6, 6, 6)  # Add some margin around the legend
  )

coffee_2020 <- ggplot() + geom_sf(data=fillmap, fill="white") + 
  geom_sf(data=plots_2020, mapping = aes(fill=p_cafe)) +
  scale_fill_gradientn(
    colors = c("white", "lightblue", "royalblue", "navy"),
    values = scales::rescale(c(0, 0.001, 0.5, 1)),
    breaks = c(0, max(plots_2020$p_cafe, na.rm = TRUE)/4, 
               max(plots_2020$p_cafe, na.rm = TRUE)/2, 
               3*max(plots_2020$p_cafe, na.rm = TRUE)/4,
               max(plots_2020$p_cafe, na.rm = TRUE)),
    labels = scales::label_number()
  ) +
  labs(fill = "Coffee Production") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),  # Remove all grid lines
    panel.background = element_rect(fill = "white"),  # Set background to white
    axis.text = element_blank(),   # Remove axis text
    axis.title = element_blank(),  # Remove axis titles
    axis.ticks = element_blank(),   # Remove axis ticks
    legend.position = c(0.1, 0.9),  # x=0.1, y=0.9 positions it in the top left
    legend.justification = c(0, 1),  # Anchor the legend at its top-left corner  # White background
    legend.box.margin = margin(6, 6, 6, 6)  # Add some margin around the legend
  )

combined_plot_2020 <-grid.arrange(oil_2020,coffee_2020, ncol=2)
ggsave("ANALYSIS/Maps production levels/Maps/2020_maps.png", combined_plot_2020, width = 16, height = 8, dpi = 300)

