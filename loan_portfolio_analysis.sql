SELECT * FROM loan_portfolio_data
---A.BANK LOAN REPORT | SUMMARY
---KPI’s:
---Total Loan Applications
SELECT COUNT(id) AS Total_Applications 
FROM loan_portfolio_data
---The bank processed 38.6K loan applications during the reporting period, indicating strong lending demand and a sizable customer base.

---MTD Loan Applications
SELECT COUNT(id) AS Total_Applications 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12

---PMTD Loan Applications
SELECT COUNT(id) AS Total_Applications 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 11
---Loan applications increased by approximately 6.9% compared to the previous month, reflecting growing borrowing activity.

---Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount 
FROM loan_portfolio_data
---The bank disbursed over $435M in loans, demonstrating significant lending volume and market presence.

---MTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12

---PMTD Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 11
---Funded amount grew by around 13.0% month-over-month, suggesting stronger loan issuance in December.

---Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected 
FROM loan_portfolio_data
---Total repayments exceeded funded amounts, indicating healthy cash inflows and portfolio performance.

---MTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12

---PMTD Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 11
---Collections increased by 15.8% from the previous month, reflecting improved repayment performance.

---Average Interest Rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate 
FROM loan_portfolio_data
---The portfolio maintains an average lending rate of approximately 12%, balancing profitability and borrower affordability.

---MTD Average Interest
SELECT AVG(int_rate)*100 AS MTD_Avg_Int_Rate 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12

---PMTD Average Interest
SELECT AVG(int_rate)*100 AS PMTD_Avg_Int_Rate 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 11
---Average interest rates increased slightly in December, indicating a shift toward higher-risk or higher-yield loans.

---Avg DTI
SELECT AVG(dti)*100 AS Avg_DTI 
FROM loan_portfolio_data
---Borrowers generally maintain a manageable debt-to-income ratio, suggesting acceptable repayment capacity.

---MTD Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12

---PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 11
---DTI increased marginally, implying slightly higher borrower leverage in recent applications.

---GOOD LOAN ISSUED
---Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM loan_portfolio_data
---The vast majority of loans are classified as Good Loans, indicating a healthy and well-performing loan portfolio.

---Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications 
FROM loan_portfolio_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

---Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount 
FROM loan_portfolio_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

---Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received 
FROM loan_portfolio_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
---Good Loans account for most applications, funding, and repayments, highlighting strong portfolio quality and repayment behavior.

---BAD LOAN ISSUED
---Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM loan_portfolio_data
---Approximately 14% of loans were charged off, representing the primary source of credit risk within the portfolio.

---Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications 
FROM loan_portfolio_data
WHERE loan_status = 'Charged Off'

---Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount 
FROM loan_portfolio_data
WHERE loan_status = 'Charged Off'

---Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM loan_portfolio_data
WHERE loan_status = 'Charged Off'
---Bad Loans generated substantially lower repayment amounts compared to funding provided, resulting in financial losses for the bank.

---LOAN STATUS
SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
FROM loan_portfolio_data
GROUP BY loan_status

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM loan_portfolio_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status
---Fully Paid loans dominate the portfolio and generate the highest repayment value, indicating strong portfolio performance.
---Charged-Off loans exhibit higher interest rates and DTI levels, suggesting increased borrower risk.
---Current loans carry the highest average interest rates and DTI levels, reflecting ongoing exposure to higher-risk borrowers.

---B.BANK LOAN REPORT | OVERVIEW
---MONTH
SELECT 
	MONTH(issue_date) AS Month_Munber, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)
---Loan applications, funded amounts, and repayments increased steadily throughout the year. December recorded the highest values across all three metrics, indicating strong year-end lending demand and repayment activity.

---STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY address_state
ORDER BY address_state
---California (CA) and New York (NY) contribute the highest number of loan applications and funding volumes, making them the bank's most important lending markets.

---TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY term
ORDER BY term
---36-month loans are significantly more popular than 60-month loans, accounting for nearly three-quarters of all applications.

---EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY emp_length
ORDER BY emp_length
---Borrowers with more than 10 years of employment represent the largest customer segment, generating the highest application volume, funding amount, and repayments. Longer employment history appears positively associated with loan demand.

---PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY purpose
ORDER BY purpose
---Debt Consolidation is the dominant borrowing purpose, accounting for nearly half of total applications and funding volume.
---Credit card refinancing is the second most common reason for borrowing, indicating strong consumer demand for debt management solutions.

---HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
GROUP BY home_ownership
ORDER BY home_ownership
---Most borrowers either Rent or have a Mortgage, accounting for nearly all loan applications. Mortgage borrowers receive the highest funded amount, while Rent borrowers represent the largest customer group. Borrowers with Own, Other, or None home ownership contribute only a small share of the portfolio.

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose
---Borrowers with Grade A maintain a well-diversified loan portfolio, with Debt Consolidation remaining the primary borrowing purpose. Lower-risk borrowers also show relatively high demand for Credit Card refinancing and Home Improvement loans.

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
WHERE grade = 'B'
GROUP BY purpose
ORDER BY purpose
---Grade B follows a similar borrowing pattern to Grade A. Debt Consolidation dominates loan demand, while Credit Card and Home Improvement remain the second and third largest purposes.

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
WHERE grade = 'C'
GROUP BY purpose
ORDER BY purpose
---As borrower risk increases, Debt Consolidation continues to be the dominant purpose. Credit Card refinancing remains the second largest category, suggesting that debt management is a common financial need among medium-risk borrowers.

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
WHERE grade = 'D'
GROUP BY purpose
ORDER BY purpose
---Grade D borrowers exhibit a similar loan purpose distribution, although funded amounts become more concentrated in Debt Consolidation loans. Small Business loans also represent a noticeable share compared to higher-grade borrowers.

SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM loan_portfolio_data
WHERE grade = 'E'
GROUP BY purpose
ORDER BY purpose
---Despite representing the highest credit risk, Grade E borrowers still primarily seek loans for Debt Consolidation. Credit Card refinancing remains the second largest purpose, indicating that financially stressed borrowers mainly borrow to restructure existing debt.

---Overall Observation: Across all credit grades (A–E), Debt Consolidation consistently accounts for the largest number of applications and funded amount, followed by Credit Card loans. This suggests that managing existing debt is the primary reason customers apply for loans, regardless of their credit quality.