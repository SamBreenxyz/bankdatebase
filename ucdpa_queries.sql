-- Query 1: Employees in London Branches (INNER JOIN)
-- Advanced Technique Explanation:
-- INNER JOIN precisely matches employees to their respective branches by branch_id. Chosen for its efficiency in directly linking records, improving query performance and accuracy when filtering by city.
SELECT e.first_name, e.last_name, e.salary
FROM uk_employees e
JOIN uk_branches b ON e.branch_id = b.branch_id
WHERE b.city = 'London';

-- Query 2: Customers in Lowest 10% Credit Scores (Window Functions - PERCENT_RANK & LEAD)
-- Advanced Technique Explanation:
-- Utilises PERCENT_RANK() to segment customers into percentile ranks and LEAD() to identify gaps between consecutive credit scores. This approach highlights customers in the lowest decile and provides insights into the distribution of low credit scores.
WITH RankedCustomers AS (
    SELECT customer_id, first_name, last_name, credit_score,
           PERCENT_RANK() OVER (ORDER BY credit_score ASC) AS pct_rank,
           LEAD(credit_score) OVER (ORDER BY credit_score ASC) AS next_higher_score
    FROM uk_customers
)
SELECT customer_id, first_name, last_name, credit_score,
       (next_higher_score - credit_score) AS gap_to_next_score
FROM RankedCustomers
WHERE pct_rank <= 0.10;

-- Query 3: Account Type Summary (Aggregation & HAVING)
-- Advanced Technique Explanation:
-- Aggregates accounts by type using COUNT and AVG, with a HAVING clause to filter only significant account types. Demonstrates efficiency and clarity in summarising data and filtering aggregated results.
SELECT account_type,
       COUNT(*) AS total_accounts,
       ROUND(AVG(balance), 2) AS avg_balance
FROM uk_accounts
GROUP BY account_type
HAVING COUNT(*) > 1;

-- Query 4: Branches with High-Value Accounts (Correlated Subquery)
-- Advanced Technique Explanation:
-- Employs a correlated subquery, directly linking each branch to the account counts individually. Clearly demonstrates proficiency in advanced SQL constructs, enhancing clarity and data retrieval accuracy.
SELECT b.branch_name,
       (SELECT COUNT(*) FROM uk_accounts a
        WHERE a.branch_id = b.branch_id AND a.balance > 10000) AS high_value_accounts
FROM uk_branches b;

-- Query 5: Transactions per Account Type (Window Function)
-- Advanced Technique Explanation:
-- Utilises window function COUNT() OVER PARTITION BY for efficiently summarising transaction counts per account type, eliminating the need for a GROUP BY clause and showcasing advanced analytical SQL skills.
SELECT DISTINCT a.account_type,
       COUNT(t.transaction_id) OVER (PARTITION BY a.account_type) AS total_transactions
FROM uk_transactions t
JOIN uk_accounts a ON t.account_id = a.account_id;

-- Query 6: Branches with High Credit-Score Customers (DISTINCT & JOIN)
-- Technique Explanation:
-- DISTINCT with JOIN operations clearly identifies unique branches serving customers with high credit scores, eliminating duplication from multiple customer accounts per branch.
SELECT DISTINCT b.branch_name
FROM uk_branches b
JOIN uk_accounts a ON b.branch_id = a.branch_id
JOIN uk_customers c ON a.customer_id = c.customer_id
WHERE c.credit_score > 800;

-- Query 7: Customers with Mortgage Loans (Multiple JOINs)
-- Advanced Technique Explanation:
-- Clearly demonstrates sequential JOIN operations for accurate matching between customers, loans, and accounts, filtering explicitly for mortgage loans.
SELECT DISTINCT c.first_name, c.last_name, a.account_type
FROM uk_customers c
JOIN uk_loans l ON c.customer_id = l.customer_id
JOIN uk_accounts a ON c.customer_id = a.customer_id
WHERE l.loan_type = 'Mortgage';

-- Query 8: Branches without Credit Card Customers (NOT EXISTS)
-- Advanced Technique Explanation:
-- Utilises NOT EXISTS as an anti-join method, clearly and efficiently identifying branches without customers holding credit cards.
SELECT b.branch_name,
       e.first_name AS manager_first_name,
       e.last_name AS manager_last_name
FROM uk_branches b
LEFT JOIN uk_employees e ON b.manager_id = e.employee_id
WHERE NOT EXISTS (
    SELECT 1
    FROM uk_accounts a
    JOIN uk_cards c ON a.account_id = c.account_id
    WHERE c.card_type = 'Credit' AND a.branch_id = b.branch_id
);

-- Query 9: Customers with Both Current and Savings Accounts (INTERSECT)
-- Advanced Technique Explanation:
-- Employs INTERSECT set operation to clearly identify customers holding both Current and Savings accounts
SELECT first_name, last_name
FROM uk_customers
WHERE customer_id IN (
    SELECT customer_id FROM uk_accounts WHERE account_type = 'Current'
    INTERSECT
    SELECT customer_id FROM uk_accounts WHERE account_type = 'Savings'
);

-- Query 10: Loan Amount Range per Loan Type (Aggregation)
-- Advanced Technique Explanation:
-- Aggregates data to compute loan amount ranges by type, clearly presenting variability insights within loan categories.
SELECT loan_type,
       MAX(amount) - MIN(amount) AS loan_amount_range
FROM uk_loans
GROUP BY loan_type;

-- Query 11: Average Loan Amount by Branch (Nested CTEs)
-- Advanced Technique Explanation:
-- Implements nested Common Table Expressions for organised, extraction and aggregation.
WITH AccountLoans AS (
    SELECT a.branch_id, l.amount
    FROM uk_accounts a
    JOIN uk_loans l ON a.customer_id = l.customer_id
),
BranchAggregates AS (
    SELECT b.branch_name, AVG(al.amount) AS average_amount
    FROM AccountLoans al
    JOIN uk_branches b ON al.branch_id = b.branch_id
    GROUP BY b.branch_name
)
SELECT branch_name, ROUND(average_amount, 2) AS average_loan_amount
FROM BranchAggregates;

-- Query 12: Customers with All Account Types (HAVING & Subquery)
--Technique Explanation:
-- Uses HAVING clause and subquery to clearly confirm customers possessing every available account type
SELECT c.customer_id, c.first_name, c.last_name, c.credit_score
FROM uk_customers c
JOIN uk_accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.credit_score
HAVING COUNT(DISTINCT a.account_type) = (
    SELECT COUNT(DISTINCT account_type) FROM uk_accounts
);
