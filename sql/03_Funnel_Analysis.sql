/*
===============================================================================
Project : E-Commerce Funnel Conversion Analysis

File    : 03_Funnel_Analysis.sql

Objective:
Analyze customer progression through the e-commerce funnel, identify
conversion rates at each stage, measure customer drop-offs, and generate
business insights to improve overall conversion performance.

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
How many product view events were recorded during the analysis period?

Business Objective:
Measure the total number of product view events to establish the first stage
of the e-commerce funnel. This metric serves as the baseline for calculating
subsequent funnel conversion rates.

===============================================================================
*/

SELECT
    COUNT(*) AS total_views
FROM ecommerce
WHERE event_type = 'view';

-- Result:
-- Total Views : 1,862,047

/*
Business Interpretation

A total of 1,862,047 product view events were recorded during the analysis
period, representing the first stage of the customer journey within the
e-commerce funnel.

Product views indicate the level of customer interest in products and serve
as the entry point for all subsequent interactions, including adding products
to the cart and completing purchases.

This metric establishes the baseline for evaluating funnel performance and
will be used to calculate the View-to-Cart Conversion Rate in the next stage
of the analysis.

Business Recommendation

- Continuously monitor product view trends to measure customer engagement.
- Increase product visibility through personalized recommendations,
  search optimization, and promotional campaigns to maximize the number
  of customers entering the shopping funnel.
- Compare high-view products with their conversion performance to identify
  products that attract customer interest but fail to convert into purchases.

===============================================================================
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
How many add-to-cart events were recorded during the analysis period?

Business Objective:
Measure the total number of add-to-cart events to quantify customer
progression from product interest to purchase intent. This metric
represents the second stage of the e-commerce funnel.

===============================================================================
*/

SELECT
    COUNT(*) AS cart_added
FROM ecommerce
WHERE event_type = 'cart';

-- Result:
-- Total Add-to-Cart Events : 1,203,756

/*
Business Interpretation

A total of 1,203,756 add-to-cart events were recorded during the analysis
period, representing customers who expressed purchase intent by adding
products to their shopping carts.

The add-to-cart stage is a critical step in the customer journey because it
indicates that users have progressed beyond simply viewing products and are
considering a purchase.

This metric will be compared with the total number of product views to
calculate the View-to-Cart Conversion Rate, helping evaluate how effectively
the platform converts customer interest into purchase intent.

Business Recommendation

- Improve product pages with high-quality images, detailed descriptions,
  customer reviews, and competitive pricing to encourage more customers to
  add products to their carts.
- Monitor products with high view counts but low add-to-cart rates to
  identify potential issues affecting customer purchase intent.
- Optimize promotional offers and product recommendations to increase
  add-to-cart activity.

===============================================================================
*/

/*
===============================================================================
Business Question 3
===============================================================================

Question:
How many purchase events were recorded during the analysis period?

Business Objective:
Measure the total number of completed purchase events to identify the
final stage of the e-commerce funnel. This metric represents successful
customer conversions and serves as the basis for evaluating overall
funnel performance.

===============================================================================
*/

SELECT
    COUNT(*) AS total_purchases
FROM ecommerce
WHERE event_type = 'purchase';

-- Result:
-- Total Purchases : 245,261

/*
Business Interpretation

A total of 245,261 purchase events were completed during the analysis
period, representing the final stage of the e-commerce funnel and
successful customer conversions.

Purchase events indicate that customers successfully completed their
shopping journey after progressing through earlier stages such as product
views and add-to-cart actions.

This metric will be compared with the total number of product views and
add-to-cart events to calculate the overall funnel conversion rate and
the Cart-to-Purchase Conversion Rate, enabling the business to identify
where customers are most likely to drop off.

Business Recommendation

- Continuously monitor purchase trends to evaluate overall business
  performance.
- Analyze products with high cart activity but low purchase completion
  to identify barriers such as pricing, checkout friction, or customer
  hesitation.
- Optimize the checkout process and provide incentives, such as discounts
  or free shipping, to improve purchase completion rates.

===============================================================================
*/

