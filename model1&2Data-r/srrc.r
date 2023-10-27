#author: R.Gluskin
# Original: May 2018
# Updated: March 2015
# For: Measure of America Data2go.ny

#To generate your own Census API key, go to this website first https://www.census.gov/programs-surveys/acs/data/data-via-api.html

#packages you will need
library("devtools")
library("acs")

api.key.install('75c871cf936302d636d65dd6c54b47e6185ab5f4', file = "key.rda")

#this makes your geography pan where all the data will be poured into
nyc_city <- geo.make(state = "NY", place = "New York city")

#borough pan
nyc_boro <- geo.make(state = "NY", county = c(
  "Bronx",
  "Kings",
  "New York",
  "Queens",
  "Richmond"))

#PUMA pans, these will be converted into community districts
nyc_puma <- geo.make(state="NY",
                     puma = c(
                       3701,
                       3702,
                       3703,
                       3704,
                       3705,
                       3706,
                       3707,
                       3708,
                       3709,
                       3710,
                       4001,
                       4002,
                       4003,
                       4004,
                       4005,
                       4006,
                       4007,
                       4008,
                       4009,
                       4010,
                       4011,
                       4012,
                       4013,
                       4014,
                       4015,
                       4016,
                       4017,
                       4018,
                       3801,
                       3802,
                       3803,
                       3804,
                       3805,
                       3806,
                       3807,
                       3808,
                       3809,
                       3810,
                       4101,
                       4102,
                       4103,
                       4104,
                       4105,
                       4106,
                       4107,
                       4108,
                       4109,
                       4110,
                       4111,
                       4112,
                       4113,
                       4114,
                       3901,
                       3902,
                       3903))


#population
#basic total population in raw numbers

oldB01003 = acs.lookup(table.number="B01003", endyear = 2015, span = 1)
df <- acs.fetch(geography = nyc_city, variable=oldB01003, endyear = "2015", span = "1", col.names="pretty")

df <- df@estimate

df <- as.data.frame(df)

names(df)[1] <- "age_pyramid_total_nyc"

#now we have a dataframe set up that we can easily add new tract data to.

#median income per household

medianinc <- acs.fetch(geo = nyc_city, table.number="B19013", endyear = "2015", span = "1", col.names="pretty")
medianinc <- as.data.frame(medianinc@estimate)

df$median_household_income_nyc <- medianinc[,1]

#median income per person
medianinc_personal <- acs.fetch(geo = nyc_city, table.number="B20017", endyear = "2015", span = "1", col.names="pretty")
medianinc_personal <- as.data.frame(medianinc_personal@estimate)
df$median_personal_earnings_nyc <- medianinc_personal[,c(1)]

#education
#goal is to get three different indicators to use -- No high school, at least HS, and at least bachelors

oldB15002 = acs.lookup(table.number="B15002", endyear = 2015, span = 1)

education <- acs.fetch(geo = nyc_city, variable=oldB15002, endyear = "2015", span = "1", col.names="pretty")

education <- as.data.frame(education@estimate)

#no hs
#df$male_no_hs_nyc <- rowSums(education[, c(3:10)])/education[,c(2)]*100
#df$female_no_hs_nyc <- rowSums(education[, c(20:27)])/education[,(19)]*100
df$no_hs_nyc <- rowSums(education[,c(3:10, 20:27)])/education[,(1)]*100

#at least hs
#df$male_at_least_hs_nyc <- rowSums(education[, c(11:18)])/education[,c(2)]*100
#df$female_at_least_hs_nyc <- rowSums(education[, c(28:35)])/education[,c(19)]*100
df$at_least_hs_nyc <- rowSums(education[,c(11:18, 28:35)])/education[,(1)]*100

#hs and some college
#df$male_complete_hs_somecollege_nyc <- rowSums(education[,c(11:13)])/education[,c(2)]*100
#df$female_complete_hs_somecollege_nyc <- rowSums(education[,c(28:30)])/education[,c(19)]*100
df$complete_hs_somecollege_nyc <- rowSums(education[,c(11:14, 28:31)])/education[,(1)]*100

#completed bachelor's
#df$male_complete_bach_nyc <- education[,c(15)]/education[,c(2)]*100
#df$female_complete_bach_nyc <- education[,c(32)]/education[,(19)]*100
df$complete_bach_nyc <- rowSums(education[,c(15,32)])/education[,c(1)]*100

#at least bachelor's
#df$male_at_least_bachelor_nyc <- rowSums(education[, c(15:18)])/education[,c(2)]*100
#df$female_at_least_bachelor_nyc <- rowSums(education[, c(32:35)])/education[,c(19)]*100
df$at_least_bachelors_nyc <- rowSums(education[,c(15:18,32:35)])/education[,c(1)]*100

#graduate degree
#df$male_grad_degree_nyc <- rowSums(education[, c(16:18)])/education[,c(2)]*100
#df$female_grad_degree_nyc <- rowSums(education[, c(33:35)])/education[,c(19)]*100
df$grad_degree_nyc  <- rowSums(education[,c(16:18,33:35)])/education[,c(1)]*100

#race/ethnicity

oldB03002 = acs.lookup(table.number="B03002", endyear = 2015, span = 1)
race <- acs.fetch(geo = nyc_city, variable=oldB03002, endyear = "2015", span = "1", col.names="pretty")
total_race <- as.data.frame(race@estimate)

