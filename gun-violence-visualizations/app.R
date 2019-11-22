

library(shiny)

ui <- navbarPage("Gun Violence Data in Boston",
                 tabPanel("About",
                          h1("Background"),
                          p("yaya"),
                          
                         tabPanel("Graphics"),
                          plotlyOutput("violence_Plotly"),
                 tabPanel("Methods",
                 ))
)

server <- function(input, output, session) {
    output$OK <- renderPlot({
        plot1 <- ggplot(mapping, aes(x = year, y = n_victims)) +
            geom_col() +
            labs(x = "Year", y = "Number of Victims", title = "Gun Violence in Boston and the Greater Boston Area", caption = "2018 data not included because it only extends from January through March of 2018.")
        )}}

shinyApp(ui, server)
   