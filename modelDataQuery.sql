-- View the tables

SELECT *
FROM Accenture..Reactions

SELECT *
FROM Accenture..Session

-- Cleaning up the Content Column

UPDATE Accenture..Content
SET Category=REPLACE(Category,'"','')

--to count the most popular category

SELECT DISTINCT(Category) AS Category,COUNT(Category) as Number
INTO Accenture..categoryCount
FROM Accenture..Content
GROUP BY Category
ORDER BY Number DESC

-- top 5 categories

SELECT TOP 5*
FROM Accenture..categoryCount

--to create the model data table

SELECT us.UserID, us.Email, con.ContentID, con.Category, con.Type, pro.Interests, pro.Age, ses.Duration
INTO Accenture..modelData
FROM Accenture..User1 AS us
JOIN Accenture..Content AS con
ON us.UserID = con.UserID
JOIN Accenture..Profile AS pro
ON con.UserID = pro.UserID
JOIN Accenture..Session AS ses
ON pro.UserID= ses.UserID

-- show the model data

SELECT *
FROM Accenture..modelData

--modify the model data to remove duplicate content

WITH CTE AS(
   SELECT *,
       RN = ROW_NUMBER()OVER(PARTITION BY ContentID ORDER BY ContentID)
   FROM Accenture..modelData
)
DELETE FROM CTE WHERE RN > 1