df$latino_pop_nyc <- total_race[,c(12)]/total_race[,c(1)]*100
df$white_pop_nyc <- total_race[,c(3)]/total_race[,c(1)]*100
df$aframer_pop_nyc <- total_race[,c(4)]/total_race[,c(1)]*100
df$natamer_pop_nyc <- total_race[,c(5)]/total_race[,c(1)]*100
df$asian_api_pop_nyc <- rowSums(total_race[,c(6:7)])/total_race[,c(1)]*100
df$other_pop_nyc <- rowSums(total_race[,c(8:9)])/total_race[,c(1)]*100


#race totals

df$asian_api_total_nyc <- rowSums(total_race[,c(6:7)])
df$latino_total_pop_nyc <- total_race[,c(12)]
df$white_total_pop_nyc <- total_race[,c(3)]
df$aframer_total_pop_nyc <- total_race[,c(4)]
df$natamer_total_pop_nyc <- total_race[,c(5)]
df$other_total_pop_nyc <- rowSums(total_race[,c(8:9)])

#unemployment status

oldB23001 = acs.lookup(table.number="B23001", endyear = 2015, span = 1)
unemployment <- acs.fetch(geo = nyc_city, variable=oldB23001, endyear = "2015", span = "1", col.names="pretty")
unemployment <- as.data.frame(unemployment@estimate)

#since this data is separated by age, we need to aggregate it to male unemployment / female unemployment.
#so we will take rowsums

#male sums
unemployment$male_unemployment <- rowSums(unemployment[, c(8,15,22,29,36,43,50,57,64,71,76,81,86)])

#now we need female, but because there are discrepancies in the dataset we have to subset it to make sure its right
female_unemployment <- unemployment[c(88:173)]

#female sums
unemployment$female_unemployment <- rowSums(female_unemployment[, c(7,14,21,28,35,42,49,56,63,70,75,80,85)])

#total unemployment
unemployment$total_unemployment <- (unemployment$male_unemployment + unemployment$female_unemployment)

#now to add to dataset. please note the improvement I made in adding variables to the master dataset, saves some code
#male unemployment
df$male_unemployment <- unemployment$male_unemployment/unemployment[,c(2)]*100

#female unemployment
df$female_unemployment <- unemployment$female_unemployment/female_unemployment[,c(1)]*100

df$unemployment_nyc <- unemployment$total_unemployment/(unemployment[,1])*100

#household snap rate
#this is the rate at which households receive SNAP food assistance benefits

oldB19058 = acs.lookup(table.number="B19058", endyear = 2015, span = 1)
snap <- acs.fetch(geo = nyc_city, variable=oldB19058, endyear = "2015", span = "1", col.names="pretty")
snap <- as.data.frame(snap@estimate)

df$households_receiving_snap_benefits_nyc <- snap[,c(2)]/snap[,c(1)]*100

#household public assistance rate
#this is the rate at which households receive income from Temporary Assistance for Needy Families (TANF) or General Assistance programs

oldB19057 = acs.lookup(table.number="B19057", endyear = 2015, span = 1)
public_assistance <- acs.fetch(geo = nyc_city, variable=oldB19057, endyear = "2015", span = "1", col.names="pretty")

public_assistance <- as.data.frame(public_assistance@estimate)

df$publicassist_nyc <- public_assistance[,c(2)]/public_assistance[,c(1)]*100

#Percent of NYC that is renting
#this is the percentage of households that is renting

oldB25003 = acs.lookup(table.number="B25003", endyear = 2015, span = 1)
renter <- acs.fetch(geo = nyc_city, variable=oldB25003, endyear = "2015", span = "1", col.names="pretty")

renter <- as.data.frame(renter@estimate)

df$renter_occ_nyc <- renter[,c(3)]/renter[,c(1)]*100
df$owner_occ_nyc <- 100 - df$renter

#now the median rent per sonoma

oldB25064 = acs.lookup(table.number="B25064", endyear = 2015, span = 1)
median_rent <- acs.fetch(geo = nyc_city, variable=oldB25064, endyear = "2015", span = "1", col.names="pretty")
median_rent <- as.data.frame(median_rent@estimate)

df$median_rent_nyc <- median_rent[,1]

#age pyramid

oldB01001 = acs.lookup(table.number="B01001", endyear = 2015, span = 1)
age_pyramid <- acs.fetch(geo = nyc_city, variable=oldB01001, endyear = "2015", span = "1", col.names="pretty")
age_pyramid <- as.data.frame(age_pyramid@estimate)

#male

#male under 5
df$age_pyramid_male_under_5_nyc <- age_pyramid[,3]
#male 5 - 14
df$age_pyramid_male_5_to_14_nyc <- rowSums(age_pyramid[,4:5])
#male 15 - 24
df$age_pyramid_male_15_to_24_nyc <- rowSums(age_pyramid[,6:10])
#male 25 - 34
df$age_pyramid_male_25_to_34_nyc <- rowSums(age_pyramid[,11:12])
#male 35 - 44
df$age_pyramid_male_35_to_44_nyc <- rowSums(age_pyramid[,13:14])
#male 45 - 54
df$age_pyramid_male_45_to_54_nyc <- rowSums(age_pyramid[,15:16])
#male 55 - 64
df$age_pyramid_male_55_to_64_nyc <- rowSums(age_pyramid[,17:19])
#male 65 - 74
df$age_pyramid_male_65_to_74_nyc <- rowSums(age_pyramid[,20:22])
#male 75 - 84
df$age_pyramid_male_75_to_84_nyc <- rowSums(age_pyramid[,23:24])
#male 85 +
df$age_pyramid_male_85_plus_nyc <- age_pyramid[,25]

