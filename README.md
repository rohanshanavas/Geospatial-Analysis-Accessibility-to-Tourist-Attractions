# Spatial-Analysis-Public-Transport-Accessibility-to-Attractions-in-Ireland

## Overview

This project aims to understand tourism accessibility in Ireland, particularly focusing on attractions and public transportation, which are essential components of Ireland's tourism industry. This project involves analyzing the spatial distribution of attractions and public transportation and their impact on accessibility for tourists. To achieve this, the analysis utilizes spatial data processing tools such as QGIS for visualization and analysis, with supplementary database setup provided for PostgreSQL in pgAdmin for data management and querying. The spatial data used in this analysis includes datasets for attractions, public transportation stops, and county boundaries within the Republic of Ireland.

## Spatial Data Description

The spatial data utilized for this analysis was sourced from data.gov.ie, which offers access to Irish public sector data. The datasets used encompass information on attractions and public transportation stops, initially acquired in CSV format. These CSV files were subsequently converted into Shapefiles to facilitate spatial analysis. Additionally, the datasets were further transformed into PostgreSQL files for enhanced data analysis capabilities.

Furthermore, the county shapefile was obtained from Townlands.ie, containing spatial information for all 26 counties within the Republic of Ireland. This dataset serves as a crucial component for understanding the regional distribution of attractions and public transportation facilities.

These spatial datasets form the foundation of the analysis, enabling insights into tourism accessibility and transportation infrastructure across Ireland.

## Queries for Insights

Several queries were executed to extract insights into tourism accessibility:

1. **Attractions Table - Self Join:** Identify unique pairs of attractions within a certain distance.
2. **Transportation Table - Self Join:** Similar self-join operation performed on the transportation table.
3. **Attractions and Transportation Table - JOIN by distance:** Spatial join of attractions and transportation tables to find unique pairs within a certain distance.
4. **Distance from each Attraction to Nearest Public Transportation Stop:** Calculation of the distance from attractions to the nearest public transportation stop.
5. **Choropleth Analysis for Attractions and Stops:** Point-in-polygon analysis to determine the number of attractions and stops in each county.
