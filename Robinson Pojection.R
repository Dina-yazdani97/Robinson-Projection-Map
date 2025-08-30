# Package Loading ---------------------------------------------------------
library(sf)
library(rnaturalearth)
library(ggplot2)
library(extrafont)

# Download country boundaries and ocean data ------------------------------
world_countries <- ne_countries(scale = 'medium', returnclass = 'sf')
world_oceans <- ne_download(scale = 'medium', type = 'ocean', 
                            category = 'physical', returnclass = 'sf')

# Projection Definition ---------------------------------------------------
target_crs_robinson <- "ESRI:54030" # Robinson projection

# CRS Transformation ------------------------------------------------------
world_countries_robinson <- st_transform(world_countries, crs = target_crs_robinson)
world_oceans_robinson <- st_transform(world_oceans, crs = target_crs_robinson)

# Graticule Creation ------------------------------------------------------
graticules_robinson <- st_graticule(
  lat = seq(-90, 90, by = 15),
  lon = seq(-180, 180, by = 15),
  crs = st_crs(4326)
) |> st_transform(crs = target_crs_robinson)

# Create Map --------------------------------------------------------------
ggplot() + 
  geom_sf(data = world_oceans_robinson, fill = "deepskyblue", color = NA) +
  geom_sf(data = graticules_robinson, color = "#EEDFCC", linewidth = 0.1) +
  geom_sf(data = world_countries_robinson, fill = "gray90", color = "black", linewidth = 0.1) +
  ggtitle("World Map - Robinson Projection") + 
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman"),
    plot.title = element_text(hjust = 0.5, size = 16),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save Map ----------------------------------------------------------------
ggsave("robinson_map.png", width = 10, height = 6, dpi = 300, bg = "white")
