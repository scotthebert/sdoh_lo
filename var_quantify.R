rm(list = ls())
#load in data
setwd("/Users/alo/Desktop/UMass/Capstone")
SDOH_Data = read_csv("SDOH Data - 9_ 2024 workthrough.csv")


# Adding patient numbers --------------------------------------------------
pt_nbr=nrow(SDOH_Data) #number of patients, ID'ed by number of rows of data
pt_ID = matrix(nrow = pt_nbr, ncol = 1)
for (x in 1:pt_nbr){
  pt_ID[x] = paste("P_",x,sep = "")
}
SDOH_mtrx = cbind(pt_ID, SDOH_Data)

## Quantifying variables ---------------------------------------------------
# Race --------------------------------------------------------------------
race_tbl = as.matrix(table(SDOH_mtrx[,"race"]))
race_prop_tbl = prop.table(race_tbl)
colnames(race_prop_tbl) <- c("Freq")

library(plotly)
race_chart <- data.frame("Race" = rownames(race_prop_tbl), race_prop_tbl)
data <- race_chart[, c('Race', 'Freq')]
#pie chart
colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
fig <- plot_ly(data, labels = ~Race, values = ~Freq, type = 'pie')
fig <- fig %>% layout(title = 'Race of patients FHCW primary care',
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

fig

#bar chart
fig <- plot_ly(
  x = rownames(race_prop_tbl),
  y = race_prop_tbl[,1],
  name = "Race of PT at FHCW primary care",
  type = "bar"
)

fig


# Ethnicity-------------------------------------------------------------------------
eth_tbl = as.matrix(table(SDOH_mtrx[,"ethnicity"]))
eth_prop_tbl = prop.table(eth_tbl)
colnames(eth_prop_tbl) <- c("Freq")

eth_df = as.data.frame(eth_tbl)
colnames(eth_df) = "Freq"
lang_nbr=nrow(eth_df)
hs_n_ct = 0
hs_y_ct = 0
hs_unrep_ct = 0

for (i in 1:lang_nbr) {
  current_row = rownames(eth_df)[i]
  if (grepl("Not Hispanic",current_row)) {
    hs_n_ct = hs_n_ct + eth_df[i, "Freq"]
  }else if (grepl("Unreported",current_row)) {
    hs_unrep_ct = hs_unrep_ct + eth_df[i, "Freq"]
  } 
  else{
    hs_y_ct = hs_y_ct + eth_df[i, "Freq"]
  }
}

hs_yn = matrix(
  c(hs_y_ct, hs_n_ct, hs_unrep_ct),
  nrow = 3,
  ncol = 1
  )
rownames(hs_yn) = c("Hispanic", "Not Hispanic", "Unreported")
colnames(hs_yn) = c("pts")


#pie chart if report hispanic or not
eth_chart <- data.frame("Ethnicity" = rownames(hs_yn), hs_yn)
data <- eth_chart[, c('Ethnicity', 'pts')]
colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
fig <- plot_ly(data, labels = ~Ethnicity, values = ~pts, type = 'pie')
fig <- fig %>% layout(title = 'Ethnicity of patients FHCW primary care',
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

fig

# Gender Identity ---------------------------------------------------------
gender_tbl = as.matrix(table(SDOH_mtrx[,"gender_identity"]))
gender_prop_tbl = prop.table(gender_tbl)
colnames(gender_prop_tbl) <- c("Freq")

# language ----------------------------------------------------------------
lang_tbl = as.matrix(table(SDOH_mtrx[,"pt_language"]))
lang_prop_tbl = prop.table(lang_tbl)
colnames(lang_prop_tbl) <- c("Freq")

## Hometown --------------------------------------------
# City ----------------------------------------------------------------
city_tbl = as.matrix(table(SDOH_mtrx[,"city"]))
city_prop_tbl = prop.table(city_tbl)
# ZipCode -------------------------------------------------------------
zip_tbl = as.matrix(table(SDOH_mtrx$zip))
zip_prop_tbl = prop.table(city_tbl)

# Insurance ----------------------------------------------------------------
ins_tbl = as.matrix(table(SDOH_mtrx[,"enc_payer"]))
ins_prop_tbl = prop.table(ins_tbl)

##SDOH in last 12 months----------------------
scrnd_tbl = as.matrix(table(SDOH_mtrx[,"sdoh_within_last_12_months"]))
scrnd_prop_tbl = prop.table(scrnd_tbl)

#Has patient been screened in the past 12 months?-----------------------------------------
notutd_scrn = 0
curyr = 0
yr_scrn_mtrx = matrix(nrow = pt_nbr, ncol = 1)
for (ii in 1:pt_nbr){
  yr_scrn = as.numeric(format(as.Date(SDOH_mtrx$last_sdoh_complete[ii], format = "%m/%d/%y"), "%Y"))
  yr_scrn_mtrx[ii] = yr_scrn
  if (!is.na(yr_scrn)) {
    if (yr_scrn != 2023 & yr_scrn != 2024){
      notutd_scrn = notutd_scrn + 1
    }
    if (yr_scrn == 2024)
      curyr = curyr + 1 #number of patients screened in 2024 and therefore will not count in our final count
  }
}
scrn_frqtbl = as.matrix(table(yr_scrn_mtrx))
scrn_prptbl = prop.table(scrn_frqtbl)

fig <- plot_ly(
  x = rownames(scrn_prptbl),
  y = scrn_prptbl[,1],
  name = "SDOH Screening rates for 2023 pt visits",
  type = "bar"
)

fig

fig <- plot_ly(
  x = rownames(scrn_frqtbl),
  y = scrn_frqtbl[,1],
  name = "SDOH Screening #s for 2023 pt visits",
  type = "bar"
)

fig

