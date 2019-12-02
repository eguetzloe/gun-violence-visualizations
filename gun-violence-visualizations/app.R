

library(shiny)
library(tidyverse)

ui <- navbarPage("Gun Violence Data in Boston",
                 tabPanel("About",
                          h1("Background"),
                          p("Boston is a liberal-leaning city in a state with relatively strict gun regulations, in comparison to many other states in the U.S.  Despite this, the Boston community continues to suffer from significant levels of gun violence.  Boston policymakers have expressed concerns about what steps they can take in the future to combat this challenging public safety threat.  Over just five days in July 2019, 17 shootings occurred in the Boston area that left 17 victims wounded.  Mayor Martin Walsh responded, 'We have the toughest gun laws in the country in Massachusetts...we’ve taken 4,000 guns off the street in the last five years.  But all of what we’ve done, you still have a weekend like this. And it makes you think, God, what more can you do? But there has to be more.'  This project aims to compare Massachusetts gun policy with firearm restrictions in other states.  My goal through these comparisons is to understand what policies or other factors Boston lacks that could contribute to this continued gun violence epidemic.  Ultimately, I hope that these visualizations will aid Boston activists, community organizers, and policymakers seeking to better understand new possibilities for action that can be taken to stem the tide of violence.")),
                          
                 tabPanel("Graphics",
                          plotOutput("plot1"), plotOutput("plot2"), plotOutput("plot3"), plotOutput("graph")),
                 tabPanel("Methods",
                          h1("Modeling"),
                          p("I included four graphics: one examining the total number of gun violence victims in the Boston area over the five year period examined, one examining only gun injuries, one examining solely gun deaths, and finally a regression showing increasing levels of gun violence in Boston over the five year period."),
                          h1("Gun Violence Dataset"),
                          p("The first dataset I used which included details on gun violence incidents across the United States from 2013 to 2017 was the most comprehensive and consistent dataset on U.S. gun violence that I found in my research. This dataset was from the Gun Violence Archive, which is an online archive of gun violence incidents collected from over 2,000 media, law enforcement, government and commercial sources."),
                          h1("Firearm Restrictions Dataset"),
                          p("The second dataset comes from the State Firearms Law Project. This data compiles all the firearm restrictions implemented in U.S. states since 1991."),
                          h1("FBI Dataset"),
                          p("The final dataset I examined came from the Center for Disease Control(CDC). This dataset tracked the total number of deaths from gun violence for each state by year.")
))

server <- function(input, output, session) {
    output$plot1 <- renderPlot(
            ggplot(mapping, aes(x = year, y = n_victims)) +
            geom_col() +
            labs(x = "Year", y = "Number of Victims", 
                 title = "Gun Violence in Boston and the Greater Boston Area", caption = "2018 data not included because it only extends from January through March of 2018.")
        )
    
    output$plot2 <- renderPlot(
        ggplot(mapping2, aes(x = year, y = n_injured)) +
            geom_col() +
            labs(x = "Year", y = "Number of Victims Injured", title = "Gun-related Injuries in Boston and the Greater Boston Area")
    )
    output$plot3 <- renderPlot(
        ggplot(mapping3, aes(x = year, y = n_killed)) +
            geom_col() +
            labs(x = "Year", y = "Number of Victims Killed", title = "Gun-related Deaths in Boston and the Greater Boston Area")
    )
    output$graph <- renderPlot(
        ggplot(regression, aes(x = year, y = deaths)) +
            geom_point() +
            geom_smooth(method = "lm") +
            ggtitle("Massachusetts Deaths from Gun Violence, 2013-2017") +
            xlab("Year") +
            ylab("Number of Deaths")
    )}

shinyApp(ui, server)
   