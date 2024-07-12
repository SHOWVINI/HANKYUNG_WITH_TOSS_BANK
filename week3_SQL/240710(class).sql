#chapter 4장: 자동차 매출 데이터를 이용한 리포트 작성

USE classicmodels;

SELECT A.Orderdate, priceeach * quantityordered AS 매출액
FROM ORDERS A 
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber;

-- group by 절을 활용해서 일별 매출액 구하기

SELECT A.Orderdate, sum(priceeach * quantityordered) AS 매출액
FROM ORDERS A 
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

-- 이 SQL 쿼리는 ORDERS 테이블과 orderdetails 테이블을 조인하여 각 주문 날짜별로 총 매출액을 계산하고 정렬하여 반환합니다. 
-- 각각의 주요 요소를 설명하겠습니다.

		-- 주요 요소 설명
	
    -- SELECT A.Orderdate, SUM(priceeach * quantityordered) AS 매출액:
-- SELECT 절은 쿼리의 결과로 반환될 열을 지정합니다.	
-- A.Orderdate는 ORDERS 테이블에서 주문 날짜를 선택합니다.
-- SUM(priceeach * quantityordered) AS 매출액는 orderdetails 테이블의 priceeach 열과 
-- quantityordered 열을 곱한 값의 합계를 계산하여 매출액을 구하고, 그 결과를 매출액이라는 별칭으로 반환합니다.

	-- FROM ORDERS A:
-- FROM 절은 데이터를 가져올 테이블을 지정합니다.
-- ORDERS 테이블을 선택하고, A라는 별칭을 부여합니다. 이 별칭은 이후의 쿼리에서 테이블을 참조할 때 사용됩니다.

	-- LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber:
-- LEFT JOIN은 ORDERS 테이블과 orderdetails 테이블을 조인하는 방식 중 하나입니다.
-- orderdetails 테이블을 선택하고, B라는 별칭을 부여합니다.
-- ON 절은 두 테이블을 조인하는 조건을 지정합니다. 여기서는 A.ordernumber = B.ordernumber로, 
-- ORDERS 테이블의 ordernumber 열과 orderdetails 테이블의 ordernumber 열이 일치하는 행을 조인합니다.

	-- GROUP BY 1:
-- GROUP BY 절은 결과를 그룹화하는 데 사용됩니다.
-- 여기서 1은 SELECT 절에서 첫 번째 열인 Orderdate를 기준으로 그룹화함을 의미합니다. 
-- 따라서 같은 주문 날짜를 가진 행들이 하나의 그룹으로 묶입니다.

	-- ORDER BY 1:
-- ORDER BY 절은 결과를 정렬하는 데 사용됩니다.
-- 여기서 1은 SELECT 절에서 첫 번째 열인 Orderdate를 기준으로 정렬함을 의미합니다. 
-- 결과는 주문 날짜 순으로 정렬됩니다.
-- 전체적인 쿼리 동작

	-- 이 쿼리는 다음과 같은 작업을 수행합니다:

-- ORDERS 테이블의 모든 행을 선택합니다.
-- orderdetails 테이블과 ordernumber 열을 기준으로 조인합니다.
-- 각 주문 날짜별로 priceeach * quantityordered의 합계를 계산하여 매출액을 구합니다.
-- 같은 주문 날짜를 가진 행들을 그룹화합니다.
-- 주문 날짜를 기준으로 결과를 정렬합니다.
-- 이를 통해 각 주문 날짜별로 총 매출액을 확인할 수 있으며, 결과는 날짜 순으로 정렬됩니다. 
-- LEFT JOIN을 사용했기 때문에 ORDERS 테이블에 있는 모든 주문이 결과에 포함되며, 
-- 주문 상세 정보가 없는 주문은 매출액이 NULL이 됩니다.



	-- SUBSTR: PYTHON에서 말하는 슬라이싱 개념

-- substr 함수는 문자열의 일부를 추출하는 데 사용됩니다.
-- 구문: substr(string, start_position, length)
-- string: 부분 문자열을 추출할 원본 문자열입니다.
-- start_position: 추출을 시작할 위치입니다. 문자열의 첫 번째 문자는 위치 1로 간주됩니다.
-- length: 추출할 부분 문자열의 길이입니다.


	-- SUBSTR 이용해 월별 매출액 구하기

select substr(A.Orderdate,1,7) MM, sum(priceeach * quantityordered) AS 매출액
from orders A
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

