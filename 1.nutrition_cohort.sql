-- ��������������������������������������������������������������������������������������������������������
-- Step 1: ���װ˻� ������ ���� + �ڵ� ����
-- ��������������������������������������������������������������������������������������������������������

-- ��������������������������������������������������������������������������������������
-- 1-1. Albumin
-- ��������������������������������������������������������������������������������������

-- ���� ���̺� ���� (������)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_ALBUMIN';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

-- ���� ����
CREATE TABLE TEAM2.LAB_ALBUMIN AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as ALBUMIN,
        le.CHARTTIME,
        ROW_NUMBER() OVER (
            PARTITION BY le.HADM_ID 
            ORDER BY le.CHARTTIME ASC
        ) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%ALBUMIN%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 1.0 AND 6.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, ALBUMIN
FROM ranked_labs
WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-2. Hemoglobin
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_HEMOGLOBIN';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_HEMOGLOBIN AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as HEMOGLOBIN,
        le.CHARTTIME,
        ROW_NUMBER() OVER (
            PARTITION BY le.HADM_ID 
            ORDER BY le.CHARTTIME ASC
        ) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE (UPPER(di.LABEL) LIKE '%HEMOGLOBIN%' 
           OR UPPER(di.LABEL) LIKE '%HGB%')
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 3.0 AND 20.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, HEMOGLOBIN
FROM ranked_labs
WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-3. MCV
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_MCV';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_MCV AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as MCV,
        le.CHARTTIME,
        ROW_NUMBER() OVER (
            PARTITION BY le.HADM_ID 
            ORDER BY le.CHARTTIME ASC
        ) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%MCV%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 50 AND 120
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, MCV
FROM ranked_labs
WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-4. Calcium
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_CALCIUM';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_CALCIUM AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as CALCIUM,
        le.CHARTTIME,
        ROW_NUMBER() OVER (
            PARTITION BY le.HADM_ID 
            ORDER BY le.CHARTTIME ASC
        ) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%CALCIUM%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 5.0 AND 15.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, CALCIUM
FROM ranked_labs
WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-5. Lymphocyte
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_LYMPHOCYTE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_LYMPHOCYTE AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as LYMPHOCYTE,
        ROW_NUMBER() OVER (PARTITION BY le.HADM_ID ORDER BY le.CHARTTIME) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%LYMPHOCYTE%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 0 AND 10000
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, LYMPHOCYTE FROM ranked_labs WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-6. Total Protein
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_TOTAL_PROTEIN';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_TOTAL_PROTEIN AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as TOTAL_PROTEIN,
        ROW_NUMBER() OVER (PARTITION BY le.HADM_ID ORDER BY le.CHARTTIME) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%TOTAL PROTEIN%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 3.0 AND 10.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, TOTAL_PROTEIN FROM ranked_labs WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-7. Potassium
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_POTASSIUM';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_POTASSIUM AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as POTASSIUM,
        ROW_NUMBER() OVER (PARTITION BY le.HADM_ID ORDER BY le.CHARTTIME) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%POTASSIUM%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 2.0 AND 7.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, POTASSIUM FROM ranked_labs WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-8. Magnesium
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_MAGNESIUM';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_MAGNESIUM AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as MAGNESIUM,
        ROW_NUMBER() OVER (PARTITION BY le.HADM_ID ORDER BY le.CHARTTIME) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%MAGNESIUM%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 0.5 AND 5.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, MAGNESIUM FROM ranked_labs WHERE rn = 1;


-- ��������������������������������������������������������������������������������������
-- 1-9. Phosphate
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_PHOSPHATE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.LAB_PHOSPHATE AS
WITH ranked_labs AS (
    SELECT 
        le.HADM_ID,
        le.VALUENUM as PHOSPHATE,
        ROW_NUMBER() OVER (PARTITION BY le.HADM_ID ORDER BY le.CHARTTIME) as rn
    FROM TEAM2.LABEVENTS le
    JOIN TEAM2.D_LABITEMS di ON le.ITEMID = di.ITEMID
    WHERE UPPER(di.LABEL) LIKE '%PHOSPHATE%'
      AND le.VALUENUM IS NOT NULL
      AND le.VALUENUM BETWEEN 1.0 AND 8.0
      AND le.HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60)
)
SELECT HADM_ID, PHOSPHATE FROM ranked_labs WHERE rn = 1;


