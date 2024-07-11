-- 테이블 생성
CREATE DATABASE IF NOT EXISTS titanic_db;

-- 데이터베이스 사용
USE titanic_db;

-- 테이블 생성
CREATE TABLE titanic (
    PassengerId INT,
    Survived TINYINT,
    Pclass INT,
    Name VARCHAR(255),
    Sex VARCHAR(10),
    Age FLOAT,
    SibSp INT,
    Parch INT,
    Ticket VARCHAR(50),
    Fare FLOAT,
    Cabin VARCHAR(50),
    Embarked VARCHAR(10)
);

LOAD DATA INFILE '/Users/khb43/Desktop/HANKYUNG_WITH_TOSS_BANK/week3_SQL/datasets/titanic'
INTO TABLE titanic
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(PassengerId, Survived, Pclass, Name, Sex, Age, SibSp, Parch, Ticket, Fare, Cabin, Embarked);
