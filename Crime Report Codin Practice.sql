-- Create Victims table
CREATE TABLE Victims (
    VictimID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    ContactInfor TEXT
);

-- Create Suspects table
CREATE TABLE Suspects (
    SuspectID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    ContactInfor TEXT
);

-- Create Law Enforcement Agencies table
CREATE TABLE LawEnforceAgen (
    AgencyID INT PRIMARY KEY,
    AgencyName VARCHAR(100),
    Juris VARCHAR(100),
    ContactInfor TEXT
);

-- Create Officers table
CREATE TABLE Officers (
    OfficerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BadgeNumber VARCHAR(20),
    Rank VARCHAR(50),
    ContactInfor TEXT,
    AgencyID INT,
    FOREIGN KEY (AgencyID) REFERENCES LawEnforceAgen(AgencyID)
);


-- Create Incidents table
CREATE TABLE Incidents (
    IncidentID INT PRIMARY KEY,
    IncidentType VARCHAR(50),
    IncidentDate DATE,
    Location VARCHAR(100),
    Description TEXT,
    Status VARCHAR(20),
    VictimID INT,
    SuspectID INT,
    FOREIGN KEY (VictimID) REFERENCES Victims(VictimID),
    FOREIGN KEY (SuspectID) REFERENCES Suspects(SuspectID)
);
-- Create Evidence table
CREATE TABLE Evidence (
    EvidenceID INT PRIMARY KEY,
    Description TEXT,
    LocFound VARCHAR(255),
    IncidentID INT,
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

-- Create Reports table
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY,
    IncidentID INT,
    ReportingOfficer INT,
    ReportDate DATE,
    ReportDetails TEXT,
    Status VARCHAR(20),
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID),
    FOREIGN KEY (ReportingOfficer) REFERENCES Officers(OfficerID)
);
-- Insert values into Victims table
INSERT INTO Victims (VictimID, FirstName, LastName, DateOfBirth, Gender, ContactInfor)
VALUES
    (1, 'John', 'Doe', '1990-05-15', 'Male', '123 Main St, City, Country, 12345, +1234567890'),
    (2, 'Jane', 'Smith', '1985-08-20', 'Female', '456 Oak St, City, Country, 56789, +9876543210'),
    (3, 'Robert', 'Johnson', '1978-12-10', 'Male', '789 Maple St, City, Country, 101112, +1122334455');
-- Insert values into Suspects table
INSERT INTO Suspects (SuspectID, FirstName, LastName, DateOfBirth, Gender, ContactInfor)
VALUES
    (1, 'Michael', 'Williams', '1982-04-25', 'Male', '321 Elm St, City, Country, 54321, +5544332211'),
    (2, 'Emily', 'Anderson', '1995-09-18', 'Female', '654 Pine St, City, Country, 87654, +6677889900'),
    (3, 'Daniel', 'Taylor', '1988-06-05', 'Male', '987 Cedar St, City, Country, 121314, +1314151617');
	-- Insert values into LawEnforcementAgencies table
INSERT INTO LawEnforceAgen (AgencyID, AgencyName, Juris, ContactInfor)
VALUES
    (1, 'City Police Department', 'City', '789 Station St, City, Country, 141516, +1617181920'),
    (2, 'County Sheriff Office', 'County', '101 Sheriff Ave, County, Country, 212223, +2324252627'),
    (3, 'State Bureau of Investigation', 'State', '345 State St, State, Country, 282930, +3031323334');
-- Insert values into Officers table
INSERT INTO Officers (OfficerID, FirstName, LastName, BadgeNumber, Rank, ContactInfor, AgencyID)
VALUES
    (1, 'David', 'Johnson', '12345', 'Sergeant', '111 Main St, City, Country, 13579, +9753102468', 1),
    (2, 'Michelle', 'Smith', '67890', 'Detective', '222 Oak St, City, Country, 24680, +8642097531', 2),
    (3, 'Brian', 'Williams', '54321', 'Lieutenant', '333 Elm St, City, Country, 98765, +5678123459', 3);
	-- Insert values into Incidents table
INSERT INTO Incidents (IncidentID, IncidentType, IncidentDate, Location, Description, Status, VictimID, SuspectID)
VALUES
    (1, 'Robbery', '2023-01-01', '(123 Main St, City, Country)', 'Armed robbery at a convenience store', 'Open', 1, 1),
    (2, 'Homicide', '2023-02-15', '(456 Oak St, City, Country)', 'Fatal shooting in downtown area', 'Closed', 2, 2),
    (3, 'Theft', '2023-03-20', '(789 Maple St, City, Country)', 'Shoplifting at a department store', 'Under Investigation', 3, 3);
--Insert values into Evidence table
INSERT INTO Evidence (EvidenceID, Description, LocFound, IncidentID)
VALUES
    (1, 'Gun found at the crime scene', 'Street corner, City', 1),
    (2, 'Knife found in suspects possession', 'Apartment building,City', 2),
    (3, 'Stolen merchandise recovered', 'Department store, City', 3);