-- substr(A.Orderdate, 1, 7)
-- Orderdate 열에서 첫 번째 문자(위치 1)부터 시작하여 7개의 문자를 추출합니다.
-- 예를 들어, Orderdate 값이 2023-07-10인 경우, substr(A.Orderdate, 1, 7)은 2023-07을 반환합니다.

	-- SUBSTR 이용해 연도별 매출액 구하기

select substr(A.Orderdate,1,4) MM, sum(priceeach * quantityordered) AS 매출액
from orders A
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

select * from orders A;

-- 구매자 수 추출 전 중복 제거

-- select orderdate, customernumber, ordernumber 
-- from orders o;
-- 이를 확인하면 한 명의 고객이 여러 번 구매할 수 있기에 동일한 고객 번호가 여러 줄 생성되어있음을 알 수 있음

-- 이렇기에 고객 번호는 중복을 제외한 값을 세어야 하기에 중복을 젝하고 값을 세는 count(distinct 칼럼)을 사용해야 함

select orderdate, customernumber, ordernumber 
from orders o;

-- 어떻게 칼럼에 중복된 값이 있는지 확인하냐
-- 데이터 구조를 파악하고 있다면 언제 중복을 제거해야 하는지 알 수 있지만
-- 알지 못하는 경우 단순히 카운트한 값과 중복을 제거하고 카운트한 값이 같디면 해당 칼럼을 중복된 값이 없다고 판단할 수 있음
-- 정확히는 테이블의 칼럼 속성을 보고 PK로 중복을 허용하지 않는지 확인하는 것이 좋음
select count(orderNumber) N_orders, count(distinct orderNumber) N_orders_disinct
from orders;

-- 연도별 고객 수와 매출액

select 
	substr(A.Orderdate,1,4) Year, 
	count(distinct customerNumber) 고객수, 
	sum(B.priceEach * B.quantityOrdered) 매출액
from 
	orders A
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

-- 인당 구매금액

select 
	substr(A.Orderdate,1,4) Year, 
	count(distinct customerNumber) as 고객수, 
	sum(B.priceEach * B.quantityOrdered) as 매출액,
    sum(B.priceEach * B.quantityOrdered)/ count(distinct customerNumber) as 인당_구매_금액
from 
	orders A
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

-- 건당 구매 금액

select 
	substr(A.Orderdate,1,4) as Year, 
	count(distinct A.orderNumber) as 고객수, 
	sum(B.priceEach * B.quantityOrdered) as 매출액,
    sum(B.priceEach * B.quantityOrdered)/ count(distinct A.orderNumber) as 건당_구매_금액
from 
	orders A
LEFT JOIN orderdetails B ON A.ordernumber = B.ordernumber
group by 1
order by 1;

-- 국가별, 도시별 매출액 구하기
	
    -- 우선 세 개 테이블  결합하기
select *
from ORDERS as A
LEFT JOIN orderdetails as B ON A.ordernumber = B.ordernumber
LEFT JOIN customers as C ON A.customernumber = C.customernumber;

	-- 필요한 칼럼 COUNTRY, CITY, PRICEEACH * QUANTITIORDERED	호출 뒤 
    -- COUNTRY, CITY로 그룹핑 후 PRICEEACH * QUANTITIORDERED 합하면 국가별 도시멸 매출액 계산

SELECT C.country, C.city, SUM(B.priceeach * B.quantityordered) AS 매출
FROM orders A
LEFT JOIN orderdetails as B ON A.ordernumber = B.ordernumber
LEFT JOIN customers as C ON A.customernumber = C.customernumber
GROUP BY 1, 2
ORDER BY 1, 2
;

-- CASEWHEN을 이용한 북미(USA, CANADA), 비북미 매출액 비교 

	-- 우선 북미, 비북미 구분
SELECT case 
	when country in ('USA', 'CANADA') then 'North America' 
    else 'others' END 
    as country_GRP
from customers;

	-- SELECT CASE:
-- customers 테이블에서 각 행에 대해 평가됩니다.

	-- WHEN country IN ('USA', 'CANADA') THEN 'North America':
-- WHEN 절은 조건을 지정합니다. 여기서는 country 열의 값이 'USA' 또는 'CANADA'인 경우를 의미합니다.
-- 조건이 참(True)이면 'North America'를 반환합니다.

	-- ELSE 'others':
-- ELSE 절은 WHEN 조건이 거짓(False)일 때 실행됩니다.
-- country 열의 값이 'USA'나 'CANADA'가 아닌 경우 'others'를 반환합니다.

	-- END AS country_GRP:
