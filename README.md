# zepto-sql-powerbi-analysis
# Zepto Inventory & Pricing Analysis (MySQL)

SQL analysis of a public Zepto inventory dataset covering data cleaning, ranking with window functions, price-tier segmentation and stock-availability insights.

## Dataset
3,732 rows and 9 columns: `Category`, `name`, `mrp`, `discountPercent`, `availableQuantity`, `discountedSellingPrice`, `weightInGms`, `outOfStock`, `quantity`. Prices are stored in paise.

## What I did
- Created the table and loaded the CSV with `LOAD DATA LOCAL INFILE`
- Checked for NULLs and repeated product names
- Removed 1 invalid zero-price record (3,731 products remain) and converted prices from paise to rupees
- Ranked top-discounted products per category with `ROW_NUMBER` and `DENSE_RANK`
- Segmented products into price tiers (low < Rs. 300, mid Rs. 300 to 600, high > Rs. 600)
- Calculated price per gram and found products with high MRP and low discount

## Key findings
- 453 of 3,731 products (12.1%) are out of stock
- 92% of products (3,431) are priced under Rs. 300; 242 are mid-priced and 58 are high-priced
- Fruits & Vegetables has the highest average discount (15.46%)

## Data quality note
The dataset repeats identical product lists under several categories (for example, Cooking Essentials and Munchies are identical). Ignoring the Category column, 1,931 of 3,731 rows are repeats. Category-level totals such as revenue and weight are therefore inflated and should be treated with caution.

## Tools
MySQL 8.0, MySQL Workbench, [Power BI Desktop for the dashboard, include only if finished]

## How to run
1. Download the dataset and update the file path in `zepto_sql.sql`
2. Enable `local_infile` in MySQL (needed for `LOAD DATA LOCAL INFILE`)
3. Run `zepto_sql.sql` from top to bottom

## Repository structure
- `zepto_sql.sql`: table creation, cleaning and analysis queries
- `screenshots/`: sample query results and dashboard
<img width="1920" height="1080" alt="Screenshot (397)" src="https://github.com/user-attachments/assets/bbdb8810-2a36-41e3-80e0-c971a8f8a06f" />
