

source("R/00-librerias.R")
source(here::here("R/01-importar.R"))
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
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "estilo.css")
  ),
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
  nav_panel("Sobre las Olimpíadas",
            page_fillable(
            layout_column_wrap(
              width = "250px",
              fill = FALSE,
              value_box(
                title = "Medallas en disputa",
                value = textOutput("out_medallas_tot"),
                #showcase = "🥇🥈🥉"), 
                showcase = a(tags$img(src="https://upload.wikimedia.org/wikipedia/commons/1/15/Gold_medal.svg", width = 20),
                             tags$img(src="https://upload.wikimedia.org/wikipedia/commons/0/03/Silver_medal.svg", width = 20),
                             tags$img(src="https://upload.wikimedia.org/wikipedia/commons/5/52/Bronze_medal.svg", width = 20))),
              value_box(
                title = "Cantidad de países disputando",
                value = textOutput(outputId = "out_paises_tot"),
                #showcase = "🌎"),
                showcase = a(tags$img(src = "https://camo.githubusercontent.com/638926866cd7654aa8600a398113bb4182c499c5d06cd79cc0614a6627794fe4/68747470733a2f2f63646e2e7261776769742e636f6d2f666c656b73636861732f73696d706c652d776f726c642d6d61702f61333664656365352f776f726c642d6d61702e737667", width = 100))),
              value_box(
                title = "Cantidad de disciplinas",
                value = textOutput(outputId = "out_discuplina_tot"),
                #showcase = "🚴🏾 🏋🏼 🤸🏿 🏃🏿‍♀️ 🏹")
                showcase = a(tags$img(src='https://upload.wikimedia.org/wikipedia/commons/8/8f/Athletics_pictogram.svg', width = 30),
                             tags$img(src='https://upload.wikimedia.org/wikipedia/commons/3/31/Modern_pentathlon_pictogram.svg', width = 30))
              )
            )
            )
            ),
  nav_panel(height="1000px",
            title = "Medallero", 
            icon = icon("medal"),
            page_fillable(
              card(
                min_height =  "1000px",
                card_body(
                  tabsetPanel(
                    nav_panel(title = "Empty Tab",
                              highchartOutput("sankey")),
                    nav_panel(title = "Empty Tab")
                  )
                )
              ),
              div(tags$a(href='https://linktr.ee/estacion_r',
                     tags$img(src='https://ugc.production.linktr.ee/9ed888ed-c016-468e-95da-2c449b2c2fc5_Logo-PNG-Baja-Mesa-de-trabajo-1-copia-3.png?io=true&size=avatar-v3_0',
                              width = 300)), align = "center")
            )
  ),
  nav_panel(title = "TEST",
            navset_card_tab(
              height = 1500,
              full_screen = TRUE,
              title = "HTML Widgets",
              nav_panel(
                "Plotly",
                #card_title("A plotly plot"),
                highchartOutput("sankey", height = 1000)
              ),
              nav_panel(
                "Leaflet",
                card_title("A leaflet plot"),
                "leaflet_widget"
              ),
              nav_panel(
                shiny::icon("circle-info"),
                markdown("Learn more about [htmlwidgets](http://www.htmlwidgets.org/)")
              )
            )
            ),
  nav_spacer(),
  nav_menu(
    title = "+Info",
    align = "right",
    nav_item(a("Fuente: Wikipedia", 
             href = "https://es.wikipedia.org/wiki/Juegos_Olímpicos_de_París_2024")),
    nav_item(tags$a(href='https://linktr.ee/estacion_r',
                    tags$img(src='https://ugc.production.linktr.ee/9ed888ed-c016-468e-95da-2c449b2c2fc5_Logo-PNG-Baja-Mesa-de-trabajo-1-copia-3.png?io=true&size=avatar-v3_0',
                             width = 50)))
    #nav_item(a("Paquete {eph}", href = "https://docs.ropensci.org/eph/")),
  )
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

# Run the application 
shinyApp(ui = ui, server = server)