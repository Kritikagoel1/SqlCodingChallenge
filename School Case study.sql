-- Create CourseMaster Table
CREATE TABLE CourseMaster (
    CID INTEGER PRIMARY KEY,
    CourseName VARCHAR(40) NOT NULL,
    Category CHAR(1) NULL CHECK (Category IN ('B', 'M', 'A')),
    Fee SMALLMONEY NOT NULL CHECK (Fee >= 0)
);

-- Create StudentMaster Table
CREATE TABLE StudentMaster (
    SID TINYINT PRIMARY KEY,
    StudentName VARCHAR(40) NOT NULL,
    Origin CHAR(1) NOT NULL CHECK (Origin IN ('L', 'F')),
    Type CHAR(1) NOT NULL CHECK (Type IN ('U', 'G'))
);

-- Create EnrollmentMaster Table
CREATE TABLE EnrollmentMaster (
    CID INTEGER NOT NULL,
    SID TINYINT NOT NULL,
    DOE DATETIME NOT NULL,
    FWF BIT NOT NULL,
    Grade CHAR(1) CHECK (Grade IN ('O', 'A', 'B', 'C')),
    PRIMARY KEY (CID, SID),
    FOREIGN KEY (CID) REFERENCES CourseMaster(CID),
    FOREIGN KEY (SID) REFERENCES StudentMaster(SID)
);

-- Insert values into CourseMaster table
INSERT INTO CourseMaster (CID, CourseName, Category, Fee)
VALUES 
(1, 'Professional Comm', 'A', 500.00),
(2, 'Maths', 'M', 750.00),
(3, 'Computer Science', 'A', 1000.00),
(4, 'DBMS', 'B', 600.00),
(5, 'Data Structures', 'M', 800.00),
(6, 'Operating System', 'A', 1200.00),
(7, 'Machine Learning', 'B', 550.00),
(8, 'OOPS', 'M', 900.00),
(9, 'Programming Basics', 'A', 1500.00),
(10, 'Introduction to Java', 'B', 700.00);

-- Insert values into StudentMaster table
INSERT INTO StudentMaster (SID, StudentName, Origin, Type)
VALUES 
(1, 'John Doe', 'L', 'U'),
(2, 'Jane Smith', 'F', 'G'),
(3, 'Mike Johnson', 'L', 'U'),
(4, 'Emily White', 'F', 'G'),
(5, 'Chris Brown', 'L', 'U'),
(6, 'Olivia Taylor', 'F', 'G'),
(7, 'Daniel Lee', 'L', 'U'),
(8, 'Sophia Rodriguez', 'F', 'G'),
(9, 'William Miller', 'L', 'U'),
(10, 'Emma Davis', 'F', 'G');


-- Insert values into EnrollmentMaster table
INSERT INTO EnrollmentMaster (CID, SID, DOE, FWF, Grade)
VALUES 
(1, 1, '2023-01-01', 0, 'A'),
(2, 2, '2023-02-15', 1, 'B'),
(3, 3, '2023-03-10', 0, 'C'),
(4, 4, '2023-04-05', 1, 'A'),
(5, 5, '2023-05-20', 0, 'B'),
(6, 6, '2023-06-15', 1, 'C'),
(7, 7, '2023-07-01', 0, 'A'),
(8, 8, '2023-08-10', 1, 'B'),
(9, 9, '2023-09-25', 0, 'C'),
(10, 10, '2023-10-15', 1, 'A');

