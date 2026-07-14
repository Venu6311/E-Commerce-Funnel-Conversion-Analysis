/*
===============================================================================
Project : Customer Segmentation Analysis

File    : 06_Customer_Segmentation.sql

Objective:
Analyze customer purchasing behavior by evaluating revenue contribution,
purchase frequency, spending patterns, and product diversity. The goal is
to identify high-value customers, understand customer behavior, and
generate actionable business insights that support customer retention,
personalized marketing, and revenue growth strategies.

Dataset:
October 2019 E-Commerce Events Dataset

Author:
Venu TR

===============================================================================
*/

/*
===============================================================================
Business Question 1
===============================================================================

Question:
Who are the most valuable customers based on their purchasing behavior?

Business Objective:
Calculate customer-level purchase metrics including total revenue,
purchase frequency, average order value, first and last purchase dates,
and product diversity. These metrics establish a comprehensive customer
profile that serves as the foundation for customer segmentation,
loyalty analysis, and future RFM analysis.

===============================================================================
*/

SELECT
    user_id,
    SUM(price) AS total_revenue,
    COUNT(*) AS total_purchases,
    ROUND(AVG(price), 2) AS avg_order_value,
    MIN(date) AS first_purchase_date,
    MAX(date) AS last_purchase_date,
    COUNT(DISTINCT brand) AS brands_purchased,
    COUNT(DISTINCT category_id) AS categories_purchased
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY user_id
ORDER BY total_revenue DESC;

-- Result (Top 5 Customers):
--
-- +-----------+---------------+-----------------+-----------------+---------------------+--------------------+------------------+----------------------+
-- | user_id   | total_revenue | total_purchases | avg_order_value | first_purchase_date | last_purchase_date | brands_purchased | categories_purchased |
-- +-----------+---------------+-----------------+-----------------+---------------------+--------------------+------------------+----------------------+
-- | 557850743 | 1295.48       | 104             | 12.46           | 2019-10-18          | 2019-10-24         | 4                | 31                   |
-- | 561592095 | 1109.70       | 94              | 11.81           | 2019-10-30          | 2019-10-31         | 12               | 23                   |
-- | 150318419 | 1104.76       | 95              | 11.63           | 2019-10-04          | 2019-10-31         | 19               | 40                   |
-- | 546827800 | 1004.45       | 329             | 3.05            | 2019-10-04          | 2019-10-15         | 11               | 28                   |
-- | 474623506 | 914.91        | 47              | 19.47           | 2019-10-14          | 2019-10-31         | 9                | 26                   |
-- +-----------+---------------+-----------------+-----------------+---------------------+--------------------+------------------+----------------------+
--
-- Note:
-- The complete result contains one row for each customer and is ordered
-- by total revenue in descending order.

/*
Business Interpretation

The customer purchase metrics reveal significant differences in
purchasing behavior across the customer base. While some customers
generate high revenue through frequent purchases, others contribute
similar revenue through fewer but higher-value transactions.

For example, customer 546827800 generated over ₹1,000 in revenue from
329 purchases with an average order value of ₹3.05, indicating a highly
loyal and frequent shopper. In contrast, customer 474623506 generated
over ₹900 from just 47 purchases with an average order value of ₹19.47,
indicating a preference for higher-priced products.

The analysis demonstrates that customer value is influenced not only by
total revenue but also by purchase frequency, average order value,
shopping duration, and product diversity. These metrics provide a
comprehensive customer profile that forms the foundation for customer
segmentation and subsequent RFM analysis.

Business Recommendation

- Prioritize high-value customers through loyalty programs, exclusive
  discounts, and personalized marketing campaigns.
- Target customers with high purchase frequency but lower average order
  values using cross-selling and upselling strategies to increase
  revenue per transaction.
- Encourage customers with high average order values but infrequent
  purchases through personalized promotions and retention campaigns.
- Use these customer metrics as the foundation for advanced customer
  segmentation and RFM analysis to support data-driven marketing
  decisions.

===============================================================================
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
Who are the top 10 customers contributing the highest revenue?

Business Objective:
Identify the customers generating the highest revenue for the business.
Understanding the contribution of top customers helps prioritize customer
retention strategies, loyalty programs, and personalized marketing
efforts by focusing on customers with the greatest business value.

===============================================================================
*/

SELECT
    user_id,
    SUM(price) AS total_revenue,
    COUNT(*) AS total_purchases,
    ROUND(AVG(price),2) AS avg_order_value
FROM ecommerce
WHERE event_type='purchase'
GROUP BY user_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Result:
--
-- +-----------+---------------+-----------------+-----------------+
-- | user_id   | total_revenue | total_purchases | avg_order_value |
-- +-----------+---------------+-----------------+-----------------+
-- | 557850743 | 1295.48       | 104             | 12.46           |
-- | 561592095 | 1109.70       | 94              | 11.81           |
-- | 150318419 | 1104.76       | 95              | 11.63           |
-- | 546827800 | 1004.45       | 329             | 3.05            |
-- | 474623506 | 914.91        | 47              | 19.47           |
-- | 549368055 | 903.88        | 208             | 4.35            |
-- | 550009641 | 838.61        | 56              | 14.98           |
-- | 549195612 | 831.78        | 131             | 6.35            |
-- | 531900924 | 799.08        | 93              | 8.59            |
-- | 499085268 | 764.61        | 147             | 5.20            |
-- +-----------+---------------+-----------------+-----------------+

