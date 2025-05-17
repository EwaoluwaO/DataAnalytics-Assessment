# DataAnalytics-Assessment

# SQL Query Solutions

This document outlines the thought process and challenges involved in solving several SQL tasks.

## Question 1

**Task:** Write a query to find customers with at least one funded savings plan **AND** one funded investment plan, sorted by total deposits.

**Tables Used:** `users_customuser`, `plans_plan`, `savings_savingsaccount`

**Required Columns:**

* `Owner_id` (`users_customuser`)
* `Name` (`users_customuser`)
* `Savings count` (`plans_plan`)
* `Investment count` (`plans_plan`)
* `Total deposits` (`savings_savingsaccount`)

**Solution Approach:**

This was achieved by first using a Common Table Expression (CTE) to aggregate the total deposits for each customer, filtering for successful transactions only. Next, the first and last names from the `users_customuser` table were concatenated to obtain the customer's full name. The query then counted the number of savings and investment plans associated with each user from the `plans_plan` table. Finally, the CTE was joined with the `users_customuser` and `plans_plan` tables to retrieve the required information.

**Challenges:**

Initially, using raw table joins resulted in slow query execution due to the large volume of data in the transactions table. To address this performance issue, a CTE was employed to pre-aggregate the transaction data from the `savings_savingsaccount` table before joining with other tables.

## Question 2

**Task:** Calculate the average number of transactions per customer per month and categorize them.

**Tables Used:** (Implied: `transactions` table)

**Required Columns:**

* `Frequency_category`
* `Customer_count`
* `Avg_transactions_per_month`

**Solution Approach:**

This task was accomplished using multiple CTEs.

1.  **`MonthlyTransactionCounts` CTE:** This CTE determined the number of transactions per month for each user, also ensuring only successful transactions were selected.
2.  **`AverageMonthlyTransactions` CTE:** This CTE then calculated the average monthly transaction count for each user by using the results from the `MonthlyTransactionCounts` CTE.
3.  **Final `SELECT` Statement:** The final query categorized users based on their average monthly transaction count (High, Medium, Low Frequency), counted the number of users within each category, and displayed the average transaction count for each frequency category.

## Question 3

**Task:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

**Tables Used:** `plans_plan`, `savings_savingsaccount`

**Required Columns:**

* `Plan_id` (`plans_plan`)
* `Owner_id` (`plans_plan`)
* `Type` (`plans_plan`)
* `Last_transaction_date` (`savings_savingsaccount`)
* `Inactivity_days` (generated from `savings_savingsaccount`)

**Solution Approach:**

A CTE was used to select the necessary fields from the relevant tables. Next, a `SELECT` query was used to filter the results based on the account type. The most recent transaction date for each user was identified using the `MAX` function. The inactivity period was calculated by subtracting the last transaction date from the current date. A `CASE` statement was employed to group plans by their type (savings or investment). Finally, users with no transactions in the past year were identified by filtering those whose last transaction date was not within the range of 365 days prior to the current date.

## Question 4

**Task:** For each customer, assuming the `profit_per_transaction` is 0.1% of the transaction value, calculate:

* Account tenure (months since signup)
* Total transactions
* Estimated CLV (Assume: CLV = (`total_transactions` / tenure) \* 12 \* `avg_profit_per_transaction`))
* Order by estimated CLV from highest to lowest

**Tables Used:** `users_customuser`, `savings_savingsaccount`

**Required Columns:**

* `customer_id` (`users_customuser`)
* `name` (`users_customuser`)
* `tenure_months` (`users_customuser`)
* `total_transactions` (`savings_savingsaccount`)
* `estimated_clv` (generated from the other columns)

**Solution Approach:**

This problem was solved using two CTEs.

1.  **`Account_clv` CTE:** This CTE calculated the average profit per transaction for each user, which is a needed value for determining the Customer Lifetime Value (CLV).
2.  **`User_details` CTE:** This CTE retrieved the full name of each user by concatenating their first and last names. It also calculated the account tenure in months by finding the difference between their `created_at` date and the current date.

The final query then joined the data from these CTEs and computed the estimated CLV using the provided formula. The results were then ordered in descending order based on the calculated CLV.