#female

df$age_pyramid_female_under_5_nyc <- age_pyramid[,27]
#female 5 - 14
df$age_pyramid_female_5_to_14_nyc <- rowSums(age_pyramid[,28:29])
#female 15 - 24
df$age_pyramid_female_15_to_24_nyc <- rowSums(age_pyramid[,30:34])
#female 25 - 34
df$age_pyramid_female_25_to_34_nyc <- rowSums(age_pyramid[,35:36])
#female 35 - 44
df$age_pyramid_female_35_to_44_nyc <- rowSums(age_pyramid[,37:38])
#female 45 - 54
df$age_pyramid_female_45_to_54_nyc <- rowSums(age_pyramid[,39:40])
#female 55 - 64
df$age_pyramid_female_55_to_64_nyc <- rowSums(age_pyramid[,41:43])
#female 65 - 74
df$age_pyramid_female_65_to_74_nyc <- rowSums(age_pyramid[,44:46])
#female 75 - 84
df$age_pyramid_female_75_to_84_nyc <- rowSums(age_pyramid[,47:48])
#female 85 +
df$age_pyramid_female_85_plus_nyc <- age_pyramid[,49]



#male under 5
df$perc_age_pyramid_male_under_5_nyc <- age_pyramid[,3]/age_pyramid[,1]*100
#male 5 - 14
df$perc_age_pyramid_male_5_to_14_nyc <- rowSums(age_pyramid[,4:5])/age_pyramid[,1]*100
#male 15 - 24
df$perc_age_pyramid_male_15_to_24_nyc <- rowSums(age_pyramid[,6:10])/age_pyramid[,1]*100
#male 25 - 34
df$perc_age_pyramid_male_25_to_34_nyc <- rowSums(age_pyramid[,11:12])/age_pyramid[,1]*100
#male 35 - 44
df$perc_age_pyramid_male_35_to_44_nyc <- rowSums(age_pyramid[,13:14])/age_pyramid[,1]*100
#male 45 - 54
df$perc_age_pyramid_male_45_to_54_nyc <- rowSums(age_pyramid[,15:16])/age_pyramid[,1]*100
#male 55 - 64
df$perc_age_pyramid_male_55_to_64_nyc <- rowSums(age_pyramid[,17:19])/age_pyramid[,1]*100
#male 65 - 74
df$perc_age_pyramid_male_65_to_74_nyc <- rowSums(age_pyramid[,20:22])/age_pyramid[,1]*100
#male 75 - 84
df$perc_age_pyramid_male_75_to_84_nyc <- rowSums(age_pyramid[,23:24])/age_pyramid[,1]*100
#male 85 +
df$perc_age_pyramid_male_85_plus_nyc <- age_pyramid[,25]/age_pyramid[,1]*100

#female

df$perc_age_pyramid_female_under_5_nyc <- age_pyramid[,27]/age_pyramid[,1]*100
#female 5 - 14
df$perc_age_pyramid_female_5_to_14_nyc <- rowSums(age_pyramid[,28:29])/age_pyramid[,1]*100
#female 15 - 24
df$perc_age_pyramid_female_15_to_24_nyc <- rowSums(age_pyramid[,30:34])/age_pyramid[,1]*100
#female 25 - 34
df$perc_age_pyramid_female_25_to_34_nyc <- rowSums(age_pyramid[,35:36])/age_pyramid[,1]*100
#female 35 - 44
df$perc_age_pyramid_female_35_to_44_nyc <- rowSums(age_pyramid[,37:38])/age_pyramid[,1]*100
#female 45 - 54
df$perc_age_pyramid_female_45_to_54_nyc <- rowSums(age_pyramid[,39:40])/age_pyramid[,1]*100
#female 55 - 64
df$perc_age_pyramid_female_55_to_64_nyc <- rowSums(age_pyramid[,41:43])/age_pyramid[,1]*100
#female 65 - 74
df$perc_age_pyramid_female_65_to_74_nyc <- rowSums(age_pyramid[,44:46])/age_pyramid[,1]*100
#female 75 - 84
df$perc_age_pyramid_female_75_to_84_nyc <- rowSums(age_pyramid[,47:48])/age_pyramid[,1]*100
#female 85 +
df$perc_age_pyramid_female_85_plus_nyc <- age_pyramid[,49]/age_pyramid[,1]*100


#total percent 5 - 14
df$perc_age_pyramid_5_to_14_nyc <- rowSums(age_pyramid[,c(4:5,28:29)])/age_pyramid[,1]*100
#total percent 15 - 24 
df$perc_age_pyramid_15_to_24_nyc <- rowSums(age_pyramid[,c(6:10,30:34)])/age_pyramid[,1]*100
#total percent 25 - 34
df$perc_age_pyramid_25_to_34_nyc <- rowSums(age_pyramid[,c(11:12,35:36)])/age_pyramid[,1]*100
#total percent 35 - 44
df$perc_age_pyramid_35_to_44_nyc <- rowSums(age_pyramid[,c(13:14,37:38)])/age_pyramid[,1]*100
#total percent 45 - 54
df$perc_age_pyramid_45_to_54_nyc <- rowSums(age_pyramid[,c(15:16,39:40)])/age_pyramid[,1]*100
#total percent 55 - 64
df$perc_age_pyramid_55_to_64_nyc <- rowSums(age_pyramid[,c(17:19,41:43)])/age_pyramid[,1]*100
#total percent 65 - 74
df$perc_age_pyramid_65_to_74_nyc <- rowSums(age_pyramid[,c(20:22,44:46)])/age_pyramid[,1]*100
#total percent 75 - 84
df$perc_age_pyramid_75_to_84_nyc <- rowSums(age_pyramid[,c(23:24,47:48)])/age_pyramid[,1]*100
#total percent 85 plus
df$perc_age_pyramid_85_plus_nyc <- rowSums(age_pyramid[,c(25,49)])/age_pyramid[,1]*100

