# Comprehensive Guide to Database Management Systems (DBMS)

This document provides a complete and concise overview of core database and DBMS theories.

## 1. Fundamentals: DB vs. DBMS

| Concept           | Description                                                                                              | Key Focus                                                          |
| :---------------- | :------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------- |
| **Database (DB)** | A structured, organized collection of interrelated data.                                                 | The **Data** itself (e.g., tables, records, fields).               |
| **DBMS**          | The software system that manages the data, acts as an interface between the user/application and the DB. | **Management** of the data (e.g., storage, security, concurrency). |

### Data Abstraction and Independence

- **Data Abstraction:** Hiding complex physical storage details from users.
- **Data Independence:** The ability to change the schema at one level without affecting the schema at a higher level (e.g., changing disk location (physical) doesn't affect the user's view (conceptual/external)).

---

## 2. Structured Query Language (SQL)

SQL is the standard language for defining, manipulating, and controlling data in Relational DBMS (RDBMS).

| SQL Sub-Language              | Purpose                                         | Key Commands                           |
| :---------------------------- | :---------------------------------------------- | :------------------------------------- |
| **DDL** (Data Definition)     | Defines the database structure/schema.          | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`  |
| **DML** (Data Manipulation)   | Manages data within the schema.                 | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** (Data Control)        | Manages access rights and permissions.          | `GRANT`, `REVOKE`                      |
| **TCL** (Transaction Control) | Manages the integrity of database transactions. | `COMMIT`, `ROLLBACK`, `SAVEPOINT`      |

---

## 3. Data Integrity and Keys

**Data Integrity** ensures the accuracy and consistency of data. It is enforced through constraints:

- **Domain Constraint:** Values must be valid for the column's data type/range.
- **Entity Integrity:** The **Primary Key** cannot contain **NULL** values.
- **Referential Integrity:** Enforced by **Foreign Keys**, ensuring that a Foreign Key value either matches an existing Primary Key value in the referenced table or is completely NULL.

| Key Type          | Role                                                                 | Constraint                                           |
| :---------------- | :------------------------------------------------------------------- | :--------------------------------------------------- |
| **Primary Key**   | Uniquely identifies each row; chosen from candidate keys.            | Unique, Not Null                                     |
| **Foreign Key**   | Establishes a link/relationship between two tables.                  | Must reference a Primary Key value in another table. |
| **Candidate Key** | Any attribute or set of attributes that can uniquely identify a row. | Unique, Minimal                                      |

---

## 4. Transaction Management: The ACID Properties

A **Transaction** is a single, logical unit of work that must be reliably processed. The **ACID** properties are the guarantees that ensure database reliability during transactions, especially with concurrent access.

- **A - Atomicity:** "All or nothing." A transaction either completes entirely (commits) or is completely reversed (rolls back).
- **C - Consistency:** A transaction must bring the database from one valid state to another, upholding all constraints.
- **I - Isolation:** Concurrent transactions execute independently, as if they were running serially. The effect of one transaction is invisible to others until it commits.
- **D - Durability:** Once a transaction is committed, its changes are permanent and survive system failures.

---

## 5. Normalization Theory

**Normalization** is the process of organizing tables to minimize **redundancy** and dependency by decomposing large tables into smaller, well-structured ones.

### Functional Dependency

- $A \rightarrow B$ means that the value of attribute **A** uniquely determines the value of attribute **B**. This is the basis for all Normal Forms.

### Anomalies (Problems solved by Normalization)

1.  **Insertion Anomaly:** Cannot add data unless other, unrelated data is also available.
2.  **Update Anomaly:** Must update the same data across multiple rows, risking inconsistency.
3.  **Deletion Anomaly:** Deleting a record unintentionally removes other important information.

### Normal Forms (NF)

| Normal Form           | Rule (Dependency Violation)                             | How to Achieve                                                               |
| :-------------------- | :------------------------------------------------------ | :--------------------------------------------------------------------------- |
| **1NF** (First)       | No **non-atomic values** or **repeating groups**.       | Each cell must contain a single, indivisible value.                          |
| **2NF** (Second)      | No **Partial Dependency**. (Applies to composite keys). | Every non-key attribute must depend on the **entire** Primary Key.           |
| **3NF** (Third)       | No **Transitive Dependency**.                           | Non-key attributes cannot depend on other non-key attributes.                |
| **BCNF** (Boyce-Codd) | Every **determinant** must be a **candidate key**.      | Stricter than 3NF, addresses cases with multiple overlapping candidate keys. |

---

## 6. Data Models

The structure used to organize data in the database.

- **Relational Model (RDBMS):** Data structured in tables (relations) with relationships defined by Foreign Keys. Uses SQL. (e.g., MySQL, PostgreSQL).
- **NoSQL Models:** Non-relational, designed for high scalability and handling unstructured data.
  - **Key-Value:** Simple storage of unique keys and corresponding values.
  - **Document:** Stores data in flexible documents, usually JSON or BSON (e.g., MongoDB).
  - **Graph:** Uses nodes and edges to map relationships, optimized for network data (e.g., Neo4j).

---

## 7. Relational Algebra

A procedural query language that mathematically defines the operations used to manipulate relations. It forms the theoretical basis of SQL.

| Operation                | Description                                                    | SQL Equivalent              |
| :----------------------- | :------------------------------------------------------------- | :-------------------------- |
| **Select** ($\sigma$)    | Filters rows based on a condition.                             | `WHERE` clause              |
| **Project** ($\pi$)      | Selects columns.                                               | `SELECT` list of attributes |
| **Union** ($\cup$)       | Combines two compatible relations (removes duplicates).        | `UNION`                     |
| **Set Difference** ($-$) | Returns rows in the first relation that are not in the second. | `EXCEPT`                    |
| **Join** ($\bowtie$)     | Combines tuples from two relations based on a condition.       | `JOIN` clauses              |
