library(here)

source(here("R/00-librerias.R"))
source(here("R/01-importar.R"))
df_banderas <- read_excel("datos/base_bandera_limpio.xlsx")
source(here("R/02-preparo_base_viz.R"))

highchart() |> 
  hc_add_series(data = tb_medallero_pivot, 
                type = "sankey",
                hcaes(from = from, to = to, weight = weight),
                nodes = nodes_list) |> 
  hc_plotOptions(series = list(dataLabels = list(
    style = list(
      fontSize = "12px",
      color = "black"
    ),
    useHTML = TRUE,
    padding = 2,
    shadow = FALSE
  ))) |> 
  hc_tooltip(useHTML = TRUE, formatter = JS("
    function() {
      let point = this.point;
      let tooltipStyle = 'background-color: white; border-radius: 10px; border: 1px solid #0072CE; padding: 5px;';
      if (point.isNode) {
        // Node tooltip (country name)
        let country = point.id;
        let totalMedals = this.series.chart.series[0].points
          .filter(p => p.to === country)
          .reduce((acc, p) => acc + p.weight, 0);
        return '<div style=\"' + tooltipStyle + '\">' +
               '<b>' + country + '</b><br/>' +
               'Total Medals: ' + totalMedals +
               '</div>';
      } else {
        // Link tooltip (medal bar)
        let medalType = point.from;
        let weight = point.weight;
        let medalIcons = {
          'Medalla de oro': '🥇',
          'Medalla de plata': '🥈',
          'Medalla de bronce': '🥉'
        };
        return '<div style=\"' + tooltipStyle + '\">' +
               medalIcons[medalType] + ' ' + weight + ' ' + medalType.replace('med_', '') +
               '</div>';
      }
    }
  ")) |> 
  hc_title(text = "Medallero") |> 
  hc_subtitle(text = "Juegos Olímpicos de París 2024") |> 
  hc_caption(text = "Fuente: Wikipedia") |> 
  hc_add_theme(hc_theme_smpl())

