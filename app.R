library(shiny)
library(lab5package)
library(ggplot2)

plot_data <- na.omit(kolada('Stockholm')$getallcitydata())

ui <- fluidPage(
  titlePanel("Time Series Plot"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("lines", "Select Cities to Plot:",
                         choices = names(plot_data[-1]),
                         selected = names(plot_data[-1])),
      sliderInput("period_range", "Select Period Range:",
                  min = min(plot_data$period), max = max(plot_data$period),
                  value = c(min(plot_data$period), max(plot_data$period)),
                  step = 1)
    ),
    mainPanel(
      p("The values are percentage of temporary parental benefit (in terms of net days) taken out by men."),
      strong("Source:"),
      em("Försäkringskassan."),
      br(),
      plotOutput("linePlot")
    )
  )
)


server <- function(input, output) {
  output$linePlot <- renderPlot({
    selected_lines <- input$lines
    period_min <- input$period_range[1]
    period_max <- input$period_range[2]
    
    gg <- ggplot(data = subset(plot_data, period >= period_min & period <= period_max), aes(x = period))
    i <- 1
    for (line in selected_lines) {
      gg <- gg + geom_line(aes_string(y = line, color = factor(names(plot_data[-1])[i])), linewidth = 1.5)
      i <- i + 1
    }
    gg + labs(x = "Year", y = "Value (%)", color = NULL) +
      scale_color_manual(values = c('#1F78B4', '#2D452C', '#FF7F00', '#6A3D9A', '#E41A1C')
                         , labels = selected_lines) +
      scale_x_continuous(breaks = seq(min(plot_data$period), max(plot_data$period), by = 2),
                         labels = seq(min(plot_data$period), max(plot_data$period), by = 2)) +
      theme(legend.position = "bottom", 
            legend.text = element_text(size = 14),
            axis.title.x = element_text(size = 16),
            axis.title.y = element_text(size = 16),
            axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14))  
  })
}

shinyApp(ui = ui, server = server)



