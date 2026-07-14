/*
===============================================================================
Project : E-Commerce Funnel Conversion Analysis

File    : 04_Root_Cause_Analysis.sql

Objective:
Identify the major reasons behind customer drop-offs by analyzing
conversion performance across brands, categories, time periods, and
shopping behavior. The goal is to provide actionable business
recommendations to improve overall conversion rates.

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
Which stage of the e-commerce funnel experiences the highest customer
drop-off?

Business Objective:
Compare customer progression across the View, Cart, Remove from Cart,
and Purchase stages to identify where the greatest customer loss occurs.
Understanding the weakest stage enables the business to prioritize
optimization efforts where they will have the greatest impact.

===============================================================================
*/

SELECT
    event_type AS funnel_stage,
    COUNT(*) AS total_events
FROM ecommerce
GROUP BY event_type
ORDER BY total_events DESC;

-- Result:
-- +-------------------+--------------+
-- | Funnel Stage      | Total Events |
-- +-------------------+--------------+
-- | view              | 1,862,047    |
-- | cart              | 1,203,756    |
-- | remove_from_cart  |   577,470    |
-- | purchase          |   245,261    |
-- +-------------------+--------------+

/*
Business Interpretation

The number of customer interactions decreases substantially as users
progress through the shopping journey. Product views represent the
highest level of engagement (1,862,047 events), while only 245,261
events result in completed purchases.

The largest reduction occurs after customers add products to their
shopping carts. Combined with the previously calculated Cart-to-
Purchase Conversion Rate (20.37%) and Cart Removal Rate (47.97%), this
suggests that the checkout stage is the primary bottleneck in the
e-commerce funnel.

Business Recommendation

- Prioritize optimization of the checkout process to reduce customer
  abandonment.
- Investigate the reasons behind product removals from shopping carts,
  including pricing, shipping costs, and payment friction.
- Focus future optimization efforts on the Cart-to-Purchase stage,
  where the greatest opportunity exists to improve overall conversion.

===============================================================================
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
Which funnel transition has the highest customer drop-off?

Business Objective:
Measure customer loss at each stage transition within the e-commerce
funnel. Identifying the stage with the highest drop-off enables the
business to prioritize optimization efforts where they will have the
greatest impact on overall conversion.

===============================================================================
*/

WITH funnel_metrics AS (
    SELECT
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS total_views,
        COUNT(CASE WHEN event_type = 'cart' THEN 1 END) AS total_carts,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_purchases
    FROM ecommerce
)

SELECT
    'View → Cart' AS funnel_transition,
    ROUND(
        total_carts * 100.0 / NULLIF(total_views, 0),
        2
    ) AS conversion_rate,
    ROUND(
        (total_views - total_carts) * 100.0 / NULLIF(total_views, 0),
        2
    ) AS drop_off_rate
FROM funnel_metrics

UNION ALL

SELECT
    'Cart → Purchase',
    ROUND(
        total_purchases * 100.0 / NULLIF(total_carts, 0),
        2
    ),
    ROUND(
        (total_carts - total_purchases) * 100.0 / NULLIF(total_carts, 0),
        2
    )
FROM funnel_metrics;

-- Result:
-- +-------------------+-----------------+---------------+
-- | Funnel Transition | Conversion Rate | Drop-off Rate |
-- +-------------------+-----------------+---------------+
-- | View → Cart       | 64.65%          | 35.35%        |
-- | Cart → Purchase   | 20.37%          | 79.63%        |
-- +-------------------+-----------------+---------------+

/*
Business Interpretation

The funnel transition analysis reveals that customer loss increases
significantly as users progress through the shopping journey.

While 64.65% of product views successfully convert into add-to-cart
events, only 20.37% of cart additions result in completed purchases.
Consequently, the Cart-to-Purchase stage experiences the highest
customer drop-off rate (79.63%), compared with 35.35% between the
View-to-Cart stage.

This indicates that the primary obstacle in the customer journey is
not generating customer interest, but converting purchase intent into
completed sales.

Business Recommendation

- Prioritize optimization of the Cart-to-Purchase stage, as it presents
  the greatest opportunity for increasing overall conversion.
- Investigate checkout friction, including payment methods, shipping
  costs, account creation requirements, and checkout complexity.
- Implement abandoned cart recovery strategies such as reminder emails,
  personalized offers, or limited-time discounts.
- Continuously monitor transition-level conversion rates to measure the
  effectiveness of optimization initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 3
===============================================================================

Question:
Which brands receive high customer interest but have low conversion rates?

Business Objective:
Identify brands that attract a large number of product views but convert
only a small percentage of those views into purchases. These brands
represent the greatest opportunity for improving overall sales through
pricing, product presentation, or promotional optimization.

===============================================================================
*/

WITH brand_metrics AS (
    SELECT
        brand,
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS views,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchases
    FROM ecommerce
    WHERE brand IS NOT NULL
    GROUP BY brand
    HAVING COUNT(CASE WHEN event_type = 'view' THEN 1 END) >= 100
)

SELECT
    brand,
    views,
    purchases,
    ROUND(
        purchases * 100.0 /
        NULLIF(views, 0),
        2
    ) AS conversion_rate
FROM brand_metrics
ORDER BY
    views DESC,
    conversion_rate ASC
LIMIT 10;