/*
===============================================================================
Business Question 4
===============================================================================

Question:
What is the View-to-Cart Conversion Rate?

Business Objective:
Measure the percentage of product views that resulted in customers adding
products to their shopping carts. This KPI evaluates how effectively the
platform converts customer interest into purchase intent.

===============================================================================
*/

WITH funnel AS (
    SELECT
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS total_views,
        COUNT(CASE WHEN event_type = 'cart' THEN 1 END) AS total_carts
    FROM ecommerce
)

SELECT
    ROUND(
        total_carts * 100.0 / NULLIF(total_views, 0),
        2
    ) AS view_to_cart_conversion_rate
FROM funnel;

-- Result:
-- View-to-Cart Conversion Rate : 64.65%

/*
Business Interpretation

The View-to-Cart Conversion Rate is 64.65%, indicating that nearly
two-thirds of all product view events resulted in customers adding a
product to their shopping cart.

This is a strong indication that customers are finding products relevant
and are progressing from initial interest to purchase intent. The product
catalog, pricing, and product information appear effective in encouraging
customers to continue through the shopping journey.

This KPI measures the effectiveness of converting customer interest into
shopping intent and represents the first major transition within the
e-commerce funnel.

Business Recommendation

- Continue optimizing product pages with high-quality images, detailed
  descriptions, and customer reviews to maintain strong engagement.
- Analyze products with exceptionally high view counts but lower
  add-to-cart rates to identify opportunities for improving product
  presentation or pricing.
- Perform A/B testing on product pages and promotional offers to further
  increase the View-to-Cart Conversion Rate.

===============================================================================
*/

/*
===============================================================================
Business Question 5
===============================================================================

Question:
What is the Cart-to-Purchase Conversion Rate?

Business Objective:
Measure the percentage of add-to-cart events that resulted in completed
purchases. This KPI evaluates how effectively the platform converts
customer purchase intent into successful sales.

===============================================================================
*/

WITH funnel AS (
    SELECT
        COUNT(CASE WHEN event_type = 'cart' THEN 1 END) AS total_carts,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_purchases
    FROM ecommerce
)

SELECT
    ROUND(
        total_purchases * 100.0 / NULLIF(total_carts, 0),
        2
    ) AS cart_to_purchase_conversion_rate
FROM funnel;

-- Result:
-- Cart-to-Purchase Conversion Rate : 20.37%

/*
Business Interpretation

The Cart-to-Purchase Conversion Rate is 20.37%, indicating that only
about one in every five products added to the shopping cart resulted in
a completed purchase.

Compared to the strong View-to-Cart Conversion Rate (64.65%), this
significant decline suggests that a considerable number of customers
abandon their shopping journey after expressing purchase intent. This
stage represents the largest conversion gap in the current e-commerce
funnel and may indicate friction during the checkout process.

Business Recommendation

- Investigate the checkout process to identify friction points that
  discourage customers from completing purchases.
- Analyze cart abandonment behavior to understand why customers leave
  before checkout.
- Improve customer confidence through transparent pricing, shipping
  information, secure payment options, and simplified checkout.
- Use targeted strategies such as abandoned cart reminders or limited-
  time discounts to encourage customers to complete their purchases.

===============================================================================
*/

/*
===============================================================================
Business Question 6
===============================================================================

Question:
What is the Overall Funnel Conversion Rate?

Business Objective:
Measure the percentage of product view events that resulted in completed
purchases. This KPI represents the overall effectiveness of the
e-commerce funnel in converting customer interest into successful sales.

===============================================================================
*/

WITH cte AS (
    SELECT
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS total_views,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_purchases
    FROM ecommerce
)

SELECT
    ROUND(
        total_purchases * 100.0 / NULLIF(total_views, 0),
        2
    ) AS overall_conversion_rate
FROM cte;

-- Result:
-- Overall Funnel Conversion Rate : 13.17%

