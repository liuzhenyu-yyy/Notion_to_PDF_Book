library(pagedown)
library(stringi)
library(dplyr)
library(lubridate)

setwd("E:/LabWork/Record")

# 1. organize tasks ----
# load task table
task.info <- data.table::fread("./notion_export/Tasks 936ec570ec844a598aee4d40ee3515a0.csv",
    stringsAsFactors = FALSE, encoding = "UTF-8",
) %>% as.data.frame()

task.info$Date <- mdy_hm(task.info$`Date Created`)
task.info$Project <- gsub(" \\(.+?$", "", task.info$Project)
table(task.info$Project)
task.info <- task.info[order(task.info$Project, task.info$Date), ]
View(task.info)

# html records
file_html <- dir("./notion_export/Tasks 936ec570ec844a598aee4d40ee3515a0",
    pattern = ".html$", full.names = TRUE) # 186 task
file_name <- file_html %>%
    stri_reverse() %>%
    gsub("lmth..+? ", "", .) %>%
    stri_reverse() %>%
    gsub("./notion_export/Tasks 936ec570ec844a598aee4d40ee3515a0/", "", .)

# rename task names
table(file_name %in% task.info$`Task name`)
task.info$Task <- task.info$`Task name`

setdiff(file_name, task.info$Task)
setdiff(task.info$Task, file_name) %>% sort()

task.info$Task <- gsub("\\.", " ", task.info$Task)
task.info$Task <- gsub("\\/", " ", task.info$Task)
task.info$Task <- gsub("\\:", "", task.info$Task)
task.info$Task <- gsub("  ", " ", task.info$Task)
task.info$Task <- gsub(" $", "", task.info$Task)
task.info$Task <- substring(task.info$Task, 0, 50)
table(file_name %in% task.info$Task)
names(file_html) <- file_name

task.info$Html <- file_html[task.info$Task]

# 2. generate pdf by project----

## 2.1. task pdf ----
dir.create("pdf_task", showWarnings = FALSE)

task.info$PDF <- paste0(
    "./pdf_task/Task_",
    stringr::str_pad(seq_along(task.info$Task), 3, pad = "0"),  ".pdf"
)
rm(file_html, file_name)

for (i in seq_along(task.info$Task)) {
    message(Sys.time(), " Processing ", i, " of ", length(task.info$Task), ": ", task.info$Task[i])
    chrome_print(task.info$Html[i],
        output = task.info$PDF[i],
        format = "pdf", outline = FALSE,
        options = list(
            paperWidth = 8.27,
            paperHeight = 11.69,
            marginTop = 0.2,
            marginBottom = 0.2,
            marginLeft = 0.1,
            marginRight = 0.1,
            preferCSSPageSize = TRUE,
            scale = 0.75
        )
    )
}

## 2.2. project pdf ----
file_html <- dir("./notion_export/Projects c05922abb2e4494781bf40973f14b55e",
    pattern = ".html$", full.names = TRUE
) # 11 projects
file_name <- file_html %>%
    stri_reverse() %>%
    gsub("lmth..+? ", "", .) %>%
    stri_reverse() %>%
    gsub("./notion_export/Projects c05922abb2e4494781bf40973f14b55e/", "", .)
table(file_name %in% task.info$Project)
setdiff(file_name, task.info$Project)
names(file_html) <- file_name

project.info <- data.frame(
    Project = file_name,
    Html = file_html,
    stringsAsFactors = FALSE
)
rm(file_html, file_name)

dir.create("pdf_project_cover", showWarnings = FALSE)
project.info$Cover <- paste0(
    "./pdf_project_cover/", "Proj_",
    stringr::str_pad(seq_along(project.info$Project), 2, pad = "0"),
    ".cover", ".pdf"
)

for (i in seq_along(project.info$Project)) {
    message(Sys.time(), " Processing ", i, " of ", length(project.info$Project), ": ", project.info$Project[i])
    chrome_print(project.info$Html[i],
        output = project.info$Cover[i],
        format = "pdf", outline = FALSE,
        options = list(
            paperWidth = 8.27,
            paperHeight = 11.69,
            marginTop = 0.2,
            marginBottom = 0.2,
            marginLeft = 0.1,
            marginRight = 0.1,
            preferCSSPageSize = TRUE,
            scale = 0.75
        )
    )
}
rm(i)

# 3. generate project pdf ----
dir.create("pdf_project", showWarnings = FALSE)

project.info$PDF <- paste0(
    "./pdf_project/", "Proj_",
    stringr::str_pad(seq_along(project.info$Project), 2, pad = "0"), " ",
    project.info$Project, ".pdf"
)

for (i in seq_along(project.info$Project)) {
    message(Sys.time(), " Processing ", i, " of ", length(project.info$Project), ": ", project.info$Project[i])
    qpdf::pdf_combine(
        input = c(
            project.info$Cover[i],
            task.info$PDF[task.info$Project == project.info$Project[i]]
        ),
        output = project.info$PDF[i]
    )
}

# manually add header


# merge all project pdfs
qpdf::pdf_combine(
    input = dir("./pdf_project", pattern = ".pdf$", full.names = TRUE),
    output = "./Record.merge.pdf"
)
