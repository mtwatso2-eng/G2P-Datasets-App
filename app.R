source("global.R")

ui <- navbarPage(id = "tabs", collapsible = TRUE, title = "Genome-to-Phenome Datasets App",
  modulePanel("Datasets", value = "datasets"),
  modulePanel("Add dataset", value = "addDataset"),
  reloadWarning,
  tags$head(tags$link(rel="shortcut icon", href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAMAAABF0y+mAAAAgVBMVEVHcEzghHj/nz//n0D/n0D/gGH/nz//nj//n0D/n0D/nj4/tNP/n0A9rdo1ouw1ouv/n0H/n0D/YoT/YoT/Y4Q1ouw2ous2ouv/Y4T/Y4Q2ouv/Y4Q2outIvcX/Y4T/YoQ1oetLwMBLwMBLwMBKwMBLwMBLv79KwcFKwMBKwMBLwMCR6nxXAAAAK3RSTlMABVzM/xKldSDlLg/yO3SVP2k5a5Vk2v/a//HxtyC6sTJNdr7o/9ib2W+zkyXgngAAAOtJREFUeAF90FOCxVAQRdFTz7FtY/4D7Khawfrdl4UfdLs/Hvcb4cDz9Vi8ntih92Pz3u/93DneP/socBTEXRT3O/fv4Rcdb73/O1WSaK4vQZaF19zoybsVVdNUBSDSDUMngEzLti2TADiuN3FVwoYsP5j4FqCE3iJ0OFpRsIhMxN4mTrZnp8EmhcdcBQvTDxjC8xj9Olb6f2x2/SD+ikNg/BVMcmcaQg5AKsqykACsQ+BvS5goVd00daVgQoQ/lLZZtEv9G6Wu2XQS/kt6jn2yjzXH+iBWHKt9xMBxwJ7UHb2HUTHW9VgQGL4AedoflmgkiVAAAAAASUVORK5CYII="))
)
  
server <- function(input, output, session) {
  
  sapply(list.files(path = "modules"), function(module){
    get(module)$server(input, output, session)
  })
  
}

shinyApp(ui = ui, server = server)