#% of total population ages 25-54 ("prime age")
df$prime_age_nyc <- rowSums(age_pyramid[,c(11:16,35:40)])/age_pyramid[,1]*100

#percentage under 5
df$underfive_nyc <- rowSums(age_pyramid[,c(3,27)])/age_pyramid[,1]*100
#percentage under 18
df$undereighteen_nyc <- rowSums(age_pyramid[,c(3:6,27:30)])/age_pyramid[,1]*100
#percentage over 65
df$sixtyfive_nyc <- rowSums(age_pyramid[,c(20:25, 44:49)])/age_pyramid[,1]*100

#commute time

oldB08012 = acs.lookup(table.number="B08012", endyear = 2015, span = 1)
commute <- acs.fetch(geo = nyc_city, variable=oldB08012, endyear = "2015", span = "1", col.names="pretty")

commute <- as.data.frame(commute@estimate)

df$commute_under_30_mins_nyc <- (rowSums(commute[,c(2:7)])/commute[,c(1)])*100

df$commute_30_59_mins_nyc <- (rowSums(commute[,c(8:11)])/commute[,c(1)])*100

df$commute_60_mins_plus_nyc <- (rowSums(commute[,c(12:13)])/commute[,c(1)])*100

#employment -- full time / part time

oldB23022 = acs.lookup(table.number="B23022", endyear = 2015, span = 1)
employ_full_part <- acs.fetch(geo = nyc_city, variable=oldB23022, endyear = "2015", span = "1", col.names="pretty")
employ_full_part <- as.data.frame(employ_full_part@estimate)

df$full_time_workers_nyc <- rowSums(employ_full_part[,c(4,28)])/rowSums(employ_full_part[,c(3,27)])*100
df$part_time_workers_nyc <- 100 - df$full_time


#rent burden

oldB25070 = acs.lookup(table.number="B25070", endyear = 2015, span = 1)
rent_burden <- acs.fetch(geo = nyc_city, variable=oldB25070, endyear = "2015", span = "1", col.names="pretty")
rent_burden <- as.data.frame(rent_burden@estimate)

df$high_cost_h_nyc <- rowSums(rent_burden[,c(7:10)])/(rent_burden[,c(1)]-rent_burden[,c(11)])*100
df$ex_high_cost_h_nyc <- rent_burden[,c(10)]/(rent_burden[,c(1)]-rent_burden[,c(11)])*100

#percent of foreign born (either citizen or noncitizen)

oldB05002 = acs.lookup(table.number="B05002", endyear = 2015, span = 1)
foreign_born <- acs.fetch(geo = nyc_city, variable=oldB05002, endyear = "2015", span = "1", col.names="pretty")

foreign_born <- as.data.frame(foreign_born@estimate)

df$foreign_nyc <- foreign_born[,c(13)]/foreign_born[,c(1)]*100
df$native_nyc <- 100 - df$foreign_nyc

#where are the foreign born from?

oldB05006 = acs.lookup(table.number="B05006", endyear = 2015, span = 1)
foreign_born_location <- acs.fetch(geo = nyc_city, variable=oldB05006, endyear = "2015", span = "1", col.names="pretty")

foreign_born_location <- as.data.frame(foreign_born_location@estimate)

df$north_eur_nyc <- foreign_born_location[,c(3)]/foreign_born_location[,c(1)]*100

#western europe
df$west_eur_nyc <- foreign_born_location[,c(13)]/foreign_born_location[,c(1)]*100

#southern europe
df$south_eur_nyc <- foreign_born_location[,c(21)]/foreign_born_location[,c(1)]*100

#eastern europe
df$east_eur_nyc <- foreign_born_location[,c(28)]/foreign_born_location[,c(1)]*100

#europe, not elsewhere classifed
df$nec_eur_nyc <- foreign_born_location[,c(46)]/foreign_born_location[,c(1)]*100

#eastern asia
df$east_asia_nyc <- foreign_born_location[,c(48)]/foreign_born_location[,c(1)]*100

#south central asia 
df$south_cen_asia_nyc <- foreign_born_location[,c(56)]/foreign_born_location[,c(1)]*100

#south eastern asia
df$south_east_asia_nyc <- foreign_born_location[,c(67)]/foreign_born_location[,c(1)]*100

#western asia
df$west_asia_nyc <- foreign_born_location[,c(78)]/foreign_born_location[,c(1)]*100

#asia, not elsewhere classified
df$nec_asia_nyc <- foreign_born_location[,c(90)]/foreign_born_location[,c(1)]*100

#eastern africa

df$east_afr_nyc <- foreign_born_location[,c(92)]/foreign_born_location[,c(1)]*100

#middle africa 

