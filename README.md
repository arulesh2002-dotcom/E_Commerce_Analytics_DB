# 🏪 E-Commerce Analytics Database (MySQL)

This project provides a **ready-to-use MySQL database template** for building real-time e-commerce applications and analytics systems.

It includes SQL files for creating tables, inserting sample data, and running useful business queries.



## 📁 Folder Structure

sql/
├── create_tables.sql        # Database schema (tables, keys, constraints)
├── insert_sample_data.sql   # Sample records for quick testing
└── queries_examples.sql     # Example analytical queries




## ⚙️ 1. Create the Database Schema

Run this file first to create all tables and relationships:

```bash
mysql -u root -p < sql/create_tables.sql
```

**Creates:**
- Users, products, categories, orders, payments  
- Inventory, reviews, carts, and tracking tables  
- All primary and foreign key constraints  

---

## 📥 2. Insert Sample Data

Run this after creating the tables to load demo data:

```bash
mysql -u root -p < sql/insert_sample_data.sql
```

**Adds:**
- Sample users, products, and categories  
- Example orders, payments, and reviews  
- Basic tracking events (page views, product views)  

---

## 🔍 3. Run Example Queries

Try the sample analytics queries to explore insights:

```bash
mysql -u root -p < sql/queries_examples.sql
```

**Includes:**
- Top selling products  
- Daily revenue reports  
- Customer retention and repeat purchase analysis  
- Funnel and conversion metrics  

---

## 🧠 Notes
- MySQL version: **8.0+**
- Storage engine: **InnoDB**
- Character set: **utf8mb4**
- Make sure the database exists before running the scripts:
  ```sql
  CREATE DATABASE ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  USE ecommerce;
  ```



## 📜 License
This project is open-source. You can use, modify, and extend it for commercial or educational purposes.
