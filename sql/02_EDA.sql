/*
===============================================================================
Project : E-Commerce Funnel Conversion Analysis

File    : 02_EDA.sql

Objective:
Perform Exploratory Data Analysis (EDA) to understand customer behavior,
product performance, and shopping patterns before conducting funnel analysis.

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
During which hour of the day is customer activity the highest?

Business Objective:
Identify the peak hours of customer activity to understand when users are
most active on the platform. This insight can support marketing campaigns,
inventory planning, and system resource allocation.

===============================================================================
*/

SELECT
    hour,
    COUNT(*) AS customer_activity
FROM ecommerce
GROUP BY hour
ORDER BY customer_activity DESC;

-- Result:
-- Hour | Customer Activity
-- ------------------------
-- 19   | 250,041
-- 18   | 240,441
-- 12   | 237,962
-- 11   | 234,470
-- 10   | 233,298
-- ...
-- Lowest Activity:
-- 01   | 37,477
-- 00   | 40,337
-- 02   | 43,638

/*
Business Interpretation

Customer activity reaches its highest level during the evening hours,
with 7:00 PM (Hour 19) recording the highest number of interactions
(250,041 events), followed by 6:00 PM and 12:00 PM.

The lowest customer activity is observed during the early morning hours
between 12:00 AM and 2:00 AM, indicating that customers are least active
during this period.

These insights can help the business schedule promotional campaigns,
product launches, push notifications, and system maintenance during the
most appropriate hours. Running marketing campaigns during peak activity
hours may improve customer engagement, while maintenance activities can
be scheduled during periods of low customer activity to minimize user impact.

===============================================================================
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
Which day of the week records the highest customer activity?

Business Objective:
Identify the days with the highest customer engagement to understand weekly
shopping patterns. This insight helps optimize marketing campaigns,
promotional activities, staffing, and operational planning.

===============================================================================
*/

SELECT
    weekday,
    COUNT(*) AS customer_weekday_activity
FROM ecommerce
GROUP BY weekday
ORDER BY customer_weekday_activity DESC;

-- Result:
-- +------------+---------------------------+
-- | Weekday    | Customer Activity         |
-- +------------+---------------------------+
-- | Wednesday  | 698,510                   |
-- | Tuesday    | 656,404                   |
-- | Thursday   | 611,573                   |
-- | Monday     | 557,130                   |
-- | Sunday     | 514,969                   |
-- | Friday     | 442,304                   |
-- | Saturday   | 407,644                   |
-- +------------+---------------------------+

/*
Business Interpretation

Customer activity is highest on Wednesday, with 698,510 recorded events,
followed by Tuesday (656,404) and Thursday (611,573). In contrast,
Saturday (407,644) and Friday (442,304) record the lowest levels of
customer interaction.

This pattern suggests that customer engagement is stronger during the
middle of the week compared to weekends. Understanding these weekly
behavior patterns enables the business to identify periods of high
customer engagement and plan activities accordingly.

Business Recommendation

- Schedule major promotional campaigns and product launches during
  mid-week, particularly on Tuesday, Wednesday, and Thursday, to
  maximize customer reach and engagement.
- Allocate additional customer support and system resources during
  peak activity days to ensure a seamless shopping experience.
- Investigate the lower activity on weekends to identify opportunities
  for improving customer engagement through targeted offers or
  weekend-specific marketing campaigns.

===============================================================================
*/

/*
===============================================================================
Business Question 3
===============================================================================

Question:
Which day of the week records the highest number of purchases?

Business Objective:
Identify the day on which customers complete the highest number of purchases
to understand peak sales periods and optimize promotional strategies,
inventory planning, and resource allocation.

===============================================================================
*/

SELECT
    weekday,
    COUNT(*) AS total_day_purchases
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY weekday
ORDER BY total_day_purchases DESC;

-- Result:
-- +------------+----------------------+
-- | Weekday    | Total Purchases      |
-- +------------+----------------------+
-- | Wednesday  | 43,254               |
-- | Thursday   | 42,968               |
-- | Tuesday    | 42,430               |
-- | Monday     | 34,568               |
-- | Friday     | 29,388               |
-- | Sunday     | 28,958               |
-- | Saturday   | 23,695               |
-- +------------+----------------------+

/*
Business Interpretation

Wednesday recorded the highest number of purchases (43,254), closely followed
by Thursday (42,968) and Tuesday (42,430). Saturday recorded the lowest
number of purchases, with only 23,695 completed transactions.

The purchase pattern indicates that customers are more likely to complete
their purchases during the middle of the week, while weekend purchase
activity is comparatively lower.

Business Recommendation

- Schedule promotional campaigns, product launches, and limited-time offers
  during mid-week, particularly on Tuesday, Wednesday, and Thursday, to
  maximize sales opportunities.
- Ensure sufficient inventory and customer support resources are available
  during peak purchasing days.
- Investigate the lower purchase activity on weekends to determine whether
  targeted discounts or weekend-exclusive offers could improve sales
  performance.

===============================================================================
*/


/*
===============================================================================
Business Question 4
===============================================================================

Question:
Which brands receive the highest number of customer interactions?

Business Objective:
Identify the brands that generate the highest customer engagement to
understand brand popularity and customer interest across the platform.
This insight helps businesses prioritize marketing efforts, inventory
management, and brand partnerships.

===============================================================================
*/

