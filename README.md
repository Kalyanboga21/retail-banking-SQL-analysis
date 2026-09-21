# Retail Banking SQL Analysis

## Project Overview

**Retail Banking Transaction Analysis** is a MySQL-based business analytics project focused on understanding customer profiles, account usage, branch activity, transaction patterns, loan performance, repayment behaviour, and card engagement.

The project uses a relational banking database containing **9,140 records across 7 related tables**. SQL was used to explore the data, answer business questions, identify patterns, and generate business insights that can support banking-related decision-making.

### Project Role

**Data Analyst — SQL & Business Analysis**

### Team Size

**3 Members**

---

## Business Scenario

A retail bank manages customers, accounts, branches, transactions, loans, loan payments, and cards across multiple locations.

Management wants to understand:

* Customer profiles and segmentation
* Account usage and branch activity
* Transaction behaviour and channels
* Loan performance and repayment behaviour
* Card usage and product engagement

The objective of this project is to use SQL-based analysis to answer these business questions and communicate meaningful insights.

---

## Business Objectives

### 1. Customer Profile & Segmentation

Understand the customer base and identify differences between customer segments using customer demographics, income, credit scores, location, and activity.

### 2. Account Usage & Branch Activity

Analyze account types, balances, account status, branch activity, and regional differences.

### 3. Transaction Patterns

Understand transaction types, transaction channels, transaction status, transaction amounts, and activity over time.

### 4. Loan Performance & Repayment Behaviour

Analyze loan types, outstanding balances, loan status, payment behaviour, late payments, payment delays, and penalties.

### 5. Card Usage & Product Engagement

Analyze card types, card activity, credit limits, outstanding balances, utilization, reward points, and card relationships with banking products.

---

## Database Overview

**Database:** `retail_banking`

**DBMS:** MySQL

**Tables:** 7

**Total Records:** 9,140

**Total Columns:** 74

### Tables

| Table           | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| `Customers`     | Customer profile, demographic, income, KYC and credit information      |
| `Accounts`      | Customer bank accounts, balances, account types and status             |
| `Branches`      | Branch details, locations, regions and employee information            |
| `Transactions`  | Account transaction details, amounts, channels and status              |
| `Loans`         | Loan details, amounts, interest rates, status and outstanding balances |
| `Loan_payments` | Loan payment details, delays, penalties and payment status             |
| `Cards`         | Card type, credit limit, outstanding balance, rewards and activity     |

---

## Database Relationships

The database follows a relational structure with primary and foreign keys connecting related entities.

* Customers → Accounts
* Customers → Loans
* Branches → Accounts
* Branches → Loans
* Accounts → Transactions
* Accounts → Cards
* Loans → Loan_Payments

The ER diagram provides the complete database structure and relationships.

---

## SQL Concepts Used

The project demonstrates practical SQL concepts including:

* Database and table creation
* Primary keys and foreign keys
* Data types and constraints
* CSV data import and transformation
* `SELECT`
* `WHERE`
* `DISTINCT`
* `ORDER BY`
* `LIMIT`
* Aggregate functions
* `GROUP BY`
* `HAVING`
* `CASE`
* `INNER JOIN`
* Multi-table analysis
* Subqueries
* Percentage calculations
* Date-based analysis
* Business-oriented aggregations

A temporary staging table was also used during the Accounts CSV import to transform and clean imported values before inserting them into the final `Accounts` table.

---

## Key Analysis & Insights

### Customer Analysis

* The dataset contains **500 customers**, including **375 active** and **125 inactive** customers.
* **Student** is the largest customer segment with **100 customers**.
* **Premium** customers have the highest average annual income at approximately **$158.7K**.
* Average credit scores are relatively close across customer segments.

### Account & Branch Analysis

* **IRA** is the most common account type with **136 accounts**.
* IRA accounts also hold the highest total balance at approximately **$2.89M**.
* There are **497 active** and **203 closed** accounts.
* The **West** region has the highest average account balance at approximately **$16,447**.

### Transaction Analysis

* The dataset contains **5,000 transactions**.
* **Transfer** is the most frequent transaction type with **858 transactions**.
* **Online** is the most frequently used transaction channel with **1,470 transactions**.
* **1,688 transactions** are recorded as completed.
* Completed transactions represent approximately **$10.98M** in transaction value.

### Loan & Repayment Analysis

* **Education loans** are the largest loan category with **64 loans**.
* Total outstanding loan balance is approximately **$53.44M**.
* **169 loans** are recorded as Defaulted or In Arrears.
* **500 loan payments** were late.
* Average payment delay is approximately **5.63 days**.
* Total penalties recorded are approximately **$93,961**.

### Card Analysis

* There are **358 Debit cards** and **242 Credit cards**.
* **37 cards** are active and **563 cards** are inactive in the dataset.
* Average credit-card utilization is approximately **39.70%**.

---

## Project Workflow

```text
Business Requirement
        ↓
Data Understanding
        ↓
ER Diagram & Database Design
        ↓
Table Creation & Data Import
        ↓
SQL Analysis
        ↓
Business Insights
        ↓
Recommendations
```

---

## Repository Structure

```text
retail-banking-SQL-analysis/
│
├── Datasets/
│   ├── accounts.csv
│   ├── branches.csv
│   ├── cards.csv
│   ├── customers.csv
│   ├── loans.csv
│   ├── loan_payments.csv
│   └── transactions.csv
│
├── Documentation/
│   └── Retail_Banking_Project_Documentation.docx
│
├── ER_Diagram/
│   └── Retail_Banking_ER_Diagram.png
│
├── Presentation/
│   └── Retail_Banking_SQL_Analysis.pptx
│
└── SQL/
    └── Retail_Banking_SQL_Analysis.sql
```

---

## Tools & Technologies

* **MySQL**
* **MySQL Workbench**
* **SQL**
* **Microsoft PowerPoint**
* **Microsoft Word**
* **CSV datasets**

---

## My Contribution

As part of the three-member team, my primary contribution was on the **SQL and business analysis side** of the project.

I worked on:

* Database and table creation
* Applying primary and foreign key relationships
* SQL query development and testing
* Data analysis using SQL
* Customer, account, transaction, loan and card analysis
* Interpreting query results into business insights
* Project documentation and presentation

---

## Project Files

* **SQL:** Complete database setup and analysis queries
* **Datasets:** CSV files used for the analysis
* **ER Diagram:** Visual representation of database relationships
* **Presentation:** Project analysis, findings and recommendations
* **Documentation:** Project requirements and analysis documentation

---

## Conclusion

This project provided practical experience in using MySQL to work with a relational banking dataset and convert raw data into business-oriented insights.

The analysis covered customer segmentation, account and branch activity, transaction behaviour, loan repayment performance, and card engagement, demonstrating how SQL can be used as a tool for structured business analysis and decision support.

