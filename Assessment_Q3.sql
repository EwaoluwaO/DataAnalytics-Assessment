-- using a cte so it is possible to use the case when field as a filter
WITH user_inactivity AS
(
         SELECT   sa.plan_id,
                  sa.owner_id,
                  CASE
                           WHEN pp.is_regular_savings=1 THEN 'savings'
                           WHEN pp.is_a_fund= 1 THEN 'investment'
                           ELSE NULL
                  END                                    AS type,
                  Max(transaction_date)                  AS last_transaction_date,
                  Datediff(Now(), Max(transaction_date)) AS inactivity_days
         FROM     `adashi_staging`.`savings_savingsaccount` sa
         JOIN     `adashi_staging`.`plans_plan` pp
         ON       pp.id=sa.plan_id
         GROUP BY plan_id,
                  owner_id
         HAVING   last_transaction_date NOT BETWEEN date_sub(now(), interval 365 day) AND      now())
SELECT *
FROM   user_inactivity
WHERE  type IS NOT NULL;