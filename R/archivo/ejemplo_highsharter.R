
library(dplyr)
library(highcharter)

df_banderas <- readxl::read_excel("base_bandera_limpio.xlsx")

# Calculate total number of medals for each country
country_totals <- tb_medallero_pivot %>%
  group_by(to) %>%
  summarise(total_medals = sum(weight)) %>%
  arrange(desc(total_medals))

# Ensure the `to` column is a factor with levels in the desired order
tb_medallero_pivot <- tb_medallero_pivot %>%
  mutate(from = factor(from, levels = c('med_oro', 'med_plata', 'med_bronce')),
         to = factor(to, levels = country_totals$to)) %>%
  arrange(from, to, -weight)

# Prepare nodes with country flags
nodes_list <- lapply(1:nrow(country_totals), function(i) {
  country <- country_totals$to[i]
  flag_url <- df_banderas$bandera[match(country, df_banderas$pais_orig)]
  list(id = country, name = flag_url)
})

# Add medal nodes
nodes_list <- append(nodes_list, list(
  list(id = 'med_oro', color = "#FFD700"),  # Gold
  list(id = 'med_plata', color = "#C0C0C0"),  # Silver
  list(id = 'med_bronce', color = "#CD7F32")  # Bronze
))

# Highchart with custom labels for countries
highchart() |> 
  hc_add_series(data = tb_medallero_pivot, 
                type = "sankey",
                hcaes(from = from, to = to, weight = weight),
                nodes = nodes_list) |> 
  hc_plotOptions(series = list(dataLabels = list(
    style = list(
      fontSize = "12px",
      color = "black"  # Text color
    ),
    useHTML = TRUE,  # Enable HTML in data labels
    backgroundColor = "white",  # Background color
    borderRadius = 10,
    borderWidth = 1,
    borderColor = '#0072CE',  # Border color (Olympic blue)
    padding = 2,
    shadow = FALSE
  ))) |> 
  hc_tooltip(useHTML = TRUE, formatter = JS("
    function() {
      let point = this.point;
      if (point.isNode) {
        // Node tooltip (country name)
        let country = point.id;
        let totalMedals = this.series.chart.series[0].points
          .filter(p => p.to === country)
          .reduce((acc, p) => acc + p.weight, 0);
        return '<b>' + country + '</b><br/>' +
               'Total Medals: ' + totalMedals;
      } else {
        // Link tooltip (medal bar)
        let medalType = point.from;
        let weight = point.weight;
        let medalIcons = {
          'med_oro': '<img src=\"https://example.com/gold_icon.png\" style=\"width:15px;height:15px;\">',
          'med_plata': '<img src=\"https://example.com/silver_icon.png\" style=\"width:15px;height:15px;\">',
          'med_bronce': '<img src=\"https://example.com/bronze_icon.png\" style=\"width:15px;height:15px;\">'
        };
        return medalIcons[medalType] + ' ' + weight + ' ' + medalType.replace('med_', '');
      }
    }
  "))