df$mid_afr_nyc <- foreign_born_location[,c(98)]/foreign_born_location[,c(1)]*100

#northern africa
df$north_afr_nyc <- foreign_born_location[,c(101)]/foreign_born_location[,c(1)]*100

#southern africa
df$south_afr_nyc <- foreign_born_location[,c(106)]/foreign_born_location[,c(1)]*100

#western africa
df$west_afr_nyc <- foreign_born_location[,c(109)]/foreign_born_location[,c(1)]*100

#africa, not elsewhere classified
df$nec_afr_nyc <- foreign_born_location[,c(116)]/foreign_born_location[,c(1)]*100

#oceania, Austalia and New Zealand
df$aus_nz_ocean_nyc <- foreign_born_location[,c(118)]/foreign_born_location[,c(1)]*100

#oceania, Fiji
df$fiji_ocean_nyc <- foreign_born_location[,c(121)]/foreign_born_location[,c(1)]*100

#oceania, not elsewhere classified
df$nec_ocean_nyc <- foreign_born_location[,c(122)]/foreign_born_location[,c(1)]*100

#the caribbean
df$carib_amer_nyc <- foreign_born_location[,c(125)]/foreign_born_location[,c(1)]*100

#Central America
df$cent_amer_nyc <- foreign_born_location[,c(138)]/foreign_born_location[,c(1)]*100

#South America
df$south_amer_nyc <- foreign_born_location[,c(148)]/foreign_born_location[,c(1)]*100

#North America
df$north_amer_nyc <- foreign_born_location[,c(160)]/foreign_born_location[,c(1)]*100

#adults same home

oldB07001 = acs.lookup(table.number="B07001", endyear = 2015, span = 1)
stability <- acs.fetch(geo = nyc_city, variable=oldB07001, endyear = "2015", span = "1", col.names="pretty")

stability <- as.data.frame(stability@estimate)

df$adult_samehome_nyc <- rowSums(stability[,c(20:32)])/rowSums(stability[,c(4:16)])*100

#child same home
df$child_samehome_nyc <- rowSums(stability[,c(18:19)])/rowSums(stability[,c(2:3)])*100

#gini coefficient

oldB19083 = acs.lookup(table.number="B19083", endyear = 2015, span = 1)
gini <- acs.fetch(geo = nyc_city, variable=oldB19083, endyear = "2015", span = "1", col.names="pretty")

gini <- as.data.frame(gini@estimate)

df$income_inequality_nyc <- gini[,c(1)]

#adult and child medicaid rates

oldB27010 = acs.lookup(table.number="B27010", endyear = 2015, span = 1)
insurance_type <- acs.fetch(geo = nyc_city, variable=oldB27010, endyear = "2015", span = "1", col.names="pretty")

insurance_type <- as.data.frame(insurance_type@estimate)

df$children_with_medicaid_nyc <- insurance_type[,c(7)]/insurance_type[,c(2)]*100
df$adult_medicaid_nyc <- rowSums(insurance_type[,c(23,39)])/rowSums(insurance_type[,c(18,34)])*100

#marital status

oldB06008= acs.lookup(table.number="B06008", endyear = 2015, span = 1)
marital <- acs.fetch(geo = nyc_city, variable=oldB06008, endyear = "2015", span = "1", col.names="pretty")

marital <- as.data.frame(marital@estimate)

df$married_nyc <- marital[,c(3)]/marital[,c(1)]*100
df$divorced_nyc <- marital[,c(4)]/marital[,c(1)]*100

#living alone (% of households)

oldB11001= acs.lookup(table.number="B11001", endyear = 2015, span = 1)
nonfam <- acs.fetch(geo = nyc_city, variable=oldB11001, endyear = "2015", span = "1", col.names="pretty")

nonfam <- as.data.frame(nonfam@estimate)

df$lonely_nyc <- nonfam[,c(8)]/nonfam[,c(1)]*100

#non family not living alone(% of households)

df$nonfammore1_nyc <- nonfam[,c(9)]/nonfam[,c(1)]*100

#single mom

oldB11005= acs.lookup(table.number="B11005", endyear = 2015, span = 1)
single_par <- acs.fetch(geo = nyc_city, variable=oldB11005, endyear = "2015", span = "1", col.names="pretty")

single_par <- as.data.frame(single_par@estimate)

df$singlemom_nyc <- single_par[,c(7)]/single_par[,c(1)]*100
df$singledad_nyc <- single_par[,c(6)]/single_par[,c(1)]*100

#language variables 
oldB16001= acs.lookup(table.number="B16001", endyear = 2015, span = 1)
language <- acs.fetch(geo = nyc_city, variable=oldB16001, endyear = "2015", span = "1", col.names="pretty")

language <- as.data.frame(language@estimate)

#bad english
#we don't want to have to add all the columns by typing them individually, so a seq is used. 
bad_english <- language[,c(5:119)]
n <- length(bad_english)
bad_english <- bad_english[seq(1,n,3)] 

#now the percentage
df$badenglish_speakers_nyc <- rowSums(bad_english[,c(1:39)])
df$badenglish_speakers_nyc <- df$badenglish_speakers_nyc/language[,c(1)]*100 

#speak a language other english at home, same process as above (ages 5+)
language_home <- language[,c(3:119)]
n <- length(language_home)
language_home <- language_home[seq(1,n,3)] 



df$nonenglish_speakers_nyc <- rowSums(language_home[,c(1:39)])
df$nonenglish_speakers_nyc <- df$nonenglish_speakers_nyc/language[,c(1)]*100

