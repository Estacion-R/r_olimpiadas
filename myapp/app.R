

source("R/00-librerias.R")
source("R/01-importar.R")
#df_banderas <- readxl::read_excel("base_bandera_limpio.xlsx")
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
ui <- page_navbar(
  
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
  
  #title = "Olimpiadas",
  title=div(tags$a(href='https://olympics.com/es/olympic-games',
                   tags$img(src='https://olympics.com/images/static/b2p-images/logo_color.svg',
                            height = 105, width = 300)), align = "center"),
  #bg = "white",
  underline = TRUE,
  
  nav_panel(height="1000px",
            icon = icon("video"),
            title = "Medallero", 
            fluidRow(
              # column(filter_line_desde, width = 3),
              # column(filter_line_hacia, width = 3),
            ),
            card(min_height =  "1000px", 
                 highchartOutput("sankey", height = 1000)
            )
  ),
  
  nav_panel(
    icon = icon("circle-info"),
    title = "Sobre la App",
    card(
      class = "bg-dark",
      #padding = "20px", gap = "20px",


      br(),

      titlePanel(title=div(tags$a(href='https://linktr.ee/estacion_r',
                                  tags$img(src='https://pbs.twimg.com/profile_banners/1214735980172845056/1716430021/600x200',
                                           height = 105, width = 300)), align = "center")),

      br(),

      tags$blockquote("La siguiente aplicación es un desarrollo de Estación R"
      ),

      #br(),

      # h1("La E-P-H"),
      # p(
      #   strong(em("La Encuesta Permanente de Hogares")),
      #   "es una de las fuentes de información sociodemográfica más importante del", a("Sistema Estadístico Nacional (SEN)", href = "https://www.indec.gob.ar/indec/web/Institucional-Indec-SistemaEstadistico"), "Argentino.
      #         Si bien este operativo es más conocido por la Tasa de Desocupación",a("[1], ", href="#footnote-1"), "el abanico de indicadores que se pueden obtener para caracterizar las condiciones de vida de la población es muy amplio."
      # ),
      # 
      # p("Dos estrategias de análisis son plausible de abordar al momento de querer caracterizar a una población determinada.
      #   La primera es el", strong("Análisis Transversal,"), "entendido como una forma de leer los datos en clave de 'foto'. Esta es el abordaje para el cual fue diseñada la encuesta, aunque no el único."
      # ),
      # 
      # p("Una segunda manera de interpretar la información es mediante el", strong("Anáisis Longitudinal"), "en el cual la lectura es en clave de 'película'. Esto es, para una misma población, observo su evolución respecto al indicador seleccionado.
      # Para ejemplificar, bajo este análisis puedo saber si la población ocupada que entrevisté en el primer trimestre del 2023 se encuentra en la misma situación o la ha modificado (pasó a la desocupación o inactividad) en el trimestre siguiente"
      # ),
      # 
      # br(),
      # h4("Análisis longitudinal de la EPH."),
      # 
      # p("Esta forma de interpretar los datos se debe gracias al", strong("esquema de rotación "), "bajo el cual fue diseñada la muestra, conocido como '2-2-2'.
      # Este esquema implica que una vivienda es seleccionada para ser entrevistada 4 veces. En una primera instancia participa del operativo durante los primeros", strong("dos "), "trimestres de forma consecutiva, descansa los", strong("dos "), "trimestres siguientes y vuelve a participar por", strong("dos "), "trimestres más, para finalmente salir de la muestra y no volver a ser seleccionada.
      # 
      #   Al usar un esquema como el descripto, la muestra plausible de ser utilizada para el análisis de panel (longitudinal) es (teóricamente) del 50% para trimestres consecutivos (ejemplo, trimestre 1 y 2 del 2022) y para un mismo trimestre de años consecutivo (trimestre 1 del año 2022 y 2023)"
      # ),
      # 
      # 
      # p(id="footnote-1", "1 Porcentaje entre la población desocupada y la población económicamente activa.")
    )
  ),
  nav_spacer(),
  nav_menu(
    title = "+Info",
    nav_item(a("Fuente: Wikipedia", href = "https://es.wikipedia.org/wiki/Anexo:Medallero_hist%C3%B3rico_de_los_Juegos_Ol%C3%ADmpicos_de_verano")),
    #nav_item(a("Paquete {eph}", href = "https://docs.ropensci.org/eph/")),
  ),
  nav_spacer(),
)


# Define server logic required to draw a histogram
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