-- Aggregating the customer deposits first
WITH total_deposits AS
(
         SELECT   owner_id,
                  Sum(confirmed_amount) AS deposit_amount
         FROM     `adashi_staging`.`savings_savingsaccount`
         WHERE    transaction_status='success'
         GROUP BY owner_id)
SELECT    pp.owner_id,
                    concat(uc.first_name, " ", uc.last_name) AS NAME ,
          sum(pp.is_a_fund)                                  AS investment_count,
          sum(pp.is_regular_savings)                         AS savings_account ,
          td.deposit_amount AS total_deposits
FROM      `adashi_staging`.`plans_plan` pp
LEFT JOIN `adashi_staging`.`users_customuser` uc
ON        uc.id=pp.owner_id
LEFT JOIN total_deposits td
ON        td.owner_id=uc.id
GROUP BY  pp.owner_id
HAVING    sum(is_a_fund) >1
AND       sum(is_regular_savings) = 1
ORDER BY  deposit_amount;