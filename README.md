# Notion_to_PDF_Book

Convert Notion database export (html) to PDF books in R.

Advantage:
- Easily organize tasks by metadata (project, project, status ...)
- Adaptable parameters for PDF rendering by `pagedown`

## Usage

- Step 1: Export in Notion.

Export database to `html`, with subpages in distinct folder

![image](https://github.com/user-attachments/assets/fcfc9559-da2b-4063-beaa-9f6881bc5df3)

- Step 2: Organize Tasks by metadata.
- Step 3: Render PDF.
- Step 4: Concatenate Task PDFs to books.

## Dependency
``` text
> sessionInfo()
R version 4.1.0 (2021-05-18)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 26100)

Matrix products: default

locale:
[1] LC_COLLATE=Chinese (Simplified)_China.936  LC_CTYPE=Chinese (Simplified)_China.936    LC_MONETARY=Chinese (Simplified)_China.936
[4] LC_NUMERIC=C                               LC_TIME=Chinese (Simplified)_China.936

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base

other attached packages:
[1] lubridate_1.9.2 dplyr_1.1.2     stringi_1.7.12  pagedown_0.22  

loaded via a namespace (and not attached):
 [1] fansi_1.0.4      utf8_1.2.3       R6_2.5.1         lifecycle_1.0.3  jsonlite_1.8.4   magrittr_2.0.3   pillar_1.9.0     rlang_1.1.0      cli_3.6.1       
[10] vctrs_0.6.1      generics_0.1.3   tools_4.1.0      glue_1.6.2       compiler_4.1.0   timechange_0.2.0 pkgconfig_2.0.3  tidyselect_1.2.0 tibble_3.2.1
```