--Q1
SELECT CM.CourseName,
COUNT(EM.SID) AS TotalStudentsEnrolled
FROM CourseMaster CM
JOIN EnrollmentMaster EM ON CM.CID = EM.CID
JOIN StudentMaster SM ON EM.SID = SM.SID
WHERE SM.Origin = 'F'
GROUP BY CM.CourseName
HAVING COUNT(EM.SID) > 10;
--Q2
select sm.StudentName from StudentMaster sm
join EnrollmentMaster em on sm.SID=em.SID
join CourseMaster cm on cm.CID=em.CID
where cm.CourseName Not In ('Introduction to Java')
GROUP BY sm.StudentName;
--Q3
WITH RankedCourses AS (
SELECT cm.CourseName,
RANK() OVER (ORDER BY COUNT(*) DESC) AS EnrollmentRank
FROM CourseMaster cm
JOIN EnrollmentMaster em ON cm.CID = em.CID
JOIN StudentMaster sm ON em.SID = sm.SID
WHERE cm.Category = 'A' AND sm.Origin = 'F'
GROUP BY cm.CourseName)
SELECT CourseName
FROM RankedCourses
WHERE EnrollmentRank = 1;
--Q4
select sm.StudentName from StudentMaster sm
join EnrollmentMaster em on sm.SID=em.SID
join CourseMaster cm on cm.CID=em.CID
where cm.Category='B' And MONTH(em.DOE)=MONTH(GETDATE()) AND YEAR(em.DOE) = YEAR(GETDATE());
--Q5
Select sm.StudentName FROM StudentMaster sm
JOIN EnrollmentMaster em ON sm.SID = em.SID
JOIN CourseMaster cm ON cm.CID = em.CID
WHERE sm.Type = 'U' AND sm.Origin = 'L' AND cm.Category = 'B' AND em.Grade = 'C';
--Q6
SELECT cm.CourseName
FROM CourseMaster cm
WHERE NOT EXISTS 
(SELECT 1 FROM EnrollmentMaster em
WHERE em.CID = cm.CID AND MONTH(em.DOE) = 5 AND YEAR(em.DOE) = 2020);
--Q7
SELECT cm.CourseName,
COUNT(em.SID) AS NumberofEnrollments,
CASE
WHEN COUNT(em.SID) > 50 THEN 'High'
WHEN COUNT(em.SID) >= 20 AND COUNT(em.SID) <= 50 THEN 'Medium'
ELSE 'Low'
END AS Popularity
FROM CourseMaster cm
LEFT JOIN EnrollmentMaster em ON cm.CID = em.CID
GROUP BY cm.CourseName;
--Q8
SELECT sm.StudentName,cm.CourseName,em.DOE AS EnrollmentDate,
DATEDIFF(DAY, em.DOE, GETDATE()) AS AgeOfEnrollmentInDays
FROM EnrollmentMaster em
JOIN CourseMaster cm ON cm.CID = em.CID
JOIN StudentMaster sm ON sm.SID = em.SID
WHERE em.DOE = (SELECT MAX(DOE) FROM EnrollmentMaster WHERE SID = em.SID AND CID = em.CID);
--Q9
SELECT sm.StudentName
FROM StudentMaster sm
JOIN EnrollmentMaster em ON sm.SID = em.SID
JOIN CourseMaster cm ON cm.CID = em.CID
WHERE sm.Origin = 'L' AND cm.Category = 'B'
GROUP BY sm.StudentName
HAVING COUNT(DISTINCT em.CID) = 3;
--Q10
SELECT cm.CourseName
FROM CourseMaster cm
WHERE NOT EXISTS (SELECT 1 FROM StudentMaster sm
WHERE NOT EXISTS (SELECT 1 FROM EnrollmentMaster em
WHERE em.SID = sm.SID AND em.CID = cm.CID));
--Q11
SELECT sm.StudentName
FROM StudentMaster sm
JOIN EnrollmentMaster em ON sm.SID = em.SID
WHERE em.FWF = 1 AND em.Grade = 'O';
--Q12
SELECT DISTINCT sm.StudentName
FROM StudentMaster sm
JOIN EnrollmentMaster em ON sm.SID = em.SID
JOIN CourseMaster cm ON cm.CID = em.CID
WHERE sm.Origin = 'F' AND sm.Type = 'U' AND cm.Category = 'B' AND em.Grade = 'C';
--Q13
SELECT cm.CourseName,COUNT(em.SID) AS TotalEnrollments
FROM CourseMaster cm
LEFT JOIN EnrollmentMaster em ON cm.CID = em.CID
WHERE MONTH(em.DOE) = MONTH(GETDATE()) AND YEAR(em.DOE) = YEAR(GETDATE())
GROUP BY cm.CourseName;


