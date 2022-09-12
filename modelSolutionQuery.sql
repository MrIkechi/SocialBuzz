
SELECT Type
FROM Accenture..Reactions

SELECT *
FROM Accenture..Content

--to create the solution model

SELECT re.ContentID, re.Type AS reactionType, re.Datetime, con.UserID, con.Type AS mediaType, con.Category
INTO Accenture..solutionModel
FROM Accenture..Reactions as re
LEFT JOIN Accenture..Content as con
ON re.ContentID = con.ContentID

-- to remove duplicates (not necessary)

WITH CTE AS(
   SELECT *,
       RN = ROW_NUMBER()OVER(PARTITION BY ContentID ORDER BY ContentID)
   FROM Accenture..solutionModel
)
DELETE FROM CTE WHERE RN > 1

-- show the model data

SELECT *
FROM Accenture..solutionModel

-- to delete this table from database

DROP TABLE Accenture..solutionModel

SELECT *
FROM Accenture..ReactionTypes

SELECT sol.*, ret.Type, ret.Sentiment, ret.Score
FROM Accenture..solutionModel AS sol
LEFT JOIN Accenture..ReactionTypes as ret
ON sol.reactionType = ret.Type

-- measure popularity of content

SELECT sol.*, ret.Type, ret.Sentiment, ret.Score
INTO #table
FROM Accenture..solutionModel AS sol
LEFT JOIN Accenture..ReactionTypes as ret
ON sol.reactionType = ret.Type

SELECT Category, SUM(Score) AS Score
FROM  #table
GROUP BY Category
ORDER BY Score DESC