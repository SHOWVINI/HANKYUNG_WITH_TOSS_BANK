#chapter 2 SQL 기초 문법:

USE classicmodels; -- 해당 Database를 사용하겠음

-- 이 구문은 classicmodels라는 데이터베이스를 사용하겠다는 것을 의미합니다. 
-- 즉, 이후의 모든 SQL 구문은 classicmodels 데이터베이스를 대상으로 실행됩니다.

-- CREATE SCHEMA mydata2;
-- mydata2라는 스키마를 생성하게 됩니다. 
-- 스키마는 데이터베이스 내의 객체(테이블, 뷰 등)를 조직화하는 단위입니다.

SHOW databases;
-- 이 구문은 현재 MySQL 서버에 존재하는 모든 데이터베이스 목록을 보여줍니다.

SELECT * FROM customers; -- Ctrl + Enter
-- SELECT: 데이터베이스에서 데이터를 선택하는 명령어입니다.
-- *: 모든 열(columns)을 의미합니다. 
-- 즉, customers 테이블의 모든 열을 선택하겠다는 의미입니다.
-- FROM customers: 데이터를 가져올 테이블을 지정합니다. 
-- 여기서는 customers 테이블에서 데이터를 가져옵니다.
-- 따라서, SELECT * FROM customers; 구문은 
-- customers 테이블의 모든 행(rows)과 열(columns)을 조회하여 반환합니다.

SELECT * FROM classicmodels.customers;
-- FROM classicmodels.customers: 데이터를 가져올 테이블을 지정합니다.
-- 여기서는 classicmodels 데이터베이스의 customers 테이블에서 데이터를 가져옵니다.
-- 따라서, SELECT * FROM classicmodels.customers; 구문은 
-- classicmodels 데이터베이스의 customers 테이블의 
-- 모든 행(rows)과 열(columns)을 조회하여 반환합니다.

USE classicmodels; -- 위처럼 쓰기 귀찮으면 이와 같이 하기
-- USE: 특정 데이터베이스를 사용하도록 설정하는 명령어입니다.
-- classicmodels: 사용하려는 데이터베이스의 이름입니다.
-- 따라서, USE classicmodels; 구문은 앞으로 실행될 모든 SQL 명령어들이 
-- classicmodels 데이터베이스를 대상으로 하도록 설정합니다. 
-- 이렇게 설정하면, 이후에 테이블을 조회하거나 수정하는 등의 작업을 할 때 
-- 데이터베이스 이름을 명시하지 않아도 됩니다.

SHOW tables;
-- SHOW: MySQL에서 데이터베이스, 테이블, 컬럼 등의 다양한 객체에 대한 
-- 정보를 조회하는 데 사용되는 명령어입니다.
-- tables: 현재 사용 중인 데이터베이스에 있는 테이블 목록을 표시하라는 의미입니다.
-- 따라서, SHOW tables; 구문은 현재 사용 중인 데이터베이스(classicmodels) 내의 
-- 모든 테이블을 나열합니다.

SELECT DATABASE();
-- DATABASE(): 현재 사용 중인 데이터베이스의 이름을 반환하는 함수입니다.
-- 따라서, SELECT DATABASE(); 구문은 현재 사용 중인 데이터베이스의 이름을 반환합니다.


-- USE sakila;
-- USE: 특정 데이터베이스를 사용하도록 설정하는 명령어입니다.
-- sakila: 사용하려는 데이터베이스의 이름입니다.
-- 따라서, USE sakila; 구문은 앞으로 실행될 모든 SQL 명령어들이 
-- sakila 데이터베이스를 대상으로 하도록 설정합니다. 
-- 이렇게 설정하면, 이후에 테이블을 조회하거나 수정하는 등의 작업을 할 때 
-- 데이터베이스 이름을 명시하지 않아도 됩니다.

SELECT * FROM customers; -- 간결하게

-- 
DESC customers;
-- 이 SQL 구문은 customers 테이블의 구조(스키마)를 설명하는 명령어입니다. 
-- DESC는 DESCRIBE의 약어로 사용됩니다.
-- 각 부분의 의미는 다음과 같습니다:
-- DESC 또는 DESCRIBE: 테이블의 구조를 설명하는 명령어입니다.
-- customers: 구조를 설명할 테이블의 이름입니다.
-- 이 구문을 실행하면 customers 테이블의 각 컬럼(열)의 정보가 반환됩니다. 
-- 반환되는 정보에는 각 컬럼의 이름, 데이터 타입, Null 허용 여부, 기본값 등이 포함됩니다.

SELECT customerNumber, customerName, contactFirstName FROM customers;

SELECT 
	customerNumber
    , customerName
    , contactFirstName
