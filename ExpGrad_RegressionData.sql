/* Query data for an analysis of outcomes for expected graduates for the past three semesters */
/* Includes campus, field of study, cumulative GPA, number of fails/withdrawals in courses, number of credits completed at other campuses */

SELECT 
	DISTINCT A.EMPLID AS 'Student ID', 
	A.STRM AS 'EB Term', 
	A.EXP_GRAD_TERM AS 'Exp Grad Term', 
	A.ACAD_CAREER AS 'Career', 
	A.ACAD_PROG AS 'Program', 
	A.ACAD_PLAN AS 'Plan',
	A.BERK_IR_SCHOOL AS 'School', 
	A.CAMPUS AS 'Home Campus', 
	CASE WHEN A.CAMPUS = 'ONL' THEN 'ONL' ELSE 'ONS' END AS 'ONL/ONS',
	CASE WHEN A.BERK_IR_EF_OUT = 'GRADUATE' THEN 'Graduate' ELSE 'Non-Grad' END AS 'Outcome', A.CUM_GPA AS 'Cumulative GPA', 
	(ISNULL(A.BERK_IR_F_GRADE,0) + ISNULL(A.BERK_IR_FAIL_PF,0) + ISNULL(A.BERK_IR_WD_GRADES,0) + ISNULL(A.BERK_IR_DROP_CLASS,0)) 
		AS '# of F/W/I',
	SUM(CASE WHEN C.LOCATION <> 'ONLINE' AND C.CANCEL_DT IS NULL THEN B.UNT_TAKEN ELSE 0 END) OVER(PARTITION BY A.EMPLID) 
		AS '# ONS Credit',
	SUM(CASE WHEN C.LOCATION = 'ONLINE' AND C.CANCEL_DT IS NULL THEN B.UNT_TAKEN ELSE 0 END) OVER(PARTITION BY A.EMPLID) 
		AS '# ONL Credit',
	SUM(CASE WHEN C.LOCATION NOT LIKE '%'+A.CAMPUS+'%' AND C.CANCEL_DT IS NULL THEN B.UNT_TAKEN ELSE 0 END) OVER(PARTITION BY A.EMPLID) 
		AS '# Non-Home Credit',
	A.UNT_TAKEN_PRGRSS AS 'Total Term Credits',
	(SELECT (COUNT(D.RQ_AA_WHO_DATA)) 
		FROM PS_AA_OVERRIDE D 
			WHERE A.EMPLID = D.RQ_AA_WHO_DATA AND A.ACAD_PROG = D.ACAD_PROG AND A.ACAD_PLAN = D.ACAD_PLAN AND D.EFFDT > '2018-01-01') 
			AS '# Substitutions',
	(SELECT (CASE WHEN E.BERK_IR_SAP_IND_RS = 'M150' OR E.BERK_IR_SAP_IND_RS = 'NET4' THEN 'Y' ELSE 'N' END) 
		FROM PS_BERK_IR_TRM_CEN E 
			WHERE A.EMPLID = E.EMPLID AND A.STRM = E.STRM) 
			AS 'Exceed SAP?' 

FROM 
	PS_BERK_IR_TRM_RET A,
	(PS_STDNT_ENRL B LEFT OUTER JOIN PS_CLASS_TBL C ON B.CLASS_NBR = C.CLASS_NBR AND B.STRM = C.STRM)

		WHERE A.STRM = '1189' 
		AND A.EXP_GRAD_TERM = A.STRM
		AND A.STRM = B.STRM
		AND A.EMPLID = B.EMPLID
		AND A.ACAD_PROG = B.ACAD_PROG

		ORDER BY A.EXP_GRAD_TERM, A.EMPLID, A.CAMPUS;
