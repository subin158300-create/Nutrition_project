CREATE TABLE TEAM2.albumin_events_small AS
SELECT
    le.hadm_id,
    TO_DATE(le.charttime, 'YYYY-MM-DD HH24:MI:SS') AS charttime,
    TO_NUMBER(le.valuenum) AS albumin
FROM TEAM2.LABEVENTS le
WHERE le.itemid = 50862
  AND le.valuenum IS NOT NULL
  AND TO_NUMBER(le.valuenum) BETWEEN 1.5 AND 6.0;

CREATE TABLE TEAM2.initial_albumin AS
SELECT
    ae.hadm_id,
    AVG(ae.albumin) AS albumin,
    MIN(ae.charttime) AS charttime
FROM TEAM2.albumin_events_small ae
JOIN TEAM2.ADMISSIONS a ON ae.hadm_id = a.hadm_id
WHERE ae.charttime <= TO_DATE(a.admittime, 'YYYY-MM-DD HH24:MI:SS') + 2
GROUP BY ae.hadm_id;

CREATE TABLE TEAM2.final_albumin AS
SELECT
    ae.hadm_id,
    AVG(ae.albumin) AS albumin,
    MAX(ae.charttime) AS charttime
FROM TEAM2.albumin_events_small ae
JOIN TEAM2.ADMISSIONS a ON ae.hadm_id = a.hadm_id
WHERE ae.charttime BETWEEN TO_DATE(a.admittime, 'YYYY-MM-DD HH24:MI:SS') + 25
                       AND TO_DATE(a.admittime, 'YYYY-MM-DD HH24:MI:SS') + 35
GROUP BY ae.hadm_id;


CREATE TABLE TEAM2.protein_intake AS
SELECT
    hadm_id,
    SUM(TO_NUMBER(amount)) /
    NULLIF(COUNT(DISTINCT TRUNC(TO_DATE(starttime, 'YYYY-MM-DD HH24:MI:SS'))), 0)
    AS protein_intake_g_per_day
FROM TEAM2.INPUTEVENTS
WHERE itemid IN (220864, 220862, 225166, 225168)
  AND amount IS NOT NULL
GROUP BY hadm_id;



SELECT DISTINCT
    TO_NUMBER(p.anchor_age) AS age,
    CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END AS gender,
    c.ckd,
    c.diabetes,
    NVL(c.COMORBIDITY_COUNT, 0) AS cci,
    i.albumin AS initial_albumin,
    NVL(n.protein_intake_g_per_day, 0) AS protein_intake,
    ROUND(f.charttime - i.charttime) AS days_between,
    f.albumin - i.albumin AS albumin_change,
    f.albumin AS final_albumin    
FROM TEAM2.PATIENTS p
JOIN TEAM2.nutrition_cohort_final c ON p.subject_id = c.subject_id
JOIN TEAM2.initial_albumin i ON c.hadm_id = i.hadm_id
JOIN TEAM2.final_albumin f ON c.hadm_id = f.hadm_id
LEFT JOIN TEAM2.protein_intake n ON c.hadm_id = n.hadm_id
WHERE TO_NUMBER(p.anchor_age) BETWEEN 18 AND 100
  AND ROUND(f.charttime - i.charttime) BETWEEN 25 AND 35;


