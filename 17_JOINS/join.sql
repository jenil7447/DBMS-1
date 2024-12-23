--CREATE TABLE ARTIST
CREATE TABLE Artists (
 Artist_id INT PRIMARY KEY,
 Artist_name NVARCHAR(50)
);


--CREATE TABLE ALBUMS
CREATE TABLE Albums (
 Album_id INT PRIMARY KEY,
 Album_title NVARCHAR(50),
 Artist_id INT,
 Release_year INT,
 FOREIGN KEY (Artist_id) REFERENCES Artists(Artist_id)
);


--CREATE TABLE SONGS
CREATE TABLE Songs (
 Song_id INT PRIMARY KEY,
 Song_title NVARCHAR(50),
 Duration DECIMAL(4, 2),
 Genre NVARCHAR(50),
 Album_id INT,
 FOREIGN KEY (Album_id) REFERENCES Albums(Album_id)
);



--INSERT DATA INTO ARTIST

INSERT INTO Artists (Artist_id, Artist_name) VALUES
(1, 'Aparshakti Khurana'),
(2, 'Ed Sheeran'),
(3, 'Shreya Ghoshal'),
(4, 'Arijit Singh'),
(5, 'Tanishk Bagchi');



--INSERT DATA INTO ALBUMS

INSERT INTO Albums (Album_id, Album_title, Artist_id, Release_year) VALUES (1007, 'Album7', 1, 2015),
(1001, 'Album1', 1, 2019),
(1002, 'Album2', 2, 2015),
(1003, 'Album3', 3, 2018),
(1004, 'Album4', 4, 2020),
(1005, 'Album5', 2, 2020),
(1006, 'Album6', 1, 2009);



--INSERT DATA INTO SONGS

INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id) VALUES
(101, 'Zaroor', 2.55, 'Feel good', 1001),
(102, 'Espresso', 4.10, 'Rhythmic', 1002),
(103, 'Shayad', 3.20, 'Sad', 1003),
(104, 'Roar', 4.05, 'Pop', 1002),
(105, 'Everybody Talks', 3.35, 'Rhythmic', 1003),
(106, 'Dwapara', 3.54, 'Dance', 1002),
(107, 'Sa Re Ga Ma', 4.20, 'Rhythmic', 1004),
(108, 'Tauba', 4.05, 'Rhythmic', 1005),
(109, 'Perfect', 4.23, 'Pop', 1002),
(110, 'Good Luck', 3.55, 'Rhythmic', 1004);



---------------------------PART-A---------------------------

--1. Retrieve a unique genre of songs.

SELECT DISTINCT GENRE FROM SONGS;

--2. Find top 2 albums released before 2010.

SELECT TOP 2 * FROM ALBUMS
WHERE Release_year < 2010;

--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)

INSERT INTO SONGS VALUES(1245, 'Zaroor', 2.55, 'Feel good', 1005);

--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’

UPDATE SONGS
SET GENRE = 'HAPPY'
WHERE SONG_TITLE = 'ZAROOR';

--5. Delete an Artist ‘Ed Sheeran’

DELETE FROM ARTISTS
WHERE ARTIST_NAME = 'ED SHEERAN';

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]

ALTER TABLE SONGS
ADD RATINGS DECIMAL(3 , 2);

--7. Retrieve songs whose title starts with 'S'.

SELECT * FROM SONGS
WHERE SONG_TITLE LIKE 'S%';

--8. Retrieve all songs whose title contains 'Everybody'.

SELECT * FROM SONGS 
WHERE SONG_TITLE LIKE '%Everybody%';

--9. Display Artist Name in Uppercase.

SELECT UPPER(ARTIST_NAME) FROM ARTISTS;

--10. Find the Square Root of the Duration of a Song ‘Good Luck’

SELECT SQRT(DURATION) , SONG_TITLE FROM SONGS
WHERE SONG_TITLE = 'GOOD LUCK';

--11. Find Current Date.

SELECT GETDATE();

--12. Find the number of albums for each artist.

SELECT ARTISTS.ARTIST_NAME , COUNT(ALBUMS.ALBUM_ID)
FROM ARTISTS JOIN ALBUMS
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
GROUP BY ARTISTS.ARTIST_NAME;

--13. Retrieve the Album_id which has more than 5 songs in it.

