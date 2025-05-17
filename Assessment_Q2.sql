-- First getting the monthly transactions for each user each month
WITH MonthlyTransactionCounts AS (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
        COUNT(id) AS monthly_transaction_count
    FROM
        `adashi_staging`.`savings_savingsaccount`
	where transaction_status='success'
    GROUP BY
        owner_id,
        transaction_month
),
-- Getting the average transactions for each user
AverageMonthlyTransactions AS (
    SELECT
        owner_id,
        AVG(monthly_transaction_count) AS average_transactions_per_month
    FROM
        MonthlyTransactionCounts
    GROUP BY
        owner_id
)
-- Categorizing the average transactions
SELECT
    CASE
        WHEN amt.average_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN amt.average_transactions_per_month >= 3 AND amt.average_transactions_per_month < 10 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
	    count(amt.owner_id) as customer_count,
    avg(amt.average_transactions_per_month) as avg_transactions_per_month
FROM
    AverageMonthlyTransactions amt
GROUP BY frequency_category;