-- Insert values into Reports table
INSERT INTO Reports (ReportID, IncidentID, ReportingOfficer, ReportDate, ReportDetails, Status)
VALUES
    (1, 1, 1, '2023-01-02', 'Initial incident report', 'Draft'),
    (2, 2, 2, '2023-02-20', 'Final investigation report', 'Finalized'),
    (3, 3, 3, '2023-03-25', 'Ongoing investigation report', 'Draft');
	--Q1)--
	select * from Incidents where Status='Open';
	--Q2)--
	select  Distinct count(IncidentType) as IncidentType from Incidents;
	--Q3)--
	select distinct IncidentType from Incidents;
	--Q4)--
	SELECT * FROM Incidents
    WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

	-Q5)--
	SELECT FirstName, LastName, DateOfBirth FROM (
    SELECT FirstName, LastName, DateOfBirth
    FROM Victims
    UNION
    SELECT FirstName, LastName, DateOfBirth
    FROM Suspects) as pir 
	ORDER BY DATEDIFF(YEAR, DateOfBirth, GETDATE()) DESC;
	--Q6)--
	select AVG(DATEDIFF(year,DateOfBirth,GETDATE())) as  AVG_AGE 
	from (SELECT DateOfBirth
    FROM Victims
    UNION
    SELECT DateOfBirth
    FROM Suspects) as pir;
	--Q7)--
	select IncidentType, Count(IncidentType) from Incidents 
	where Status='Open'
	Group by IncidentType;
	--Q8)--
	select * from (select lastname from Victims union select lastname from Suspects)as abc where lastname like'%Doe%';
	--Q9)--
SELECT FirstName, LastName, DateOfBirth, 'Open' AS CaseStatus
FROM Victims
WHERE EXISTS (
    SELECT 1
    FROM Incidents
    WHERE Victims.VictimID = Incidents.VictimID AND Incidents.Status = 'Open'
)

UNION

SELECT FirstName, LastName, DateOfBirth, 'Closed' AS CaseStatus
FROM Victims
WHERE EXISTS (
    SELECT 1
    FROM Incidents
    WHERE Victims.VictimID = Incidents.VictimID AND Incidents.Status = 'Closed'
)

UNION

SELECT FirstName, LastName, DateOfBirth, 'Open' AS CaseStatus
FROM Suspects
WHERE EXISTS (
    SELECT 1
    FROM Incidents
    WHERE Suspects.SuspectID = Incidents.SuspectID AND Incidents.Status = 'Open'
)

UNION

SELECT FirstName, LastName, DateOfBirth, 'Closed' AS CaseStatus
FROM Suspects
WHERE EXISTS (
    SELECT 1
    FROM Incidents
    WHERE Suspects.SuspectID = Incidents.SuspectID AND Incidents.Status = 'Closed'
);

--Q10)--

SELECT DISTINCT IncidentType
FROM (
    SELECT IncidentType
    FROM Victims
    INNER JOIN Incidents ON Victims.VictimID = Incidents.VictimID
    WHERE DATEDIFF(YEAR, Victims.DateOfBirth, GETDATE()) IN (30, 35)
    
    UNION
    
    SELECT IncidentType
    FROM Suspects
    INNER JOIN Incidents ON Suspects.SuspectID = Incidents.SuspectID
    WHERE DATEDIFF(YEAR, Suspects.DateOfBirth, GETDATE()) IN (30, 35)
) AS PersonsInvolved;
--Q11)--
SELECT DISTINCT FirstName, LastName, DateOfBirth
FROM (
    SELECT FirstName, LastName, DateOfBirth
    FROM Victims
    INNER JOIN Incidents ON Victims.VictimID = Incidents.VictimID
    WHERE Incidents.IncidentType = 'Robbery'
    
    UNION
    
    SELECT FirstName, LastName, DateOfBirth
    FROM Suspects
    INNER JOIN Incidents ON Suspects.SuspectID = Incidents.SuspectID
    WHERE Incidents.IncidentType = 'Robbery'
) AS PersonsInvolved;
--Q12)--
select IncidentType from Incidents where Status='Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;
--Q14)--
SELECT  I.IncidentType, V.VictimID, V.FirstName AS VFirstName, V.LastName AS VLastName,
S.SuspectID, S.FirstName AS SFirstName, S.LastName AS SLastName
FROM Incidents AS I
LEFT JOIN Victims AS V ON I.VictimID = V.VictimID
LEFT JOIN Suspects AS S ON I.SuspectID = S.SuspectID;
--Q16)--
SELECT Suspects.SuspectID, FirstName, LastName, COUNT(DISTINCT IncidentID) 
FROM Suspects
JOIN Incidents ON Suspects.SuspectID = Incidents.SuspectID
GROUP BY Suspects.SuspectID, FirstName, LastName
HAVING COUNT(DISTINCT IncidentID) > 1;
--Q17)--
select IncidentType from Incidents where SuspectID is null;
--Q18)--
SELECT *
FROM Incidents
WHERE IncidentType = 'Homicide' AND IncidentID IN (
    SELECT IncidentID
    FROM Incidents AS OtherIncidents
    WHERE OtherIncidents.IncidentType = 'Robbery'
);

--Q19)--
SELECT I.IncidentID,I.IncidentType,S.SuspectID,
CASE WHEN S.SuspectID IS NOT NULL THEN S.FirstName ELSE 'No Suspect' END AS SuspectFirstName,
CASE WHEN S.SuspectID IS NOT NULL THEN S.LastName ELSE 'No Suspect' END AS SuspectLastName,
CASE WHEN S.SuspectID IS NOT NULL THEN S.DateOfBirth ELSE 'No Suspect' END AS SuspectDateOfBirth
FROM Incidents AS I
LEFT JOIN Suspects AS S ON I.SuspectID = S.SuspectID;

--Q20)-- 
SELECT DISTINCT S.SuspectID,S.FirstName,S.LastName,S.DateOfBirth
FROM Suspects S
JOIN Incidents I ON S.SuspectID = I.SuspectID
WHERE I.IncidentType IN ('Robbery', 'Assault');

    



