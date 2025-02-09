# Telegram Database Project

This repository contains the implementation of a Telegram-like messaging platform database. It was designed as a final project for a database course and includes:

- **ER Diagram & Logical Design:**  
  An ER diagram (created with Draw.io) that models the entities and relationships of the Telegram system. The source file (`telegram_ER.drawio`) and an exported image (`telegram_ER.png`) are located in the `design/` folder.

- **SQL Implementation:**  
  SQL scripts to create the database schema, populate tables with test data, and execute various queries to analyze the data. The queries cover operations such as:
  - Retrieving the three most-used stickers by a user.
  - Finding mutual contacts between users.
  - Counting messages in groups with more than 10,000 members.
  - And more advanced data retrieval tasks.

- **Workload Simulation:**  
  A Python script (`workload_simulation.py`) that simulates real user behavior by performing operations such as user sign-up, login, chat creation, and sending messages. This simulation helps test the performance and concurrency of the database.

---

## Repository Structure

telegram-database-project/
├── design/
│   ├── telegram_ER.drawio    (Draw.io source file for the ER diagram)
│   └── telegram_ER.png       (Exported ER diagram image)
├── sql/
│   └── queries.sql           (SQL scripts for schema creation and sample queries)
├── workload_simulation.py    (Python script for workload simulation)
└── README.md                 (This file)

---

## Technologies and Tools

- **CockroachDB / PostgreSQL:**  
  The database is implemented using CockroachDB with PostgreSQL compatibility.  
  Connection string example (in `workload_simulation.py`):  
  `postgresql://root@localhost:26257/dbfinalproject?sslmode=disable`

- **SQL:**  
  For defining the schema and writing queries.


- **Draw.io:**  
  Used to design the ER diagram.

---

## Getting Started

### Prerequisites

- **Database Server:**  
  Install and run CockroachDB (or PostgreSQL) on your machine. Create a database named `dbfinalproject`.


### Database Setup

1. **Create the Database:**  
   Connect to your database server and create the `dbfinalproject` database.

2. **Run SQL Scripts:**  
   Execute the SQL scripts located in the `sql/` folder to create the tables and populate them with test data.

### Running the Workload Simulation

1. **Configure the Connection String:**  
   If necessary, update the `DATABASE_URL` in `workload_simulation.py` with your database credentials.

2. **Run the Simulation Script:**  
   Execute the script using:
   ```
   python3 workload_simulation.py
   ```
   The script starts multiple threads simulating user operations (sign-up, login, chat creation, and messaging). To stop the simulation, press `Ctrl+C`.

---

## SQL Queries

The `sql/queries.sql` file contains several queries that:
- Retrieve the three most-used stickers by a given user.
- Identify mutual contacts between specified users.
- Count messages in groups with more than 10,000 members.
- And perform other useful analyses.

---

## Contributing

Contributions are welcome! Feel free to fork this repository and submit pull requests for improvements or additional features.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Acknowledgements

Special thanks to the course instructors and all resources that contributed to the development of this project.
