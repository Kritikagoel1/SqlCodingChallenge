-- Create the Artists table
CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));
-- Create the Categories table
CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);
-- Create the Artworks table
CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));
-- Create the Exhibitions table
CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);
-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));
-- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');
-- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');
-- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, 
ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picassos powerful anti-war mural', 'guernica.jpg');
-- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) 
VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');
-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);
 --1--
SELECT ArtistID,Name AS ArtistName, COUNT(*) AS NumArtworks
FROM Artists
GROUP BY ArtistID, Name
ORDER BY NumArtworks DESC;
--2--
SELECT aw.Title, aw.Year FROM Artists a
join ArtWorks aw on aw.ArtistId= a.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY Year ASC;
--3--
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS PaintingCount
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Categories.Name = 'Painting'
GROUP BY Artists.ArtistID,Artists.Name;
--4--
SELECT Artworks.Title, Artists.Name AS Artist, Categories.Name AS Category
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
JOIN Categories ON Artworks.CategoryID = Categories.CategoryID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';
--5--
SELECT Artists.Name FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.Name
HAVING COUNT(Artworks.ArtworkID) > 2;

--6--
SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE Exhibitions.Title IN ('Modern Art Masterpieces', 'Renaissance Art')
GROUP BY Artworks.ArtworkID,Artworks.Title
HAVING COUNT(DISTINCT Exhibitions.ExhibitionID) = 2;

--7--
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY  Categories.Name,Artworks.ArtworkID;
--8--
SELECT Artists.Name FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID,Artists.Name
HAVING COUNT(Artworks.ArtworkID)> 3;
--9--
SELECT Artworks.Title, Artists.Name, Artists.Nationality
FROM Artworks
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Nationality = 'Spanish';
--10--
SELECT Exhibitions.Title FROM Exhibitions
JOIN ExhibitionArtworks ON Exhibitions.ExhibitionID = ExhibitionArtworks.ExhibitionID
JOIN Artworks ON ExhibitionArtworks.ArtworkID = Artworks.ArtworkID
JOIN Artists ON Artworks.ArtistID = Artists.ArtistID
WHERE Artists.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY Exhibitions.ExhibitionID,Exhibitions.Title
HAVING COUNT(DISTINCT Artists.ArtistID) = 2;
--11-
SELECT Artworks.Title
FROM Artworks
WHERE Artworks.ArtworkID NOT IN (SELECT DISTINCT ArtworkID FROM ExhibitionArtworks);
--12--
SELECT Artists.Name
FROM Artists
WHERE NOT EXISTS (
SELECT * FROM Categories WHERE NOT EXISTS (SELECT * FROM Artworks
WHERE Artists.ArtistID = Artworks.ArtistID AND Categories.CategoryID = Artworks.CategoryID));
--13--
SELECT Categories.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Categories
LEFT JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID,Categories.Name;
--14--
SELECT Artists.Name FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID, Artists.Name
HAVING  COUNT(Artworks.ArtworkID) > 2;
--15--
SELECT Categories.Name, AVG(Artworks.Year) AS AvgYear
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.CategoryID,Categories.Name
HAVING COUNT(Artworks.ArtworkID) > 1;
--16--
SELECT Artworks.Title
FROM Artworks
JOIN ExhibitionArtworks ON Artworks.ArtworkID = ExhibitionArtworks.ArtworkID
JOIN Exhibitions ON ExhibitionArtworks.ExhibitionID = Exhibitions.ExhibitionID
WHERE Exhibitions.Title = 'Modern Art Masterpieces';
--17--
SELECT Categories.Name
FROM Categories
JOIN Artworks ON Categories.CategoryID = Artworks.CategoryID
GROUP BY Categories.Name
HAVING AVG(Artworks.Year) > (SELECT AVG(Year) FROM Artworks);
--18--
SELECT Artworks.Title
FROM Artworks
WHERE Artworks.ArtworkID NOT IN (SELECT DISTINCT ArtworkID FROM ExhibitionArtworks);
--19--
SELECT DISTINCT Artists.Name
FROM Artists
JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
WHERE Artworks.CategoryID IN (SELECT CategoryID FROM Artworks WHERE Title = 'Mona Lisa')
AND Artists.ArtistID <> (SELECT ArtistID FROM Artworks WHERE Title = 'Mona Lisa');
--20--
SELECT Artists.Name, COUNT(Artworks.ArtworkID) AS ArtworkCount
FROM Artists
LEFT JOIN Artworks ON Artists.ArtistID = Artworks.ArtistID
GROUP BY Artists.ArtistID,Artists.Name;











