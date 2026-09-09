select distinct card_type from credit_card_transactions; --Silver, Signature, Gold & Platinum
select count(*) from credit_card_transactions; --26052
select max(transaction_date) from credit_card_transactions;-- Start 2013-10-04 end 2015-05-26
select distinct exp_type from credit_card_transactions; --Entertainment, Food, Bills, Fuel, Travel & Grocery
select min(amount) from credit_card_transactions; -- Max Amount 998077 Min Amount 1005

--Question-1:- Write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends. Rows:- 5
with cte1 as (
select city, sum(amount) as total_sum from credit_card_transactions
group by city
), total_spent as (select sum(amount) as sum_total from credit_card_transactions)

select top 5 cte1.*,round(total_sum/sum_total * 100,2) as Per_Contribution from cte1, total_spent
order by total_sum desc;

--Question-2:- Write a query to print highest spend month and amount spent in that month for each card type. Rows:-4 
with cte as(
select card_type,datepart(year,transaction_date) as yt,
datepart(month,transaction_date) as mt, sum(amount) as Total_Sum from credit_card_transactions
group by card_type,datepart(year,transaction_date),datepart(month,transaction_date)
)
select * from (select *, rank() over(partition by card_type order by Total_Sum desc) as rn from cte) a
where rn=1

--Question-3:-Write a query to print the transaction details (all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends (We should have 4 rows in the o/p one for each card type). Rows:- 4
with cte as(
select *, sum(amount) over(partition by card_type order by transaction_date, transaction_id) as Total_Spend
from credit_card_transactions
)
select * from (select *, rank() over(partition by card_type order by Total_Spend) as rn from cte
where Total_Spend >= 1000000) a
where rn=1

--Question-4:- Write a query to find city which had lowest percentage spend for gold card type Rows:-1 
with cte as(
select city, card_type, sum(amount) as amount,
sum(case when card_type='Gold' then amount end) as gold_amount from credit_card_transactions
group by city, card_type
)
select top 1 city, sum(gold_amount)*1.0/sum(amount) as Gold_Ratio from cte
group by city
having sum(gold_amount) is not null
order by Gold_Ratio;

--Question-5:- Write a query to print 3 columns: city, highest_expense_type, lowest_expense_type (example format: Delhi, bills, Fuel). Rows:-986
with cte as (
select city, exp_type, sum(amount) as Expenses from credit_card_transactions
group by city, exp_type)
select 
city, max(case when rn_asc=1 then exp_type end) as lowest_Expense_Type,
min(case when rn_desc=1 then exp_type end) as Highest_Expense_Type
from (
select *,
rank() over(partition by city order by Expenses desc) as rn_desc,
rank() over(partition by city order by Expenses asc) as rn_asc from cte) a
group by city

--Question-6:- Write a query to find percentage contribution of spends by females for each expense type. Rows:-6
select exp_type, 
sum(case when gender='F' then amount else 0 end)/sum(amount) as Pre_F_Contri from credit_card_transactions
group by exp_type
order by Pre_F_Contri desc;

--Question-7:- Which card and expense type combination saw highest month over month growth in Jan-2014. Rows:- 1
with cte as(
select card_type, exp_type, datepart(year,transaction_date) as yt,
datepart(month,transaction_date) as mt, sum(amount) as Total_Sum from credit_card_transactions
group by card_type, exp_type, datepart(year,transaction_date),datepart(month,transaction_date)
)
select top 1 *, (Total_Sum-pre_mon_spt) as mom_growth from
(select *,
lag(Total_Sum, 1) over(partition by card_type, exp_type order by yt,mt) as pre_mon_spt
from cte) a
where pre_mon_spt is not null and yt=2014 and mt=1
order by mom_growth desc

--Question-8:- During weekends which city has highest total spend to total no of transcations ratio. Rows:- 1
select top 1 city, sum(amount)/count(1) as Total_Raito from credit_card_transactions
where datepart(WEEKDAY,transaction_date) in (1,7)
group by city
order by Total_Raito desc;

--Question-9:- which city took least number of days to reach its 500th transaction after the first transaction in that city. Rows:- 1
with cte as(
select *,
row_number() over(partition by city order by transaction_date,transaction_id) as RN from credit_card_transactions
)
select top 1 city, datediff(day,min(transaction_date),max(transaction_date)) as No_of_Days_Diff from cte
where RN=1 or RN=500
group by city
having count(city) > 1
order by No_of_Days_Diff