-- ��������������������������������������������������������������������������������������������������������
-- Step 2: ������ȯ ������ ���� + �ڵ� ����
-- ��������������������������������������������������������������������������������������������������������

-- ��������������������������������������������������������������������������������������
-- 2-1. �索��
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_DIABETES';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_DIABETES AS
SELECT DISTINCT HADM_ID, 1 as DIABETES
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'E10%'
    OR ICD_CODE LIKE 'E11%'
    OR ICD_CODE LIKE 'E12%'
    OR ICD_CODE LIKE 'E13%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-2. �����ź���
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_CKD';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_CKD AS
SELECT 
    HADM_ID, 
    1 as CKD,
    CASE 
        WHEN ICD_CODE LIKE 'N18.1%' THEN 1
        WHEN ICD_CODE LIKE 'N18.2%' THEN 2
        WHEN ICD_CODE LIKE 'N18.3%' THEN 3
        WHEN ICD_CODE LIKE 'N18.4%' THEN 4
        WHEN ICD_CODE LIKE 'N18.5%' THEN 5
        WHEN ICD_CODE LIKE 'N18.6%' THEN 6
        ELSE NULL
    END as CKD_STAGE
FROM TEAM2.DIAGNOSES_ICD
WHERE ICD_CODE LIKE 'N18%'
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-3. ��ٰ���
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_OSTEOPOROSIS';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_OSTEOPOROSIS AS
SELECT DISTINCT HADM_ID, 1 as OSTEOPOROSIS
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'M80%'
    OR ICD_CODE LIKE 'M81%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-4. ������
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_HYPERTENSION';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_HYPERTENSION AS
SELECT DISTINCT HADM_ID, 1 as HYPERTENSION
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'I10%'
    OR ICD_CODE LIKE 'I11%'
    OR ICD_CODE LIKE 'I12%'
    OR ICD_CODE LIKE 'I13%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-5. �ɺ���
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_HEART_FAILURE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_HEART_FAILURE AS
SELECT DISTINCT HADM_ID, 1 as HEART_FAILURE
FROM TEAM2.DIAGNOSES_ICD
WHERE ICD_CODE LIKE 'I50%'
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-6. ġ��
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_DEMENTIA';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_DEMENTIA AS
SELECT DISTINCT HADM_ID, 1 as DEMENTIA
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'F01%'
    OR ICD_CODE LIKE 'F02%'
    OR ICD_CODE LIKE 'F03%'
    OR ICD_CODE LIKE 'G30%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-7. ������
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_STROKE';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_STROKE AS
SELECT DISTINCT HADM_ID, 1 as STROKE
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'I60%'
    OR ICD_CODE LIKE 'I61%'
    OR ICD_CODE LIKE 'I63%'
    OR ICD_CODE LIKE 'I64%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-8. COPD
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_COPD';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_COPD AS
SELECT DISTINCT HADM_ID, 1 as COPD
FROM TEAM2.DIAGNOSES_ICD
WHERE ICD_CODE LIKE 'J44%'
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������
-- 2-9. ��
-- ��������������������������������������������������������������������������������������

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_CANCER';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE TEAM2.DX_CANCER AS
SELECT DISTINCT HADM_ID, 1 as CANCER
FROM TEAM2.DIAGNOSES_ICD
WHERE (ICD_CODE LIKE 'C%'
   AND ICD_CODE NOT LIKE 'C44%')
  AND HADM_ID IN (SELECT HADM_ID FROM TEAM2.COHORT_60);


