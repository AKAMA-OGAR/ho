 CREATE database `Bank`;
USE bank;
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_holder_name VARCHAR(100) NOT NULL,
    account_balance DECIMAL(15, 2) NOT NULL,
    account_type ENUM('savings', 'checking') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT * FROM accounts;

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer') NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
SELECT * FROM ACCOUNTS;

-- Inserting accounts
INSERT INTO accounts (account_number, account_holder_name, account_balance, account_type)
VALUES 
('1234567890', 'Alice Smith', 5000.00, 'savings'),
('0987654321', 'Bob Johnson', 3000.50, 'checking'),
('1122334455', 'Charlie Brown', 12000.00, 'savings'),
('2233445566', 'David White', 700.75, 'checking');
-- Inserting transactions
INSERT INTO transactions (account_id, transaction_type, amount)
VALUES
(1, 'deposit', 1000.00),    -- Deposit to Alice Smith's account
(2, 'withdrawal', 500.00),  -- Withdrawal from Bob Johnson's account
(3, 'deposit', 2000.00),    -- Deposit to Charlie Brown's account
(4, 'withdrawal', 300.75),  -- Withdrawal from David White's account
(1, 'withdrawal', 200.00),  -- Withdrawal from Alice Smith's account
(2, 'transfer', 150.00);    -- Transfer from Bob Johnson's account
SELECT * FROM TRANSACTIONS;

-- WRITE A QUERY TO FIND THE DISTINCT ACCOUNT TYPE
-- USE DISTINCT
SELECT Distinct account_type from accounts;
 
-- WRITE A QUERY TO FIND ALL ACCOUNTS WITH BALANCES GREATER THAN THE AVERAGE BALANCE
SELECT * FROM accounts
 WHERE account_balance
 > (SELECT avg(account_balance) FROM accounts);

-- WRITE A QUERY TO DISPLAY A MESSAGE "LOW BALANCE" IF AN ACCOUNT BALANCE IS BELOW 1000, AND "SUFFICIENT BALANCE" OTHERWISE
-- USING IF STATEMENT
SELECT *,
 IF(account_balance<1000,"low balance","sufficient balance")
 AS account_balance FROM accounts;
SELECT * FROM accounts;

-- WRITE A QUERY TO UPDATE THE ACCOUNT BALANCE OF A SPECIFIC ACCOUNT BY DEDUCTING 500 FROM THE CURRENT BALANCE WITH ID = 2
-- USING UPDATE
UPDATE accounts SET account_balance
 = 3000 - 500 WHERE account_id = 2;   
SELECT * FROM accounts;

-- WRITE A QUERY TO  ACCOUNTS WITH BALANCES LOWER THAN THE AVERAGE BALANCE
-- USING SUB-QUERY
SELECT * FROM accounts
 WHERE account_balance 
 < (SELECT avg(account_balance) FROM accounts);  

-- WRITE A QUERY TO DELETE ALL TRANSACTIONS OF AN ACCOUNT WITH ID OF 2
DELETE FROM transactions
 WHERE account_id = 2;
SELECT * FROM transactions;

-- JOIN ALL THE TWO TABLES TOGETHER
-- WE USE INNER JOIN TO JION TWO TABLES WHICH IS THE ACCOUNTS TABLE AND THE TRANSACTION TABLE
SELECT * FROM accounts
 JOIN transactions ON accounts.account_id 
 = transactions.account_id;
SELECT * FROM transactions;
SELECT * FROM accounts;

-- LEFT JOIN 
SELECT * FROM accounts LEFT JOIN transactions
 ON accounts.account_id = transactions.account_id;

-- FIND ALL THE ACCOUNTS THAT HAVE PERFORMED A WITHDRAWAL
-- ANOTHER METHOD OF USING INNER JOIN TO JOIN TWO TABLES
SELECT a.account_holder_name
FROM transactions t
JOIN accounts a
ON t.account_id = a.account_id
WHERE t.transaction_type = "withdrawal";

