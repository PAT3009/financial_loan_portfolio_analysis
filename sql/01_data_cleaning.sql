-- Data Quality Check
-- Check Duplicate Loan ID
SELECT id, COUNT(*) AS duplicate_count
FROM loan_portfolio_data
GROUP BY id
HAVING COUNT(*) > 1;
-- No duplicate Loan IDs were found, indicating that each loan record has a unique identifier.
-- Check Missing Values
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS Missing_ID,
    SUM(CASE WHEN issue_date IS NULL THEN 1 ELSE 0 END) AS Missing_Issue_Date,
    SUM(CASE WHEN loan_amount IS NULL THEN 1 ELSE 0 END) AS Missing_Loan_Amount,
    SUM(CASE WHEN loan_status IS NULL THEN 1 ELSE 0 END) AS Missing_Loan_Status
FROM loan_portfolio_data;
# Missing value check was performed on key variables (id, issue_date, loan_amount, loan_status). No missing values were detected in the dataset.
-- Check Loan Status
SELECT DISTINCT loan_status
FROM loan_portfolio_data;
-- Check Employment Length
SELECT DISTINCT emp_length
FROM loan_portfolio_data;
-- Standardize Date Format
SET SQL_SAFE_UPDATES = 0;
UPDATE loan_portfolio_data
SET
    issue_date = DATE_FORMAT(STR_TO_DATE(issue_date, '%d-%m-%Y'), '%Y-%m-%d'),
    last_credit_pull_date = DATE_FORMAT(STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'), '%Y-%m-%d'),
    last_payment_date = DATE_FORMAT(STR_TO_DATE(last_payment_date, '%d-%m-%Y'), '%Y-%m-%d'),
    next_payment_date = DATE_FORMAT(STR_TO_DATE(next_payment_date, '%d-%m-%Y'), '%Y-%m-%d');
ALTER TABLE loan_portfolio_data
MODIFY issue_date DATE,
MODIFY last_credit_pull_date DATE,
MODIFY last_payment_date DATE,
MODIFY next_payment_date DATE;
SELECT
    issue_date,
    last_credit_pull_date,
    last_payment_date,
    next_payment_date
FROM loan_portfolio_data
LIMIT 10;
-- Validate Interest Rate
-- Interest rate validation was performed to identify values below 0% or above 100%. No invalid interest rate values were found in the dataset.
-- Validate DTI
SELECT *
FROM loan_portfolio_data
WHERE dti < 0
OR dti > 1;
-- DTI validation was performed. No invalid DTI values were identified in the dataset.