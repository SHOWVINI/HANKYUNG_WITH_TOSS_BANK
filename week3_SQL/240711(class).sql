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













-- chapter 5장: 상품 리뷰 데이터를 활용한 리포트 작성 
-- mydata 사용
use mydata;
Select * From dataset2;

-- ClothingID : 상품번호(Unique Value)
-- Age: 리뷰작성자의연령 
-- Title: 리뷰제목
-- Review Text: 리뷰내용
-- Rating: 리뷰작성자가제출한 평점 
-- Recommended IND:리뷰어에의한상품추천여부 
-- Positive FeedbackCount: 긍정적피드백수
-- DiVision Name: 상품이속한Division
-- Department Name: 상품이속한Department
-- Class Name: 상품의타입


-- SQL에서 백틱: `` 을 사용하는 이유는 주로 다음과 같은 상황에서 발생합니다:

-- 	예약어와 충돌 방지
--     : SQL 키워드 또는 예약어와 같은 이름을 가진 컬럼이나 테이블을 사용할 때,
-- 	백틱을 사용하여 이름이 예약어임을 명확히 합니다.
--     예를 들어, select, table, group 등과 같은 단어는 SQL 예약어이기 때문에 
--     이를 컬럼이나 테이블 이름으로 사용할 때 백틱으로 감싸야 합니다.

-- 	공백 또는 특수 문자가 포함된 이름
--     : 컬럼이나 테이블 이름에 공백이나 특수 문자가 포함된 경우, 
--     백틱을 사용하여 이를 감쌀 수 있습니다. 
--     예를 들어, Department name처럼 공백이 포함된 이름은 백틱을 사용해야 합니다.

-- 	대소문자 구분
--     : MySQL에서는 기본적으로 테이블과 컬럼 이름이 대소문자를 구분하지 않지만, 
--     운영체제와 설정에 따라 달라질 수 있습니다. 백틱을 사용하면 대소문자를 정확히 구분할 수 있습니다.

-- 따라서 다음 쿼리에서 Department name은 공백이 포함된 컬럼 이름이므로 백틱으로 감싸야 합니다:


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
SELECT 
	*, 
    floor(AGE/10)*10 as 연령대 -- Cast()활용하면 형 변환 가능!
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
	floor(AGE/10)*10 as 연령대,
	COUNT(*) as 머릿수
FROM DATASET2
WHERE `Department name` = 'Trend' and Rating <= 3
GROUP BY 1
ORDER BY 1;

-- 50대에서 3점 이하의 평점수가 가장 많은 것으로 확인된다. 
-- 하지만 만약 50대의 리뷰가 많다면 가장 많은 불만이 있다고 할 수는 없다.

SELECT 
	floor(AGE/10)*10 as AGEBAND,
	COUNT(*) as CNT
FROM DATASET2
WHERE `Department name` = 'Trend'
GROUP BY 1
ORDER BY 1;

-- Trend의 전체 리뷰 수를 보면 30, 40, 50대 순으로 리뷰수가 많은 것으로확인. 
-- 이를 종합해보면, 50대의 Trend에 대한 평점이 다소 좋지 않은 것으로 생각할 수 있다. 
-- 연령 별 3점 이하의 리뷰수를 비중으로 구한다면, 더 명확하게 결과를 확인할 수 있을 것이다. 

-- 50대에서 3점 이하의 Trend 리뷰 추출: 방법 1
select A.`Review Text`
from
	(
	SELECT *, floor(AGE/10)*10 as AGEBAND
	FROM DATASET2
	WHERE `Department name` = 'Trend' and Rating <= 3 
	) A
where AGEBAND = 50; 

-- 50대에서 3점 이하의 Trend 리뷰 추출: 방법 2
SELECT `Review Text`
FROM DATASET2
WHERE `Department name` = 'Trend' 
		and Rating <= 3 
		and AGE BETWEEN 50 and 59 LIMIT 10;

-- 먼저 Department 별로 평점이 낮은 주요 10개 상품을 조회한 후, 해당 상품들의 리뷰를 살펴보기
-- Department 별 평점이 낮은 10개 상품을 임시 테이블로 생성