/*
Business Interpretation

The analysis identifies the top 10 customers based on total revenue,
highlighting the customers who contribute the most to overall sales.
These customers represent the highest-value segment and play a critical
role in the business's revenue generation.

The results reveal varying purchasing behaviors among high-value
customers. For example, customer 546827800 generated over ₹1,000 in
revenue through 329 purchases, indicating frequent repeat purchases with
a relatively low average order value. In contrast, customer 474623506
generated over ₹900 from only 47 purchases while maintaining a much
higher average order value, suggesting a preference for premium-priced
products.

These differences indicate that high-value customers cannot be evaluated
based solely on revenue. Purchase frequency and average order value
provide additional insights into customer behavior and purchasing
patterns, which are valuable for designing personalized marketing and
customer retention strategies.

Business Recommendation

- Prioritize the top revenue-generating customers through exclusive
  loyalty programs, personalized offers, and early access to new
  products.
- Reward customers with frequent purchases to strengthen customer
  loyalty and encourage long-term engagement.
- Identify customers with high average order values and recommend
  premium or complementary products to maximize revenue.
- Continuously monitor the purchasing behavior of high-value customers
  to reduce churn and improve customer lifetime value.

===============================================================================
*/

/*
===============================================================================
Business Question 3
===============================================================================

Question:
How many customers are one-time buyers versus repeat buyers?

Business Objective:
Classify customers based on their purchase frequency to understand
customer retention and repeat purchasing behavior. Identifying the
proportion of one-time and repeat buyers helps evaluate customer
loyalty and provides insights for designing effective retention
strategies.

===============================================================================
*/

WITH customer_purchases AS (
    SELECT
        user_id,
        COUNT(*) AS total_purchases
    FROM ecommerce
    WHERE event_type = 'purchase'
    GROUP BY user_id
)

SELECT
    CASE
        WHEN total_purchases = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_purchases
GROUP BY customer_type;

-- Result:
--
-- +-----------------+----------------+
-- | Customer Type   | Customer Count |
-- +-----------------+----------------+
-- | Repeat Buyer    | 23,314         |
-- | One-Time Buyer  | 2,448          |
-- +-----------------+----------------+

/*
Business Interpretation

The analysis shows that the majority of customers are repeat buyers,
with 23,314 customers making more than one purchase compared to only
2,448 one-time buyers. This indicates that a significant proportion of
customers return to the platform for additional purchases, reflecting
strong customer retention and engagement.

The relatively small number of one-time buyers suggests that many
customers continue purchasing after their initial transaction, which is
a positive indicator of customer loyalty and overall shopping experience.

Business Recommendation

- Continue strengthening customer retention strategies through loyalty
  programs, personalized product recommendations, and targeted
  promotional campaigns.
- Analyze the purchasing behavior of one-time buyers to identify factors
  preventing repeat purchases and develop re-engagement strategies.
- Reward repeat buyers with exclusive benefits and incentives to
  increase customer lifetime value and encourage long-term loyalty.
- Monitor the ratio of one-time to repeat buyers regularly to measure
  the effectiveness of customer retention initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 4
===============================================================================

Question:
How are customers distributed based on their total spending?

Business Objective:
Segment customers into High, Medium, and Low Value groups based on
their total purchase revenue. Customer value segmentation helps the
business identify its most profitable customers, prioritize retention
efforts, and develop targeted marketing strategies for different
customer groups.

===============================================================================
*/

WITH customer_revenue AS (
    SELECT
        user_id,
        SUM(price) AS total_revenue
    FROM ecommerce
    WHERE event_type = 'purchase'
    GROUP BY user_id
)

SELECT
    CASE
        WHEN total_revenue > 500 THEN 'High Value'
        WHEN total_revenue BETWEEN 200 AND 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM customer_revenue
GROUP BY customer_segment;

-- Result:
--
-- +------------------+----------------+
-- | Customer Segment | Customer Count |
-- +------------------+----------------+
-- | High Value       | 42             |
-- | Medium Value     | 507            |
-- | Low Value        | 25,213         |
-- +------------------+----------------+

/*
Business Interpretation

The customer base is heavily concentrated in the Low Value segment,
with 25,213 customers contributing relatively small purchase amounts.
Only 42 customers belong to the High Value segment, while 507 customers
fall into the Medium Value segment.

This distribution indicates that a very small proportion of customers
generate substantial revenue, whereas the majority contribute through
smaller purchases. These findings highlight the importance of retaining
high-value customers while also creating opportunities to increase the
spending of low- and medium-value customers.

Business Recommendation

- Retain High Value customers through VIP programs, exclusive offers,
  and personalized experiences to maximize customer lifetime value.
- Target Medium Value customers with cross-selling and upselling
  strategies to encourage progression into the High Value segment.
- Engage Low Value customers with personalized promotions, discounts,
  and product recommendations to increase purchase frequency and
  spending.
- Regularly monitor customer value distribution to evaluate the
  effectiveness of marketing and customer retention initiatives.

===============================================================================
*/

/*
===============================================================================
Conclusion
===============================================================================

The customer segmentation analysis provides a comprehensive understanding
of customer purchasing behavior by evaluating revenue contribution,
purchase frequency, and spending patterns.

Key findings from the analysis include:

- A small group of customers contributes a significant portion of total
  revenue, highlighting the importance of retaining high-value customers.
- The majority of purchasing customers are repeat buyers, indicating
  strong customer retention and continued engagement with the platform.
- Most customers fall into the Low Value segment, while only a small
  percentage belong to the High Value segment, presenting opportunities
  for targeted marketing and customer value growth.

Overall, these insights enable the business to better understand customer
behavior, prioritize retention efforts, and design personalized marketing
strategies.

The next phase of the analysis focuses on RFM (Recency, Frequency, and
Monetary) Analysis, which provides a more advanced and data-driven
approach to customer segmentation by identifying customer loyalty,
engagement, and lifetime value.

===============================================================================
*/