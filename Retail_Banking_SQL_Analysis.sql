-- =========================================
-- DATABASE SETUP
-- =========================================

create database retail_banking;
use retail_banking;

-- =========================================
-- TABLE CREATION
-- =========================================

create table Branches(
	branch_id varchar(10) primary key ,
    branch_name varchar(100) not null ,
    city varchar(50) not null ,
    state varchar(30) not null ,
    region varchar(20) not null ,
    opening_date date not null ,
    employee_count int not null 
);

create table Customers(
	customer_id varchar(20) primary key ,
    first_name varchar(50) not null,
    last_name varchar(50) not null ,
    date_of_birth date not null ,
    gender varchar(20) not null ,
    city varchar(50) not null ,
    state varchar(30) not null ,
    customer_since date not null , 
    kyc_status varchar(20) not null ,
    segment varchar(30) not null ,
    annual_income decimal(12,2) not null,
    credit_score int not null ,
    is_active varchar(5) not null 
);	

create table Accounts(
	account_id varchar(20) primary key ,
    customer_id varchar(20) not null ,
    branch_id varchar(10) not null ,
    account_type varchar(30) not null,
    open_date date not null,
    close_date date default null,
    current_balance decimal(15,2) not null ,
    interest_rate decimal(5,2) not null ,
    overdraft_limit decimal(12,2) default 0 ,
    `status` varchar(20) not null ,
    
    foreign key(customer_id)
		references Customers(customer_id),
	foreign key(branch_id) 
		references Branches(branch_id)
);

-- Temporary staging table used to import and transform accounts.csv data
-- before inserting the cleaned data into the final Accounts table.

CREATE TABLE Accounts_import (
    account_id VARCHAR(20),
    customer_id VARCHAR(20),
    branch_id VARCHAR(10),
    account_type VARCHAR(30),
    open_date VARCHAR(30),
    close_date VARCHAR(30),
    current_balance VARCHAR(30),
    interest_rate VARCHAR(30),
    overdraft_limit VARCHAR(30),
    status VARCHAR(20)
);

-- IMPORTANT:
-- Import accounts.csv into Accounts_import using
-- MySQL Workbench > Table Data Import Wizard.
-- After importing the CSV, execute the INSERT statement below.

INSERT INTO Accounts
(
    account_id,
    customer_id,
    branch_id,
    account_type,
    open_date,
    close_date,
    current_balance,
    interest_rate,
    overdraft_limit,
    status
)
SELECT
    account_id,
    customer_id,
    branch_id,
    account_type,
    STR_TO_DATE(NULLIF(TRIM(open_date), ''), '%Y-%m-%d'),
    STR_TO_DATE(NULLIF(TRIM(close_date), ''), '%Y-%m-%d'),
    CAST(current_balance AS DECIMAL(15,2)),
    CAST(interest_rate AS DECIMAL(5,2)),
    CAST(overdraft_limit AS DECIMAL(12,2)),
    status
FROM Accounts_import;

-- Remove the temporary staging table after the data has been transferred.

drop table Accounts_import;

create table Transactions (
	transaction_id varchar(20) primary key ,
    account_id varchar(20) not null ,
    transaction_date date not null ,
    transaction_time time not null ,
    transaction_type varchar(20) not null ,
    amount decimal(15,2) not null  ,
    `channel` varchar(30) not null ,
    `description` varchar(50) not null,
    balance_after decimal(15,2) not null ,
	`status` varchar(20) not null ,
    
    foreign key(account_id)
		references Accounts(account_id)
        
);

create table cards (
	card_id varchar(20) primary key ,
    account_id varchar(20) not null ,
    card_type varchar(20) not null ,
    issue_date date not null ,
    expiry_date date not null , 
    credit_limit decimal(12,2) not null ,
    outstanding_balance decimal(12,2) not null ,
    reward_points int not null ,
    is_active varchar(3) not null ,
    network varchar(20) not null ,
    
    foreign key(account_id)
		references Accounts(account_id)
    
);

create table Loans(
	loan_id varchar(20) primary key ,
    customer_id varchar(20) not null,
    branch_id varchar(10) not null ,
    loan_type varchar(30) not null ,
    principal_amount decimal(15,2) not null ,
    interest_rate decimal(5,2) not null ,
    tenure_months int not null ,
    disbursement_date date not null , 
    maturity_date date not null ,
    emi_amount decimal(12,2) not null ,
    outstanding_balance decimal(15,2) not null ,
    loan_status varchar(30) not null,
    purpose varchar(50) not null ,
    
    foreign key(customer_id)
		references Customers(customer_id),
	foreign key(branch_id)
		references Branches(branch_id)
); 