#speak spanish at home
df$spanish_speaker_nyc <- language[,c(3)]/language[,c(1)]*100

#speak asian or API language at home
df$api_speaker_nyc <- rowSums(language_home[,c(22:32)])/language[,c(1)]*100

#poverty

oldB17001= acs.lookup(table.number="B17001", endyear = 2015, span = 1)
poverty <- acs.fetch(geo = nyc_city, variable=oldB17001, endyear = "2015", span = "1", col.names="pretty")

poverty <- as.data.frame(poverty@estimate)


#total
df$poverty_all_ages_federal_number_nyc <- (poverty[,c(2)])
df$poverty_all_ages_federal_percent_nyc <- (poverty[,c(2)]/poverty[,c(1)])*100


#### WE DO USE THIS ONE#####
#child (under 18)

df$poverty_child_federal_number_nyc <- rowSums(poverty[,c(4:9,18:23)])
#percent

df$poverty_child_federal_percent_nyc <- df$poverty_child_federal_number_nyc/rowSums(poverty[,c(4:9,33:38,18:23,47:52)])*100


#elderly (over 65)
df$poverty_65_federal_number_nyc <- rowSums(poverty[,c(15:16,29:30)])
#percent
df$poverty_65_federal_percent_nyc <- df$poverty_65_federal_number_nyc/rowSums(poverty[,c(15:16,44:45,29:30,58:59)])*100

#occupation

oldC24010= acs.lookup(table.number="C24010", endyear = 2015, span = 1)
occ <- acs.fetch(geo = nyc_city, variable=oldC24010, endyear = "2015", span = "1", col.names="pretty")

occ <- as.data.frame(occ@estimate)

df$management_business_science_and_arts_occupations_nyc <- rowSums(occ[,c(3,39)])/occ[,c(1)]*100
df$service_occupations_nyc <- rowSums(occ[,c(19,55)])/occ[,c(1)]*100
df$sales_and_office_occupations_nyc <- rowSums(occ[,c(27,63)])/occ[,c(1)]*100
df$natural_resources_construction_and_maintenance_occupations_nyc <- rowSums(occ[,c(30,66)])/occ[,c(1)]*100
df$production_transportation_and_material_moving_occupations_nyc <- rowSums(occ[,c(34,70)])/occ[,c(1)]*100

#now lets start our industry categories

oldC24030= acs.lookup(table.number="C24030", endyear = 2015, span = 1)
ind <- acs.fetch(geo = nyc_city, variable=oldC24030, endyear = "2015", span = "1", col.names="pretty")

ind <- as.data.frame(ind@estimate)

#each industrial category
df$agriculture_forestry_fishing_hunting_mining_industries_nyc <- rowSums(ind[,c(3,30)])/ind[,c(1)]*100
df$construction_industries_nyc <- rowSums(ind[,c(6,33)])/ind[,c(1)]*100
df$manufacturing_industries_nyc <- rowSums(ind[,c(7,34)])/ind[,c(1)]*100
df$arts_entertainment_recreation_accommodation_food_services_nyc <- rowSums(ind[,c(24,51)])/ind[,c(1)]*100
df$educational_services_health_care_social_assistance_industries_nyc <- rowSums(ind[,c(21,48)])/ind[,c(1)]*100
df$finance_insurance_real_estate_rental_leasing_industries_nyc <- rowSums(ind[,c(14,41)])/ind[,c(1)]*100
df$information_industries_nyc <- rowSums(ind[,c(13,40)])/ind[,c(1)]*100
df$other_service_industries_nyc <- rowSums(ind[,c(27,54)])/ind[,c(1)]*100
df$professional_scientific_management_administrative_waste_management_services_industries_nyc <- rowSums(ind[,c(17,44)])/ind[,c(1)]*100
df$wholesale_trade_industries_nyc <- rowSums(ind[,c(8,35)])/ind[,c(1)]*100
df$public_administration_industries_nyc <- rowSums(ind[,c(28,55)])/ind[,c(1)]*100
df$retail_trade_industries_nyc <- rowSums(ind[,c(9,36)])/ind[,c(1)]*100
df$transportation_warehousing_utilities_industries_nyc <- rowSums(ind[,c(10,37)])/ind[,c(1)]*100

#school enrollment

oldB14003= acs.lookup(table.number="B14003", endyear = 2015, span = 1)
school_enroll <- acs.fetch(geo = nyc_city, variable=oldB14003, endyear = "2015", span = "1", col.names="pretty")
school_enroll <- as.data.frame(school_enroll@estimate)

df$sch_enrol_nyc <- rowSums(school_enroll[,c(4:9,13:18,32:37,41:46)])/rowSums(school_enroll[,c(4:9,13:18,22:27,32:37,41:46,50:55)])*100

#preschool enrollment
df$pre_k_nyc <- rowSums(school_enroll[,c(4,13,32,41)])/rowSums(school_enroll[,c(4,13,22,32,41,50)])*100

#household variables

oldB11005= acs.lookup(table.number="B11005", endyear = 2015, span = 1)
household_type <- acs.fetch(geo = nyc_city, variable=oldB11005, endyear = "2015", span = "1", col.names="pretty")

household_type <- as.data.frame(household_type@estimate)

#households with people under 18
df$familychild_nyc <- (household_type[,2]/household_type[,1])*100