select * from dataset2;

-- Department Name, Clothing 별 평균 평점 계산
-- 평점이 낮은 상품의 주요 Complain 
SELECT 
	`Department Name`, ClothingID, AVG(rating) as AVG_RATE
FROM dataset2
GROUP BY 1, 2
;

-- Department, Clothing ID의 평균 평점 계산 및 Department 내에서 평균 평점 기준으로 순위 매기기

-- ROW_NUMBER()
-- 	: 각 행에 고유한 번호를 부여하는 윈도우 함수입니다.
-- OVER (PARTITION BY DEPARTMENT NAME ORDER BY AVG_RATE)
-- 	: 윈도우 함수의 범위를 지정합니다.
-- 		PARTITION BY DEPARTMENT NAME
-- 			: DEPARTMENT NAME별로 데이터를 나눕니다. 즉, 각 부서별로 별도의 그룹을 형성합니다.
-- 		ORDER BY AVG_RATE
-- 			: 각 그룹 내에서 AVG_RATE 기준으로 행을 정렬합니다.

SELECT 
	*, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) as RNK
FROM 
	(
	SELECT 
		`Department Name`, ClothingID , AVG(rating) as AVG_RATE
	FROM dataset2
	GROUP BY 1, 2
	) A;

-- 위 결과를 토대로, 1-10위 데이터 필터링 및 해당 데이터 테이블로 생성하기

-- CREATE TABLE mydata.stat AS 
-- SELECT *
-- FROM 
-- 	(
-- 	SELECT *, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) as RNK
-- 	FROM 
-- 		(
-- 		SELECT 
-- 			`Department Name`, ClothingID, AVG(rating) as AVG_RATE
-- 		FROM dataset2
-- 		GROUP BY 1, 2
-- 		) A
-- 	) B
-- WHERE RNK BETWEEN 1 AND 10
-- ;


-- 138 페이지부터 자습시간에 다시 
-- 불만족 1위-10위인 제품의 불만족 리뷰를 가져오는 것이 포인트
-- bottoms의 평점이 낮은 10위까지의 상품 리뷰 가져오기 

select * from stat;

SELECT ClothingID 
FROM stat
WHERE `department name` = 'Bottoms'; 

-- 해당 ClothingID에 해당하는 리뷰 텍스트
	-- 메인쿼리 : dataset2에서 review text만 가져오기
	-- 서브쿼리 : stat 테이블에서 department가 bottoms인 clothingID

SELECT `review text`
FROM dataset2
WHERE clothingid IN 
	(
	SELECT ClothingID 
	FROM stat
	WHERE `department name` = 'Bottoms'
	)
;

-- 리뷰를 통해 size에 관한 컴플레인을 해결하기!
-- : 전체 리뷰 내용 중 size의 관련한 리뷰가 얼마나 되는지 확인

-- 아래 코드를 통해 전체 리뷰 중 약 31퍼센트가 사이즈에 관련한 리뷰임을 확인
SELECT 
    SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) as N_SIZE
	, COUNT(*) as N_TOTAL
    , round(SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*), 2)AS ratio
FROM dataset2
;

-- 사이즈 별로 나눠 리뷰 살펴보기 

SELECT 
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) as N_SIZE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END ) as N_LARGE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END ) as N_LOOSE,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END ) as N_SMALL,
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END ) as N_TIGHT,
	SUM(1) as N_TOTAL
FROM dataset2
;











# chapter 8
# titanic 데이터 다뤄보기 

use titanic;
select * from titanic;

desc titanic;


-- id의 중복값 유무 확인
select 
	count(PassengerID) as N_passengers,
    count(distinct PASSENGERID) as N_D_passengers
from titanic;

-- 요인별 생존 여부 집계

	-- 0은 사망 / 1은 생존
select survived from titanic;

	-- 성별에 따른 승객 수와 생존자 수, 생존 비율 구하기
select 
	sex, 
    count(passengerID) as 승객_수,
	sum(survived) as 생존자_수,
    round(sum(survived) / count(passengerID), 2) as 생존_비율
from titanic
group by 1;

	-- 연령대 별 승객수, 생존자 수, 비율 구하기

