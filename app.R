library(shiny)
library(pngnewsR)
library(DT)
library(shinycssloaders)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Package Demonstration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("category", "News Category",
                  c("National" = "national",
                    "World" = "world",
                    "Sport" = "sport",
                    "Business" = "business",
                    "Feature" = "feature",
                    "Top Stories" = "topstories")),
      numericInput("page", "Pages to Scrape",
                   value = 1,
                   min = 1
      ),
      
      downloadButton("download", "Export as CSV")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      withSpinner(DT::dataTableOutput("table"), type = 6)
    )
  ),
  
  # Add the image outside the sidebar layout and position it at the bottom left
  tags$img(src = "pngnewsR.png", height = 250, width = 250,
           style = "position:absolute; bottom:20px; left:20px;")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dt <- reactive({
    df <- scrape_news(input$page, input$category)
  })
  
  output$table <- DT::renderDataTable({
    df <- dt()
  })
  
  # Download handler for exporting the table as CSV
  output$download <- downloadHandler(
    filename = function() {
      paste("scraped_articles_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(dt(), file)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