-- ��������������������������������������������������������������������������������������������������������
-- Step 3: ���� ������ȣƮ ����
-- ��������������������������������������������������������������������������������������������������������

-- ���� ���̺� ����
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.NUTRITION_COHORT';
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

-- ���� ���� ��ȣƮ ����
CREATE TABLE TEAM2.NUTRITION_COHORT AS
SELECT 
    -- �⺻ ����
    c.SUBJECT_ID,
    c.HADM_ID,
    c.AGE,
    
    -- ���װ˻�
    alb.ALBUMIN,
    hgb.HEMOGLOBIN,
    mcv.MCV,
    ca.CALCIUM,
    phos.PHOSPHATE,
    mg.MAGNESIUM,
    k.POTASSIUM,
    lymph.LYMPHOCYTE,
    tp.TOTAL_PROTEIN,
    
    -- ������ȯ
    NVL(dm.DIABETES, 0) as DIABETES,
    NVL(ckd.CKD, 0) as CKD,
    ckd.CKD_STAGE,
    NVL(osteo.OSTEOPOROSIS, 0) as OSTEOPOROSIS,
    NVL(htn.HYPERTENSION, 0) as HYPERTENSION,
    NVL(hf.HEART_FAILURE, 0) as HEART_FAILURE,
    NVL(dem.DEMENTIA, 0) as DEMENTIA,
    NVL(stroke.STROKE, 0) as STROKE,
    NVL(copd.COPD, 0) as COPD,
    NVL(cancer.CANCER, 0) as CANCER,
    
    -- ������ȯ ����
    (NVL(dm.DIABETES, 0) + NVL(ckd.CKD, 0) + NVL(osteo.OSTEOPOROSIS, 0) +
     NVL(htn.HYPERTENSION, 0) + NVL(hf.HEART_FAILURE, 0) + 
     NVL(dem.DEMENTIA, 0) + NVL(stroke.STROKE, 0) + 
     NVL(copd.COPD, 0) + NVL(cancer.CANCER, 0)) as COMORBIDITY_COUNT

FROM TEAM2.COHORT_60 c

-- ���װ˻� LEFT JOIN
LEFT JOIN TEAM2.LAB_ALBUMIN alb ON c.HADM_ID = alb.HADM_ID
LEFT JOIN TEAM2.LAB_HEMOGLOBIN hgb ON c.HADM_ID = hgb.HADM_ID
LEFT JOIN TEAM2.LAB_MCV mcv ON c.HADM_ID = mcv.HADM_ID
LEFT JOIN TEAM2.LAB_CALCIUM ca ON c.HADM_ID = ca.HADM_ID
LEFT JOIN TEAM2.LAB_PHOSPHATE phos ON c.HADM_ID = phos.HADM_ID
LEFT JOIN TEAM2.LAB_MAGNESIUM mg ON c.HADM_ID = mg.HADM_ID
LEFT JOIN TEAM2.LAB_POTASSIUM k ON c.HADM_ID = k.HADM_ID
LEFT JOIN TEAM2.LAB_LYMPHOCYTE lymph ON c.HADM_ID = lymph.HADM_ID
LEFT JOIN TEAM2.LAB_TOTAL_PROTEIN tp ON c.HADM_ID = tp.HADM_ID

-- ������ȯ LEFT JOIN
LEFT JOIN TEAM2.DX_DIABETES dm ON c.HADM_ID = dm.HADM_ID
LEFT JOIN TEAM2.DX_CKD ckd ON c.HADM_ID = ckd.HADM_ID
LEFT JOIN TEAM2.DX_OSTEOPOROSIS osteo ON c.HADM_ID = osteo.HADM_ID
LEFT JOIN TEAM2.DX_HYPERTENSION htn ON c.HADM_ID = htn.HADM_ID
LEFT JOIN TEAM2.DX_HEART_FAILURE hf ON c.HADM_ID = hf.HADM_ID
LEFT JOIN TEAM2.DX_DEMENTIA dem ON c.HADM_ID = dem.HADM_ID
LEFT JOIN TEAM2.DX_STROKE stroke ON c.HADM_ID = stroke.HADM_ID
LEFT JOIN TEAM2.DX_COPD copd ON c.HADM_ID = copd.HADM_ID
LEFT JOIN TEAM2.DX_CANCER cancer ON c.HADM_ID = cancer.HADM_ID;