FROM 
	customers;

-- customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit

SELECT * 
FROM customers
WHERE country = "USA" ;

SELECT * 
FROM customers
WHERE country = "France" ;


SELECT * 
FROM customers
WHERE customerNumber = 112;

SELECT * 
FROM customers
WHERE customerNumber = "112" ;
-- customerNumber을 추출할 때 숫자가 아닌 문자로 쳐도 나오긴 함
-- SQL 자체에서 Guessing을 하기 때문
-- 다만 좋은 코드는 아니므로 최대한 데이터 타입에 맞춰 쿼리 작성하기

SELECT * 
FROM customers
WHERE customerNumber < 112;

SELECT state
FROM customers
WHERE state > 'B';

SELECT state
FROM customers
WHERE state != 'D';


-- WHERE LIKE 연산자
SELECT * 
FROM customers
WHERE customerName LIKE "%GIFT%";

-- SQL에서 LIKE 연산자는 문자열을 패턴 매칭할 때 사용됩니다. 
-- 와일드카드 문자를 사용하여 특정 패턴과 일치하는 행을 선택할 수 있습니다. 
-- 주요 와일드카드 문자는 다음과 같습니다:

-- %: 0개 이상의 임의의 문자와 일치
-- _: 정확히 1개의 임의의 문자와 일치

-- 아래는 LIKE 연산자를 사용하는 예시입니다:
	-- 특정 패턴과 일치하는 행 찾기:
-- SELECT * FROM customers WHERE customerName LIKE 'A%';
-- 위 쿼리는 customerName이 'A'로 시작하는 모든 행을 선택합니다.
	-- 특정 패턴을 포함하는 행 찾기:
-- SELECT * FROM customers WHERE customerName LIKE '%Market%';
-- 위 쿼리는 customerName에 'Market'이라는 단어를 포함하는 모든 행을 선택합니다.
	-- 특정 문자로 끝나는 행 찾기:
-- SELECT * FROM customers WHERE customerName LIKE '%Inc.';
-- 위 쿼리는 customerName이 'Inc.'로 끝나는 모든 행을 선택합니다.
	-- 임의의 단일 문자와 일치하는 행 찾기:
-- SELECT * FROM customers WHERE customerName LIKE '_a%';
-- 위 쿼리는 두 번째 문자가 'a'인 모든 행을 선택합니다
	-- 복합 패턴 사용:
-- SELECT * FROM customers WHERE customerName LIKE 'A%o_';
-- 위 쿼리는 'A'로 시작하고 'o'가 포함되며, 
-- 그 다음에 정확히 한 문자가 더 있는 모든 행을 선택합니다.




-- 문자열 검색할 때 가장 유용한 것: 정규표현식을 활용한 검색
-- 매우 어렵지만 무조건 필요함!!

	-- 정규 표현식이란?
-- 정규 표현식(regular expressions, regex)은 문자열 검색 및 처리를 위한 매우 강력한 도구입니다. 
-- 처음 접할 때는 어려울 수 있지만, 기본 개념과 몇 가지 패턴을 이해하면 점차 익숙해질 수 있습니다. 
-- 정규 표현식을 배우고 사용하는 것은 확실히 노력할 만한 가치가 있습니다.

	-- 정규 표현식의 기본 개념
-- 정규 표현식은 특정한 규칙을 가진 문자열 패턴을 정의하는 언어입니다. 
-- 이를 통해 문자열 검색, 매칭, 치환 등의 작업을 할 수 있습니다.

	-- MySQL에서 정규 표현식 사용
-- MySQL에서는 REGEXP 연산자를 사용하여 정규 표현식을 활용할 수 있습니다.
-- SQL에서 정규 표현식을 작성할 때 사용하는 기호는 대부분의 프로그래밍 언어에서 사용하는 정규 표현식의 기호와 비슷합니다. 
-- 주요 기호와 그 의미를 설명드리겠습니다. 이 기호들은 특정 패턴을 정의하고, 문자열 매칭을 수행하는 데 사용됩니다.

	-- 기본 기호 및 의미
-- . (점): 임의의 단일 문자와 일치합니다. (개행 문자는 제외)
-- 예: a.b는 "aab", "acb", "a1b" 등과 일치합니다.

-- ^ (캐럿): 문자열의 시작 부분과 일치합니다.
-- 예: ^abc는 "abc"로 시작하는 문자열과 일치합니다.

-- $ (달러 기호): 문자열의 끝 부분과 일치합니다.
-- 예: abc$는 "abc"로 끝나는 문자열과 일치합니다.

