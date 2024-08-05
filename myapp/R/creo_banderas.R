# # Extract text inside parentheses
pais_orig <- country_totals$to
pais_iso <- str_extract(country_totals$to, "(?<=\\().*?(?=\\))")
pais_nombre <- str_trim(str_replace(country_totals$to, "\\([^)]*\\)", ""))

base_banderas <- data.frame(pais_orig, pais_iso, pais_nombre)
base_banderas <- base_banderas |> 
  arrange(pais_nombre)

writexl::write_xlsx(base_banderas, "base_bandera_crudo.xlsx")

df_banderas <- readxl::read_excel("base_bandera_limpio.xlsx")
