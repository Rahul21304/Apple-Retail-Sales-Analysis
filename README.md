# 🍏 Apple Retail Sales SQL Project

An advanced SQL case study analyzing **Apple’s retail sales data** to uncover business insights. This project simulates real-world scenarios involving **sales performance, product demand, warranty claims, and revenue trends**.

---

## 🚀 Project Overview

The goal of this project was to design and query a relational database for Apple’s retail operations.
I created multiple tables — **Sales, Products, Stores, Warranty, and Category** — and wrote queries to solve **25+ business questions** from basic to complex.

The analysis covers:

* Store performance & revenue trends
* Product demand & lifecycle analysis
* Warranty claim patterns & rejection rates
* Growth metrics and correlations

---

## 📂 Database Schema

**Tables Used:**

* **sales** (`sales_id`, `sale_date`, `store_id`, `product_id`, `quantity`)
* **products** (`product_id`, `product_name`, `category_id`, `launch_date`, `price`)
* **stores** (`store_id`, `store_name`, `country`)
* **warranty** (`claim_id`, `sales_id`, `claim_date`, `repair_status`)
* **category** (`category_id`, `category_name`)

**Relationships:**

* `sales → products` (Product\_ID)
* `sales → stores` (Store\_ID)
* `sales → warranty` (Sales\_ID)
* `products → category` (Category\_ID)


**ER Diagram**
  
<img width="1227" height="823" alt="ER DIAGRAM (3)" src="https://github.com/user-attachments/assets/cfc50a1a-a5cc-4bbb-999d-b403774ad9eb" />


---

## 🛠 Skills & SQL Concepts Used

* Database Design (Primary & Foreign Keys)
* `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY`
* Window Functions (`RANK`, `LAG`, `Running Totals`)
* Common Table Expressions (CTEs)
* Subqueries
* Business-focused query writing

---

## 🔍 Business Questions Solved

### **Easy to Medium**

* 📊 Number of stores in each country
* 🏬 Units sold by each store
* 📅 Sales in December 2023
* 🛠 Stores with no warranty claims
* ❌ % of rejected warranty claims
* 🏆 Store with highest units sold in 2024
* 💲 Average product price per category
* 📦 Best-selling day per store

### **Medium to Hard**

* 🔽 Least selling product per country
* ⏳ Warranty claims filed within 180 days
* 📈 Warranty claims for recently launched products
*  months with more than 5,000 units sold in USA
* 📂 Category with most warranty claims

### **Complex Analysis**

* 📉 Probability of warranty claims per purchase by country
* 📊 Year-over-year growth per store
* 🔗 Correlation between price ranges & warranty claims
* ✅ Store with highest % of completed repairs
* 📆 Monthly running total of sales per store
* 🕒 Product lifecycle sales (0–6m, 6–12m, 12–18m, 18+)

---

## 📊 Sample Insights

✅ United States stores recorded months exceeding **5,000 units sold**       
✅ Warranty claims have a rejection rate of **X%** (from query output)        
✅ Mid-range products (\$501–\$1000) had the highest correlation with warranty claims       
✅ Some stores showed **double-digit YoY growth**, while others declined         

---

## 📎 Project Files

* **Apple Query.sql** → All SQL queries & solutions
* **CSV Files (Sales, Products, Stores, Warranty, Category)** → Dataset

---

## 🚀 How to Use

1. Clone this repository
2. Import the dataset into MySQL
3. Run `Apple Query.sql` to create tables, relationships, and queries
4. Explore results and adapt queries for deeper analysis

---

## 📢 Connect With Me

💼 [LinkedIn](https://www.linkedin.com/in/rahul-gautam-5981b5227)        
🌐 [GitHub](https://github.com/Rahul21304)     
📧 Email: [gautamrahul.2106@gmail.com](mailto:gautamrahul.2106@gmail.com)

---

⭐ If you found this project useful, don’t forget to star the repo!