#married couples with people under 18
df$marriedchild_nyc <- (household_type[,4]/household_type[,1])*100

#non family households with under 18
df$nonfamilychild_nyc <- (household_type[,8]/household_type[,1])*100

#married no children
df$marriednochild_nyc <- (household_type[,13]/household_type[,1])*100

#non family no kids
df$nonfamily_nyc <- (household_type[,17]/household_type[,1])*100


#family no kids (married and not married) - to replace marriednochild in d2g2015
df$familynochild_nyc <- (household_type[,12]/household_type[,1])*100

#percentage of households with householder or spouse grandparent responsible for grandchildren and parents of children not present

oldB10063= acs.lookup(table.number="B10063", endyear = 2015, span = 1)
grandparents <- acs.fetch(geo = nyc_city, variable=oldB10063, endyear = "2015", span = "1", col.names="pretty")
grandparents <- as.data.frame(grandparents@estimate)

df$grandrearers_nyc <- grandparents[,4]/grandparents[,1]*100

#elderly living alone

oldB11007= acs.lookup(table.number="B11007", endyear = 2015, span = 1)
elderly_living_alone <- acs.fetch(geo = nyc_city, variable=oldB11007, endyear = "2015", span = "1", col.names="pretty")
elderly_living_alone <- as.data.frame(elderly_living_alone@estimate)

df$lonelyaged_nyc <- (elderly_living_alone[,3]/elderly_living_alone[,1])*100

#disability

oldB18101= acs.lookup(table.number="B18101", endyear = 2015, span = 1)
disability <- acs.fetch(geo = nyc_city, variable=oldB18101, endyear = "2015", span = "1", col.names="pretty")

disability <- as.data.frame(disability@estimate)

df$disabled_nyc <- rowSums(disability[,c(4,7,10,13,16,19,23,26,29,32,35,38)])/disability[,1]*100

#median home value

oldB25077= acs.lookup(table.number="B25077", endyear = 2015, span = 1)
median_home_value <- acs.fetch(geo = nyc_city, variable=oldB25077, endyear = "2015", span = "1", col.names="pretty")
median_home_value <- as.data.frame(median_home_value@estimate)

df$median_value_nyc <- median_home_value[,1]

#class of worker

oldB24080= acs.lookup(table.number="B24080", endyear = 2015, span = 1)
class_of_worker <- acs.fetch(geo = nyc_city, variable=oldB24080, endyear = "2015", span = "1", col.names="pretty")
class_of_worker <- as.data.frame(class_of_worker@estimate)

#private
df$private_wage_and_salary_workers_class_nyc <- rowSums(class_of_worker[,c(3,6,13,16)])/class_of_worker[,1]*100
#government
df$government_workers_class_nyc <- rowSums(class_of_worker[,c(7:9,17:19)])/class_of_worker[,1]*100
#self employed
df$self_employed_class_nyc <- rowSums(class_of_worker[,c(10,20)])/class_of_worker[,1]*100
#unpaid family
df$unpaid_family_workers_class_nyc <- rowSums(class_of_worker[,c(11,21)])/class_of_worker[,1]*100

#rental vacancies

oldB25002= acs.lookup(table.number="B25002", endyear = 2015, span = 1)
rental_vacancies <- acs.fetch(geo = nyc_city, variable=oldB25002, endyear = "2015", span = "1", col.names="pretty")

rental_vacancies <- as.data.frame(rental_vacancies@estimate)
df$rental_vac_nyc <- rental_vacancies[,3]/rental_vacancies[,1]*100

#labor force participation rate
oldB12006= acs.lookup(table.number="B12006", endyear = 2015, span = 1)
labor_force_participation <- acs.fetch(geo = nyc_city, variable=oldB12006, endyear = "2015", span = "1", col.names="pretty")
labor_force_participation <- as.data.frame(labor_force_participation@estimate)

df$labor_force_participation_nyc <- rowSums(labor_force_participation[,c(4,9,15,20,26,31,37,42,48,53)])/labor_force_participation[,1]*100


#kitchen

oldB25052= acs.lookup(table.number="B25052", endyear = 2015, span = 1)
kitchen <- acs.fetch(geo = nyc_city, variable=oldB25052, endyear = "2015", span = "1", col.names="pretty")
kitchen <- as.data.frame(kitchen@estimate)

df$no_kitchen_nyc <- kitchen[,3]/kitchen[,1]*100

#overcrowding

oldB25014= acs.lookup(table.number="B25014", endyear = 2015, span = 1)
overcrowding <- acs.fetch(geo = nyc_city, variable=oldB25014, endyear = "2015", span = "1", col.names="pretty")

overcrowding <- as.data.frame(overcrowding@estimate)

df$more_than_one_nyc <- rowSums(overcrowding[,c(5:7,11:13)])/overcrowding[,1]*100


#working poor

oldB17005= acs.lookup(table.number="B17005", endyear = 2015, span = 1)
pov_status <- acs.fetch(geo = nyc_city, variable=oldB17005, endyear = "2015", span = "1", col.names="pretty")
pov_status <- as.data.frame(pov_status@estimate)

df$working_poor_nyc <- rowSums(pov_status [ , c(5,10)])/rowSums(pov_status[,c(5,10,16,21)])*100


#internet

