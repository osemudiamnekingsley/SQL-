
-- Create Boat Table

CREATE TABLE Boat_T(
  BoatID INT NOT NULL,
  BoatType VARCHAR(200) NOT NULL,
  BoatLength INT NOT NULL,
  CONSTRAINT Boat_PK PRIMARY KEY (BoatID)
);

-- Populate Boat Table

INSERT INTO Boat_T (BoatID, BoatType, BoatLength)
VALUES(1, 'Motorboat', 12);

INSERT INTO Boat_T (BoatID, BoatType, BoatLength)
VALUES(2, 'Pontoon', 17);

INSERT INTO Boat_T (BoatID, BoatType, BoatLength)
VALUES(3, 'Rowboat', 15);

INSERT INTO Boat_T (BoatID, BoatType, BoatLength)
VALUES(4, 'Sailboat', 26);
    
INSERT INTO Boat_T (BoatID, BoatType, BoatLength)
VALUES(5, 'Yacht', 14);

-- Create Sailor Tables

CREATE TABLE Sailor_T(
  SailorID INT NOT NULL,
  SailorName VARCHAR(200) NOT NULL,
  BirthDate TEXT NOT NULL,
  RatePerDay INT NOT NULL,
  CONSTRAINT Sailor_PK PRIMARY KEY (SailorID)
);

--Populate Sailor Table

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES (1, 'Smith', '1997-01-20', 3);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(2, 'Mike', '2019-05-03', 7);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(3, 'Jake', '2020-01-30', 5);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(4, 'Ross', '1996-11-10', 12);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(5, 'Drake', '1991-05-11', 7);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(6, 'Kai', '2014-12-14', 17);

INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(7, 'Rose', '2011-12-15',15);
    
    INSERT INTO Sailor_T (SailorID, SailorName, BirthDate, RatePerDay)
VALUES(8, 'Blake', '2001-04-05',21);

--Create Reserves Table

CREATE TABLE Reserves_T(
  SailorID INT NOT NULL,
  BoatID INT NOT NULL,
  Day VARCHAR(20) NOT NULL, 
  CONSTRAINT Reserves_PK PRIMARY KEY (SailorID, BoatID, Day),
  CONSTRAINT SailorID_FK FOREIGN KEY (SailorID) REFERENCES Sailor_T(SailorID),
  CONSTRAINT BoatID_FK FOREIGN KEY (BoatID) REFERENCES Boat_T(BoatID)
);

-- Populate Reserve Table

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES  (2, 2, 'Saturday');

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 1, 'Friday');

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (3, 5, 'Sunday');  

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (4, 3, 'Monday');
    
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (6, 1, 'Tuesday');
    
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (5, 2, 'Tuesday'); 
    
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (5, 4, 'Sunday');
    
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (2, 1, 'Saturday'); 
     
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (2, 3, 'Friday');
        
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (2, 4, 'Sunday'); 
       
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 3, 'Monday');
        
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 2, 'Tuesday');  
        
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 4, 'Sunday');
       
INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 5, 'Sunday');

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES (1, 5, 'Tuesday');

INSERT INTO Reserves_T (SailorID, BoatID, Day)
VALUES(1, 5, 'Friday');



/* Question 1: Retrieve the sailors' names who reserved both Pontoon and Sailboat boats 
(meaning they reserved at least one Pontoon and one Sailboat). */

SELECT DISTINCT S.SailorName, B.BoatType
FROM Sailor_T S
JOIN Reserves_T R ON S.SailorID = R.SailorID
JOIN Boat_T B ON R.BoatID = B.BoatID
WHERE B.BoatType IN ('Pontoon', 'Sailboat')
AND EXISTS (
    SELECT 1 
    FROM Reserves_T R1
    JOIN Boat_T B1 ON R1.BoatID = B1.BoatID
    WHERE R1.SailorID = S.SailorID AND B1.BoatType = 'Pontoon'
)
AND EXISTS (
    SELECT 1 
    FROM Reserves_T R2
    JOIN Boat_T B2 ON R2.BoatID = B2.BoatID
    WHERE R2.SailorID = S.SailorID AND B2.BoatType = 'Sailboat'
);


/* Question 2: Retrieve the names of the sailors who have reserved every type of boat.  
Want a hint: Can you write a query that returns the number of distinct boat types?  
Also, consider using HAVING. */

SELECT DISTINCT SailorName, BoatType
FROM Reserves_T
JOIN Sailor_T ON Reserves_T.SailorID = Sailor_T.SailorID
JOIN Boat_T ON Reserves_T.BoatID = Boat_T.BoatID

WHERE Sailor_T.SailorID IN (
    SELECT Reserves_T.SailorID
    FROM Reserves_T
    JOIN Boat_T ON Reserves_T.BoatID = Boat_T.BoatID
    GROUP BY Reserves_T.SailorID
    HAVING COUNT(DISTINCT Boat_T.BoatType) = (SELECT COUNT(DISTINCT Boat_T.BoatType) FROM Boat_T))
ORDER BY Sailor_T.SailorName, Boat_T.BoatType;

/* Question 3: Retrieve the name of the sailor who reserved the most distinct count of boats 
that are of the type Yacht. */

SELECT SailorName, COUNT(BoatType) as YachtCount
FROM Reserves_T
JOIN Sailor_T ON Reserves_T.SailorID = Sailor_T.SailorID
JOIN Boat_T ON Reserves_T.BoatID = Boat_T.BoatID
WHERE BoatType = 'Yacht'
GROUP BY SailorName
ORDER BY COUNT(DISTINCT Reserves_T.BoatID) DESC
LIMIT 1;


/* Question 4) Retrieve the names of sailors who have reserved boats with a daily rate greater than 10, 
 and list the boat types they reserved. */

select SailorName, BoatType, RatePerDay
FROM Sailor_T
Join Reserves_T ON Sailor_T.SailorID = Reserves_T.SailorID
JOIN Boat_T ON Reserves_T.BoatID = Boat_T.BoatID
WHERE RatePerDay >10;

