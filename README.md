# bankdatebase

# 🏦 Banking Data Analysis Project (DuckDB + SQL)

This project demonstrates advanced SQL techniques applied to a relational banking database built in DuckDB. It includes full database setup, data insertion, advanced querying, and verification using real-world financial data structures.

---

## 📘 Project Summary

As part of the UCD Professional Academy assessment, I created a fully relational banking database and answered complex business questions using optimised SQL. The work involved importing data from CSVs, enforcing referential integrity, creating a manager view, and writing 12 advanced SQL queries, each showcasing a different technique (e.g. window functions, CTEs, anti-joins, etc.).

---

## 🧩 Database Schema

The database includes the following tables:
- **customers** – Personal and credit information
- **branches** – Bank branch details
- **employees** – Staff members and their branch assignment
- **accounts** – Customer accounts with IBAN, balance, etc.
- **transactions** – Money movements across accounts
- **cards** – Debit/credit card records tied to accounts
- **loans** – Loans taken by customers with terms and payment status

All tables were created with primary and foreign key constraints to reflect real-world dependencies.

---

## 🧠 SQL Techniques Demonstrated

| Technique              | Description                                                  | Example Query     |
|------------------------|--------------------------------------------------------------|-------------------|
| `PERCENT_RANK()`       | Rank customers based on credit score percentile              | Query 2           |
| `LEAD()`               | Compare current and next customer's credit score             | Query 2           |
| Correlated Subquery    | Count conditionally per branch                               | Query 4           |
| `COUNT() OVER()`       | Running total transactions by account type                   | Query 5           |
| `INTERSECT`            | Identify customers with both current and savings accounts    | Query 9           |
| Nested CTEs            | Average loan amount per branch                               | Query 11          |
| `NOT EXISTS`           | Anti-join for filtering branches without credit card users   | Query 8           |
| `HAVING` + Subquery    | Filter customers who have all account types                  | Query 12          |

---

## 📸 Screenshots

The `screenshots/` folder includes:
- Table creation and population
- Verification outputs (`UNION ALL` row counts, `SELECT` checks)
- View creation confirmation
- Each query result (Query 1–12)

---

## 🛠️ Tools Used

- 🐤 [DuckDB](https://duckdb.org/) – SQL database engine
- 🖥️ DBeaver – GUI for schema management and query execution
- 📊 CSV import for data loading
- 🧠 AI-assisted commenting and documentation

---

## 🔁 How to Reproduce

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/banking-data-analysis-sql-duckdb.git
   cd banking-data-analysis-sql-duckdb
