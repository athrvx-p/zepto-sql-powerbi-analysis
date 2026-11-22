create  database zepto;
use zepto;
CREATE TABLE zepto (
  snr INT AUTO_INCREMENT PRIMARY KEY,
  Category VARCHAR(50),
  name VARCHAR(150),
  mrp INT,
  discountPercent INT,
  availableQuantity INT,
  discountedSellingPrice INT,
  weightInGms INT,
  outOfStock VARCHAR(5),
  quantity INT
);

LOAD DATA LOCAL INFILE 'C:/Users/athar/Downloads/zepto.csv'
INTO TABLE zepto
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity);

SELECT COUNT(*) FROM zepto limit 10;
select * from zepto where
Category is null or
name is null or
mrp is null or
discountPercent is null or
availableQuantity is null or
discountedSellingPrice is null or
weightInGms is null or
outOfStock is null or
quantity is null ;

 # product category
select distinct Category from zepto order by Category;

-- product in stock vs out of stocks 
select outOfStock,count(snr) from zepto group by outOfStock ;

-- producty name present multiple times 
select name , count(snr) as "number of snr"
from zepto
group by name 
having count(snr)>1
order by count(snr) desc;

-- product with o price
select * from zepto where mrp = 0 or discountedSellingPrice=0;
delete from zepto where mrp = 0;
select * from zepto order by mrp desc limit 10;

-- coversion of mrp and discountedselling price into rupees from paisa 
update zepto 
set mrp = mrp/100 , discountedSellingPrice = discountedSellingPrice/100;

-- top 2 best value product by catagory based on discount percentage 
select name,Category ,discountPercent from (select name ,Category, discountPercent,dense_rank() over(partition by Category order by discountPercent desc) as ranking from zepto) as ranked_product where ranking<=2;

-- top discounted products per catagory
select name , discountPercent,Category from 
(select name ,Category, discountPercent , row_number() over(partition by Category order by discountPercent desc ) as rnk from zepto) as ranking where rnk=1 order by discountPercent desc;

-- top mrp product by category out of stocks
select name ,Category , mrp,outOfStock from (select name , mrp ,Category,outOfStock,row_number() over(partition by Category order by mrp desc) as ranking from zepto) as rnk where ranking in (1,2) and outOfStock = True;

-- estimated revenue for each catagory
select sum(total_revenue) from(select Category , sum(discountedSellingPrice*availableQuantity) as total_revenue from zepto group by Category order by total_revenue desc) as total_sum ;

-- product with high mrp and low discount

select * from zepto where mrp>500 and discountPercent<10 order by mrp desc;

-- top 5 catagory offering highest average discount price
select Category , round(avg(discountPercent),2) as avg_discount from zepto group by Category order by  avg_discount desc limit 5 ;

-- price per gram 
select name ,weightInGms, discountedSellingPrice , round((discountedSellingPrice/weightInGms),2) as price_per_gm from zepto order by price_per_gm;

-- group product by price 
select distinct name , discountedSellingPrice ,
case when discountedSellingPrice <300 then 'low'
when discountedSellingPrice >=300 and discountedSellingPrice <=600  then 'mid'
when discountedSellingPrice >600 then 'high'
end as expensiveness from zepto order by discountedSellingPrice desc;

-- total inventery weight by category
select Category , sum(weightInGms*availableQuantity) as total_weight from zepto group by Category order by total_weight desc;