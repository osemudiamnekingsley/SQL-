# SQL Boat Rental Project

Welcome to the **SQL Boat Rental Project**! This project demonstrates a database management system designed to manage boat rental operations using SQL. It consists of three primary tables: **Sailor_T**, **Boat_T**, and **Reserves_T**.

## 📂 Database Schema

- **Sailor_T**  
  | Column Name   | Data Type | Description                     |
  |----------------|-----------|--------------------------------|
  | SailorID       | INT       | Unique identifier for sailors  |
  | SailorName     | VARCHAR   | Name of the sailor             |
  | BirthDate      | DATE      | Sailor's date of birth         |
  | RatePerDay     | DECIMAL   | Daily rental rate for sailors  |

- **Boat_T**  
  | Column Name   | Data Type | Description                     |
  |----------------|-----------|--------------------------------|
  | BoatID         | INT       | Unique identifier for boats    |
  | BoatType       | VARCHAR   | Type of the boat (e.g., Sailboat, Yacht) |
  | BoatLength     | DECIMAL   | Length of the boat in meters   |

- **Reserves_T**  
  | Column Name   | Data Type | Description                     |
  |----------------|-----------|--------------------------------|
  | SailorID       | INT       | References Sailor_T(SailorID)  |
  | BoatID         | INT       | References Boat_T(BoatID)      |
  | Day            | DATE      | Date of reservation            |

---

## ⚙️ Features

- Efficiently manage boat rentals and sailor data.  
- Track reservation details using a relational database.  
- Perform SQL queries for insights and reports.


---

## 📊 Example Queries

1. **Find all Sailors with Reservations**  
    ```sql
    SELECT DISTINCT S.SailorName
    FROM Sailor_T S
    JOIN Reserves_T R ON S.SailorID = R.SailorID;
    ```

2. **List Boats with Their Reservations**  
    ```sql
    SELECT B.BoatType, R.Day
    FROM Boat_T B
    JOIN Reserves_T R ON B.BoatID = R.BoatID;
    ```

3. **Calculate Total Rental Cost for Each Sailor**  
    ```sql
    SELECT S.SailorName, COUNT(R.BoatID) * S.RatePerDay AS TotalCost
    FROM Sailor_T S
    JOIN Reserves_T R ON S.SailorID = R.SailorID
    GROUP BY S.SailorName, S.RatePerDay;
    ```
