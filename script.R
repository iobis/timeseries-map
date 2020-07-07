library(dplyr)
library(leaflet)
library(digest)
library(glue)
library(robis)

df <- read.csv("occurrences.csv")

ds <- dataset() %>%
  select(id, title)

ts <- df %>%
  filter(year >= 2010) %>%
  group_by(dataset_id, lon, lat) %>%
  summarize(years = length(unique(year))) %>%
  filter(years >= 3) %>%
  left_join(ds, by = c("dataset_id" = "id"))


colors <- paste0("#", substr(as.hexmode(digest2int(ts$dataset_id)), 1, 6))

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(data = ts, lng = ~lon, lat = ~lat,
                   radius = ~years / 2,
                   weight = 1,
                   opacity = 1,
                   fillOpacity = 0.1,
                   col = colors,
                   popup = glue("<a href=\"https://obis.org/dataset/{ts$dataset_id}\">{ts$title}</a>"))
