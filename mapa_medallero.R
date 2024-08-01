library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(viridis)

# Load world map data
df_mundo_orig <- ne_countries(scale = "medium", returnclass = "sf")

df_mundo <- df_mundo_orig |> 
  select(name_es, continent, postal, adm0_iso, fclass_tlc, pop_est, geometry, label_x, label_y) |> 
  filter(fclass_tlc == "Admin-0 country")

tb_medallero <- tb_medallero |> 
  mutate(pais = str_trim(sub("\\s*\\(.*$", "", pais)))

test <- df_mundo |>
  left_join(tb_medallero, by = c("name_es" = "pais")) |> 
  mutate(across(.cols = c(starts_with("med_"), "total"), as.numeric),
         # total = case_when(is.na(total) ~ 0,
         #                   .default = total)
         )


ggplot(data = test) +
  geom_sf(aes(fill = total), color = "black") +
  scale_fill_viridis_c(option = "viridis", na.value = "white") +
  theme_minimal() +
  labs(fill = "Variable")