SELECT
    brand,
    COUNT(*) AS total_customer_interaction_by_brand
FROM ecommerce
WHERE brand IS NOT NULL
GROUP BY brand
ORDER BY total_customer_interaction_by_brand DESC;

-- Result:
-- +-----------+-----------------------------+
-- | Brand     | Customer Interactions       |
-- +-----------+-----------------------------+
-- | runail    | 287,101                     |
-- | irisk     | 213,241                     |
-- | masura    | 182,834                     |
-- | grattol   | 125,838                     |
-- | bpw.style | 107,889                     |
-- | ...       | ...                         |
-- +-----------+-----------------------------+

/*
Business Interpretation

Runail received the highest customer engagement with 287,101 interactions,
followed by Irisk (213,241) and Masura (182,834). These brands consistently
attracted the largest share of customer activity on the platform during the
analysis period.

Higher customer interactions indicate greater customer interest and brand
visibility. However, high engagement does not necessarily translate into
higher sales. Further analysis is required to determine whether these brands
also achieve strong purchase conversion rates.

Business Recommendation

- Prioritize high-engagement brands such as Runail, Irisk, and Masura in
  promotional campaigns, homepage recommendations, and featured product
  sections.
- Evaluate whether these highly engaged brands also generate high purchase
  volumes and conversion rates.
- Investigate brands with high customer interactions but relatively low
  purchases to identify opportunities for improving product descriptions,
  pricing strategies, or promotional offers.

===============================================================================
*/

/*
===============================================================================
Data Quality Observations
===============================================================================

1. Approximately 40% of the records have missing brand values.
2. Brand-specific analyses exclude NULL values to ensure meaningful insights.
3. These records are retained for all other analyses because they contain
   valid customer interaction data.

===============================================================================
*/


/*
===============================================================================
Business Question 5
===============================================================================

Question:
Which brands generate the highest number of purchases?

Business Objective:
Identify the brands with the highest purchase volume to understand which
brands contribute the most to completed sales. This insight helps the
business prioritize inventory, strengthen brand partnerships, and optimize
marketing strategies.

===============================================================================
*/

SELECT
    brand,
    COUNT(*) AS brand_purchased
FROM ecommerce
WHERE brand IS NOT NULL
  AND event_type = 'purchase'
GROUP BY brand
ORDER BY brand_purchased DESC;

-- Result:
-- +-----------+------------------+
-- | Brand     | Total Purchases  |
-- +-----------+------------------+
-- | runail    | 21,920           |
-- | irisk     | 15,621           |
-- | masura    | 11,314           |
-- | bpw.style | 9,506            |
-- | grattol   | 6,438            |
-- | ...       | ...              |
-- +-----------+------------------+

/*
Business Interpretation

Runail recorded the highest number of completed purchases (21,920),
followed by Irisk (15,621), Masura (11,314), BPW.Style (9,506), and
Grattol (6,438). These brands contribute significantly to the platform's
overall sales volume.

Comparing these results with the previous analysis on customer interactions
shows that the brands attracting the highest customer engagement also rank
among the highest in completed purchases. This indicates that these brands
maintain strong customer interest throughout the shopping journey.

Business Recommendation

- Prioritize top-performing brands such as Runail, Irisk, and Masura in
  promotional campaigns and featured product placements.
- Maintain adequate inventory for these brands to prevent stock shortages
  during periods of high demand.
- Compare customer interactions with completed purchases for each brand to
  identify brands with high engagement but relatively low purchase volumes.
  Such brands may benefit from improvements in pricing, product descriptions,
  customer reviews, or promotional offers.

===============================================================================
*/

/*
===============================================================================
Business Question 6
===============================================================================

Question:
Which products receive the highest number of customer interactions?

Business Objective:
Identify the products that generate the highest customer engagement to
understand product popularity. This insight helps the business prioritize
inventory management, promotional campaigns, and product recommendations.

===============================================================================
*/

SELECT
    product_id,
    COUNT(*) AS product_interactions
FROM ecommerce
GROUP BY product_id
ORDER BY product_interactions DESC
LIMIT 10;

-- Result:
-- +------------+----------------------+
-- | Product ID | Customer Interactions|
-- +------------+----------------------+
-- | 5809910    | 10,410               |
-- | 5892179    | 10,015               |
-- | 5700037    | 8,655                |
-- | 5751383    | 8,259                |
-- | 5877454    | 8,150                |
-- | 5751422    | 7,913                |
-- | 5809912    | 7,651                |
-- | 5809911    | 6,826                |
-- | 5802432    | 6,769                |
-- | 5792800    | 6,758                |
-- +------------+----------------------+

/*
Business Interpretation

Product ID 5809910 recorded the highest customer engagement with 10,410
interactions, followed by Product ID 5892179 with 10,015 interactions.
These products attracted the greatest customer attention during the
analysis period.

Products with consistently high customer interactions indicate strong
customer interest and should be monitored further to determine whether
this interest translates into completed purchases.

Business Recommendation

- Feature high-performing products in promotional campaigns and homepage
  recommendations to maximize customer engagement.
- Ensure adequate inventory is maintained for highly popular products to
  avoid stock shortages.
- Compare customer interactions with purchase counts to identify products
  that attract high interest but have low conversion rates. Such products
  may require improvements in pricing, product descriptions, or promotional
  strategies.

===============================================================================
*/
