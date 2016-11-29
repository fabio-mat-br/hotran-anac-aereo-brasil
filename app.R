#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
print(getwd())
# ORIGINAL DATA FROM http://www2.anac.gov.br/arquivos/xls/hotran/1.5.xls
data <- read.csv("./data/1.5_editado.csv")
origem <- sort(unique(data$ARPT_origem))
destino <- sort(unique(data$ARPT_destino))
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
  
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("cmbOrigem", "ORIGEM", origem),
        selectInput("cmbDestino", "ORIGEM", destino)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        dataTableOutput('mytable')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
   observe({
     orig <- input$cmbOrigem
     dest <- sort(filter(data, ARPT_origem == orig)$ARPT_destino)
     updateSelectInput(session, "cmbDestino", choices = dest)
   })
   observeEvent(input$cmbDestino, {
     orig <- input$cmbOrigem
     dest <- input$cmbDestino
     result <- filter(data, ARPT_origem == orig & ARPT_destino == dest)
     output$mytable = renderDataTable({
       result[, c("Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Horario_partida", "Horario_chegada", "Natureza_operacao")]
     })
     #print(result[, c("Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Horario_partida", "Horario_chegada")])
   })   
}

# Run the application 
shinyApp(ui = ui, server = server)

