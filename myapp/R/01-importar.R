
source(here::here("R/00-librerias.R"))

url <- "https://es.wikipedia.org/wiki/Juegos_Olímpicos_de_París_2024"

url_bow <- bow(url)
#url_bow

tb_medallero <- polite::scrape(url_bow) %>%  # scrape web page
  rvest::html_nodes("table.wikitable") %>% # pull out specific table
  rvest::html_table(fill = TRUE) 

tb_medallero <- 
  tb_medallero[[8]] %>% 
  clean_names()

colnames(tb_medallero) <- c("ranking", "pais", "med_oro", "med_plata", "med_bronce", "total")


df_banderas <- read_excel("datos/base_bandera_limpio.xlsx")

