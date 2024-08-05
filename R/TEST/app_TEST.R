

library(shiny)
library(ggplot2)
library(bslib)
library(gridlayout)


source(here::here("R/00-librerias.R"))
source(here::here("R/01-importar.R"))
df_banderas <- readxl::read_excel("base_bandera_limpio.xlsx")
source(here::here("R/02-preparo_base_viz.R"))

# Cargo banderas


waiting_screen <- tagList(
  spin_flower(),
  h4("Bancame un toque...")
) 

library(shinyalert)

colors <- c(
  fg = "#405BFF",
  primary = "#EAFF38",
  heading_font = "#191919"
)

options(shiny.useragg = TRUE)
thematic_shiny(font = "auto")


ui <- page_navbar(
  title = "Olimpiadas",
  selected = "Line Plots",
  collapsible = TRUE,
  theme = bslib::bs_theme(),
  nav_panel(
    title = "Nav Panel",
    card(min_height =  "1000px",
      card_body(
        tabsetPanel(
          nav_panel(title = "Empty Tab",
                    highchartOutput("sankey", height = 1000)),
          nav_panel(title = "Empty Tab")
        )
      )
    )
  ),
  nav_panel(
    title = "Line Plots",
    grid_container(
      row_sizes = c(
        "1fr"
      ),
      col_sizes = c(
        "250px",
        "1fr"
      ),
      gap_size = "10px",
      layout = c(
        "num_chicks linePlots"
      ),
      grid_card(
        area = "num_chicks",
        card_header("Settings"),
        card_body(
          sliderInput(
            inputId = "numChicks",
            label = "Number of chicks",
            min = 1,
            max = 15,
            value = 5,
            step = 1,
            width = "100%"
          )
        )
      ),
      grid_card_plot(area = "linePlots")
    )
  ),
  nav_panel(
    title = "Distributions",
    grid_container(
      row_sizes = c(
        "165px",
        "1fr"
      ),
      col_sizes = c(
        "1fr"
      ),
      gap_size = "10px",
      layout = c(
        "facetOption",
        "dists"
      ),
      grid_card_plot(area = "dists"),
      grid_card(
        area = "facetOption",
        card_header("Distribution Plot Options"),
        card_body(
          radioButtons(
            inputId = "distFacet",
            label = "Facet distribution by",
            choices = list("Diet Option" = "Diet", "Measure Time" = "Time")
          )
        )
      )
    )
  )
)


server <- function(input, output) {
  
  shinyalert(
    title = "Buenas!",
    text = "Esta aplicación está en desarrollo. Si algo no está funcionando, se puede mejorar o incluso tenés una idea para agregar, podés escribirme a pablotisco@gmail.com",
    size = "s",
    closeOnEsc = TRUE,
    closeOnClickOutside = FALSE,
    html = FALSE,
    type = "warning",
    showConfirmButton = TRUE,
    showCancelButton = FALSE,
    confirmButtonText = "JOYA",
    confirmButtonCol = "#405BFF",
    timer = 0,
    imageUrl = "",
    animation = TRUE
  )
  
  output$out_medallas_tot <- renderText({
    "329"
  })
  
  output$out_paises_tot <- renderText({
    length(unique(tb_participantes$con))
  })
  
  output$out_discuplina_tot <- renderText({
    length(unique(tb_competencias$deporte))
  })
  
  output$sankey <- renderHighchart({
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
    
    
  })
  
}

shinyApp(ui, server)