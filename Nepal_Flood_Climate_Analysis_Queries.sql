CREATE DATABASE nepal_flood_analysis;
use nepal_flood_analysis;
SELECT COUNT(*) AS total_records
FROM flood_weather;

SELECT *
FROM flood_weather
LIMIT 5;

SHOW COLUMNS FROM flood_weather;
ALTER TABLE flood_weather
CHANGE COLUMN `ï»¿date` `date` DATE;

SHOW COLUMNS FROM flood_weather;
SELECT COUNT(*) AS total_records
FROM flood_weather;

SELECT date, location, precipitation_mm, rain_mm, temperature_mean_c
FROM flood_weather
LIMIT 5;

-- A. Climate & Time-Series Analysis
-- Q1. How does rainfall change month by month over the available years?

SELECT YEAR(date) AS year, MONTH(date)
AS month, ROUND(AVG(rain_mm), 2)
AS avg_rain_mm, ROUND(SUM(rain_mm), 2)
AS sum_rain_mm
FROM flood_weather
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- Q2. Which months have the highest and lowest average rainfall?

SELECT MONTH(date) AS month_number, MONTHNAME(date)
AS month_name, ROUND(AVG(rain_mm), 2) AS avg_rain_mm
FROM flood_weather
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY avg_rain_mm DESC;

-- Q3. How does average rainfall vary from year to year?

SELECT YEAR(date) AS year, COUNT(*)
AS observations, ROUND(AVG(rain_mm), 2)
AS avg_rain_mm, ROUND(SUM(rain_mm), 2) AS sum_rain_mm
FROM flood_weather
GROUP BY YEAR(date)
ORDER BY year;

-- Q4. How does the average temperature change month by month over the years?

SELECT YEAR(date) AS year, MONTH(date)
AS month, ROUND(AVG(temperature_mean_c), 2) AS avg_temp_c
FROM flood_weather
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- Q5. How does soil moisture vary month by month over the years?

SELECT YEAR(date) AS year, MONTH(date)
AS month, ROUND(AVG(soil_moisture_0_100cm_m3m3), 3)
AS avg_soil_moisture
FROM flood_weather
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- B. Location-Wise Analysis
-- Q6.a) Which locations have the highest and average rainfall?

SELECT location, ROUND(AVG(rain_mm), 2)
AS avg_rain_mm, ROUND(MAX(rain_mm), 2)
AS max_rain_mm
FROM flood_weather
GROUP BY location
ORDER BY avg_rain_mm DESC;

-- Q6.b) Which locations have the lowest and average rainfall?

SELECT location, ROUND(AVG(rain_mm), 2)
AS avg_rain_mm, ROUND(MIN(rain_mm), 2)
AS min_rain_mm
FROM flood_weather
GROUP BY location
ORDER BY avg_rain_mm ASC;

-- Q7. Which locations have the highest average soil moisture?

SELECT location, ROUND(AVG(soil_moisture_0_100cm_m3m3), 3)
AS avg_soil_moisture
FROM flood_weather
GROUP BY location
ORDER BY avg_soil_moisture DESC;

-- Q8. Which locations record the highest maximum rainfall?

SELECT location, ROUND(MAX(rain_mm), 2)
AS max_rain_mm
FROM flood_weather
GROUP BY location
ORDER BY max_rain_mm DESC;

-- C. River Discharge Analysis
-- Q9. Which rivers have the highest average and maximum recorded discharge?

SELECT river, ROUND(AVG(river_discharge_m3s), 2)
AS avg_discharge_m3s, ROUND(MAX(river_discharge_m3s), 2)
AS max_discharge_m3s
FROM flood_weather
WHERE river_discharge_m3s IS NOT NULL
GROUP BY river
ORDER BY avg_discharge_m3s DESC;

-- Q10. What are the top 10 observations with the highest river discharge?

SELECT date, location, river, river_discharge_m3s
FROM flood_weather
WHERE river_discharge_m3s IS NOT NULL
ORDER BY river_discharge_m3s DESC
LIMIT 10;

-- D. Rainfall & River Relationship
-- Q11. How do average rainfall and average river discharge compare across locations?

-- Q11: Rainfall vs River Discharge by Location

SELECT location, ROUND(AVG(rain_mm), 2)
AS avg_rain_mm, ROUND(AVG(river_discharge_m3s), 2)
AS avg_discharge_m3s, COUNT(*) AS valid_observations
FROM flood_weather
WHERE rain_mm IS NOT NULL AND river_discharge_m3s IS NOT NULL
GROUP BY location
ORDER BY avg_rain_mm DESC;

-- Q12. Is there an observable relationship between rainfall and river discharge in the dataset?

SELECT ROUND(rain_mm, 1) AS rainfall_mm, COUNT(*)
AS observations, ROUND(AVG(river_discharge_m3s), 2)
AS avg_discharge_m3s
FROM flood_weather
WHERE rain_mm IS NOT NULL
AND river_discharge_m3s IS NOT NULL
GROUP BY ROUND(rain_mm, 1)
ORDER BY rainfall_mm;

-- E. Additional Weather Indicators
-- Q13. Which locations record the highest average precipitation hours?

SELECT location, ROUND(AVG(precipitation_hours), 2)
AS avg_precipitation_hours, MAX(precipitation_hours)
AS max_precipitation_hours
FROM flood_weather
GROUP BY location
ORDER BY avg_precipitation_hours DESC;

-- Q14. How does average humidity vary across different rainfall categories?

SELECT CASE
WHEN rain_mm = 0 THEN 'No Recorded Rain'
WHEN rain_mm > 0 AND rain_mm < 10
THEN 'Light Rainfall'
WHEN rain_mm >= 10 AND rain_mm < 30
THEN 'Moderate Rainfall'
ELSE 'Heavy Rainfall'
END AS rainfall_category, COUNT(*)
AS observations, ROUND(AVG(relative_humidity_mean_pct), 2)
AS avg_humidity_pct
FROM flood_weather
WHERE rain_mm IS NOT NULL
GROUP BY rainfall_category
ORDER BY avg_humidity_pct DESC;

-- Q15. Which locations record the highest maximum wind gusts?

-- Q15: Maximum Wind Gusts by Location

SELECT location, ROUND(MAX(wind_gusts_max_kmh), 2)
AS max_gust_kmh, ROUND(AVG(wind_gusts_max_kmh), 2)
AS avg_gust_kmh
FROM flood_weather
GROUP BY location
ORDER BY max_gust_kmh DESC;