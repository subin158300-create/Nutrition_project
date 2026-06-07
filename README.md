# Nutrition Module (Nutritional Status & Albumin Modeling)

## 1) 개요
본 분석 코드들은 프로젝트 영양 파트입니다.  
MIMIC-IV 기반 코호트 구성, 영양 관련 임상 변수 추출, Albumin 변화량 예측 모델링, 시뮬레이션까지의 흐름으로 구성되어 있습니다.

## 2) 파일 구성
- `1.nutrition_cohort.sql`
  - 영양 코호트 및 주요 혈액검사 변수(예: Albumin, Hemoglobin, MCV, Calcium 등) 추출/정리
- `2.nutrition_cohort_EDA.ipynb`
  - 영양 코호트 EDA 및 위험군 탐색
- `3.albumin_training_data.sql`
  - Albumin 학습용 데이터셋 생성
  - 초기/후기 Albumin 구간 정의 및 단백질 섭취량 집계
- `4.Albumin_ML_model.ipynb`
  - Albumin 변화량 회귀 모델 학습
- `5.albumin_model_tunning.ipynb`
  - 모델 튜닝 단계
- `6.nutrition simulator.ipynb`
  - 영양 시뮬레이션 단계
- `7.integrated_nutrition_simulator_v3_complete.ipynb`
  - 통합 영양 시뮬레이터 완성 버전

## 3) SQL 파이프라인 요약
1. `nutrition_cohort.sql`
- 코호트(`TEAM2.COHORT_60`) 기준으로 검사값을 필터링
- `ROW_NUMBER()` 기반으로 입원 단위(`HADM_ID`) 대표 검사값 추출

2. `albumin_training_data.sql`
- `LABEVENTS(itemid=50862)`에서 Albumin 이벤트 추출
- 입원 초기(입원 후 0~2일) 평균 Albumin 생성
- 입원 후기(입원 후 25~35일) 평균 Albumin 생성
- `INPUTEVENTS` 기반 일평균 단백질 섭취량 집계
- 환자 기본정보/기저질환과 결합하여 학습 테이블 조회

## 4) 모델링 메모 (노트북 로그 기반)
`4.Albumin_ML_model.ipynb`에서 확인된 내용:
- 학습 데이터: 약 506건(전처리 후 504건)
- 사용 피처 예시: `AGE, GENDER, CKD, DIABETES, INITIAL_ALBUMIN, PROTEIN_INTAKE`
- 모델: `GradientBoostingRegressor`
- 성능 예시:
  - Train R2: `0.5520`
  - Test R2: `0.1352`
  - Test MAE: `0.3510 g/dL`
  - Test RMSE: `0.4465 g/dL`

## 5) 수행 내용
- 외부/임상 데이터 기반 영양 상태 파악
- 개인별 영양 상태 산출 및 개선 가이드라인 근거 생성
- 성능 지표 기반 모델 평가

## 6) 기술 스택(문서 기준)
- SQL (Oracle)
- Python
- MIMIC-IV
- (운영 관점) 시뮬레이터 기반 통합 분석

## 7) 참고
