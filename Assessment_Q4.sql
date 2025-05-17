WITH account_clv AS
(
         SELECT   sa.owner_id                   AS customer_id,
                  Count(id)                     AS total_transactions,
                  (0.001*Sum(confirmed_amount)) AS avg_profit_per_transaction
         FROM     `adashi_staging`.`savings_savingsaccount` sa
         WHERE    transaction_status='success'
         GROUP BY sa.owner_id), user_details AS
(
       SELECT id,
                     concat(uc.first_name, " ", uc.last_name) AS NAME,
              timestampdiff(month,uc.created_on, now())       AS tenure_months
       FROM   `adashi_staging`.`users_customuser`uc)
SELECT    ud.id AS customer_id,
          ud.NAME,
          ud.tenure_months,
          ac.total_transactions,
          round((ac.total_transactions/ud.tenure_months)*12*avg_profit_per_transaction, 2) AS estimated_clv
FROM      user_details ud
LEFT JOIN account_clv ac
ON        ac.customer_id=ud.id
ORDER BY  estimated_clv DESC