-- FIND ALL THE ACCOUNTS THAT HAVE MADE A DEPOSIT
-- I USE INNER JOIN
SELECT account_holder_name FROM  
  transactions join accounts on accounts.account_id
  = transactions.account_id WHERE transaction_type = "deposit"; 
  SELECT * FROM transactions;
   SELECT * FROM ACCOUNTS;
  
 -- FIND ALL THE ACCOUNTS THAT HAVE MADE A DEPOSIT
 -- I USE THE OTHER METHOD OF INNER JOIN 
  SELECT a.account_holder_name
FROM transactions t
JOIN accounts a
ON t.account_id = a.account_id
WHERE t.transaction_type = "deposit";

 -- LIST THE ACCOUNT NUMBER WITH AT LEAST ONE TRANSACTION OVER 1000
 -- I USE DISTINCT
 SELECT DISTINCT account_number FROM accounts
 JOIN transactions ON accounts.account_id = transactions.account_id
 WHERE amount  >  1000;
 SELECT * FROM TRANSACTIONS;
 SELECT * FROM ACCOUNTS;

-- SHOW THE HIGHEST TRANSACTION PER ACCOUNT HOLDER
SELECT
a.account_holder_name,
max(t.transaction_id) AS first_transaction_date
FROM transactions t
INNER JOIN accounts a ON t.account_id = a.account_id
GROUP BY t.transaction_id;

 SELECT * FROM TRANSACTIONS;
 SELECT * FROM ACCOUNTS;

-- SHOW THE ACCOUNT BALANCES AND THEIR NUMBER OF TRANSACTIONS
SELECT
a.account_balance,
count(t.transaction_id)AS first_transaction_date
FROM transactions t
INNER JOIN accounts a ON t.account_id = a.account_id
GROUP BY t.account_id;

-- FIND THE AVERAGE TRANSACTION AMOUNT FOR EACH ACCOUNT TYPE
SELECT
a.account_type,
avg(t.amount) AS first_transaction_date
FROM accounts a
INNER JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_type;

-- LIST ALL THE ACCOUNTS EVEN IF THEY HAVE NO TRANSACTIONS
SELECT a.account_number
FROM accounts a
join transactions t ON a.account_id = t.account_id
group by a.account_number;

-- SHOW THE TOTAL AMOUNT OF TRANSACTION PER ACCOUNT HOLDER
 SELECT
 a.account_holder_name,
 sum(t.amount)
 FROM transactions t
 JOIN accounts a
 ON t.account_id = a.account_id
 GROUP BY t.account_id;
 
 -- SHOW THE TOTAL AMOUNT OF TRANSACTION PER ACCOUNT HOLDER
 SELECT
 a.account_holder_name,
 sum(t.amount)
 FROM transactions t
 JOIN accounts a
 ON t.account_id = a.account_id
 GROUP BY t.account_id;
 
 -- SHOW THE TOTAL AMOUNT OF TRANSACTION PER ACCOUNT HOLDER
 -- USING LEFT JOIN
 SELECT
 a.account_holder_name,
 sum(t.amount)
 FROM transactions t left
 JOIN accounts a 
 ON t.account_id = a.account_id
 GROUP BY t.account_id;
 
-- LIST ALL THE TRANSACTIONS WITH MISSING ACCOUNT INFO
 SELECT *,  a.account_holder_name
FROM transactions t
JOIN accounts a
ON t.account_id = a.account_id
WHERE t.transaction_type =  "missing accounts"; 
SELECT * FROM TRANSACTIONS;

-- FIND THE TOTAL TRANSACTION AMOUNT FOR ALICE SMITH,
-- USE SUB QUERY
SELECT sum(amount)
FROM transactions
WHERE account_id = (SELECT account_id
FROM accounts WHERE account_holder_name = 'Alice smith');

-- LIST ALL TRANSACTIONS FOR THE ACCOUNT WITH THE LOWEST BALANCE
SELECT * FROM transactions WHERE account_id
 = (SELECT account_id FROM accounts ORDER BY account_balance ASC LIMIT 1);

