#' @author Jon Clutton
#' 
#' @title load_clean
#' 
#' @details Development
#' 10.11.22 Began development
#' 

##### Declare Paths #####
project_dir = "C:/Users/Jon/Documents/R_projects/WorkoutTracker"
script_dir = file.path(project_dir,"R")
data_dir = file.path(project_dir,"data")
markdown_dir = file.path(project_dir,"markdown_projects")

##### Libraries ##### 
library(googlesheets4)
library(googledrive)
library(lubridate)
library(rio)
library(tidyverse)

####### Google Sheets Data ##### 
supplements <- read_sheet("https://docs.google.com/spreadsheets/d/1kl68zGvc3V0nb0GjYeIbeo_hyw-1LaXxWaK9CqVMCQI/edit?resourcekey=undefined#gid=797768600", sheet = "Form Responses 1") %>%
  arrange(Timestamp)
workout_log <- read_sheet("https://docs.google.com/spreadsheets/d/1Ir-oveWqR_S0ypGQrsXarWi8jx5_MWT0rdP0bFehw5I/edit?resourcekey=undefined#gid=440864844", 
                          sheet = "Form Responses 1", 
                          na = c(""," "),
                          col_types = "Tcccciiiic") %>%
  arrange(Timestamp)
daily_check <- read_sheet("https://docs.google.com/spreadsheets/d/1oHgdC2f-DaNvyz1z2Iy3uHzYd2p5m1hLaRwhz_WVqAs/edit", sheet = "Form Responses 1") %>%
  arrange(Timestamp)

###### Load Codebooks #####
exercises_codebook <- import(file.path(data_dir,"codebooks","exercises.xlsx"))
week_codebook <- import(file.path(data_dir,"codebooks","weeks.xlsx"))
supplement_codebook <- import(file.path(data_dir,"codebooks","supplement_list_codebook.csv"))

#### Supplement by day list ####
daily_supplements <- supplements %>%
  select(-contains("Rate"), -contains("eat"), -Notes) %>%
  unite(all, -Timestamp, na.rm = T, sep = ", ") %>%
  mutate(date = as_date(Timestamp)) %>%
  select(-Timestamp) %>%
  group_by(date) %>%
  summarize(supplements = paste(all, collapse = ', '))

#Get list of all supplements recorded
all_supplements <- supplements %>%
  select(-contains("Rate"), -contains("16"), -Notes, -contains("eat")) %>%
  pivot_longer(., cols = -Timestamp) %>%
  filter(!is.na(value)) %>% select(-name) %>%
  separate(., col = value, sep = ", ", into = c(as.character(1:20))) %>%
  pivot_longer(., cols = -Timestamp, values_to = "supplement") %>%
  filter(!is.na(supplement)) %>% select(-name) %>%
  distinct(supplement)

## Update Supplement Codebook
new_supps <- anti_join(all_supplements, supplement_codebook, by = "supplement")

if(nrow(new_supps) > 0) {
  supplement_codebook <- supplement_codebook %>%
    bind_rows(new_supps) %>%
    mutate(Frequency = case_when(is.na(Frequency) ~ "Need To Update",
                                 T ~ Frequency))
  
  export(supplement_codebook, file.path(data_dir,"codebooks","supplement_list_codebook.csv"))
}




#### List to Save ####
save_list <- c("project_dir","script_dir","data_dir", "supplements", "workout_log", "daily_check", "exercises_codebook","week_codebook","daily_supplements", "supplement_codebook")
save(list = save_list, file = file.path(data_dir,'rdata','clean.Rdata'))



         