-- CASE 문이 끝났음을 나타내며, 결과 값을 country_GRP라는 새로운 열로 반환합니다.

	-- FROM customers:
-- customers 테이블에서 데이터를 가져옵니다.
	
    -- 결과
-- 이 쿼리는 customers 테이블의 각 행에 대해 country 열의 값을 평가하고, 
-- 해당 국가가 'USA' 또는 'CANADA'이면 'North America'를, 
-- 그렇지 않으면 'others'를 country_GRP라는 새로운 열에 반환합니다.

	-- 북미와 비북미 지역의 매출 구하기

SELECT C.country, C.city, SUM(B.priceeach * B.quantityordered) AS Sales
FROM orders A
LEFT JOIN orderdetails as B ON A.ordernumber = B.ordernumber
LEFT JOIN customers as C ON A.customernumber = C.customernumber
GROUP BY 1, 2
ORDER BY 3
;

-- 아까 국가별, 도시별 매출액 구하기 쿼리를 보면 country와 city로 데이터를 그룹핑해 매출을 집계하는데,
-- 여기서 country와 city를 Casewhen으로 변경하면 북미, 비북미 매출액을 구분해 조회할 수 있다.
SELECT 
	case when country in ('USA', 'CANADA') then 'North America' else 'others' END as country_GRP, 
    SUM(B.priceeach * B.quantityordered) AS Sales
FROM orders A
LEFT JOIN orderdetails as B ON A.ordernumber = B.ordernumber
LEFT JOIN customers as C ON A.customernumber = C.customernumber
GROUP BY 1 -- 국가별로 그룹화
ORDER BY 2 DESC -- 매출액 열을 내림차순으로 정렬
;

-- 매출 TOP 5 국가 및 매출

CREATE TABLE CLASSICMODELS.STAT AS
SELECT C.COUNTRY,
	SUM(PRICEEACH*QUANTITYORDERED) SALES
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B ON A.ORDERNUMBER = B.ORDERNUMBER
LEFT JOIN CLASSICMODELS.CUSTOMERS C ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY 1
ORDER BY 2 DESC
;
-- CLASSICMODELS 스키마 내에 STAT라는 새 테이블을 생성합니다. 
-- 이 테이블은 ORDERS, ORDERDETAILS 및 CUSTOMERS 테이블의 데이터를 사용하여 국가별 매출액을 집계한 결과를 저장합니다. 

-- 아래 코드처럼 국가별 매출액을 다른 이름의 테이블로 생성한 후, 
select * from stat;

-- 이제 매출에 따라 RANK를 매겨 우리가 원하는 Top 5 국가 산출
SELECT 
	country, sales, DENSE_RANK() OVER(ORDER BY SALES DESC) RNK 
FROM stat
WHERE RNK BETWEEN 1 AND 5 
; 
-- 그런데 위 코드의 경우 에러가 납니다. 
-- why? -> QUERY 실행하는 순서는 다음과 같기 때문  > FROM ==> WHERE ==> GROUP BY ==> HAVING ==> SELECT 

CREATE TABLE stat_rnk AS 
SELECT 
	country, sales, DENSE_RANK() OVER(ORDER BY SALES DESC) as RNK 
FROM stat
;

SELECT * 
FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5
;

-- 주요 요소 설명

	-- CREATE TABLE stat_rnk AS:
-- stat_rnk라는 새 테이블을 생성합니다.
-- AS 키워드를 사용하여 SELECT 쿼리의 결과를 이 테이블에 저장합니다.
	-- SELECT 절:
-- country: stat 테이블의 country 열을 선택합니다.
-- sales: stat 테이블의 sales 열을 선택합니다.
-- DENSE_RANK() OVER (ORDER BY sales DESC) AS rnk
-- : DENSE_RANK 윈도우 함수를 사용하여 매출액을 기준으로 내림차순으로 순위를 매기고, 이를 rnk라는 별칭으로 반환합니다.
	-- FROM stat:
-- stat 테이블에서 데이터를 가져옵니다.

	-- 윈도우 함수: DENSE_RANK()
-- DENSE_RANK 함수는 순위를 계산할 때 중복된 값을 가진 행들에 대해 같은 순위를 부여하며, 중간 순위를 건너뛰지 않습니다.
-- OVER (ORDER BY sales DESC): 매출액을 기준으로 내림차순으로 정렬하여 순위를 계산합니다.



-- 서브쿼리

select * from employees;
select * from offices;

