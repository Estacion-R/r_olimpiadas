library(ggiraph)
library(rnaturalearth)
library(sf)
library(patchwork)

world_map <- ne_countries(scale = "medium", returnclass = "sf")

world_data <- world_map |> 
  select(adm0_a3, name_es, pop_est, geometry) 

centroids <- st_centroid(world_data)

# Extract coordinates of centroids
coords <- st_coordinates(centroids)

# Add latitude and longitude columns to the original sf object
world_data <- world_data %>%
  mutate(longitude = coords[, 1],
         latitude = coords[, 2]) |> 
  left_join(tb_medallero, 
            by = c("name_es" = "pais_nombre")) |> 
  mutate(across(c(starts_with("med"), "total"), as.numeric))

gg_mapa <- ggplot() +
  geom_sf_interactive(data = world_map, colour = "grey", fill = "white") +
  geom_point_interactive(data = world_data, 
                         aes(x = longitude, y = latitude, size = total,
                             data_id = name_es, tooltip = name_es),
                         #colour = charging_point_situation),
                         alpha = 0.6) +
  scale_size_continuous(str_wrap("Cantidad de medallas obtenidas", width = 20),) +
  coord_sf(xlim = c(-130, 200), ylim = c(-70, 80), expand = FALSE) +
  theme_void() +
  theme(
    #plot.margin = margin(2, 2, 2, 2, "cm"),
    text = element_text(family = "Fira Mono"),
    plot.title = element_text(size = 30),
    plot.subtitle = element_text(size = 15),
    legend.position = "none",
    legend.title = element_text(size = 7),
    legend.text = element_text(size = 6)
    #plot.background = element_rect(fill = "white", colour = "black", linewidth = 1)
  )


gg_tabla <- 
  world_data |> 
  select(name_es, total) |> 
  filter(!is.na(total)) |> 
  mutate(
    #city = paste(city_abb, city, sep = " - "),
    tooltip_text = paste0(name_es, "\n", 
                          format(total, big.mark = ","))) |> 
  arrange(-total) |> 
  ggplot() +
  geom_col_interactive(
    aes(
      x = total, 
      y = reorder(name_es, total),
      tooltip = tooltip_text, 
      data_id = name_es),
    fill = '#23BCED') +
  geom_vline(xintercept = 0) +
  labs(x = "Cantidad de medallas", y = "País") +
  theme_minimal()


viz <- girafe(ggobj = gg_mapa / gg_tabla, pointsize = 12,
                        width_svg = 12, height_svg = 9) |> 
  girafe_options(opts_toolbar(position = "topright", 
                              delay_mouseout = 3000, 
                              pngname = "ev_europe"),
                 opts_tooltip(
                   opacity = 0.8, 
                   use_fill = TRUE,
                   use_stroke = TRUE, 
                   css = "padding:5pt;font-size:1rem;color:white"),
                 opts_zoom(max = 1),
                 opts_hover(
                   # css = girafe_css(
                   #   css = "stroke:'#23BCED;fill:'#23BCED';opacity:0.4",
                   #   text = "stroke:'#23BCED;fill:'#23BCED';fill-opacity:1;"
                   # )),
                   #css = "fill:wheat;stroke:'#23BCED';r:5pt;"),
                   css = girafe_css(
                     css = "fill:#03c245;stroke:black;",
                     #text = "stroke:none;fill:red;"
                   )),
                 opts_sizing(rescale = FALSE, width = 1)
  )

