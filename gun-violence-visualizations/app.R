library(shiny)
library(tidyverse)
library(plotly)
library(shinythemes)
library(janitor)
library(reshape2)
library(cowplot)
library(tidyr)
library(gt)

mapping_victims <- readRDS("mapping.rds")

mapping_injuries <- readRDS("mapping2.rds")

mapping_deaths <- readRDS("mapping3.rds")

regression_line <- readRDS("regression.rds")

violence_by_year <- readRDS("violence_by_year.rds")

ui <- navbarPage(theme = shinytheme("united"),
                "Gun Violence Data in Boston",
                 tabPanel("About",
                          h1("Background"),
                          p("Boston is a liberal-leaning city in a state with relatively strict gun regulations, in comparison to many other states in the U.S.  Massachusetts also has lower levels of gun violence than most other states in the U.S.  Despite this, the Boston community continues to suffer from significant levels of gun violence, and these levels of violence appear to be increasing.  Boston policymakers have expressed concerns about what steps they can take in the future to combat this challenging public safety threat.  Over just five days in July 2019, 17 shootings occurred in the Boston area that left 17 victims wounded.  Mayor Martin Walsh responded, 'We have the toughest gun laws in the country in Massachusetts...we’ve taken 4,000 guns off the street in the last five years.  But all of what we’ve done, you still have a weekend like this. And it makes you think, God, what more can you do? But there has to be more.'  This project aims to compare Massachusetts gun policy with firearm restrictions in other states.  My goal through these comparisons is to understand what policies or other factors Boston lacks that could contribute to this continued gun violence epidemic.  Ultimately, I hope that these visualizations will aid Boston activists, community organizers, and policymakers seeking to better understand new possibilities for action that can be taken to stem the tide of violence."),
                          
                          p("This project is a collaborative effort with several students within David Kane's Government 1005 Data Science class. Inspired by discussions with activist David Hogg of the March for Our Lives movement, many different students have been working separately over the course of the semester to map and analyze levels of gun violence in different cities across the United States. After completing our research, we will compare our findings to better understand the policies and places that are more successful at reducing gun violence rates."),
                         
                          p("Throughout the semester, I have been specifically analyzing levels of gun violence within Boston and the Greater Boston area. My friend, Yao Yu, has been focusing on the gun violence rates in San Francisco and the Bay Area. After we finish our invidiual research, we will meet to share our findings and try to gain a better understanding of which policies actually work in gun violence prevention."),
                          h1("About Me"),
                          p("My name is Erin Guetzloe and I’m currently an undergraduate at Harvard studying Government and Economics."),
                          
                          p("Reach me at ",
                            a("eguetzloe@college.harvard.edu",
                              href = "eguetzloe@college.harvard.edu",))),
                 tabPanel("Boston Gun Violence in Numbers",
                          plotOutput("plot1"), plotOutput("plot2"), plotOutput("plot3"), plotOutput("graph")),
                 tabPanel("Comparing Boston Gun Violence",          
                          plotlyOutput("violence_per_year")),
                 tabPanel("Mapping Boston Gun Violence",
                          imageOutput("graphic_GB")),
                 tabPanel("Methods",
                          h1("Modeling"),
                          p("I included four graphics: one examining the total number of gun violence victims in the Boston area over the five year period examined, one examining only gun injuries, one examining solely gun deaths, and finally a regression showing increasing levels of gun violence in Boston over the five year period."),
                          h1("Gun Violence Dataset"),
                          p("The first dataset I used which included details on gun violence incidents across the United States from 2013 to 2017 was the most comprehensive and consistent dataset on U.S. gun violence that I found in my research. This dataset was from the Gun Violence Archive, which is an online archive of gun violence incidents collected from over 2,000 media, law enforcement, government and commercial sources."),
                          h1("Firearm Restrictions Dataset"),
                          p("The second dataset comes from the State Firearms Law Project. This data compiles all the firearm restrictions implemented in U.S. states since 1991."),
                          h1("FBI Dataset"),
                          p("The final dataset I examined came from the Center for Disease Control (CDC). This dataset tracked the total number of deaths from gun violence for each state by year.")),
                tabPanel("Analysis",
                          h1("Final Thoughts"),
                          p("Before going any further, it's important to note the difficulty of working with data on gun violence. Much of the data we have is incomplete or even contradictory, and thus it is very challenging to track substantial changes in levels of gun violence since data has not been truly comprehensively collected until recent years. This is the reason that I chose to focus in specifically on the years 2014-2017: I was able to find the most complete and comprehensive data on gun violence incidents and firearm restrictions from these years. While there was some data in these sets from the year 2018, it only extended through March and therefore could not be included."),
                          
                          p("One thing is clear from the data- gun violence incidents in Boston and the Greater Boston area rose over the course of the 4 years I examined. Though Boston still has much lower levels of violence in comparison to demographically similar cities such as Philadelphia and Milwaukee (which I was encouraged to compare to Boston by Dr. Deb Azrael at the Harvard Injury Control Research Center), it is concerning that Boston seems to be experiencing a continued rise in violence. One interesting finding, however, is that Boston has largely kept the same set of gun laws for the past 20 years, with its total number of laws remaining at 100 since 1999. It is difficult to isolate the main cause for these rising levels of gun violence, as information about the nature of the incidents is not always reported. Some interesting laws that are not implemented in Massachusetts, however, but have been implemented in the state of California are restrictions on firearm purchase and possession for some people with alcoholism, universal background checks required at points of transfer for handguns, firearm and handgun possession is prohibited for people with a history of a violent misdemeanor punishable by less than one year of imprisonment, and a waiting period is required on all firearm and handgun purchases from dealers. These laws could potentially be models for laws to implement in Massachusetts moving forwards because the Bay Area and San Francisco in California have recently experienced a significant decrease in levels of gun violence(for more information on this, check out my friend Yao Yu's project which specifically analyzes gun violence in this region).")))
