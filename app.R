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

