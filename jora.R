message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url <- "https://id.jora.com/j?sp=homepage&trigger_source=homepage&q=&l="
page <- read_html(url)


posisi <- page %>% html_nodes(xpath = '//h2[@class= "job-title heading-large -no-margin-bottom -one-line"]') %>% html_text()

perusahaan <- page %>% html_nodes(xpath = '//span[@class="job-company"]') %>% html_text()

lokasi <- page %>% html_nodes(xpath = '//div[@class="info-container -last-row"]') %>% html_text()

deskripsi <- page %>% html_nodes(xpath = '//div[@class="job-abstract"]') %>% html_text()

waktu.posting <-page %>% html_nodes(xpath = '//span[@class="job-listed-date"]') %>% html_text()


data <- data.frame(
  time_scraped = Sys.time(),
  posisi = head(posisi, 5),
  perusahaan = head(perusahaan, 5),
  lokasi = head(lokasi, 5),
  deskripsi = head(deskripsi, 5),
  waktu.posting = head(waktu.posting, 5),
  stringsAsFactors = FALSE
)

# MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data)
rm(atlas_conn)