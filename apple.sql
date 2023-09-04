CREATE TABLE Appled_description_combined AS

SELECT * FROM appleStore_description1
UNION ALL

SELECT * FROM appleStore_description2
UNION ALL

SELECT * FROM appleStore_description3
UNION ALL

SELECT * FROM appleStore_description4

--check the unique number of apps in the dataset

SELECT COUNT(DISTINCT id) AS Uniqueid
FROM AppleStore

SELECT COUNT(DISTINCT id) AS Uniqueid
FROM Appled_description_combined

--check the missing values 

SELECT COUNT(*) AS Missingvalues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS Missingvalues
FROM Appled_description_combined
WHERE app_desc IS NULL 

--find out the famous genre app

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--overview of the app ratings

SELECT min(user_rating) AS Min_rating, max(user_rating) AS Max_rating,
       avg(user_rating) AS Average_rating
FROM AppleStore

--check whether paid apps have higher rating than free apps

SELECT CASE 
WHEN price > 0 THEN 'Paid'
ELSE 'Free'
END AS Apptype,
avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY Apptype

--check if apps that support more languages have more ratings

SELECT CASE 
WHEN lang_num < 10 THEN 'less than 10'
WHEN lang_num BETWEEN 10 AND 30 THEN '10 - 30 languages'
ELSE '> 30 languages'
END AS lang_bucket,
avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY lang_bucket
ORDER BY Avg_Rating DESC

--check genre with low rating

SELECT prime_genre, avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10

--check if there is a coorelation between the description and the user rating

SELECT CASE 
WHEN length(b.app_desc) < 500 THEN 'short'
WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
ELSE 'Long'
END AS description_length_bucket,
avg(user_rating) AS Avg_Rating
FROM AppleStore AS A
JOIN
Appled_description_combined AS B
ON
a.id = b.id
GROUP By description_length_bucket
ORDER By Avg_Rating DESC

--check the top rated apps for each genre

SELECT prime_genre, track_name, user_rating
FROM (
  SELECT prime_genre, track_name, user_rating,
  RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
  FROM AppleStore
  ) AS A
 WHERE A.rank = 1
  