

source("R/00-librerias.R")
source("R/01-importar.R")
df_banderas <- read_excel("base_bandera_limpio.xlsx")
source("R/02-preparo_base_viz.R")

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

# Define UI for application that draws a histogram
ui <- page_fluid(
  
  theme = bslib::bs_theme(
    bg = "white",
    fg = "#191919",
    primary = "#405BFF",
    secondary = "#405BFF",
    heading_font = "#191919",
    # bslib also makes it easy to import CSS fonts
    base_font = bslib::font_google("Ubuntu")
  ),
  
  useWaitress(color = "#7F7FFF"),
  
  title = "Olimpiadas",
  #bg = "white",
  underline = TRUE,
  

    fluidRow(
      # column(filter_line_desde, width = 3),
      # column(filter_line_hacia, width = 3),
    ),
    highchartOutput("sankey", height =1000),
  )



# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # shinyalert(
  #   title = "Buenas!",
  #   text = "Esta aplicación está en desarrollo. Si algo no está funcionando, se puede mejorar o incluso tenés una idea para agregar, podés escribirme a pablotisco@gmail.com",
  #   size = "s", 
  #   closeOnEsc = TRUE,
  #   closeOnClickOutside = FALSE,
  #   html = FALSE,
  #   type = "warning",
  #   showConfirmButton = TRUE,
  #   showCancelButton = FALSE,
  #   confirmButtonText = "JOYA",
  #   confirmButtonCol = "#405BFF",
  #   timer = 0,
  #   imageUrl = "",
  #   animation = TRUE
  # )
  
  # observe({
    # ### Armo la base de panel
    # df_eph_panel <- reactive({
    #   armo_base_panel(anio_0 = anio_ant, 
    #                   trimestre_0 = trim_ant,
    #                   anio_1 = anio_post, 
    #                   trimestre_1 = trim_post)
    #   
    # })
    
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

# Run the application 
shinyApp(ui = ui, server = server)