SELECT ALBUMS.ALBUM_ID , COUNT(SONGS.SONG_TITLE)
FROM ALBUMS JOIN SONGS
ON ALBUMS.ALBUM_ID = SONGS.ALBUM_ID
GROUP BY ALBUMS.ALBUM_ID
HAVING COUNT(SONGS.SONG_TITLE) > 5;

--14. Retrieve all songs from the album 'Album1'. (using Subquery)

SELECT * FROM SONGS
WHERE ALBUM_ID = (SELECT ALBUM_ID FROM ALBUMS WHERE ALBUM_TITLE = 'ALBUM1');

--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)

SELECT * FROM ALBUMS
WHERE ARTIST_ID = (SELECT ARTIST_ID FROM ARTISTS WHERE ARTIST_NAME = 'Aparshakti Khurana');

--16. Retrieve all the song titles with its album title.

SELECT SONGS.SONG_TITLE , ALBUMS.ALBUM_TITLE 
FROM SONGS JOIN ALBUMS 
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
GROUP BY SONGS.SONG_TITLE , ALBUMS.ALBUM_TITLE;

--17. Find all the songs which are released in 2020.

SELECT SONGS.SONG_TITLE
FROM SONGS JOIN ALBUMS
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
WHERE ALBUMS.RELEASE_YEAR > 2020
GROUP BY SONGS.SONG_TITLE , ALBUMS.ALBUM_TITLE;

--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.

CREATE VIEW FAV_SONGS
AS 
SELECT * FROM SONGS
WHERE SONG_ID BETWEEN 101 AND 105;

--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.

UPDATE FAV_SONGS
SET SONG_TITLE = 'JANNAT'
WHERE SONG_ID = 101;

--20. Find all artists who have released an album in 2020.

SELECT ARTISTS.ARTIST_NAME , ALBUMS.ALBUM_TITLE
FROM ARTISTS JOIN ALBUMS
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
WHERE ALBUMS.RELEASE_YEAR = 2020;

--21. Retrieve all songs by Shreya Ghoshal and order them by duration. 

SELECT SONG_TITLE
FROM SONGS JOIN ALBUMS
ON SONGS.ALBUM_ID = ALBUMS.ALBUM_ID
JOIN ARTISTS 
ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
WHERE ARTISTS.ARTIST_ID = (SELECT ARTIST_ID FROM ARTISTS WHERE ARTIST_NAME = 'SHREYA GHOSHAL')
ORDER BY SONGS.DURATION;	




------------------------PART-B-------------------------

--22. Retrieve all song titles by artists who have more than one album.

SELECT DISTINCT s.Song_title
FROM Artists a
JOIN Albums al ON a.Artist_id = al.Artist_id
JOIN Songs s ON al.Album_id = s.Album_id
WHERE a.Artist_id IN (
    SELECT Artist_id
    FROM Albums
    GROUP BY Artist_id
    HAVING COUNT(Album_id) > 1
);

--23. Retrieve all albums along with the total number of songs.

SELECT ALBUMS.ALBUM_TITLE , COUNT(songs.song_id)
from albums left join songs
on albums.album_id = songs.album_id
group by albums.album_title;


--24. Retrieve all songs and release year and sort them by release year.

select songs.song_title , albums.release_year
from songs join albums
on songs.album_id = albums.album_id
order by albums.release_year 

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.

select genre , count(song_id)
from songs
group by genre
having count(song_id) > 2

--26. List all artists who have albums that contain more than 3 songs.

select artists.Artist_name
from Artists join albums
on artists.Artist_id = Albums.Artist_id
join songs
on albums.Album_id = songs.Album_id
group by artists.Artist_id , artists.Artist_name
having count(songs.Song_id) > 3





-------------------------PART-C----------------------

--27. Retrieve albums that have been released in the same year as 'Album4'

SELECT ALBUM_ID , ALBUM_TITLE , RELEASE_YEAR
FROM ALBUMS
WHERE ALBUM_ID = (SELECT ALBUM_ID FROM ALBUMS WHERE ALBUM_TITLE = 'ALBUM4');

--28. Find the longest song in each genre

SELECT GENRE , SONG_TITLE , MAX(DURATION)
FROM SONGS
GROUP BY GENRE , SONG_TITLE
ORDER BY GENRE;
