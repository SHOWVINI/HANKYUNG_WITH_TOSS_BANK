USE classicmodels;

# 이탈률 구하기 (Churn Rate %)
-- 이탈률이란? 활동 고객 중 얼마나 많은고객이 비활동고객으로 전환되었는지를 의미하는 지표
-- Chum = max(구매일, 접속일) 이후 정의한 일정기간 동안 구매 또는 접속하지 않은 상태
-- 이를 통해 분석하는 사람은 누가 이탈하는지 상급자에게 보고

-- 현재 테이블의 가장 최근 날짜
select MAX(orderdate) as MX_order
from orders
;

-- 현재 테이블의 가장 오래된 날짜
select MIN(orderdate) as MX_order
from orders
;

-- 각 고객의 마지막 구매일
select customerNumber, MAX(orderdate) as 마지막_구매일
from orders
group by 1
;

-- 현재 시점이 2006-06-01이라면
select '2006-06-01';

-- 2006-06-01 기준으로 가장 마지막에 구매한 날짜를 빼서 기간 구하기
-- 힌트 DATEDIFF()
select 
    A.*, 
    '2006-06-01' as 오늘날짜,
    DATEDIFF('2006-06-01', 마지막구매일) as DIFF
from
    (
    select customerNumber, MAX(orderDate) as 마지막구매일
    from orders
    group by customerNumber
    ) A;
    
-- 진짜 현재 날짜 기준으로 가장 마지막에 구매한 날짜를 빼서 기간 구하기
select 
    A.*, 
    current_date as 오늘날짜,
    DATEDIFF(current_date, 마지막구매일) as DIFF
from
    (
    select customerNumber, MAX(orderDate) as 마지막구매일
    from orders
    group by customerNumber
    ) A;
    
-- DIFF 90을 기준으로 Churn, Non-Churn (이탈 발생, 이탈 미발생) 구하기 1
	
select 
	A.*, 
	'2005-06-01' as 오늘날짜,
	DATEDIFF('2005-06-01', 마지막구매일) as DIFF,
	case when DATEDIFF('2005-06-01', 마지막구매일) > 90 then 'Churn'
        else 'Non-Churn'
    end as 이탈여부
from
	(
	select customerNumber, MAX(orderDate) as 마지막구매일
	from orders
	group by customerNumber
	) A
group by 1;

-- DIFF 90을 기준으로 Churn, Non-Churn (이탈 발생, 이탈 미발생) 구하기 2

SELECT 
	이탈유무, COUNT(DISTINCT customernumber) as N_CUS
FROM (
	SELECT 
		*
		, CASE WHEN DIFF >= 90 THEN '이탈발생' 
		  ELSE '이탈미발생' 
		  END 이탈유무
	FROM 
		(
		SELECT 
			*, '2005-06-01' AS 오늘날짜, DATEDIFF('2005-06-01', 마지막구매일) DIFF
		FROM 
			(
			SELECT 
				customernumber, MAX(orderdate) 마지막구매일
			FROM orders
			GROUP BY 1
			) A
		) A
	) A
GROUP BY 1
;

-- Churn 고객이 가장 많이 구매한 Produtline 구하기

CREATE TABLE CLASSICMODELS.CHURN_LIST AS
SELECT 	
	CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END  as CHURN_TYPE,
	CUSTOMERNUMBER
FROM
	(
    SELECT 
		CUSTOMERNUMBER,
		'2005-06-01' END_POINT,
		DATEDIFF('2005-06-01',MX_ORDER) DIFF
	FROM
		(
        SELECT 
			CUSTOMERNUMBER,
			MAX(ORDERDATE) MX_ORDER
		FROM CLASSICMODELS.ORDERS
		GROUP BY 1
        ) BASE
	) BASE;

-- 방법 1
SELECT 
	D.churn_type, C.productline, COUNT(DISTINCT B.customernumber) as BU
FROM orderdetails A
	LEFT JOIN orders B ON A.ordernumber = B.ordernumber
	LEFT JOIN products C ON A.productcode = C.productcode
	LEFT JOIN CHURN_LIST D ON B.customernumber = D.customernumber
GROUP BY 1, 2
HAVING churn_type = 'CHURN'
;