/*
Business Interpretation

The Overall Funnel Conversion Rate is 13.17%, indicating that
approximately 13 out of every 100 product view events resulted in a
completed purchase.

While the platform demonstrates a strong View-to-Cart Conversion Rate
(64.65%), the Cart-to-Purchase Conversion Rate (20.37%) is considerably
lower. This suggests that the primary challenge lies in converting
purchase intent into completed sales rather than attracting customer
interest.

The Overall Funnel Conversion Rate serves as one of the most important
performance indicators for the e-commerce platform, providing a summary
of the effectiveness of the entire customer journey.

Business Recommendation

- Focus on improving the checkout experience to increase purchase
  completion.
- Identify products or categories with high customer interest but low
  purchase conversion and investigate potential barriers.
- Implement strategies such as abandoned cart reminders, personalized
  discounts, and simplified payment options to improve overall
  conversion.
- Continuously monitor this KPI to evaluate the impact of future
  optimization initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 7
===============================================================================

Question:
What is the Cart Removal Rate?

Business Objective:
Measure the percentage of add-to-cart events that resulted in products
being removed from the shopping cart. This KPI helps identify customer
hesitation before completing a purchase and highlights opportunities to
reduce cart abandonment.

===============================================================================
*/

WITH funnel AS (
    SELECT
        COUNT(CASE WHEN event_type = 'cart' THEN 1 END) AS total_carts,
        COUNT(CASE WHEN event_type = 'remove_from_cart' THEN 1 END) AS total_cart_removals
    FROM ecommerce
)

SELECT
    ROUND(
        total_cart_removals * 100.0 / NULLIF(total_carts, 0),
        2
    ) AS cart_removal_rate
FROM funnel;

-- Result:
-- Cart Removal Rate : 47.97%

/*
Business Interpretation

The Cart Removal Rate is 47.97%, indicating that nearly half of all
add-to-cart events resulted in customers removing products from their
shopping carts before completing a purchase.

This represents a significant point of customer hesitation in the
shopping journey. Customers initially showed purchase intent by adding
products to their carts but later decided not to proceed with those
items.

A high cart removal rate may indicate issues such as pricing concerns,
unexpected shipping costs, product comparison behavior, changes in
purchase intent, or insufficient product information.

Business Recommendation

- Investigate products with the highest cart removal rates to identify
  common characteristics affecting customer decisions.
- Review pricing strategies, promotional offers, and shipping charges
  to reduce customer hesitation.
- Improve product descriptions, images, and customer reviews to build
  confidence before purchase.
- Analyze customer behavior after cart removal to determine whether
  users switch to alternative products or abandon the platform
  entirely.

===============================================================================
*/

/*
===============================================================================
Business Question 8
===============================================================================

Question:
What is the Overall Funnel Drop-off Rate?

Business Objective:
Measure the percentage of product view events that did not result in a
completed purchase. This KPI quantifies the overall customer loss
throughout the e-commerce funnel and highlights opportunities for
conversion improvements.

===============================================================================
*/

WITH cte AS (
    SELECT
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS total_views,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_purchases
    FROM ecommerce
)

SELECT
    ROUND(
        (total_views - total_purchases) * 100.0 /
        NULLIF(total_views, 0),
        2
    ) AS overall_drop_off_rate
FROM cte;

-- Result:
-- Overall Funnel Drop-off Rate : 86.83%

/*
Business Interpretation

The Overall Funnel Drop-off Rate is 86.83%, indicating that approximately
87 out of every 100 product view events did not result in a completed
purchase.

While customers demonstrate strong initial engagement by viewing products
and adding them to their shopping carts, a significant proportion exit
the shopping journey before completing a purchase. This highlights a
substantial opportunity to improve conversion throughout the funnel.

Reducing the overall drop-off rate can have a direct impact on increasing
sales without necessarily increasing website traffic.

Business Recommendation

- Investigate the stages with the highest customer loss to identify
  opportunities for improvement.
- Analyze customer behavior by product, brand, category, and time to
  determine where drop-offs are most significant.
- Optimize the checkout experience, pricing strategy, and promotional
  campaigns to encourage more customers to complete their purchases.
- Continuously monitor the drop-off rate after implementing changes to
  measure the effectiveness of optimization initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 9
===============================================================================

Question:
Which brands have the highest View-to-Purchase Conversion Rate?

Business Objective:
Measure the conversion rate for each brand by comparing product view
events with completed purchases. This analysis identifies brands that
effectively convert customer interest into sales and highlights
high-performing brands.

===============================================================================
*/

