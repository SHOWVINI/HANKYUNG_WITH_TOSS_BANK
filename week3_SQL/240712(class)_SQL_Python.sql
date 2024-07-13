USE book_ratings;

CREATE TABLE books
	(
		id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		title VARCHAR(100),
		author VARCHAR(100),
		genre VARCHAR(100),
		release_year YEAR(4)
	);

drop table books;

# Python에서 MYSQL 레코드 작업 후 다시 MYSQL Workbench에서 확인 (반복) 
USE book_ratings;
Select * From books;