select 
	A.연령대,
    count(passengerID) as 승객_수,
	sum(survived) as 생존자_수,
    round(sum(survived) / count(passengerID), 2) as 생존_비율
from
	(
	select *, floor(AGE/10)*10 as 연령대
	from titanic
	) A
group by 1
order by 1;

-- 쿼리 한번에 

SELECT 
	FLOOR(AGE/10) * 10 AGEBAND 
    , COUNT(passengerid) AS 승객수
    , SUM(survived) AS 생존자수
    , ROUND(SUM(survived) / COUNT(passengerid), 2) AS ratio
 FROM titanic
 GROUP BY 1
 ORDER BY 1
 ;


-- 남자만 

select 
	A.연령대,
    sex,
    count(passengerID) as 승객_수,
	sum(survived) as 생존자_수,
    round(sum(survived) / count(passengerID), 2) as 생존_비율
from
	(
	select *, floor(AGE/10)*10 as 연령대
	from titanic
	) A
group by 1, 2
having sex = 'male'
order by 1, 2;

-- 쿼리 한번에
SELECT 
	FLOOR(AGE/10) * 10 AGEBAND 
    , sex
    , COUNT(passengerid) AS 승객수
    , SUM(survived) AS 생존자수
    , ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
 FROM titanic
 GROUP BY 1, 2
 HAVING sex = 'male'
 ORDER BY 1, 2
 ;

-- 여자만

select 
	A.연령대,
    sex,
    count(passengerID) as 승객_수,
	sum(survived) as 생존자_수,
    round(sum(survived) / count(passengerID), 2) as 생존_비율
from
	(
	select *, floor(AGE/10)*10 as 연령대
	from titanic
	) A
group by 1, 2
having sex = 'female'
order by 1, 2;

-- 쿼리 한번에 

SELECT 
	FLOOR(AGE/10) * 10 AGEBAND 
    , sex
    , COUNT(passengerid) AS 승객수
    , SUM(survived) AS 생존자수
    , ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
 FROM titanic
 GROUP BY 1, 2
 HAVING sex = 'male'
 ORDER BY 1, 2
 ;
 
-- AGEBAND 별 열 나열 / 남성의 생존율 열 나열 / 여성의 생존율 열 나열 / 두 성별의 생존율 차이 나열
-- 인라인 뷰에 조인문 만드는 것이 힌트

SELECT 
	A.AGEBAND, 
    A.ratio AS M_RATIO,
    B.ratio AS F_RATIO, 
    ROUND(B.ratio - A.ratio, 2) AS DIFF
FROM 
	(
	SELECT 
		FLOOR(AGE/10) * 10 as AGEBAND, 
        sex, 
        COUNT(passengerid) AS 승객수,
        SUM(survived) AS 생존자수,
        ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'male'
	 ORDER BY 1, 2
	) A
    LEFT JOIN 
	(
	SELECT 
		FLOOR(AGE/10) * 10 as AGEBAND,
        sex,
        COUNT(passengerid) AS 승객수,
        SUM(survived) AS 생존자수,
        ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'female'
	 ORDER BY 1, 2
	) B
	ON A.AGEBAND = B.AGEBAND
;

select * from titanic;

-- 승선 항구별 승객 수 

select embarked, count(PassengerId)
from titanic
group by 1;

-- 승선 항구별 성별 승객 수 

select embarked, sex, count(PassengerId)
from titanic
group by 1, 2
order by 1;

-- 승선 항구별 성별 승객 비중(%)

SELECT 
	A.embarked
    , A.sex
    , A.승객수
    , B.전체_승객수
    , ROUND(A.승객수 / B.전체_승객수, 2) AS ratio
FROM (
	SELECT 
		embarked
		, sex
		, COUNT(passengerid) as 승객수
	FROM titanic
	GROUP BY 1, 2
	ORDER BY 1, 2
) A 
LEFT JOIN (
	SELECT 
		embarked
		, COUNT(passengerid) as 전체_승객수
	FROM titanic
	GROUP BY 1
	ORDER BY 1
) B
ON A.embarked = B.embarked
;
