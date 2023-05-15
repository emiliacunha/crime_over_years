# ------------------- LIBRARIES ----------


#the following packages need to be installed 

# install.packages("here")
# install.packages("tidyverse")
# install.packages("readxl")
# install.packages("ggplot2")
# install.packages("RColorBrewer")
# install.packages("plotly")
# install.packages("htmlwidgets")

#run the following packages

library(here)
library(tidyverse)
library(readxl)
library(ggplot2)
library(RColorBrewer)
library(plotly)
library(htmlwidgets)




# ------------------- DATA SOURCE ----------


#download file from original ONS source and save it in the data folder

download.file(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/crimeandjustice/datasets/crimeinenglandandwalesappendixtables/yearendingseptember2022/appendixtablesyesept22.xlsx", destfile = "data/ons_source_crime_data.xlsx", mode="wb")


#see all the sheets the excel file contains 

excel_sheets("data/ons_source_crime_data.xlsx")


# ------------------- LOAD DATA ----------


# load only the excel sheet that contains the required data

df <- read_excel("data/ons_source_crime_data.xlsx",
                   sheet = "Table A1",
                   range = cell_rows(9:65), # omit top rows that contain notes but no data 
                   na = c("[x]") # specify values that should be treated as missing
)

                

# ------------------- DATA WRANGLE ----------


# select only the columns that include figures from April to March

df2 <- df %>% 
  select("A1a: Trends in CSEW incidents of crime, adults aged 16 and over/households (1,000s)",...10:...28)



# ensure the column names reflect the data in each column 

colnames(df2) <- df2[1, ] 


# keep only the main offence groups and omit the subgroups

df2 <- df2 %>%
  slice(2,7,8,38,47,52)


# transpose the data

df2 <- t(df2)


# again: ensure the column names reflect the data in each column 

colnames(df2) <- df2[1, ]


# remove first row that is no longer needed 

df2 <- df2[- 1, ]

# ensure column names are not written in all capitals 

df2 <- as.data.frame(df2) %>% 
  setNames(c("Violence", "Robbery", "Theft Offences", "Criminal Damage", "Fraud", "Computer Misuse"))



# create a new column called "year"
  #that is an extraction of the 5th to 9th characters in the rows


df2 <- df2 %>% 
  mutate(year = str_sub(rownames(df2), start = 5, end =9)) %>% 
  rownames_to_column(var = "row") %>% # name the row names column "row"
  select(-row) # delete this now unnecessary column



# ------------------- SPECIFIC ADJUSTMENTS FOR THE GRAPH ----------


# convert data from wide format to long format

df3 <- df2 %>% 
  gather(key = colnames, value = "recorded_cases", -year) %>%
  rename(crime_group = colnames) # change "colnames" to "crime_group

# convert NA values into 0 so that NA value appear at the bottom of the graph

df3[is.na(df3)] <- 0


# check if y (recorded_cases) is a numeric value

if(is.numeric(df3$recorded_cases)) {
  print("TRUE")
} else {
  print("FALSE")
}


# convert "recorded_cases" to numeric variable 

df3$recorded_cases <- as.numeric(as.character(df3$recorded_cases))
  

# again: check if y (recorded_cases) is a numeric value

if(is.numeric(df3$recorded_cases)) {
  print("TRUE")
} else {
  print("FALSE")
}

# show the the first few rows of processed data

head(df3)

# ------------------- PLOT THE GRAPH ----------

#  to choose a pallet that is colour blind friendly: display.brewer.all(colorblindFriendly = TRUE)

# first attempt

b <- ggplot(df3, aes(x = year, y = recorded_cases, fill = crime_group)) +
  geom_bar(stat = "identity") +
  labs(title = "Progression of Crime in England and Wales", #plot a title
       subtitle = "Recorded from April to March, 2001 to 2019", #plot a subtitle
       x ="Years", y = "Recorded Cases", # plot the axes' titles
       fill = "Crime Group", # plot the colour legend title
       caption = "SOURCE: Office for National Statistics") +
  theme_bw() + #classic black and white look +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  scale_fill_manual(values = c("pink", "orange", "brown", "chocolate", "beige","gray")) +
  scale_y_continuous(labels = scales::comma_format()) #format the y axis



# the chosen graph

p <- df3 %>% 
  ggplot(mapping=aes(x=year, y=recorded_cases, group= crime_group, colour = crime_group)) +
  geom_line() + #plot a line
  geom_point(size = 3, alpha = 0.3) + #plot the points
  labs(title = "Progression of Crime in England and Wales", #plot a title
       subtitle = "Recorded from April to March, 2001 to 2019", #plot a subtitle
       x ="Years", y = "Recorded Cases", # plot the axes' titles
       colour = "Crime Group", # plot the colour legend title
       caption = "SOURCE: Office for National Statistics") + #plot caption
  theme_bw() + #classic black and white look
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + # rotate the years 90 dregrees
  scale_color_brewer(palette ="Set2") + #choose a pallet that is colour blind friendly
  scale_y_continuous(labels = scales::comma_format()) # format the y axis




# the chosen graph with hover over animation
  
p2 <- ggplotly(p)

p2 <- p2 %>% 
  plotly::layout(title = list(text = "<b>Crime Progression Over Time</b> <br> <span style='font-size:14px'> Recorded from April to March, 2001 to 2019 </span>", x = 0.5), #add title and subtitle
             annotations = list(
               list(x = 1, y = 0, text = "SOURCE: Office for National Statistics", showarrow = FALSE, font = list(size = 8), xref = "paper", yref="paper", align="left", xanchor="left", yanchor="bottom", pad=list(10,10))
             )) #add caption





# show the plot and interactive 
p 
p2


# save the graphs 

ggsave("graphs/crime_years.png", plot = p, width = 8, height = 6) # save static plot

ggsave("graphs/crime_years_bar.png", plot = b, width = 8, height = 6) # save static plot

htmlwidgets::saveWidget(
  widget = p2, # the plotly object
  file = "graphs/interactive_crime_years.html") #the path & file name save



