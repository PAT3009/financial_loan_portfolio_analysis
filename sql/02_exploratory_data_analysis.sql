-- A. Loan Portfolio Overview
-- 1. Loan Status Distribution
SELECT loan_status, COUNT(*) AS Loan_Count
FROM loan_portfolio_data
GROUP BY loan_status;
-- Charged Off loans represent ~90% of the portfolio.
-- Further analysis is needed to identify risk drivers (Grade, DTI, Income, etc.).
-- 2. Total Funded Amount by Loan Status
SELECT loan_status, SUM(loan_amount) AS funded_amount
FROM loan_portfolio_data
GROUP BY loan_status;
-- Fully Paid loans dominate the portfolio (~88%).
-- Charged Off loans account for only ~12%, indicating relatively low default risk.
-- B. Risk Analysis
-- 3. Default Rate by Grade
SELECT grade,
    COUNT(*) AS total_loans,
    COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END) AS default_loans,
    ROUND( COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END) *100.0/COUNT(*),2) AS default_rate
FROM loan_portfolio_data
GROUP BY grade
ORDER BY grade;
-- Grade A has the lowest default rate (5.26%).
-- Grades B-D exhibit substantially higher default rates (19%-26%).
-- Grade E shows 0% default rate, but the sample size is too small (2 loans) for meaningful conclusions.
-- 4. Default Rate by Home Ownership
SELECT home_ownership,
    COUNT(*) AS total_loans,
    COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END) AS default_loans
FROM loan_portfolio_data
GROUP BY home_ownership;
-- Renters show the highest default rate (20.21%).
-- Borrowers with mortgages have the lowest default rate (6.09%).
-- The result suggests that housing stability may be associated with lower credit risk.
-- 5. Default Rate by Employment Length
SELECT emp_length,
    COUNT(*) AS total_loans,
    COUNT(CASE WHEN loan_status='Charged Off' THEN 1 END) AS default_loans,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2 ) AS default_rate
FROM loan_portfolio_data
GROUP BY emp_length;
-- Borrowers with less than 1 year of employment exhibit the highest default rate (24.39%).
-- Long-term employees (10+ years) show a substantially lower default rate (6.12%).
-- This suggests that employment stability may be associated with lower credit risk.
-- C. Borrower Profile
-- 6. Average Income by Grade
SELECT grade, AVG(annual_income) AS avg_income
FROM loan_portfolio_data
GROUP BY grade
ORDER BY grade;
-- Average annual income is relatively consistent across all loan grades, ranging from approximately $60K to $65K.
-- No significant income differences are observed between grades.
-- This suggests that loan grading may be influenced by factors beyond borrower income, such as credit history, repayment behavior, and debt obligations.
-- 7.Average DTI by Loan Status
SELECT loan_status, AVG(dti)*100 AS avg_dti
FROM loan_portfolio_data
GROUP BY loan_status;
-- Charged Off loans have a slightly higher average DTI (11.39%) than Fully Paid loans (11.02%).
-- However, the difference is relatively small, suggesting DTI alone may not strongly explain loan defaults.
-- D. Loan Characteristics
-- 8. Average Interest Rate by Grade
SELECT grade, AVG(int_rate)*100 AS avg_interest_rate
FROM loan_portfolio_data
GROUP BY grade
ORDER BY grade;
-- Average interest rates increase consistently from Grade A (7.01%) to Grade E (16.29%).
-- Lower credit grades are charged higher interest rates to compensate for increased lending risk.
-- 9. Loan Amount by Term
SELECT term, AVG(loan_amount) AS avg_loan_amount
FROM loan_portfolio_data
GROUP BY term;
-- Loans with a 36-month term have a higher average loan amount ($5,985) than 60-month loans ($3,708).
-- This suggests that longer loan terms are not necessarily associated with larger loan amounts in this dataset.
-- E. Time Analysis
-- 10. Monthly Loan Applications Trend
SELECT MONTH(issue_date) AS month_number, COUNT(*) AS total_applications
FROM loan_portfolio_data
GROUP BY MONTH(issue_date)
ORDER BY month_number;
-- Loan applications remained relatively stable throughout the year.
-- Application volume peaked in March, June, and November (36 applications each).
-- Lower application activity was observed between July and September.
-- 11. Monthly Funded Amount Trend
SELECT MONTH(issue_date) AS month_number, SUM(loan_amount) AS total_funded
FROM loan_portfolio_data
GROUP BY MONTH(issue_date)
ORDER BY month_number;
-- Loan disbursement showed a downward trend from March to August,
-- followed by a strong recovery in Q4.
-- December achieved the highest funded amount, indicating increased lending activity at year-end.