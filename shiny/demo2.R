#model in python
library(tidyverse)
library(reticulate)
library(magrittr)

# should be uncommented!
source_python('Python2.py')

(ilces <- ilce %>% unique() %>% as.character())
(mahalles <- mahalle%>% unique() %>% as.character())


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
                   value = 1000),
      numericInput("mevcut_alani",
                   h3("mevcut_alani"),
                   value = 1000),
      numericInput("tapunun_yili",
                   h3("tapunun_yili"),
                   value = 2010),
      numericInput("area",
                   h3("area"),
                   value = 1000),
      numericInput("duration",
                   h3("duration"),
                   value = 10),
      selectInput("ilce_kod", h3("ilce_kod"),
                  uiOutput("selected_ilce"),
                  choices = list(`regions`=ilces)),
      selectInput("mahalle_kod", h3("mahalle_kod"),
                  choices = list(`districts`=mahalles))
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
server <- function(input, output, session) {
  
  observe(updateSelectInput(session, "mahalle_kod",
                            # selected = input$ilce_kod[1],
                            choices = list(`district`=df_prev %>% group_by(ilce_kod) %>% 
                                             filter(ilce_kod==input$ilce_kod) %>% select(mahalle_kod) %>% 
                                             as.data.frame() %>% extract2('mahalle_kod') %>% 
                                             unique() %>% as.character())))
  
  # values <- reactiveValues(mah=input$mahalle_kod)
  # 
  # reactiveB <- reactive({
  #   values$A + 1
  # })
  
  
  output$PredictionOutput <- renderText({
    
    #working on ilcekods
    ilcekods <- rep(0,18)
    x=names(df)[8:(8+17)]
    sub('.*-([0-9]+).*','\\1',x)
    m <- gregexpr('[0-9]+',x)
    names(ilcekods) <- regmatches(x,m)
    
    #working on mahallekods
    mahallekods <- rep(0,240)
    x=names(df)[26:(26+239)]
    sub('.*-([0-9]+).*','\\1',x)
    m <- gregexpr('[0-9]+',x)
    names(mahallekods) <- regmatches(x,m)
    
    ilcekods[as.character(input$ilce_kod)]=1
    mahallekods[as.character(input$mahalle_kod)]=1
  
    arr <- np_array(c(input$bagimsiz_bolum_kat,
                      input$yuzolcumu,
                      input$mevcut_alani,
                      input$tapunun_yili,
                      input$area,
                      input$duration,
                      ilcekods,
                      mahallekods), order = "C")
    
    test.data <- array_reshape(arr, c(1,length(arr)))
    
    prediction <- rf$predict(test.data)
    
    prediction})
  
  
  
  output$PredictionPlot <- renderPlot({
    
    hist(log2(df[,'adil_piyasa_degeri_yasal_durum']),xlab = 'log2(adil_piyasa_degeri_yasal_durum)',
              main = 'log2(adil_piyasa_degeri_yasal_durum)')
    # mydata_hist <- hist(df[,'adil_piyasa_degeri_yasal_durum'],xlab = 'adil_piyasa_degeri_yasal_durum',
    #      main = 'adil_piyasa_degeri_yasal_durum',
    #      breaks=c(0,10^3,10^4,10^5,10^6,10^7,10^8,10^9,10^10), plot=FALSE)
    # plot(mydata_hist$count, log="y", type='h', lwd=10, lend=2)
    
    #working on ilcekods
    ilcekods <- rep(0,18)
    x=names(df)[8:(8+17)]
    sub('.*-([0-9]+).*','\\1',x)
    m <- gregexpr('[0-9]+',x)
    names(ilcekods) <- regmatches(x,m)
    
    #working on mahallekods
    mahallekods <- rep(0,240)
    x=names(df)[26:(26+239)]
    sub('.*-([0-9]+).*','\\1',x)
    m <- gregexpr('[0-9]+',x)
    names(mahallekods) <- regmatches(x,m)
    
    ilcekods[as.character(input$ilce_kod)]=1
    mahallekods[as.character(input$mahalle_kod)]=1
    
    arr <- np_array(c(input$bagimsiz_bolum_kat,
                      input$yuzolcumu,
                      input$mevcut_alani,
                      input$tapunun_yili,
                      input$area,
                      input$duration,
                      ilcekods,
                      mahallekods), order = "C")
    
    test.data <- array_reshape(arr, c(1,length(arr)))
    
    prediction <- rf$predict(test.data)
    
    abline(v = log2(prediction), col = 'red', lw=3)
    
    
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
    hist(df[,'tapunun_yili'],xlab = 'tapunun_yili', main = 'tapunun_yili')
    abline(v = input$tapunun_yili, col = 'blue', lw=2)
  })

  output$col5 <- renderPlot({
    hist(df[,'area'],xlab = 'area', main = 'area')
    abline(v = input$area, col = 'blue', lw=2)
  })
  
  output$col6 <- renderPlot({
    hist(df[,'duration'],xlab = 'duration', main = 'duration')
    abline(v = input$duration, col = 'blue', lw=2)
  })
  ## Does it correctly get the mahalle and ilce kod
  # output$Mahalle <- renderText({
  # 
  #   # mah1 <- ifelse(test = 4673%% as.numeric(input$mahalle_kod) == 0,yes = 1,no = 0 )
  #   # mah1
  #   input$mahalle_kod 
  # })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)

