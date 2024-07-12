-- 테이블 생성
use testdb;

CREATE TABLE vehicles (
	vehicleId INT
    , year INT NOT NULL
    , make VARCHAR(100) NOT NULL, 
    PRIMARY KEY(vehicleId)
);

-- 필드 추가를 위한 ALTER TABLE 명령어
-- : ALTER TABLE 명령어는 SQL에서 기존 테이블의 구조를 변경하는 데 사용됩니다. 
-- 이 명령어를 사용하여 테이블에 컬럼을 추가하거나 삭제하고, 기존 컬럼의 데이터 타입을 변경하는 등의 작업을 수행할 수 있습니다. 
-- 주요 사용 예시를 통해 ALTER TABLE 명령어의 다양한 용도를 살펴보겠습니다.

ALTER TABLE vehicles ADD model varchar(100) NOT NULL;
DESC vehicles;

	-- color 필드 추가하기

ALTER TABLE vehicles ADD color varchar(100) NOT NULL;
DESC vehicles;

    -- note필드 추가 및 삭제, 수정, 이름 바꾸기
# 추가
ALTER TABLE vehicles ADD note varchar(100);
DESC vehicles;

#삭제
ALTER TABLE vehicles DROP COLUMN note;
DESC vehicles;

#추가 후 수정
ALTER TABLE vehicles ADD note varchar(100);
DESC vehicles;
ALTER TABLE vehicles Modify note varchar(100) not null;
DESC vehicles;

# 이름 바꾸기
ALTER TABLE note RENAME TO vehicleCondition;
DESC vehicles;

	-- 테이블명 변경
ALTER TABLE vehicles RENAME TO cars;

DESC vehicles;
DESC cars;

COMMIT;
