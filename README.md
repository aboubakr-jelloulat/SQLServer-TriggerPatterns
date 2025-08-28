#  Database Triggers Collection

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)](https://www.microsoft.com/en-us/sql-server)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=for-the-badge)](CONTRIBUTING.md)

> A comprehensive collection of database triggers for modern database systems, focusing on data integrity, security, and automated data management.

---

##  Table of Contents

- [Overview](#overview)
- [What are Database Triggers?](#what-are-database-triggers)
- [Types of Triggers](#types-of-triggers)
- [Use Cases](#use-cases)
- [Repository Structure](#repository-structure)
- [Best Practices](#best-practices)


##  Overview

This repository contains a curated collection of database triggers designed for enterprise-level applications. Each trigger is thoroughly tested, documented, and optimized for performance across different database systems including SQL Server , T-SQL.

##  What are Database Triggers?

Database triggers are special stored procedures that automatically execute (or "fire") in response to specific events in a database. They are powerful tools that help maintain data integrity, implement business rules, and provide automated responses to data changes.

### Key Characteristics:
- **Automatic Execution**: Triggers run automatically when specific events occur
- **Event-Driven**: Respond to INSERT, UPDATE, DELETE, or DDL operations
- **Transparent**: Execute without explicit calls from applications
- **Atomic**: Part of the transaction that triggered them

##  Types of Triggers

### 1. **DML Triggers** (Data Manipulation Language)
- **AFTER Triggers**: Execute after the triggering event completes
- **BEFORE Triggers**: Execute before the triggering event (PostgreSQL, MySQL)
- **INSTEAD OF Triggers**: Replace the triggering event (mainly for views)

### 2. **DDL Triggers** (Data Definition Language)
- **Database-level**: Respond to database structure changes
- **Server-level**: Respond to server-wide events

### 3. **Event Categories**
```sql
INSERT Triggers    -- Fire when new records are added
UPDATE Triggers    -- Fire when existing records are modified  
DELETE Triggers    -- Fire when records are removed
```

##  Use Cases

### 🛡 **Security & Auditing**
- **Audit Trails**: Track who changed what and when
- **Data Loss Prevention**: Prevent unauthorized deletions
- **Access Logging**: Monitor sensitive data access
- **Compliance**: Meet regulatory requirements (GDPR, HIPAA, SOX)

###  **Data Snapshots & History**
- **Point-in-Time Recovery**: Maintain historical data states
- **Change Tracking**: Capture before/after values
- **Version Control**: Track document or record versions
- **Backup Automation**: Create automatic data backups

###  **Data Integrity & Validation**
- **Business Rules**: Enforce complex business logic
- **Cross-Table Validation**: Maintain referential integrity
- **Data Consistency**: Ensure data remains consistent across tables
- **Automatic Calculations**: Update derived fields automatically

###  **Performance & Automation**
- **Cache Invalidation**: Refresh materialized views
- **Statistics Updates**: Maintain summary tables
- **Notifications**: Send alerts on critical changes
- **ETL Processes**: Trigger data transformation workflows

## 📁 Repository Structure

```
📦 Database-Triggers
├── 📂 01_AFTER_Trigger/
│   ├── 🔧 00_after_insert.sql      # Basic INSERT trigger
│   ├── 🔧 01_after_update.sql      # UPDATE change tracking
│   └── 🔧 02_after_delete.sql      # DELETE audit logging
├── 📂 02_Instead_of_Triggers/
│   ├── 🔧 00_intro.sql             # Introduction to INSTEAD OF
│   ├── 🔧 01_Instead_of_Insert.sql # View INSERT handling
│   ├── 🔧 02_Instead_of_update.sql # View UPDATE handling
│   └── 🔧 03_Instead_of_Delete.sql # View DELETE handling
├── 🔧 triggers.sql                 # What is triggers
└── 📖 README.md                    # This->file
```


Hej 👋🏼  **Choose your database system**
```sql
-- For SQL Server
USE YourDatabase;


```


## ⚡ Best Practices

###  **Performance**
- Keep trigger logic lightweight and fast
- Avoid complex queries that could slow down DML operations
- Use `SET NOCOUNT ON` to reduce network traffic
- Consider using queues for heavy processing

###  **Security**
- Always validate input data within triggers
- Use parameterized queries to prevent SQL injection
- Implement proper error handling and logging
- Restrict trigger creation to authorized personnel

### 🛠 **Maintainability**
- Document trigger purpose and business rules clearly
- Use consistent naming conventions (e.g., `trg_tablename_purpose`)
- Avoid recursive triggers unless absolutely necessary
- Test triggers thoroughly in development environments

###  **Coding Standards**
- Handle both single and multi-row operations
- Use `inserted` and `deleted` pseudo-tables appropriately
- Implement proper transaction handling
- Include comprehensive error handling
