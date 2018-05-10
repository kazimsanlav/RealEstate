#model in python
library(reticulate)

# source_python('Python.py')

#shiny app
library(shiny)
# Define UI ----
ui <- fluidPage(
  
  headerPanel("Real Estate Price Prediction"),
  sidebarLayout(
    sidebarPanel(
      # selectInput("column", h3("Select a column to create hist"),
      #             choices = names(df)),
      numericInput(inputId = "bagimsiz_bolum_kat", 
                   h3("bagimsiz_bolum_kat"), 
                   value = 1),
      numericInput("yuzolcumu",
                   h3("yuzolcumu"),
                   value = 1),
      numericInput("mevcut_alani",
                   h3("mevcut_alani"),
                   value = 1),
      numericInput("tapunun_yasi",
                   h3("tapunun_yasi"),
                   value = 1),
      numericInput("area",
                   h3("area"),
                   value = 1),
      numericInput("duration",
                   h3("duration"),
                   value = 1),
      selectInput("mahalle_kod", h3("mahalle_kod"),
                  choices = list("4673" = 4673, "4676" = 4676))
      

    ),
    mainPanel(
      h3(paste("Predicting Price...")),
      h1(textOutput("PredictionOutput")),
      # h2(textOutput("Mahalle")),
      plotOutput("PredictionPlot"),
      
      fluidRow (
        column(4,
               plotOutput("col1",width = "100%", height = "300px")),
        column(4,
               plotOutput("col2",width = "100%", height = "300px")),
        column(4,
               plotOutput("col3",width = "100%", height = "300px"))
      ),
      fluidRow (
        column(4,
               plotOutput("col4",width = "100%", height = "300px")),
        column(4,
               plotOutput("col5",width = "100%", height = "300px")),
        column(4,
               plotOutput("col6",width = "100%", height = "300px"))
      )
      
   
    )
  )
)
  

# Define server logic ----
server <- function(input, output) {
  
  # values <- reactiveValues(mah=input$mahalle_kod)
  # 
  # reactiveB <- reactive({
  #   values$A + 1
  # })
  

  output$PredictionOutput <- renderText({
    
    mah1 <- ifelse(test = 4673%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
    mah2 <- ifelse(test = 4676%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
    
    arr <- np_array(c(input$bagimsiz_bolum_kat,
                      input$yuzolcumu,
                      input$mevcut_alani,
                      input$tapunun_yasi,
                      input$area,
                      input$duration,
                      mah1,
                      mah2), order = "C")
    
    test.data <- array_reshape(arr, c(1,8))
    
    prediction <- rf$predict(test.data)
    
    prediction})
  
  output$PredictionPlot <- renderPlot({
    
    hist(df[,'adil_piyasa_degeri_yasal_durum'],xlab = 'adil_piyasa_degeri_yasal_durum',main = 'adil_piyasa_degeri_yasal_durum')
    
    #mahalle kodu
    mah1 <- ifelse(test = 4673%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
    mah2 <- ifelse(test = 4676%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
 
    arr <- np_array(c(input$bagimsiz_bolum_kat,
                      input$yuzolcumu,
                      input$mevcut_alani,
                      input$tapunun_yasi,
                      input$area,
                      input$duration,
                      mah1,
                      mah2), order = "C")

    test.data <- array_reshape(arr, c(1,8))

    prediction <- rf$predict(test.data)

    abline(v = prediction, col = 'red', lw=3)
  
    
  })
  
  output$col1 <- renderPlot({
    hist(df[,'bagimsiz_bolum_kat'],xlab = 'bagimsiz_bolum_kat',main = 'bagimsiz_bolum_kat')
    abline(v = input$bagimsiz_bolum_kat, col = 'blue', lw=2)
  })
  
  output$col2 <- renderPlot({
    hist(df[,'yuzolcumu'],xlab = 'yuzolcumu', main = 'yuzolcumu')
    abline(v = input$yuzolcumu, col = 'blue', lw=2)
  })
  
  output$col3 <- renderPlot({
    hist(df[,'mevcut_alani'],xlab = 'mevcut_alani', main = 'mevcut_alani')
    abline(v = input$mevcut_alani, col = 'blue', lw=2)
  })
  
  output$col4 <- renderPlot({
    hist(df[,'tapunun_yasi'],xlab = 'tapunun_yasi', main = 'tapunun_yasi')
    abline(v = input$tapunun_yasi, col = 'blue', lw=2)
  })
  
  output$col5 <- renderPlot({
    hist(df[,'area'],xlab = 'area', main = 'area')
    abline(v = input$area, col = 'blue', lw=2)
  })
  
  output$col6 <- renderPlot({
    hist(df[,'duration'],xlab = 'duration', main = 'duration')
    abline(v = input$duration, col = 'blue', lw=2)
  })
  
  # output$Mahalle <- renderText({
  #   
  #   mah1 <- ifelse(test = 4673%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
  #   mah1
  #   # input$mahalle_kod
  # })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)

