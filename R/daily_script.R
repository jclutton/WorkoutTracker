#' 
#' @title daily_script
#' 
#' @details Development
#' 10.29.22 Began development
#' 
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


#### Load Data #####
source(file.path(script_dir,'load+clean_data.R'))


#### Create Markdown ####
rmarkdown::render(file.path(markdown_dir,"workout_generator","workout_generator.Rmd"), output_file = file.path(markdown_dir,"workout_generator","email.html"))
#file.copy(from = file.path(data_dir,"coordinator_email","coordinator_markdown.html"), to = file.path(report_dir,"coordinator_markdown.html"), overwrite = TRUE)


##### Mail presets

TO = "jon.clutton@utexas.edu"
body = "Daily_Workout_Plan"

##### Send to python to send email
mailcmd <- paste("py", file.path(markdown_dir,"workout_generator","send_email.py"), TO, body, file.path(markdown_dir,"workout_generator","email.html"))

#System command
system(mailcmd)



# email <- render_email(file.path(markdown_dir,"workout_generator","workout_generator.Rmd")) %>%
#   add_attachment(file = file.path(markdown_dir,"workout_generator","workout_generator.html"), filename = "Daily Workout.html") %>%
#   smtp_send(
#     from = "jon.e.clutton@gmail.com",
#     to = "jon.clutton@utexas.edu",
#     subject = "Daily Workout",
#     credentials = creds_file(file = "gmail_creds")
#   )