-- 서브 쿼리를 사용하지 않고 USA에 거주하는 직원의 이름 출력하기

select *
from employees as A
left join offices as B on A.officecode = B.officecode
where country = 'USA';

-- 서브 쿼리를 사용해 USA에 거주하는 직원의 이름 출력하기
SELECT 
	lastName, firstName
FROM employees
WHERE officeCode IN 
(
	SELECT officeCode 
    FROM offices
	WHERE country = 'USA'
);

-- 이번에는 amount가 최대값인 것을 조회하기
-- 조회해야 할 필드명: customerNumber, checkNumber, amount

select * from payments;

# 메인 쿼리
select customerNumber, checkNumber, amount
from payments;

# 서브 쿼리
select max(amount) 
from payments;

# 결합

SELECT 
	customerNumber, checkNumber, amount
FROM payments
WHERE amount = (SELECT MAX(amount) FROM payments)
;

-- 전체 고객 중에서 주문을 하지 않은 고객 찾기
-- 테이블: customers, orders
-- 조회해야 할 필드명: customerName
select bu from customers;
select * from orders;

-- 메인쿼리 고객명 조회 from customers
-- 서브쿼리 주문한 고객 from orders
select customerName
From customers
where customerNumber not in 
(
select distinct customerNumber
from orders
);

-- 각 주문건당 최소, 최대, 평균을 구하고 싶습니다. 
SELECT
	MIN(items)
    , MAX(items)
    , AVG(items)
FROM (
	SELECT 
		ordernumber, COUNT(ordernumber) AS items
	FROM orderdetails
	GROUP BY 1
) A;


-- 위에서처럼 1~5등까지 뽑지만 서브쿼리를 이용해 뽑는 코드 

SELECT *
FROM
	(
    SELECT COUNTRY, SALES, DENSE_RANK() OVER( ORDER BY SALES DESC ) as RNK
	FROM
		(
        SELECT C.COUNTRY, SUM(PRICEEACH*QUANTITYORDERED) as SALES
		FROM CLASSICMODELS.ORDERS A
			LEFT JOIN CLASSICMODELS.ORDERDETAILS B ON A.ORDERNUMBER = B.ORDERNUMBER
			LEFT JOIN CLASSICMODELS.CUSTOMERS C ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
			GROUP BY 1
		) A
	) A
WHERE RNK <= 5 ;


# 재구매율 

# 국가별 재구매율: A국가 거주 구매자 중 다음 연도에도 구매를 한 구매자의 비중

SELECT 
	C.COUNTRY,
    SUBSTR(A.ORDERDATE,1,4) as YY,
	COUNT(DISTINCT A.CUSTOMERNUMBER) as BU_1,
	COUNT(DISTINCT B.CUSTOMERNUMBER) as BU_2,
	COUNT(DISTINCT B.CUSTOMERNUMBER)/COUNT(DISTINCT A.CUSTOMERNUMBER) as RETENTION_RATE
FROM CLASSICMODELS.ORDERS A
	LEFT JOIN CLASSICMODELS.ORDERS B ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER 
		AND SUBSTR(A.ORDERDATE,1,4) = SUBSTR(B.ORDERDATE,1,4)-1
	LEFT JOIN CLASSICMODELS.CUSTOMERS C ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP BY 1,2
;

# 고객 별 재구매 확인
select A.CustomerNumber, B.CustomerNumber, A.orderdate, B.orderdate 
from orders as A
	left join orders as B on A.CustomerNumber = B.CustomerNumber 
			AND substr(A.orderdate, 1, 4) = substr(B.orderdate, 1, 4) -1;

-- 미국 고객의 Retention rate가 제일 높음 확인
-- 그러면 미국의 TOP 5 차량 모델 추출을 부탁합니다!

SELECT * -- 1등부터 5등까지 추출
FROM
	( -- 랭킹 나열하기
	SELECT 
		* , ROW_NUMBER() OVER(ORDER BY Sales DESC) RNK
	FROM 
		( -- 일단 제품 이름들과 각 제품의 매출액이 나오게 쿼리
		SELECT 
			D.productName, SUM(C.priceeach * C.quantityordered) AS Sales
		FROM orders A
			LEFT JOIN customers B ON A.customernumber = B.customernumber
			LEFT JOIN orderdetails C ON A.ordernumber = C.ordernumber
			LEFT JOIN products D ON C.productcode = D.productcode
		WHERE B.country = 'USA'
		GROUP BY 1
		) as A
	) as A
WHERE RNK BETWEEN 1 AND 5
;