create table Loan_payments (
	payment_id varchar(20) primary key ,
    loan_id varchar(20) not null,
    payment_date date not null , 
    scheduled_amount decimal(12,2) not null ,
    paid_amount decimal(12,2) not null ,
    principal_paid decimal(12,2) not null ,
    interest_paid decimal(12,2) not null ,
    penalty decimal(12,2) not null ,
    days_late int not null , 
    payment_method varchar(30) not null ,
    `status` varchar(20) not null,
    
    foreign key(loan_id)
		references Loans(loan_id)
);


-- =========================================
-- BASIC SQL ANALYSIS
-- =========================================

-- What is the total number of customers?
select count(*) from customers;

-- What is the total number of accounts?
select count(*) from accounts;

-- What are the different account types available?
select distinct account_type from accounts;

-- How many customers are currently active?
select count(*) from customers where is_active = 'Yes';

-- What are the different transaction types available?
select distinct transaction_type from transactions ; 

-- What is the total amount of completed transactions?
select sum(amount) from transactions where status = 'Completed';

-- What are the different loan types available?
select distinct loan_type from loans;

-- What is the total number of loans?
select count(*) from loans ;

-- What are the different card types available?
select distinct card_type from cards;

-- What is the total outstanding loan balance?
select sum(outstanding_balance) from loans;

-- =========================================
-- CUSTOMER PROFILE & SEGMENTATION
-- =========================================

-- Question 1: How many customers does the bank have?
select count(*) as total_customers
from customers;

-- Question 2: How many customers are in each segment?
select segment,count(*) as customer_count from customers group by segment order by customer_count desc ;

-- Question 3: What percentage of customers belong to each segment?
select segment , count(*) as customer_count , round(count(*) * 100 / (select count(*) from customers),2) as percentage from customers 
group by segment order by percentage desc;
 
-- Question 4: How many customers are active and inactive?
select is_active , count(*) as customer_count from customers group by is_active;

-- Question 5: What is the average annual income of customers?
select avg(annual_income) as average_income from customers ; 

-- Question 6: What is the average income by customer segment?
select segment , round(avg(annual_income),2) as average_income from customers group by segment order by average_income desc ; 

-- Question 7: What is the average credit score by customer segment?
select segment , round(avg(credit_score),2) as average_credit_score from customers 
group by segment order by average_credit_score desc;

-- Question 8: Which states have the most customers?
select state , count(*) as customer_count from customers group by state order by customer_count desc ; 

-- Question 9 : Which cities have the most customers?
select city, count(*) as customer_count from customers group by city order by customer_count desc ;

-- =========================================
-- ACCOUNT USAGE & BRANCH ACTIVITY
-- =========================================  

-- Q1. How many accounts are there for each account type? 
select account_type , count(*) as account_count from accounts group by account_type order by account_count desc ; 

-- Q2. What is the total balance held in each account type?
select account_type , sum(current_balance) as total_balance from accounts 
group by account_type order by total_balance desc;

-- Q3. What is the average balance for each account type?
select account_type , round(avg(current_balance),2) as average_balance from accounts 
group by account_type order by average_balance desc; 

-- Q4. How many accounts are active and closed?
select status,count(*) as account_count from accounts group by status;

-- Q5. What is the total balance by account status?
select status , sum(current_balance) as total_balance from accounts 
group by status order by total_balance desc ; 

-- Q6. How many accounts does each branch have?
select b.branch_name , b.city , count(a.account_id) as account_count from branches b 
join accounts a on b.branch_id = a.branch_id group by b.branch_id , b.branch_name,b.city 
order by account_count desc ; 

-- Q7. Which branches have the highest total account balance?
select b.branch_name,b.city,sum(a.current_balance) as total_balance
from branches b join accounts a on b.branch_id = a.branch_id 
group by b.branch_id, b.branch_name, b.city order by total_balance desc;

-- Q8. What is the average account balance by region?
select b.region, round(avg(a.current_balance), 2) AS average_balance
from branches b join accounts a on b.branch_id = a.branch_id
group by b.region order by average_balance desc;

-- Q9. Which branches have the highest number of accounts per employee?
select b.branch_name, b.employee_count,count(a.account_id) as account_count,
round(count(a.account_id) / b.employee_count, 2) as accounts_per_employee
from branches b join accounts a on b.branch_id = a.branch_id
group by  b.branch_id, b.branch_name, b.employee_count
order by accounts_per_employee desc;

-- =========================================
-- TRANSACTION PATTERNS
-- =========================================

-- Q1. What are the different transaction types and how many transactions are there for each?
select transaction_type , count(*) as transaction_count from transactions
group by transaction_type order by transaction_count desc;

-- Q2. What is the total transaction amount by transaction type?
select transaction_type,sum(amount) as total_amount from transactions
group by transaction_type order by total_amount desc;

-- Q3. Which transaction channels are used most frequently?
select channel,count(*) as transaction_count from transactions 
group by channel order by transaction_count desc;

-- Q4. What is the total transaction amount by channel?
select channel, sum(amount) as total_amount from transactions
group by channel order by total_amount desc;