-- 방법 2 
SELECT 
	D.churn_type, C.productline, COUNT(DISTINCT B.customernumber) as BU
FROM orderdetails A
	LEFT JOIN orders B ON A.ordernumber = B.ordernumber
	LEFT JOIN products C ON A.productcode = C.productcode
	LEFT JOIN CHURN_LIST D ON B.customernumber = D.customernumber
WHERE D.churn_type = 'CHURN'
GROUP BY 1, 2
;

-- chapter 5장 상품 리뷰 데이터를 활용한 리포트 작성 
-- mydata 사용
use mydata;
Select * From dataset2;

-- DIVISION NAME 별 평균평점
SELECT 
	`Division name`, -- ` 영어로 바꾼 후 원 표시 누르면 나옴  
	AVG (RATING) as AVG_RATE 
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC;

-- DEPARTMENT 별 평균평점
SELECT 
	`Department name`, -- ` 영어로 바꾼 후 원 표시 누르면 나옴  
	AVG (RATING) as AVG_RATE 
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC;

--  Trend의 평점 3점이 이하인 것들
SELECT *
FROM DATASET2 
WHERE `Department name` = 'Trend' and Rating <= 3;

-- Trend의 평점 3점 이하인 리뷰의 연령 별 분포: 방법 1

SELECT *, CASE 
		WHEN age < 20 THEN '10대'
		WHEN age BETWEEN 20 AND 29 THEN '20대'
		WHEN age BETWEEN 30 AND 39 THEN '30대'
		WHEN age BETWEEN 40 AND 49 THEN '40대'
		WHEN age BETWEEN 50 AND 59 THEN '50대'
		WHEN age >= 60 THEN '60대 이상'
            END AS age_group
FROM DATASET2 
WHERE `Department name` = 'Trend' and Rating <= 3;

-- Trend의 평점 3점 이하인 리뷰의 연령 별 분포: 방법 2 (floor 메서드 사용)
SELECT *, floor(AGE/10)*10 as 연령대 -- Cast()활용하면 형 변환 가능!
FROM DATASET2 
WHERE `Department name` = 'Trend' and Rating <= 3;


-- 이후 그룹핑과 연령대의 오름차순 정렬, 그리고 머릿수를 count해주면 연령 분포 확인 가
 
select A.연령대, count(A.연령대) as 머릿수
from
	(
	SELECT *, floor(AGE/10)*10 as 연령대
	FROM DATASET2 
	WHERE `Department name` = 'Trend' and Rating <= 3
	) A
group by 1
order by 1;

-- 또는 쿼리 한번에 

SELECT 
	floor(AGE/10)*10 as AGEBAND,
	COUNT(*) as CNT
FROM DATASET2
WHERE `Department name` = 'Trend' and Rating <= 3
GROUP BY 1
ORDER BY 2 DESC;

-- 50대에서 3점 이하의 평점수가 가장 많은 것으로 확인된다. 
-- 하지만 만약 50대의 리뷰가 많다면 가장 많은 불만이 있다고 할 수는 없다.

SELECT 
	floor(AGE/10)*10 as AGEBAND,
	COUNT(*) as CNT
FROM DATASET2
WHERE `Department name` = 'Trend'
GROUP BY 1
ORDER BY 2 DESC;

-- Trend의 전체 리뷰 수를 보면 30, 40, 50대 순으로 리뷰수가 많은 것으로확인. 
-- 이를 종합해보면, 50대의 Trend에 대한 평점이 다소 좋지 않은 것으로 생각할 수 있다. 
-- 연령 별 3점 이하의 리뷰수를 비중으로 구한다면,더 명확하게 결과를 확인할 수 있을 것 이다. 

-- 50대에서 3점 이하의 Trend 리뷰 추출: 방법 1
select A.*
from
	(
	SELECT *, floor(AGE/10)*10 as AGEBAND
	FROM DATASET2
	WHERE `Department name` = 'Trend' and Rating <= 3 
	) A
where AGEBAND = 50; 

-- 50대에서 3점 이하의 Trend 리뷰 추출: 방법 2
SELECT *
FROM DATASET2
WHERE `Department name` = 'Trend' and Rating <= 3 
AND AGE BETWEEN 50 AND 59 LIMIT 10