SELECT
    brand,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0),
        2
    ) AS brand_conversion_rate
FROM ecommerce
WHERE brand IS NOT NULL
GROUP BY brand
HAVING COUNT(CASE WHEN event_type = 'view' THEN 1 END) >= 100
ORDER BY brand_conversion_rate DESC
LIMIT 20;

-- Result:
-- +------------+-----------------------+
-- | Brand      | Conversion Rate (%)   |
-- +------------+-----------------------+
-- | eunyul     | 77.58                 |
-- | dermal     | 55.58                 |
-- | supertan   | 39.84                 |
-- | nitrile    | 38.36                 |
-- | severina   | 34.61                 |
-- | ...        | ...                   |
-- +------------+-----------------------+

/*
Business Interpretation

Among brands with at least 100 product views, Eunyul achieved the highest
View-to-Purchase Conversion Rate (77.58%), followed by Dermal (55.58%)
and Supertan (39.84%).

These brands demonstrate a strong ability to convert customer interest
into completed purchases, suggesting effective product positioning,
pricing, customer trust, or overall brand appeal.

Comparing conversion rates across brands helps identify top-performing
brands as well as brands that may attract customer attention but struggle
to convert that interest into sales.

Business Recommendation

- Prioritize high-converting brands in promotional campaigns and product
  recommendations to maximize sales.
- Analyze the characteristics of top-performing brands to identify
  successful pricing, product presentation, or marketing strategies that
  can be applied to other brands.
- Investigate brands with high customer interactions but lower conversion
  rates to identify opportunities for improvement in pricing, product
  descriptions, customer reviews, or promotional offers.

===============================================================================
*/


/*
===============================================================================
Business Question 10
===============================================================================

Question:
Which product categories have the highest View-to-Purchase Conversion Rate?

Business Objective:
Evaluate conversion performance across product categories to identify
which categories most effectively convert customer interest into completed
purchases. This analysis supports category-level inventory planning,
marketing strategies, and merchandising decisions.

===============================================================================
*/

SELECT
    category_id,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0),
        2
    ) AS category_conversion_rate
FROM ecommerce
GROUP BY category_id
HAVING COUNT(CASE WHEN event_type = 'view' THEN 1 END) >= 100
ORDER BY category_conversion_rate DESC
LIMIT 20;

-- Result:
-- +----------------------+----------------------+
-- | Category ID          | Conversion Rate (%)  |
-- +----------------------+----------------------+
-- | 1487580007592100809  | 67.62                |
-- | 1487580011476025461  | 66.67                |
-- | 1487580009622143014  | 54.17                |
-- | 2055161088059638328  | 53.62                |
-- | 1487580006509970331  | 53.31                |
-- | ...                  | ...                  |
-- +----------------------+----------------------+

/*
Business Interpretation

Among product categories with at least 100 product views, Category ID
1487580007592100809 achieved the highest View-to-Purchase Conversion
Rate (67.62%), followed by Category ID 1487580011476025461 (66.67%)
and Category ID 1487580009622143014 (54.17%).

These categories demonstrate a strong ability to convert customer
interest into completed purchases, indicating effective product
assortments and high customer demand.

Comparing conversion rates across categories enables the business to
identify high-performing categories while highlighting categories that
generate customer interest but experience lower purchase conversion.

Business Recommendation

- Prioritize high-converting categories in marketing campaigns and
  homepage promotions.
- Maintain sufficient inventory for top-performing categories to
  prevent stock shortages.
- Analyze lower-converting categories to identify opportunities for
  improving pricing, product assortment, merchandising, or customer
  experience.
- Monitor category conversion rates regularly to evaluate the impact
  of promotional and merchandising initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 11
===============================================================================

Question:
Which hours of the day have the highest View-to-Purchase Conversion Rate?

Business Objective:
Analyze hourly conversion performance to identify the time periods when
customers are most likely to complete purchases. This insight helps
optimize marketing campaigns, promotional timing, and operational
planning.

===============================================================================
*/

