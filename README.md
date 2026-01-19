# Pipeline360

Production-grade analytics pipeline built using Snowflake, dbt, and AWS.

---

## Overview
This project implements a cloud-native, end-to-end data engineering pipeline that transforms raw Airbnb CSV data into analytics-ready datasets. It follows modern data engineering best practices, including medallion architecture, incremental processing, historical change tracking, and strong data quality enforcement.

The solution mirrors real-world production data platforms used by analytics and data engineering teams.

---

## Business Problem
Airbnb-style platforms generate large volumes of frequently changing data across bookings, listings, and hosts. Analytics teams need:

- Reliable historical tracking of data changes  
- Clean, standardized datasets for BI and reporting  
- Scalable transformations without full reloads  
- Strong governance, testing, and lineage  

This pipeline addresses those challenges end-to-end.

---

## Architecture
<img width="1536" height="922" alt="pipeline360" src="https://github.com/user-attachments/assets/fe61beba-8497-4685-8554-00118981d3a2" />


### Data Flow
```bash
CSV Files
↓
AWS S3
↓
Snowflake (Staging)
↓
Bronze → Silver → Gold
↓
Analytics / BI
```
### Design Pattern
- ELT using Snowflake + dbt  
- Medallion architecture  
- Incremental and snapshot-based processing  

---

## Technology Stack
- **Cloud Data Warehouse:** Snowflake  
- **Transformation Layer:** dbt (core + snowflake)  
- **Cloud Storage:** AWS S3  
- **Language:** Python 3.12+  
- **Version Control:** Git  

### dbt Capabilities
- Incremental models  
- Snapshots (SCD Type 2)  
- Custom macros  
- Jinja templating  
- Tests and documentation  
- Data lineage  

---

## Data Modeling

### Bronze Layer (Raw)
Minimal transformations for full traceability.
- `bronze_bookings`
- `bronze_hosts`
- `bronze_listings`

### Silver Layer (Cleaned)
Validated and standardized entities.
- `silver_bookings`
- `silver_hosts`
- `silver_listings`

### Gold Layer (Analytics)
Optimized for BI and reporting.
- `fact` – dimensional fact table  
- `obt` – One Big Table for ad-hoc analysis  
- Ephemeral models for intermediate logic  

---

## Slowly Changing Dimensions (SCD Type 2)
Historical changes are tracked using dbt snapshots:
- `dim_bookings`
- `dim_hosts`
- `dim_listings`

Each record includes valid-from and valid-to timestamps to support point-in-time analysis.

---

## Project Structure

```bash
AWS_DBT_Snowflake/
├── SourceData/ # Raw CSV files
├── DDL/ # Snowflake schema setup
├── aws_dbt_snowflake_project/
│ ├── models/
│ │ ├── bronze/
│ │ ├── silver/
│ │ └── gold/
│ ├── snapshots/ # SCD Type 2
│ ├── macros/ # Reusable SQL logic
│ ├── tests/ # Data quality tests
│ ├── seeds/
│ └── analyses/
└── README.md
```
## Key Features

### Incremental Processing
Only new or updated records are processed, ensuring scalability.
```sql
{{ config(materialized='incremental') }}

{% if is_incremental() %}
WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}
```
----
## Custom Macros & Dynamic SQL

### Custom Macros
Reusable macros are used to standardize and centralize business logic across models:

- Price categorization (e.g., low / medium / high)
- String trimming and normalization
- Dynamic schema generation by environment and layer

This approach improves consistency, reduces duplication, and simplifies long-term maintenance.

### Dynamic SQL
Gold-layer models leverage **Jinja loops and templates** to dynamically generate SQL for complex joins and transformations, making models easier to extend and refactor as requirements evolve.

---

## Data Quality & Governance

Data quality is enforced at every stage of the pipeline using dbt tests and validation rules:

- Not-null and uniqueness constraints
- Source validation
- Referential integrity checks
- Business rule enforcement
**dbt provides end-to-end lineage and dependency tracking.**

## Security & Best Practices

- Credentials are excluded from version control
- Secrets are managed using environment variables
- Role-based access control (RBAC) enforced in Snowflake
- Consistent SQL formatting and code standards applied
- Git-based development workflow with version control and reviews

---

## Getting Started

### Prerequisites
- Snowflake account
- AWS account
- Python 3.12 or higher

### Setup
```bash
python -m venv .venv
source .venv/bin/activate

pip install -e .

cd aws_dbt_snowflake_project
dbt debug
dbt build
```
---
## Project Value

This project demonstrates:

- Real-world data warehouse design
- Production-grade dbt implementation
- Strong dimensional and analytical data modeling fundamentals
- Scalable, maintainable ELT pipelines

---
## Future Enhancements

- Workflow orchestration with Apache Airflow
- CI/CD automation using GitHub Actions
- Data freshness checks and SLA monitoring
- Cost-aware optimization strategies in Snowflake
