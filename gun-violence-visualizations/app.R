library(shiny)
library(plotly)
library(shinythemes)
library(janitor)
library(reshape2)
library(cowplot)
library(tidyr)
library(gt)
library(tidyverse)

# I read in all rds files made in my Rmds.

mapping_victims <- readRDS("mapping.rds")

mapping_injuries <- readRDS("mapping2.rds")

mapping_deaths <- readRDS("mapping3.rds")

regression_line <- readRDS("regression.rds")

violence_by_year <- readRDS("violence_by_year.rds")

# I set the theme as united along with Yao Yu in support of gun violence prevention.

ui <- navbarPage(theme = shinytheme("united"),
                "Gun Violence Data in Boston",
                #Created an about page with background information on the project. I set the column sizes manually to allow my graphic to be seen alongside text.
                 tabPanel("About",
                          column(6,
                          h1("Background"),
                          p("Gun violence in the United States has become a rampant public health epidemic, costing the lives of thousands of Americans each year.  Since 2015, there have been over 300 mass shootings every year.  In light of these horrific statistics, policymakers are naturally looking for states that have experienced success in lowering levels of gun violence.  One of the states which some analysts have called a model for successful gun regulation is Massachusetts.  Massachusetts has some of the lowest levels of gun violence in the United States and has pursued a strict set of regulations on gun purchases, transfers, and ownership.  Yet in recent years, some analysts have noticed a worrying trend: the city of Boston has started to experience a rise in levels of gun violence.  Over just five days in July 2019, 17 shootings occurred in the Boston area that left 17 victims wounded. Mayor Martin Walsh responded, “We have the toughest gun laws in the country in Massachusetts...we’ve taken 4,000 guns off the street in the last five years. But all of what we’ve done, you still have a weekend like this. And it makes you think, God, what more can you do? But there has to be more”.  Since Massachusetts has seemingly implemented such an aggressive set of tactics to prevent gun violence, this rise in Boston gun violence raises a simple question: why are these increases occurring?  This project examines levels of gun violence in Boston over the years 2014 to 2017.  I compared Boston to other major U.S. cities to see whether Boston's gun violence trends are occurring in other places. Then, I sought out policies being implemented in cities that are experiencing success in gun violence prevention. I hope that the findings of this project could provide a model for Massachusetts policymakers seeking to stem the tide of violence in Boston."),
                          
                          p("This project is a collaborative effort with several students within David Kane's Government 1005 Data Science class. Inspired by discussions with activist David Hogg of the March for Our Lives movement, many different students have been working separately over the semester to analyze levels of gun violence in different cities across the United States. After completing our research, we will compare our findings to better understand the policies that are most successful at reducing gun violence rates."),
                         
                          p("Throughout the semester, I have been specifically analyzing levels of gun violence within Boston and the Greater Boston area. My friend ",
                            a("Yao Yu",
                              href = "https://itsyaoyu.shinyapps.io/Gun_Violence_Bay_Area/"),
                            "has been focusing on the gun violence rates in San Francisco and the Bay Area. After we finish our invidiual research, we will share our findings to gain a better understanding of which policies actually work in gun violence prevention."),
                          h1("About Me"),
                          p("My name is Erin Guetzloe and I am currently an undergraduate at Harvard studying Government and Economics."),
                          
                          p("You can find the code for this project on my ",
                            a("GitHub",
                              href = "https://github.com/eguetzloe/gun-violence-visualizations",)),
                          p("Reach me at ",
                            a("eguetzloe@college.harvard.edu",
                              href = "eguetzloe@college.harvard.edu",))),
                          column(3,
                          imageOutput("graphic_GB"))),
                # I created a panel with all of my bar graphs and my linear regression that simply explored the statistics of gun violence in Boston and Massachusetts.
                 tabPanel("Boston Gun Violence in Numbers",
                          p("Gun violence in Boston has been rising over the past four years. While the number of victims decreased slightly in 2015, the overall trend has moved steadily upwards. This increase corresponds with an increase in gun violence across Massachusetts as a whole. Boston’s violence, however, makes up a significant portion of the total amount of gun violence in Massachusetts, so examining this city specifically can help policymakers better understand the state as a whole."),
                          plotOutput("plot1"), plotOutput("plot2"), plotOutput("plot3"), plotOutput("graph")),
                 # My next panel included my graphics which compared Boston gun violence with other cities. I also set up my dropdown menu here.
                 tabPanel("Comparing Boston Gun Violence",
                          plotlyOutput("violence_per_year", height = "100%"),
                          p("Despite the fact that Boston has seen a rise in violence over the past four years, it is also important to contextualize these results by comparing them to trends in other U.S. cities. Though Boston has certainly experienced a rise in gun violence from 2014-2107, its overall levels of gun violence are still lower than Chicago, Philadelphia, and Milwaukee (a city which is close in population to Boston and is considered demographically similar). Interestingly, Oakland has experienced enough of a decrease in gun violence over the past 4 years that its level of gun violence has actually fallen below Boston’s. Perhaps what is even more telling is that both Philadelphia and Chicago, cities known for high levels of gun violence, have started to see a downward trend in the number of victims from gun violence- although Philadelphia’s decline is much less substantial than Chicago’s."),
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("city_or_county",label = strong("City"),
                                              choices = unique(violence_by_year$city_or_county),
                                              selected = "Greater Boston",
                                              multiple = TRUE
                                  )),
                              mainPanel(
                                  plotOutput("dropdown")))),
                # I created a methods tab describing my data and models.
                 tabPanel("Methods",
                          h1("Modeling"),
                          p("I included several different graphics: one examining the total number of gun violence victims in the Boston area over the four year period examined, one examining only gun injuries, one examining solely gun deaths,and a regression showing increasing levels of gun violence in Boston over the four year period. I also created a map which explores the locations of gun violence in Boston and the greater Boston area from 2014 through 2017. Finally, I made some graphics that would compare levels of gun violence in Boston and greater Boston to gun violence in other cities: namely, Chicago, Milwaukee, Oakland, and Philadelphia. I defined gun violence victims as the total number of individuals both injured and killed."),
                          h1("Gun Violence Dataset"),
                          p("The first dataset I used which included details on gun violence incidents across the United States from 2013 to 2017 was the most comprehensive and consistent dataset on U.S. gun violence that I found in my research. This dataset was from the ", a("Gun Violence Archive",
                                                                                                                                                                                                                                                                                     href = "http://www.statefirearmlaws.org/",)," which is an online archive of gun violence incidents collected from over 2,000 media, law enforcement, government and commercial sources."),
                          h1("Firearm Restrictions Dataset"),
                          p("The second dataset comes from the ", a("State Firearm Laws Project",
                              href = "http://www.statefirearmlaws.org/",),". This data compiles all the firearm restrictions implemented in U.S. states since 1991."),
                          h1("FBI Dataset"),
                          p("The final dataset I examined came from the ", a("Center for Disease Control (CDC)",
                                                                             href = "https://www.cdc.gov/nchs/pressroom/sosmap/firearm_mortality/firearm.htm",),". This dataset tracked the total number of deaths from gun violence for each state by year.")),
                # I made an analysis tab to include my final thoughts on the project and future policy prescriptions.
                tabPanel("Analysis",
                          h1("Final Thoughts"),
                          p("Before going any further, it's important to note the difficulty of working with data on gun violence. Much of the data we have is incomplete or even contradictory, and it is thus very challenging to track substantial changes in levels of gun violence. Gun violence data was not comprehensively collected until recent years. This is the reason that I chose to focus in specifically on the years 2014-2017: I was able to find the most complete and comprehensive data on gun violence incidents and firearm restrictions from these years. While there was some data in these sets from the year 2018, it only extended through March and therefore could not be included."),
                          p("One thing is clear from the data- gun violence incidents in Boston and the Greater Boston area rose over the course of the 4 years I examined. Though Boston still has much lower levels of violence in comparison to other U.S. cities such as Philadelphia and Milwaukee (which I was encouraged to compare to Boston by Dr. Deb Azrael at the Harvard Injury Control Research Center), it is concerning that Boston seems to be experiencing a continued rise in violence. One interesting finding, however, is that Boston has largely kept the same set of gun laws for the past 20 years, with its total number of laws remaining at 100 since 1999. It is difficult to isolate the main cause for these rising levels of gun violence, as information about the nature of the incidents is not always reported. Some interesting laws that are not implemented in Massachusetts, however, but have been implemented in the state of California are restrictions on firearm purchase and possession for some people with alcoholism, universal background checks required at points of transfer for handguns, firearm and handgun possession is prohibited for people with a history of a violent misdemeanor punishable by less than one year of imprisonment, and a waiting period is required on all firearm and handgun purchases from dealers. These laws could potentially serve as models of laws to implement in Massachusetts moving forwards because the Bay Area and San Francisco in California have recently experienced a significant decrease in levels of gun violence. For more information on this, check out my friend Yao Yu's project which specifically analyzes gun violence in this region."),
                          p("The approach being taken in Philadelphia, Chicago, and Oakland- cities whose victim totals are decreasing- could also provide Massachusetts with a compelling idea of future policy tactics. All of these cities have begun to consider gun violence a public health epidemic- as a “preventable disease that can be cured with the help of community members”. Viewing gun violence through this lens has proved extremely successful in cities such as Chicago, which is the home base for an NGO known as Cure Violence. This NGO focuses on a few tactics more commonly seen in disease prevention: halting transmission, containing risk, and changing norms. This idea of working as a community to find and help those individuals at most risk of being impacted by gun violence has been used to great success in Oakland, California. In Oakland, this intervention model involves conversations between “police, gang members, clergy, and other community members”, and since adopting this model Oakland has seen a 63% decrease in youth homicides."),
                          p("Ultimately, it is impossible to know whether such a model could prove as successful in Boston as in other cities. Philadelphia, which piloted similar programs, has seen less success than Oakland or Chicago. However, this could be due in part to a lack of continued funding in Philadelphia. If Boston invested substantial time, effort, and funding into a program of focused deterrence and community conversation, modeled after the success of cities like Oakland, it could possibly see a reduction in rates of future violence. Further research could explore how other demographic factors, such as population, location, average age, or level of racial and ethnic diversity impact Boston gun violence in comparison with other major U.S. cities.")),
                # I created a panel for my explanatory video, embedding the YouTube video within the tab.
                tabPanel("Video",
         HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/sUNNE0ewQig" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')))
        # I set up my server, inputting the ggplots I had created in my main Rmd.
server <- function(input, output, session) {
    output$plot1 <- renderPlot({
        ggplot(mapping_victims, aes(x = year, y = n_victims, fill = "orange")) +
            geom_col(width = 0.4) +
            theme(legend.position = "none") +
            labs(x = "Year", y = "Number of Victims", 
                 title = "Gun Violence in Boston and the Greater Boston Area")
    })
    
    output$plot2 <- renderPlot({
        ggplot(mapping_injuries, aes(x = year, y = n_injured, fill = "orange")) +
            geom_col(width = 0.4) +
            theme(legend.position = "none") +
            labs(x = "Year", y = "Number of Victims Injured", title = "Gun-related Injuries in Boston and the Greater Boston Area")
    })
    output$plot3 <- renderPlot({
        ggplot(mapping_deaths, aes(x = year, y = n_killed, fill = "orange")) +
            geom_col(width = 0.4) +
            theme(legend.position = "none")+
            labs(x = "Year", y = "Number of Victims Killed", title = "Gun-related Deaths in Boston and the Greater Boston Area")
    })
    output$graph <- renderPlot({
        ggplot(regression_line, aes(x = year, y = deaths)) +
            geom_point() +
            geom_smooth(method = "lm", color = "orange") +
            ggtitle("Massachusetts Deaths from Gun Violence, 2014-2017") +
            xlab("Year") +
            ylab("Number of Deaths")
    })
    # Here, I created my animated plotly graphic. 
    output$violence_per_year <- renderPlotly({
        
            plot_ly(
            
            data = violence_by_year,
            
            x = ~year, 
            
            y = ~total_victims,
            
            color = ~city_or_county,
            
            frame = ~frame,
            
            text = ~city_or_county, 
            
            hoverinfo = "text",
            
            type = 'scatter',
            
            mode = 'lines',
            
            width = 1000, 
            
            height = 500
            
        ) %>% 
            
            layout(
                
                title = 'Number of Gun Violence Victims Per Year in Other US Cities',
                
                xaxis = list(
                    
                    title = "Year",
                    
                    zeroline = F,
                    
                    # I set dtick to 1 to prevent half years (such as 2014.5) from being included on the graph
                    
                    dtick = 1
                    
                ),
                
                yaxis = list(
                    
                    title = "Gun Violence Victims",
                    
                    zeroline = F
                    
                ),
                br())
        
    })
    # I created my subsetted interactive graphic here, using the same data as my previous graph.
    
    subset<-reactive({violence_by_year %>% filter(city_or_county %in%input$city_or_county)})
    
    
    output$dropdown <- renderPlot({
        
        # I chose to include color = city_or_county so that each subsetted city would be a different color.
        
        ggplot(subset(), aes(x=subset()$year, y=subset()$total_victims, color = subset()$city_or_county)) +
            geom_line() +
            geom_point() +
            labs(x = "Year",
                 y = "Gun Violence Victims",
                 color = "City",
                 title = "Compare Boston's Gun Violence")
    }
    )
    # Here, I just rendered the gif of the animated graph I made in a different Rmd.
    output$graphic_GB <- renderImage({
        
        list(src = "graphic_GB_Google.gif",
             
             contentType = 'image/gif'
             
        )}, deleteFile = FALSE)
}

# My app is being committed late because I keep receiving an error upon deployment that several objects are being masked from certain packages. It also says my mapping5 object is not found. I'm not sure what's going on here. It works locally, but just won't publish.
# Finally got the app working. I had one place where I included a variable that was in my main Rmd, but not in my app. This prevented deployment.

shinyApp(ui, server)
   