server <- function(input, output, session) {
    output$plot1 <- renderPlot(
            ggplot(mapping_victims, aes(x = year, y = n_victims, fill = "orange")) +
            geom_col(width = 0.4) +
                theme(legend.position = "none") +
            labs(x = "Year", y = "Number of Victims", 
                 title = "Gun Violence in Boston and the Greater Boston Area", caption = "2018 data not included because it only extends from January through March of 2018.")
        )
    
    output$plot2 <- renderPlot(
        ggplot(mapping_injuries, aes(x = year, y = n_injured, fill = "orange")) +
            geom_col(width = 0.4) +
            theme(legend.position = "none") +
            labs(x = "Year", y = "Number of Victims Injured", title = "Gun-related Injuries in Boston and the Greater Boston Area")
    )
    output$plot3 <- renderPlot(
        ggplot(mapping_deaths, aes(x = year, y = n_killed, fill = "orange")) +
            geom_col(width = 0.4) +
            theme(legend.position = "none")+
            labs(x = "Year", y = "Number of Victims Killed", title = "Gun-related Deaths in Boston and the Greater Boston Area")
    )
    output$graph <- renderPlot(
        ggplot(regression_line, aes(x = year, y = deaths)) +
            geom_point() +
            geom_smooth(method = "lm", color = "orange") +
            ggtitle("Massachusetts Deaths from Gun Violence, 2014-2017") +
            xlab("Year") +
            ylab("Number of Deaths")
    )
    output$violence_per_year <- renderPlotly({
        
            plot_ly(
            
            data = violence_by_year,
            
            x = ~year, 
            
            y = ~n,
            
            color = ~city_or_county,
            
            text = ~city_or_county, 
            
            hoverinfo = "text",
            
            type = 'scatter',
            
            mode = 'lines',
            
            width = 1000, 
            
            height = 500
            
        ) %>% 
            
            layout(
                
                title = 'Number of Gun Violence Incidents Per Year in Similar Cities',
                
                xaxis = list(
                    
                    title = "Year",
                    
                    zeroline = F
                    
                ),
                
                yaxis = list(
                    
                    title = "Gun Violence Incidents",
                    
                    zeroline = F
                    
                ),
                br())
        
        
        
    })
    output$graphic_GB <- renderImage({
        
        list(src = "graphic_GB_Google.gif",
             
             contentType = 'image/gif'
             
        )}, deleteFile = FALSE)
    }

shinyApp(ui, server)
   