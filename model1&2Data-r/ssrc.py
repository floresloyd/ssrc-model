import cenpy
import pandas as pd

# Set your Census API key here
census_api_key = '5b498d1ae7076f392073d199334c5cc03aba91bc'

# Create a connection to the Census API
connection = cenpy.products.APIConnection('ACSDT5Y2021', apikey=census_api_key)

# Define geographies
nyc_city = connection.from_place('New York city', state='NY')
nyc_boro = connection.from_county(['Bronx', 'Kings', 'New York', 'Queens', 'Richmond'], state='NY')
nyc_puma = connection.from_puma(['3701', '3702', '3703', '3704', '3705', '3706', '3707', '3708', '3709', '3710',
                                 '4001', '4002', '4003', '4004', '4005', '4006', '4007', '4008', '4009', '4010',
                                 '4011', '4012', '4013', '4014', '4015', '4016', '4017', '4018', '3801', '3802',
                                 '3803', '3804', '3805', '3806', '3807', '3808', '3809', '3810', '4101', '4102',
                                 '4103', '4104', '4105', '4106', '4107', '4108', '4109', '4110', '4111', '4112',
                                 '4113', '4114', '3901', '3902', '3903'], state='NY')

# FETCH POPULATION DATA
variables = connection.varslike('B01003_001E')
df = connection.query(variables, geo_filter=nyc_city)
df = df.rename(columns={'B01003_001E': 'age_pyramid_total_nyc'})
# Convert the DataFrame to a CSV file or perform any additional data processing as needed
df.to_csv('nyc_population.csv', index=False)

# FETCH MEDIAN INCOME PER HOUSEHOLD DATA
medianinc = connection.from_place('New York city', state='NY', table='B19013', year=2021, span='1')
medianinc = medianinc.rename(columns={'B19013_001E': 'median_household_income_nyc'})
# Merge the median income data into the existing DataFrame 'df'
df = pd.merge(df, medianinc[['GEOID', 'median_household_income_nyc']], on='GEOID', how='left')

# FETCH MEDIAN INCOME PER PERSON DATA
medianinc_personal = connection.from_place('New York city', state='NY', table='B20017', year=2021, span='1')
medianinc_personal = medianinc_personal.rename(columns={'B20017_001E': 'median_personal_earnings_nyc'})
# Merge the median income per person data into the existing DataFrame 'df'
df = pd.merge(df, medianinc_personal[['GEOID', 'median_personal_earnings_nyc']], on='GEOID', how='left')

# EDUCATION 
# FETCH EDUCATION DATA - NEW FEATURE 
oldB15002 = connection.varslike('B15002', year=2021, span='1')
education = connection.query(oldB15002, geo_filter=nyc_city)
education = education.rename(columns={'B15002_001E': 'no_high_school',
                                      'B15002_002E': 'at_least_hs',
                                      'B15002_015E': 'at_least_bachelors'})
# Convert the DataFrame to a CSV file or perform any additional data processing as needed
education.to_csv('nyc_education.csv', index=False)


# Calculate education indicators and add them to the DataFrame 'df'
# No HS
education['no_hs_nyc'] = (education.iloc[:, 2:10].sum(axis=1) + education.iloc[:, 20:27].sum(axis=1)) / education.iloc[:, 1] * 100
# At least HS
education['at_least_hs_nyc'] = (education.iloc[:, 11:18].sum(axis=1) + education.iloc[:, 28:35].sum(axis=1)) / education.iloc[:, 1] * 100
# HS and some college
education['complete_hs_somecollege_nyc'] = (education.iloc[:, 11:14].sum(axis=1) + education.iloc[:, 28:31].sum(axis=1)) / education.iloc[:, 1] * 100
# Completed Bachelor's
education['complete_bach_nyc'] = (education.iloc[:, 15] + education.iloc[:, 32]) / education.iloc[:, 1] * 100
# At least Bachelor's
education['at_least_bachelors_nyc'] = (education.iloc[:, 15:18].sum(axis=1) + education.iloc[:, 32:35].sum(axis=1)) / education.iloc[:, 1] * 100
# Graduate Degree
education['grad_degree_nyc'] = (education.iloc[:, 16:18].sum(axis=1) + education.iloc[:, 33:35].sum(axis=1)) / education.iloc[:, 1] * 100
# Add the calculated education indicators to the existing DataFrame 'df'
df['no_hs_nyc'] = education['no_hs_nyc']
df['at_least_hs_nyc'] = education['at_least_hs_nyc']
df['complete_hs_somecollege_nyc'] = education['complete_hs_somecollege_nyc']
df['complete_bach_nyc'] = education['complete_bach_nyc']
df['at_least_bachelors_nyc'] = education['at_least_bachelors_nyc']
df['grad_degree_nyc'] = education['grad_degree_nyc']

# RACE / ETHNICITY
# FETCH RACE DATA - NEW FEATURE 
# Fetch race/ethnicity data
race = connection.from_place('New York city', state='NY', table='B03002', year=2021, span='1')
total_race = race.rename(columns={'B03002_001E': 'total_population'})

# Convert the DataFrame to a CSV file or perform any additional data processing as needed
total_race.to_csv('nyc_race_ethnicity.csv', index=False)

# Calculate race/ethnicity indicators and add them to the DataFrame 'df'
# Latino Population
df['latino_pop_nyc'] = (total_race.iloc[:, 12] / total_race.iloc[:, 1]) * 100
# White Population
df['white_pop_nyc'] = (total_race.iloc[:, 3] / total_race.iloc[:, 1]) * 100
# African American Population
df['aframer_pop_nyc'] = (total_race.iloc[:, 4] / total_race.iloc[:, 1]) * 100
# Native American Population
df['natamer_pop_nyc'] = (total_race.iloc[:, 5] / total_race.iloc[:, 1]) * 100
# Asian and Pacific Islander Population
df['asian_api_pop_nyc'] = (total_race.iloc[:, 6:7].sum(axis=1) / total_race.iloc[:, 1]) * 100
# Other Population
df['other_pop_nyc'] = (total_race.iloc[:, 8:9].sum(axis=1) / total_race.iloc[:, 1]) * 100

# RACE TOTALS
# Calculate race/ethnicity totals and add them to the DataFrame 'df'
# Asian and Pacific Islander Total Population
df['asian_api_total_nyc'] = total_race.iloc[:, 6:7].sum(axis=1)
# Latino Total Population
df['latino_total_pop_nyc'] = total_race.iloc[:, 12]
# White Total Population
df['white_total_pop_nyc'] = total_race.iloc[:, 3]
# African American Total Population
df['aframer_total_pop_nyc'] = total_race.iloc[:, 4]
# Native American Total Population
df['natamer_total_pop_nyc'] = total_race.iloc[:, 5]
# Other Total Population
df['other_total_pop_nyc'] = total_race.iloc[:, 8:9].sum(axis=1)


# UNEMPLOYMENT STATUS
# # Fetch unemployment status data
oldB23001 = connection.varslike('B23001', year=2021, span='1')
unemployment = connection.query(oldB23001, geo_filter=nyc_city)
unemployment = unemployment.rename(columns={'B23001_001E': 'total_population'})
# Convert the DataFrame to a CSV file or perform any additional data processing as needed
unemployment.to_csv('nyc_unemployment.csv', index=False) 
# LAST LINE ON R is 177

