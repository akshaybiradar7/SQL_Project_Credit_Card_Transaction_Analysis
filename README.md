# SQL_Project (Credit Card Transaction Analysis)

A comprehensive exploratory and diagnostic data analysis project analyzing **26,000+ credit card transactions** using advanced SQL. This project demonstrates end-to-end relational data querying—from basic aggregations to multi-tier window functions and CTEs—to solve 9 complex business problems around customer spending habits, fraud patterns, and card utilization.

---

## 📌 Project Overview

Credit card transaction datasets capture critical behavioral and financial metrics. The goal of this project is to simulate real-world data analyst tasks by extracting high-impact business insights, tracking month-over-month trends, identifying high-value customers, and analyzing category-level expenditures across demographics.

* **Dataset Size:** 26,000+ transaction records.
* **Core Technology:** SQL Server 2022.
* **Techniques Used:** Window / Analytical Functions:
(Ranking Functions, Value / Offset Functions, Window Aggregates and Partitioning & Ordering),
Common Table Expressions (CTEs), Conditional Aggregation & Pivot Logic, Subqueries & Derived Tables, Date & Time Functions (T-SQL / SQL Server), Standard Aggregation & Group Filtering, Result Limiting & Sorting and Mathematical Operations & Type Casting.


---

## 🛠️ Key SQL Concepts Demonstrated

* **Window & Analytical Functions**
  * **Positional Ranking:** Deployed `RANK()` to identify peak spending cycles and expense extremes, and `ROW_NUMBER()` to enforce deterministic transaction sequencing and isolate milestone events (e.g., tracking the 1st vs. 500th transaction per city).
  * **Time-Series Offset:** Utilized `LAG()` across partitioned monthly aggregates to calculate prior-period baselines and quantify Month-over-Month (MoM) spend velocity without resource-intensive self-joins.
  * **Cumulative Running Totals:** Configured `SUM(...) OVER (PARTITION BY ... ORDER BY ...)` to monitor cumulative financial thresholds, such as identifying the precise transaction that surpassed 1,000,000 in total spend.
  * **Multi-Tier Partitioning:** Deconstructed aggregations across discrete and composite granularities (e.g., `card_type`, `city`, and `(card_type, exp_type)`).

* **Modular Query Architecture (CTEs & Derived Tables)**
  * **Common Table Expressions (CTEs):** Structured multi-layered transformations via `WITH cte AS (...)` to maintain clean separation of concerns, improve query readability, and optimize intermediate execution steps.
  * **Derived Subqueries:** Embedded inline subqueries in `FROM` clauses to filter non-aggregate window metrics (`WHERE rn = 1`).
  * **Cartesian CTE Broadcasting:** Cross-joined single-row summary aggregates against granular result sets (`FROM cte1, total_spent`) to compute percentage contributions without separate lookup passes.

* **Conditional Aggregation & Dynamic Pivoting**
  * Embedded `CASE WHEN ... THEN ... END` logic within `SUM()`, `MAX()`, and `MIN()` to conditionally segment metrics (e.g., isolating female spending ratios or Gold card volumes).
  * Implemented row-to-column pivoting to simultaneously expose the highest and lowest spending expense types per city within a single record.

* **Temporal Analytics (T-SQL / SQL Server)**
  * **Granular Extraction:** Dissected timestamps via `DATEPART(year, ...)` and `DATEPART(month, ...)` for cyclic and seasonal trend analysis.
  * **Behavioral Filtering:** Filtered specific days of the week via `DATEPART(WEEKDAY, ...)` to isolate weekend vs. weekday spending velocity.
  * **Duration Calculation:** Measured exact time-to-milestone velocity using `DATEDIFF(day, min(...), max(...))`.

* **Aggregation, Filtering & Mathematical Precision**
  * **Group-Level Pruning:** Implemented multi-column `GROUP BY` paired with `HAVING` clauses to filter aggregated distributions (e.g., verifying multi-point threshold completions via `HAVING count(city) > 1`).
  * **Boundary Slicing:** Coupled `TOP n` directives with deterministic `ORDER BY` indexing to extract edge-case distributions and top percentile rankings.
  * **Arithmetic Precision Handling:** Applied implicit numeric casting (`* 1.0`) to avoid SQL Server integer-division truncation during ratio computations, standardizing outputs with `ROUND(..., 2)`.
---

## 📊 Business Problems Solved (9 Core Queries)

1. **Top Spending Cities by Contribution:** Identified top 5 cities contributing the highest percentage to total spending.
2. **Month-over-Month (MoM) Growth:** Tracked spending velocity across different card types (Gold, Silver, Platinum, Signature) using `LAG()`.
3. **Card Type Dominance per Expense Type:** Ranked expense types (Bills, Food, Entertainment, Travel, etc.) by transaction volume and spend for each card tier.
4. **First 500-Transaction Milestone:** Pinpointed the exact date and transaction ID when each city hit cumulative spend of 500 transactions.
5. **Weekend vs. Weekday Spend Share:** Calculated spending distribution ratios across weekdays and weekends per card type.
6. **Highest Single-Day Transaction Spikes:** Detected anomalies by flagging days where an expense type exceeded its rolling 30-day average by more than 2x.
7. **Customer Spending Velocity by Demographics:** Correlated transaction amounts with customer demographic segments (gender, location tier).
8. **Repeat Transaction Thresholds:** Discovered accounts with rapid-succession purchases within short time intervals to monitor potential fraudulent activity.
9. **Low-Volume, High-Value Categories:** Isolated expense categories that drive high revenue despite low transaction counts for premium card promotions.

## Clone the repository:

Bash
git clone [https://github.com/akshaybiradar7/SQL_Project_Credit_Card_Transaction_Analysis].git
cd SQL_Project

---

## Set up the database:

Open your preferred SQL client (SQL Server).

Run sql/SQL_Project_Solved_Queries.sql to initialize the tables.

---

## Import the dataset:

Import data/credit_card_transactions.csv into the created table using the database import wizard or COPY/LOAD DATA INFILE.

---

## Execute queries:

Run sql/SQL_Project_Solved_Queries.sql sequentially to replicate the analysis.

---

## 💡 Key Business Takeaways
Expense Distribution: Essential expenses (Bills & Groceries) generated the highest transaction frequency, whereas Travel drove the highest average ticket size.

Geographic Concentration: Over 40% of total card spending originated from the top 4 metropolitan regions.

Tier Engagement: Platinum cardholders exhibited the highest weekend transaction spike, presenting prime opportunities for targeted weekend rewards programs.

---

## 📁 Repository Structure

```text
├── data/
│   └── credit_card_transactions.csv    # Raw dataset (26k+ rows)
├── sql/
│   ├── 01_schema_setup.sql             # Table definitions, constraints, and data loading
│   └── 02_analysis_queries.sql         # 9 complex analytical SQL queries with comments
├── results/
│   └── insights_summary.md             # Key business takeaways & visual highlights
└── README.md
