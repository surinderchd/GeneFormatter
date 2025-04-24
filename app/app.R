library(shiny)
library(clipr)     # Only used if you want to add server-side clipboard (optional)
library(shinyjs)   # For copy-to-clipboard via browser

# Load your gene formatting function
source("../R/gene_formatter.R")

ui <- fluidPage(
  useShinyjs(),  # enable shinyjs
  
  titlePanel("Gene Name Formatter"),
  
  textAreaInput("gene_input", "Paste your gene list:", rows = 10),
  actionButton("go", "Format Genes"),
  br(), br(),
  
  tags$h4("Formatted Output:"),
  verbatimTextOutput("output"),
  
  br(),
  downloadButton("download_txt", "Download as .txt"),
  
  br(), br(),
  actionButton("copy_btn", "📋 Copy to Clipboard")
)

server <- function(input, output, session) {
  formatted <- reactiveVal("")
  
  observeEvent(input$go, {
    genes <- format_genes(input$gene_input)
    out_text <- paste0('"', genes, '"', collapse = ", ")
    formatted(out_text)
    output$output <- renderPrint({ cat(out_text) })
  })
  
  output$download_txt <- downloadHandler(
    filename = function() {
      paste0("formatted_genes_", Sys.Date(), ".txt")
    },
    content = function(file) {
      writeLines(formatted(), file)
    }
  )
  
  observeEvent(input$copy_btn, {
    runjs(sprintf("navigator.clipboard.writeText(%s);", jsonlite::toJSON(formatted())))
  })
}

shinyApp(ui, server)