#internet access  
#2/15/18 this table is not updated on the API because it has changed significantly from 2015  code has been updated to new table, but data pulled from factfinder
oldB28002= acs.lookup(table.number="B28002", endyear = 2015, span = 1)
high_speed_internet <- acs.fetch(geo = nyc_city, variable=oldB28002, dataset = "acs", endyear = "2015", span = "1", col.names="pretty")
high_speed_internet <- as.data.frame(high_speed_internet@estimate)

df$internet_nyc <- rowSums(high_speed_internet[,c(4)])/high_speed_internet[,c(1)]*100

#computer access
oldB28003= acs.lookup(table.number="B28003", endyear = 2015, span = 1)
computer <- acs.fetch(geo = nyc_city, variable=oldB28003, dataset = "acs", endyear = "2015", span = "1", col.names="pretty")
computer <- as.data.frame(computer@estimate)

df$computer_nyc <- computer[,c(2)]/computer[,c(1)]*100



#total vets boro
oldB21001 = acs.lookup( table.number="B21001", endyear = 2015, span = 1)
vet_total_nyc  <- acs.fetch(geography = nyc_city, variable=oldB21001, endyear = "2015", span = "1", col.names="pretty")
vet_total_nyc <- as.data.frame(vet_total_nyc@estimate)
df$total_18_plus<-vet_total_nyc[,1]
df$total_veterans_nyc<-vet_total_nyc[,2]
df$total_veterans_percent_nyc <- (df$total_veterans_nyc/ df$total_18_plus)*100
df$male_veterans_nyc <- vet_total_nyc[,5]
df$male_veterans_percent_nyc <-  (df$male_veterans_nyc/df$total_veterans_nyc)*100
df$female_veterans_nyc <- vet_total_nyc[,23]
df$female_veterans_percent_nyc<-  (df$female_veterans_nyc /df$total_veterans_nyc)*100

#start w/ educational data
oldB21003 = acs.lookup( table.number="B21003", endyear = 2015, span = 1)
vet_education_nyc <- acs.fetch(geo = nyc_city, variable=oldB21003, endyear = "2015", span = "1", col.names = "pretty")
vet_education_nyc <- as.data.frame(vet_education_nyc@estimate)

df$vet_total_nyc_25_plus <- vet_education_nyc[,2]
df$veterans_nohs_nyc <- vet_education_nyc[,3]
df$veterans_bachelors_nyc <- vet_education_nyc[,6]

df$veterans_nohs_percent_nyc <- (df$veterans_nohs_nyc/df$vet_total_nyc_25_plus )*100
df$veterans_bachelors_percent_nyc <- (df$veterans_bachelors_nyc/df$vet_total_nyc_25_plus )*100

#pull in income data for last 12mo
oldB21004 = acs.lookup( table.number="B21004", endyear = 2015, span = 1)
vet_income_nyc <- acs.fetch(geo = nyc_city, variable=oldB21004, endyear = "2015", span = "1", col.names = "pretty")
vet_income_nyc <- as.data.frame(vet_income_nyc@estimate)
df$veterans_med_income_nyc <- vet_income_nyc[,2]


#now poverty & disability stats

oldB21007 = acs.lookup( table.number="B21007", endyear = 2015, span = 1)
vet_poverty_by_disability_nyc <- acs.fetch(geography = nyc_city, variable=oldB21007, endyear = "2015", span = "1", col.names="pretty")
vet_poverty_by_disability_nyc <- as.data.frame(vet_poverty_by_disability_nyc@estimate)


df$veterans_poverty_nyc <- vet_poverty_by_disability_nyc[,4] + vet_poverty_by_disability_nyc[,19] + vet_poverty_by_disability_nyc[,34] + vet_poverty_by_disability_nyc[,49]
df$veterans_poverty_percent_nyc <- (df$veterans_poverty_nyc/ df$total_veterans_nyc)*100
df$veterans_poverty_disabled_nyc <- vet_poverty_by_disability_nyc[,5] + vet_poverty_by_disability_nyc[,20] + vet_poverty_by_disability_nyc[,35] + vet_poverty_by_disability_nyc[,50]
df$veterans_poverty_disabled_percent_nyc <- ( df$veterans_poverty_disabled_nyc / df$total_veterans_nyc)*100

#employment figures...
oldC21005 = acs.lookup( table.number="C21005", endyear = 2015, span = 1)
vet_unemployed_nyc <- acs.fetch(geo = nyc_city, variable=oldC21005 , endyear = "2015", span = "1", col.names = "pretty")
vet_unemployed_nyc <- as.data.frame(vet_unemployed_nyc@estimate)
df$vet_total_nyc_18_64 <- vet_unemployed_nyc[,2]
df$veterans_unemployed_nyc <- vet_unemployed_nyc[,5]
df$veterans_unemployed_percent_nyc <- (df$veterans_unemployed_nyc /df$vet_total_nyc_18_64)*100

#service-connected disability statuses
oldC21100 = acs.lookup( table.number="C21100", endyear = 2015, span = 1)
vet_service_disability_nyc <- acs.fetch(geography = nyc_city, variable=oldC21100, endyear = "2015", span = "1", col.names="pretty")
vet_service_disability_nyc <- as.data.frame(vet_service_disability_nyc@estimate)
df$veterans_disabled_nyc <- vet_service_disability_nyc[,3]
df$veterans_disabled_percent_nyc<- (df$veterans_disabled_nyc/ vet_service_disability_nyc[,1])*100

setwd("C:/Users/seliger/Documents/NYC Data2Go")
write.csv(df, file = "nyc_city_acs_pull_5.1.19v.1.csv")

