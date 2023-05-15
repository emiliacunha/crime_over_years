# crime_over_years
A visualisation of the progression of crime from 2001 to 2019
Progression of Crime over Time

# About the project

The project aimed to answer the following research questions:

1.  How have crime levels changed over time? Are there any specific types of crime that have increased or decreased over the years?

2.  Which crime type has the highest and lowest number of recorded cases?

The plot shows that the number of recorded cases has significantly decreased over the years. Robbery has consistently been the crime group with the least recorded cases. Meanwhile, theft offences have scored the highest number until recent years. We see that fraud has recorded the highest in recent years.

# RStudio and Packages

The project was created with RStudio 2023.03.1+446 "Cherry Blossom" Release (6e31ffc3ef2a1f81d377eeccab71ddc11cfbd29e, 2023-05-09) for windows
Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) RStudio/2023.03.1+446 Chrome/108.0.5359.179 Electron/22.0.3 Safari/537.36


The packages used were under the following versions:
> packageVersion("here")
[1] ‘1.0.1’
> packageVersion("tidyverse")
[1] ‘2.0.0’
> packageVersion("readxl")
[1] ‘1.4.2’
> packageVersion("ggplot2")
[1] ‘3.4.2’
> packageVersion("RColorBrewer")
[1] ‘1.1.3’
> packageVersion("plotly")
[1] ‘4.10.1’
> packageVersion("htmlwidgets")
[1] ‘1.6.2’

# This file contains:
a data folder - with the original data frame from the Office of National Statistics and a codebook with information on the data. 
a code folder - with an r script that generated the visualisation.
a graphs folder - with all the visualisations created based on the data.
a .rdm file which generated the PDF and HTML. 

References
Office for National Statistics. (n.d.) Crime in England and Wales: Appendix tables. https://www.ons.gov.uk/peoplepopulationandcommunity/crimeandjustice/datasets/crimeinenglandandwalesappendixtables 

Kantar Public. (n.d) Crime Survey for England and Wales. https://www.crimesurvey.co.uk/en/HomeReadMore.html

