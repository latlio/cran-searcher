# Functions to scrape CRAN directory: https://cran.r-project.org/web/packages/available_packages_by_name.html

`%!in%` <- Negate(`%in%`)

get_all_cran_packages <- function() {
  
  cran_df <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html") %>%
    html_node("table") %>%
    html_table() %>%
    drop_na() %>%
    setNames(c("package", "description"))
  cran_df
}

get_metadata_from_package <- function(pkgname) {
  message("Scraping ", pkgname)
  
  package_metadata <- read_html(paste0("https://cran.r-project.org/web/packages/", 
                                   pkgname, 
                                   "/index.html")) %>%
    html_node("table") %>%
    html_table() %>%
    filter(X1 %in% c("Imports:",
                     "Suggests:",
                     "Published:",
                     "Maintainer:")) %>%
    mutate(X1 = str_replace(X1, ":", "")) %>%
    pivot_wider(names_from = X1,
                values_from = X2) %>%
    bind_cols(tibble(Description = read_html(
      paste0("https://cran.r-project.org/web/packages/", 
             pkgname, 
             "/index.html")) %>%
        html_element("p") %>%
        html_text2()))

  package_metadata
  # if("Imports" %in% names(package_metadata) && "Suggests" %in% names(package_metadata)) {
  #   
  #   package_metadata %>%
  #     separate_rows(Imports, sep = ",") %>%
  #     mutate(Imports = str_trim(Imports)) %>%
  #     mutate(Imports = str_replace(Imports, "\\([^\\)]+\\)", "")) %>%
  #     mutate(Imports = noquote(Imports)) %>%
  #     separate_rows(Suggests, sep = ",") %>%
  #     mutate(Suggests = str_trim(Suggests),
  #            Suggests = str_replace(Suggests, "\\([^\\)]+\\)", ""),
  #            Suggests = noquote(Suggests)) %>%
  #     mutate(Published = as.Date(Published)) %>%
  #     mutate(Maintainer = str_trim(Maintainer),
  #            Maintainer = str_replace(Maintainer, "<[^\\)]+>", ""),
  #            Maintainer = noquote(Maintainer))
  #   
  # } else if ("Imports" %in% names(package_metadata) && "Suggests" %!in% names(package_metadata)) {
  #   
  #   package_metadata %>%
  #     separate_rows(Imports, sep = ",") %>%
  #     mutate(Imports = str_trim(Imports)) %>%
  #     mutate(Imports = str_replace(Imports, "\\([^\\)]+\\)", "")) %>%
  #     mutate(Imports = noquote(Imports)) %>%
  #     mutate(Published = as.Date(Published)) %>%
  #     mutate(Maintainer = str_trim(Maintainer),
  #            Maintainer = str_replace(Maintainer, "<[^\\)]+>", ""),
  #            Maintainer = noquote(Maintainer))
  #   
  # } else if ("Imports" %!in% names(package_metadata) && "Suggests" %in% names(package_metadata)) {
  #   
  #   package_metadata %>%
  #     separate_rows(Suggests, sep = ",") %>%
  #     mutate(Suggests = str_trim(Suggests),
  #            Suggests = str_replace(Suggests, "\\([^\\)]+\\)", ""),
  #            Suggests = noquote(Suggests)) %>%
  #     mutate(Published = as.Date(Published)) %>%
  #     mutate(Maintainer = str_trim(Maintainer),
  #            Maintainer = str_replace(Maintainer, "<[^\\)]+>", ""),
  #            Maintainer = noquote(Maintainer))
  #   
  # } else {
  #   
  #   package_metadata %>%
  #     mutate(Published = as.Date(Published)) %>%
  #     mutate(Maintainer = str_trim(Maintainer),
  #            Maintainer = str_replace(Maintainer, "<[^\\)]+>", ""),
  #            Maintainer = noquote(Maintainer))
  # }
}