-- Q5. How many transactions are there for each status?
select status, count(*) as transaction_count from transactions 
group by status order by transaction_count desc;

-- Q6. What percentage of transactions have each status?
select status,count(*) as transaction_count,
round(count(*) * 100.0 / (select count(*) from transactions),2) as percentage
from transactions group by status order by percentage desc;

-- Q7. How many transactions occur on each date?
select transaction_date,count(*) as transaction_count 
from transactions group by transaction_date order by transaction_date;

-- Q8. What is the total transaction amount by date?
select transaction_date,sum(amount) as total_amount
from transactions group by transaction_date order by transaction_date;

-- Q9. Which day had the highest transaction volume?
select transaction_date,count(*) as transaction_count from transactions 
group by transaction_date order by transaction_count desc limit 1;

-- Q10. Which accounts have the highest number of transactions?
select account_id,count(*) as transaction_count from transactions
group by account_id order by transaction_count desc;

-- Q11. Which accounts have the highest total transaction amount?
select account_id,sum(amount) as total_transaction_amount from transactions
group by account_id Order by total_transaction_amount DESC;

-- =========================================
-- LOAN PERFORMANCE & REPAYMENT BEHAVIOUR
-- =========================================

-- Q1. How many loans are there for each loan type?
select loan_type,count(*) as loan_count from loans 
group by loan_type order by loan_count desc;

-- Q2. What is the total principal amount by loan type?
select loan_type, sum(principal_amount) as total_principal
from loans group by loan_type order by total_principal desc;

-- Q3. What is the total outstanding balance by loan type?
select loan_type,sum(outstanding_balance) as total_outstanding
from loans group by loan_type order by total_outstanding desc;

-- Q4. How many loans are there for each loan status?
select loan_status,count(*) as loan_count
from loans group by loan_status order by loan_count desc;

-- Q5. What is the total outstanding balance by loan status?
select loan_status,sum(outstanding_balance) as total_outstanding
from loans group by loan_status order by total_outstanding desc;

-- Q6. How many payments were made for each payment status?
select status,count(*) as payment_count 
from loan_payments group by status order by payment_count desc;

-- Q7. What is the total scheduled amount vs paid amount?
select sum(scheduled_amount) as total_scheduled,sum(paid_amount) as total_paid
from loan_payments;

-- Q8. How many payments were late?
select count(*) as late_payment_count
from loan_payments where days_late > 0;

-- Q9. What is the average number of days late?
select round(avg(days_late), 2) as average_days_late
from loan_payments ;

-- Q10. What is the total penalty collected?
select sum(penalty) as total_penalty from loan_payments;

-- Q11. Which loans have the highest average payment delay?
select l.loan_id,l.customer_id,l.loan_type,
round(avg(lp.days_late), 2) as average_days_late
from loans l join loan_payments lp on l.loan_id = lp.loan_id
group by l.loan_id,l.customer_id,l.loan_type
order by average_days_late desc;

-- Q12. Which loan types have the most late payments?
select l.loan_type,count(*) as late_payment_count
from loans l join loan_payments lp on l.loan_id = lp.loan_id
where lp.days_late > 0 group by l.loan_type order by late_payment_count desc;

-- =========================================
-- CARD USAGE & PRODUCT ENGAGEMENT
-- =========================================

-- Q1. How many cards are there for each card type?
select card_type, count(*) as card_count
from cards group by card_type order by card_count desc;

-- Q2. How many active and inactive cards are there?
select is_active,count(*) as card_count
from cards group by is_active;

-- Q3. What is the total credit limit by card type?
select card_type,sum(credit_limit) as total_credit_limit
from cards group by card_type order by total_credit_limit desc;

-- Q4. What is the total outstanding balance by card type?
select card_type,sum(outstanding_balance) as total_outstanding
from cards group by card_type
order by total_outstanding desc;

-- Q5. What is the credit utilization for each card?
select card_id,card_type,credit_limit,outstanding_balance,
round((outstanding_balance / credit_limit) * 100,2) AS utilization_percentage
from cards where credit_limit > 0 order by utilization_percentage desc;

-- Q6. What is the average reward points by card type?
select card_type,round(avg(reward_points), 2) as average_reward_points
from cards group by card_type order by average_reward_points DESC;

-- Q7. What is the total reward points by card type?
select card_type,sum(reward_points) as total_reward_points from cards group by card_type
order by total_reward_points desc;

-- Q8. How many cards are there for each network? 
select network,count(*) as card_count
from cards group by network order by card_count desc;

-- Q9. How many cards are associated with each account type?
select a.account_type,count(c.card_id) as card_count from accounts a
join cards c on a.account_id = c.account_id group by a.account_type order by card_count desc;

-- =========================================
-- END OF RETAIL BANKING TRANSACTION ANALYSIS
-- =========================================