-- * (별표): 앞의 문자가 0회 이상 반복되는 것과 일치합니다.
-- 예: a*는 "", "a", "aa", "aaa" 등과 일치합니다.

-- + (더하기 기호): 앞의 문자가 1회 이상 반복되는 것과 일치합니다.
-- 예: a+는 "a", "aa", "aaa" 등과 일치합니다.

-- ? (물음표): 앞의 문자가 0회 또는 1회 나타나는 것과 일치합니다.
-- 예: a?는 "", "a"와 일치합니다.

-- {n}: 정확히 n회 반복되는 것과 일치합니다.
-- 예: a{3}는 "aaa"와 일치합니다.

-- {n,}: 최소 n회 반복되는 것과 일치합니다.
-- 예: a{2,}는 "aa", "aaa", "aaaa" 등과 일치합니다.

-- {n,m}: n회 이상 m회 이하 반복되는 것과 일치합니다.
-- 예: a{2,4}는 "aa", "aaa", "aaaa"와 일치합니다.

	-- 예제:
-- 	customerName이 'A'로 시작하는 행 찾기:
-- SELECT * FROM customers WHERE customerName REGEXP '^A';

-- 	customerName에 'Market'이라는 단어를 포함하는 행 찾기:
-- SELECT * FROM customers WHERE customerName REGEXP 'Market';

-- 	customerName이 'Inc.'로 끝나는 행 찾기:
-- SELECT * FROM customers WHERE customerName REGEXP 'Inc.$';

-- 	두 번째 문자가 'a'인 customerName 찾기:
-- SELECT * FROM customers WHERE customerName REGEXP '^.a';

-- 	'A'로 시작하고 'o'가 포함되며, 그 다음에 정확히 한 문자가 더 있는 customerName 찾기:
-- SELECT * FROM customers WHERE customerName REGEXP '^A.*o.$';





-- AND 조건 사용해보기 
-- country가 USA이면서 city가 NYC인 고객 조회하기
SELECT * 
FROM customers
where country = 'USA' AND city = 'NYC';

-- OR 조건 사용해보기 
-- country가 USA이면서 city가 NYC인 고객 조회하기
SELECT * 
FROM customers
where country = 'USA' OR contactLastName = 'LEE';

-- Payments 테이블
SELECT * FROM payments;

-- BETWEEN 연산자
SELECT *
FROM payments
WHERE amount BETWEEN 20000 AND 40000
	AND paymentDate between '2000-03-20' AND '2004-03-20'
    AND checkNumber REGEXP '^A';

-- IN 연산

SELECT * 
FROM offices
WHERE country IN ('USA','France', 'UK');

SELECT * 
FROM offices
WHERE country NOT IN ('USA','France', 'UK');

-- SELECT 열 지목
-- FROM 테이블 지목
-- WHERE 지목한 열의 행에서 조건 달아 추출

-- ORDER BY 절, sort_values(), 정렬
	-- 오름차순
SELECT *
FROM orders
ORDER BY orderNumber ASC; 
	-- 내림차순
SELECT *
FROM orders
ORDER BY orderNumber DESC; 

	-- 오름차순
SELECT customerNumber, orderNumber
FROM orders
ORDER BY customerNumber ASC; 

	-- 하나는 오름차순 하나는 내림차순
SELECT customerNumber, orderNumber
FROM orders
ORDER BY  1 ASC, 2 DESC; 
-- ORDER BY 1 ASC, 2 DESC: customerNumber를 오름차순(ASC)으로 정렬하고, 
-- 동일한 customerNumber 내에서 orderNumber를 내림차순(DESC)으로 정렬합니다.

-- GROUP BY와 HAVING
	-- GROUP BY 절
-- 데이터를 하나 이상의 열을 기준으로 그룹화합니다.
-- 집계 함수와 함께 사용하여 그룹화된 데이터를 요약할 수 있습니다.
-- SELECT 목록에는 그룹화된 열과 집계 함수만 포함할 수 있습니다.
	-- HAVING 절
-- 그룹화된 데이터에 조건을 적용합니다.
-- WHERE 절과 달리 집계 함수 결과에 조건을 적용할 수 있습니다.
-- GROUP BY 절 뒤에 작성합니다.

SELECT * FROM orders;
SELECT 
	DISTINCT status -- 중복값 제거 
FROM orders;

-- 집계함수
SELECT 
	status
    , COUNT(*) AS "갯수"
FROM 
	orders
GROUP BY 
	status
HAVING 갯수 >= 5 -- DBMS마다 달라요.... (Oracle, MS-SQL에서는 안될 수도 있음)
ORDER BY 2 DESC;


SELECT country, city , COUNT(*)
FROM customers
group by country, city, "카운트 수";