-- Result:
-- +-----------+---------+-----------+----------------+
-- | Brand     | Views   | Purchases | Conversion (%) |
-- +-----------+---------+-----------+----------------+
-- | runail    | 119,602 | 21,920    | 18.33          |
-- | irisk     | 85,316  | 15,621    | 18.31          |
-- | masura    | 79,506  | 11,314    | 14.23          |
-- | grattol   | 67,868  | 6,438     | 9.49           |
-- | bpw.style | 43,325  | 9,506     | 21.94          |
-- | estel     | 36,989  | 3,199     | 8.65           |
-- | ingarden  | 35,088  | 5,175     | 14.75          |
-- | kapous    | 32,914  | 3,066     | 9.32           |
-- | jessnail  | 29,097  | 1,803     | 6.20           |
-- | concept   | 25,665  | 1,844     | 7.18           |
-- +-----------+---------+-----------+----------------+

/*
Business Interpretation

Several brands attract substantial customer interest but convert only a
small percentage of product views into completed purchases. While
Runail and Irisk receive the highest number of views and maintain
reasonable conversion rates, brands such as Grattol, Estel, Jessnail,
and Concept exhibit comparatively lower conversion despite significant
customer traffic.

These brands represent valuable optimization opportunities because even
small improvements in their conversion rates could generate a meaningful
increase in total sales due to their high visibility.

Business Recommendation

- Review pricing, promotions, and product positioning for brands with
  high traffic but relatively low conversion.
- Improve product pages by enhancing images, descriptions, and customer
  reviews to increase buyer confidence.
- Compare these brands with higher-converting brands to identify best
  practices that can be adopted across the platform.
- Conduct A/B testing on product presentation and promotional offers to
  improve conversion performance for these brands.

===============================================================================
*/

/*
===============================================================================
Business Question 4
===============================================================================

Question:
Which product categories receive high customer interest but have low
conversion rates?

Business Objective:
Identify product categories that attract a high number of product views
but generate relatively few purchases. These categories represent the
greatest opportunity for improving sales through pricing, merchandising,
product assortment, or promotional strategies.

===============================================================================
*/

WITH category_metrics AS (
    SELECT
        category_id,
        COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS views,
        COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchases
    FROM ecommerce
    GROUP BY category_id
    HAVING COUNT(CASE WHEN event_type = 'view' THEN 1 END) >= 100
)

SELECT
    category_id,
    views,
    purchases,
    ROUND(
        purchases * 100.0 /
        NULLIF(views, 0),
        2
    ) AS conversion_rate
FROM category_metrics
ORDER BY
    views DESC,
    conversion_rate ASC
LIMIT 10;

-- Result:
-- +----------------------+--------+-----------+----------------+
-- | Category ID          | Views  | Purchases | Conversion (%) |
-- +----------------------+--------+-----------+----------------+
-- | 1487580007675986893  | 77,087 | 14,510    | 18.82          |
-- | 1487580005092295511  | 74,884 | 7,899     | 10.55          |
-- | 1487580005671109489  | 53,855 | 9,956     | 18.49          |
-- | 1487580006300255120  | 52,036 | 763       | 1.47           |
-- | 1602943681873052386  | 49,768 | 4,129     | 8.30           |
-- | 1487580008246412266  | 47,878 | 3,034     | 6.34           |
-- | 1487580006317032337  | 46,759 | 10,421    | 22.29          |
-- | 1487580013950664926  | 46,692 | 1,130     | 2.42           |
-- | 1487580013841613016  | 45,332 | 2,795     | 6.17           |
-- | 1487580005268456287  | 43,248 | 5,749     | 13.29          |
-- +----------------------+--------+-----------+----------------+

/*
Business Interpretation

Several product categories attract substantial customer interest but
convert only a small proportion of product views into completed
purchases. Categories such as 1487580006300255120 and
1487580013950664926 receive tens of thousands of product views but
record conversion rates of only 1.47% and 2.42%, respectively.

These categories represent high-impact optimization opportunities
because improving their conversion rates could significantly increase
overall sales without requiring additional customer traffic.

Business Recommendation

- Investigate low-converting, high-traffic categories to identify
  pricing, merchandising, or product assortment issues.
- Review product descriptions, images, and customer reviews within
  these categories to improve customer confidence.
- Compare these categories with higher-converting categories to identify
  successful merchandising strategies and replicate best practices.
- Monitor category-level conversion after implementing improvements to
  measure business impact.

===============================================================================
*/

/*
===============================================================================
Final Business Findings
===============================================================================

1. The platform recorded 1.86 million product views, but only 245,261
   completed purchases, resulting in an Overall Funnel Conversion Rate
   of 13.17%.

2. The View-to-Cart Conversion Rate (64.65%) indicates strong customer
   interest and effective product discovery.

3. The Cart-to-Purchase Conversion Rate (20.37%) is substantially lower,
   revealing that the checkout stage is the primary bottleneck in the
   customer journey.

4. Nearly half of all cart additions (47.97%) resulted in products being
   removed from shopping carts, suggesting significant customer
   hesitation before purchase.

5. Funnel transition analysis showed that the Cart-to-Purchase stage
   experienced the highest customer drop-off (79.63%), making it the
   highest-priority area for optimization.

6. Several brands and product categories attracted high customer traffic
   but demonstrated relatively poor conversion rates, representing
   valuable opportunities to improve revenue without increasing website
   traffic.

===============================================================================
*\


/*
===============================================================================
Final Business Recommendations
===============================================================================

1. Prioritize optimization of the checkout process by simplifying the
   purchase journey, improving payment options, and minimizing checkout
   friction.

2. Implement abandoned cart recovery strategies, including reminder
   emails, personalized offers, and limited-time discounts.

3. Improve product pages for high-traffic, low-converting brands and
   categories through better product descriptions, images, pricing
   strategies, and customer reviews.

4. Allocate marketing resources toward high-converting brands,
   categories, and time periods while developing targeted improvement
   plans for lower-performing segments.

5. Continuously monitor funnel KPIs, conversion rates, and customer
   behavior using interactive dashboards to evaluate the impact of
   optimization initiatives.

===============================================================================
*\