-- LIST THE NAMES OF ALL ACCOUNT HOLDERS WHO MADE A WITHDRAWAL OF MORE THAN 250
SELECT account_holder_name FROM accounts WHERE account_id
IN (SELECT account_id FROM transactions WHERE
transaction_type = 'withdrawal' AND amount > 250);

-- FIND THE ACCOUNT NUMBER OF THE PERSON WHO DID THE HIGHEST TRANSACTION
 SELECT account_number FROM accounts WHERE account_id 
 = (SELECT account_id FROM transactions ORDER BY amount DESC LIMIT 1);
 
 -- list all transactions for charlie brown
 SELECT * FROM transactions WHERE account_id = (SELECT account_id
 FROM accounts WHERE account_id = "Charlie Brown");
 
 -- SHOW THE ACCOUNT WITH NO DEPOSIT
   SELECT *
FROM accounts
WHERE account_id
NOT IN (SELECT account_id
FROM transactions
WHERE transaction_type = "Deposit");
SELECT * FROM TRANSACTIONS;
SELECT * FROM ACCOUNTS;

 -- BOB JOHNSON DEOPSITED 1000 TO HIS ACCOUNT UPDATE HIS ACCOUNT TO 1000
 UPDATE accounts SET account_balance
 = account_balance + 1000 WHERE account_id = 2;
 SELECT * FROM transactions;
 
   -- SHOW THE NUMBER OF TRANSACTIONS MADE BY THE PERSON WITH THE HIGHEST ACCOUNT BALANCE
  SELECT
  count(transaction_id)  from transactions
  WHERE account_id 
  = (SELECT account_id from accounts
  order by account_balance asc limit 1); 
 
   -- EXISTS
  SELECT * FROM accounts
  WHERE EXISTS(SELECT * FROM accounts WHERE account_id = 1);
  
  -- NOT EXISTS
  SELECT * FROM accounts
  WHERE NOT EXISTS
  (SELECT * FROM accounts WHERE account_id = 1);
  
  -- USE SUB- QUERY AND EXISTS
  -- USE SUB-QUERY TO FIND THE ACCOUNT WITH BALANCE GREATER THAN 3000 AND ALL ROWS SHOULD BE DISPLAYED IF THE SUB-QUERY EXISTS
  SELECT * FROM accounts
  WHERE EXISTS(SELECT account_id FROM accounts WHERE account_balance > 3000);
  
 -- USE SUB-QUERY TO SELECT THE ACCOUNT_ ID AND WITHDRAWAL(TRANSACTION TYPE
 -- IF IT EXISTS, THEN SELECT EVERYTHING FROM THE TABLE WHERE NAME IS BOB JOHNSON
 SELECT * FROM accounts
 WHERE account_holder_name = "Bob Johnson" AND EXISTS
 (SELECT * FROM transactions WHERE account_id 
 AND transaction_type = "withdrawal");
 
-- STRING FUNCTIONS
-- LENGHT IS USE TO FIND THE LENGHT OF A STRING

SELECT length("Alice");

SELECT account_holder_name,length("account_holder_name")FROM accounts;

-- CONCAT
SELECT concat(account_holder_name," ",account_type) FROM accounts;
SELECT concat(account_holder_name," ",account_type) AS COMPLETE FROM accounts;
SELECT concat(account_number," ",account_balance)FROM accounts;

-- UPPER
SELECT upper("Alice")FROM accounts;
SELECT upper(account_holder_name)FROM accounts;

-- LOWER
SELECT lower("Alice")FROM accounts;

-- LOCATE
SELECT locate("X","Alenxander");


-- HOW TO ADD A COLUMN BALANCE TO THE TABLE
-- USE ALTER 
-- IF YOU WANT THE BALANCE TO BE AFTER ACCOUNT_HOLDER_NAME IN THE TABLE YOU USE AFTER
ALTER TABLE accounts ADD column balance int after account_holder_name;
select * from accounts;
-- IF YOU WANT BALANCE TO COME FIRST IN THE TABLE YOU USE FIRST
ALTER TABLE accounts ADD column balance int First;
-- HOW TO DROP A COLUMN
ALTER TABLE accounts drop column balance;
