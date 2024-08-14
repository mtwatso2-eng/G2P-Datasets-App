addDataset <- list(
  
  "ui" = fluidPage(
    h1("Add dataset"),
    "The GPDatasets repository is designed so that users can add their own public datasets. To add a dataset, first fill in the fields below, download (and check) the generated dataset folder, then push the dataset folder to https://github.com/QuantGen/GPDatasets/tree/main/Datasets",
    br(),
    br(),
    fluidRow(column(3, textInput("addDOI", "Data DOI"))),
    fluidRow(column(3, actionButton("scrapeMetadata", "Scrape other fields from web based on DOI (check that scraped information is correct)"))),
    br(),
    br(),
    fluidRow(
      column(3, textInput("addDataLink", "Additional link to data")),
      column(3, textInput("addPublicationLink", "Link to publication")),
      column(6, textInput("addTags", "Tags (semicolon separated)", width = "100%")),
    ),
    fluidRow(
      column(3, textInput("addDatasetName", "Dataset name in GPDatasets", value = paste0(str_pad(parse_number(last(sort(metadata$Folder))), 5, pad = "0"), "_NewDataset"))),
      column(3, textInput("addTitle", "Publication title")),
      column(3, textInput("addSpeciesCommonName", "Species common name")),
      column(3, textInput("addSpeciesScientificName", "Species scientific name"))
    ),
    fluidRow(
      column(6, textAreaInput("addAbstract", "Publication abstract", height = "200px",  width = "100%")),
      column(6, textAreaInput("addLoaderCode", "Code to load data (see existing datasets for examples)", height = "200px", width = "100%")),
    ),
    fluidRow(
      column(3, numericInput("addnGenotypes", "Total number of genotypes in dataset", value = 0, min = 0, step = 1)),
      column(3, numericInput("addnMarkers", "Total number of markers in dataset", value = 0, min = 0, step = 1)),
    ),
    fluidRow(column(3, checkboxGroupInput("addCheckboxes", "", choices = list(
        "Includes pedigree data?" = "pedigree",
        "Includes phenotype data?" = "phenotype",
        "Includes genetic map?" = "map"
    )))),
    fluidRow(column(3, downloadButton("downloadDataset", "Download dataset folder")))
  ),
  
  "server" = function(input, output, session){
    
    output$downloadDataset <- downloadHandler(
      filename = function() {
        paste0(input$addDatasetName, ".zip")
      },
      content = function(file) {browser()
        tempdir <- tempdir()
        dir.create(file.path(tempdir, input$addDatasetName))
        setwd(tempdir())
        generatedMetadata <- list(
          "DOI" = input$addDOI,
          "DataLink" = input$addDataLink,
          "PublicationLink" = input$addPublicationLink,
          "Title" = input$addTitle,
          "SpeciesCommonName" = input$addSpeciesCommonName,
          "SpeciesScientificName" = input$addSpeciesScientificName,
          "Abstract" = input$addAbstract,
          "nGenotypes" = input$addnGenotypes,
          "nMarkers" = input$addnMarkers,
          "Phenotype" = "phenotype" %in% input$addCheckboxes,
          "Map" = "map" %in% input$addCheckboxes,
          "Pedigree" = "pedigree" %in% input$addCheckboxes,
          "Tags" = input$addTags
        )
        writeLines(toJSON(generatedMetadata), file.path(input$addDatasetName, "metadata.json"))
        writeLines(input$addLoaderCode, file.path(input$addDatasetName, "loader.R"))
        zip(file, file.path(input$addDatasetName))
      },
      contentType = "application/zip"
    )
    
  }
  
)