datasets <- list(
  
  "ui" = fluidPage(
    h1("Datasets"),
    tags$br(),
    tags$style(HTML(".dataTables_wrapper .dataTables_length {
      float: right;}
      .dataTables_wrapper .dataTables_filter {
      float: left;
      text-align: left;}"
    )),
    DTOutput("metadataTable"),
    rclipboardSetup(),
    tags$br(),
    # h2(HTML(paste(textOutput("datasetName")))),
    tags$br(),
    navset_tab(
      nav_panel(title = "Summary", 
        htmlOutput("datasetSummary"),
        # h2(HTML(paste(textOutput("datasetName"))))
      ),
      nav_panel(title = "Loader code", 
        uiOutput("copyButton"),
        verbatimTextOutput("loaderCode")
      )
    ),
    br(),
    br()
  ),
  
  "server" = function(input, output, session){
    
    output$metadataTable <- renderDT(datatable(
      assembleMetadata(metadata),
      selection = "single",
      filter = "top",
      rownames = F,
      options = list(
        pageLength = -1,
        deferRender = T,
        scrollY = 400,
        dom = 'ft',
        autoWidth = T,
        columnDefs = list(list(width = '10%', targets = 1:3))
      ),
      callback = JS(
        "$(document).ready(function() {",
        "  $('#example').DataTable();",
        "  $.fn.dataTable.ext.search.push(",
        "    function(settings, searchData, index, rowData, counter) {",
        "      var match = false;",
        "      var searchTerm = settings.oPreviousSearch.sSearch.toLowerCase();",
        "      searchData.forEach(function(item, index) {",
        "        if (item.toLowerCase().startsWith(searchTerm)) {",
        "          match = true;",
        "        }",
        "      });",
        "      return match;",
        "    }",
        "  );",
        "});"
      ),
      escape = F
    ))
    
    observeEvent(input$metadataTable_rows_selected, {

      output$datasetSummary <- renderUI(assembleDatasetSummary(input))
        
      # output$datasetName <- renderText(metadata[input$metadataTable_rows_selected,]$Folder)
      
      loaderCode <- assembleLoaderCode(input$metadataTable_rows_selected)
      
      output$copyButton <- renderUI({
        rclipButton(
          inputId = "copy", 
          label = "",
          clipText = loaderCode,
          icon = icon("clipboard")
        )
      })
      
      output$loaderCode <- renderText(loaderCode)
          
    })
    
  }
  
)