SELECT
    hour,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0),
        2
    ) AS hour_wise_conversion_rate
FROM ecommerce
GROUP BY hour
ORDER BY hour_wise_conversion_rate DESC;

-- Result:
-- +------+-------------------------+
-- | Hour | Conversion Rate (%)     |
-- +------+-------------------------+
-- | 01   | 15.58                   |
-- | 23   | 14.42                   |
-- | 12   | 14.31                   |
-- | 11   | 14.23                   |
-- | 09   | 14.01                   |
-- | ...  | ...                     |
-- | 18   | 11.32                   |
-- +------+-------------------------+

/*
Business Interpretation

Customer conversion rates vary throughout the day, with the highest
conversion occurring at 01:00 (15.58%), followed by 23:00 (14.42%),
12:00 (14.31%), and 11:00 (14.23%).

Although 01:00 shows the highest conversion rate, it is important to
interpret this result alongside customer traffic. Some hours may have
fewer visitors, causing higher conversion percentages despite lower
overall sales volume.

Analyzing hourly conversion patterns enables the business to identify
time periods when customers are most likely to complete purchases and
supports data-driven decisions for marketing and operational planning.

Business Recommendation

- Schedule promotional campaigns during hours with consistently strong
  conversion rates to maximize sales.
- Compare hourly conversion rates with customer traffic to identify
  periods that combine both high visitor volume and high conversion.
- Allocate customer support and system resources during high-converting
  periods to ensure a smooth purchasing experience.
- Monitor hourly conversion trends regularly to evaluate the impact of
  future marketing campaigns and operational improvements.

===============================================================================
*/


/*
===============================================================================
Business Question 12
===============================================================================

Question:
Which weekdays have the highest View-to-Purchase Conversion Rate?

Business Objective:
Analyze conversion performance across weekdays to identify the days
when customers are most likely to complete purchases. This insight
supports marketing campaign scheduling, promotional planning, and
resource allocation.

===============================================================================
*/

SELECT
    weekday,
    ROUND(
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 /
        NULLIF(COUNT(CASE WHEN event_type = 'view' THEN 1 END), 0),
        2
    ) AS weekday_conversion_rate
FROM ecommerce
GROUP BY weekday
ORDER BY weekday_conversion_rate DESC;

-- Result:
-- +-----------+-----------------------+
-- | Weekday   | Conversion Rate (%)   |
-- +-----------+-----------------------+
-- | Thursday  | 14.47                 |
-- | Tuesday   | 13.58                 |
-- | Friday    | 13.28                 |
-- | Wednesday | 13.26                 |
-- | Monday    | 13.04                 |
-- | Sunday    | 12.22                 |
-- | Saturday  | 11.67                 |
-- +-----------+-----------------------+

/*
Business Interpretation

Customer purchase behavior varies across the week, with Thursday
recording the highest View-to-Purchase Conversion Rate (14.47%),
followed by Tuesday (13.58%) and Friday (13.28%).

These findings indicate that customers are more likely to complete
purchases on weekdays than during weekends. The lower conversion
rates observed on Saturday and Sunday suggest that customers may
browse products more frequently during weekends but postpone their
purchasing decisions.

Analyzing weekday conversion trends helps identify the most effective
days for launching promotional campaigns and planning business
operations.

Business Recommendation

- Schedule major promotional campaigns and product launches during
  high-converting weekdays such as Thursday and Tuesday.
- Investigate the factors contributing to lower weekend conversion
  rates and evaluate opportunities to improve weekend sales through
  targeted promotions or personalized offers.
- Monitor weekday conversion trends over time to assess seasonal
  variations and the effectiveness of marketing initiatives.

===============================================================================
*/