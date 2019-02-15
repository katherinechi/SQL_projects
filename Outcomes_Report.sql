/* For 1189 Expected Graduate Report, select population from Term Census table, join with Term Retention Table for term-to-term outcomes */

SELECT A.EMPLID AS 'Student ID', A.NAME_PSFORMAT AS 'Student Name', A.STRM AS 'Census Term', A.EXP_GRAD_TERM AS 'Census Exp Grad', 
B.EXP_GRAD_TERM AS 'Term Ret Exp Grad', A.BERK_IR_CAMPUS_DSC AS 'Campus', B.BERK_IR_EF_OUT AS 'Outcome', B.CUM_GPA AS 'Cumulative GPA',
B.CUR_GPA AS 'Current GPA', B.BERK_IR_F_GRADE AS 'F Grade', B.BERK_IR_D_GRADE AS 'D Grade', B.BERK_IR_WD_GRADES AS 'Withdrew', 
B.BERK_IR_DROP_CLASS AS 'Dropped', CASE WHEN B.CUM_GPA < 2.0 THEN 'CGPA<2.0' ELSE 'CGPA>2.0' END AS 'CGPA < 2.0'
	FROM PS_BERK_IR_TRM_CEN A
	LEFT JOIN PS_BERK_IR_TRM_RET B
		ON A.STRM = B.STRM AND A.EMPLID = B.EMPLID
	WHERE A.STRM = '1189' AND A.EXP_GRAD_TERM = '1189';

/* For 1189 Expected Graduate Report, produce a summary table with counts for number of students by campus and outcome category */

SELECT A.BERK_IR_CAMPUS_DSC AS 'Campus', B.BERK_IR_EF_OUT AS 'Outcome', COUNT(B.BERK_IR_EF_OUT) AS 'Count by Outcome'
FROM PS_BERK_IR_TRM_CEN A
	LEFT JOIN PS_BERK_IR_TRM_RET B
		ON A.STRM = B.STRM AND A.EMPLID = B.EMPLID
	WHERE A.STRM = '1189' AND A.EXP_GRAD_TERM = '1189'
	GROUP BY A.BERK_IR_CAMPUS_DSC, B.BERK_IR_EF_OUT
	ORDER BY A.BERK_IR_CAMPUS_DSC ASC, B.BERK_IR_EF_OUT ASC;