-- ��������������������������������������������������������������������������������������������������������
-- Step 4: �ӽ� ���̺� �ϰ� ����
-- ��������������������������������������������������������������������������������������������������������

BEGIN
   -- ���װ˻� �ӽ� ���̺� ����
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_ALBUMIN';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_HEMOGLOBIN';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_MCV';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_CALCIUM';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_PHOSPHATE';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_MAGNESIUM';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_POTASSIUM';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_LYMPHOCYTE';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.LAB_TOTAL_PROTEIN';
   
   -- ������ȯ �ӽ� ���̺� ����
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_DIABETES';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_CKD';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_OSTEOPOROSIS';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_HYPERTENSION';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_HEART_FAILURE';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_DEMENTIA';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_STROKE';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_COPD';
   EXECUTE IMMEDIATE 'DROP TABLE TEAM2.DX_CANCER';
   
   DBMS_OUTPUT.PUT_LINE('? ��� �ӽ� ���̺� ���� �Ϸ�!');
EXCEPTION
   WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('?? �Ϻ� �ӽ� ���̺� ���� �� ���� (���� ����)');
END;
/


-- ��������������������������������������������������������������������������������������������������������
-- Step 5: ���� ��� Ȯ��
-- ��������������������������������������������������������������������������������������������������������

-- ��ü �Ǽ�
SELECT 
    COUNT(*) as total_admissions,
    COUNT(DISTINCT SUBJECT_ID) as unique_patients
FROM TEAM2.NUTRITION_COHORT;

-- ���װ˻� ������
SELECT 
    COUNT(*) as total,
    ROUND(SUM(CASE WHEN ALBUMIN IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as albumin_pct,
    ROUND(SUM(CASE WHEN HEMOGLOBIN IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as hgb_pct,
    ROUND(SUM(CASE WHEN CALCIUM IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as calcium_pct,
    ROUND(SUM(CASE WHEN POTASSIUM IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as potassium_pct
FROM TEAM2.NUTRITION_COHORT;

-- ������ȯ ������
SELECT 
    ROUND(SUM(DIABETES) / COUNT(*) * 100, 1) as diabetes_pct,
    ROUND(SUM(CKD) / COUNT(*) * 100, 1) as ckd_pct,
    ROUND(SUM(HYPERTENSION) / COUNT(*) * 100, 1) as htn_pct,
    ROUND(SUM(OSTEOPOROSIS) / COUNT(*) * 100, 1) as osteo_pct,
    ROUND(SUM(DEMENTIA) / COUNT(*) * 100, 1) as dementia_pct
FROM TEAM2.NUTRITION_COHORT;

-- ���� Ȯ��
SELECT * FROM TEAM2.NUTRITION_COHORT;

COMMIT;

SELECT
    COUNT(*) AS weight_count
FROM cohort_60 c
JOIN chartevents ce
    ON c.hadm_id = ce.hadm_id
WHERE
    ce.itemid IN (
        226512, -- Admission Weight (kg)
        224639  -- Daily Weight (kg)
    )
    AND ce.valuenum IS NOT NULL;

SELECT
    COUNT(DISTINCT c.hadm_id) AS hadm_with_bmi
FROM cohort_60 c
JOIN chartevents w
    ON c.hadm_id = w.hadm_id
JOIN chartevents h
    ON c.hadm_id = h.hadm_id
WHERE
    w.itemid IN (226512, 224639)
    AND w.valuenum BETWEEN 30 AND 200
    AND h.itemid IN (226707, 226730)
    AND h.valuenum BETWEEN 120 AND 220;

