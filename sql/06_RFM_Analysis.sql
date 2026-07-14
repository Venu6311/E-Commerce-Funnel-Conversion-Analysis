/*
===============================================================================
Project : RFM Analysis

File    : 07_RFM_Analysis.sql

Objective:
Perform Recency, Frequency, and Monetary (RFM) analysis to evaluate
customer purchasing behavior and segment customers based on their
engagement, purchase frequency, and spending patterns. The analysis
helps identify high-value customers, loyal customers, and customers
requiring retention efforts to support data-driven marketing strategies.

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
What are the Recency, Frequency, and Monetary (RFM) metrics for each
customer?

Business Objective:
Calculate Recency, Frequency, and Monetary values for every purchasing
customer. These metrics provide the foundation for RFM Analysis, a
widely used customer segmentation technique that evaluates customer
engagement, purchase behavior, and overall customer value.

===============================================================================
*/

SELECT
    user_id,
    DATEDIFF(
        (SELECT MAX(date) FROM ecommerce),
        MAX(date)
    ) AS recency,
    COUNT(*) AS frequency,
    SUM(price) AS monetary
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY user_id;

-- Result:
--
-- +-----------+----------+-----------+----------+
-- | user_id   | recency  | frequency | monetary |
-- +-----------+----------+-----------+----------+
-- | 29025780  | 24       | 18        | 41.68    |
-- | 31229488  | 28       | 4         | 14.43    |
-- | 33535391  | 18       | 10        | 125.39   |
-- | ...       | ...      | ...       | ...      |
-- +-----------+----------+-----------+----------+
--
-- The complete result contains one row for each purchasing customer
-- with their Recency, Frequency, and Monetary (RFM) metrics.

/*
Business Interpretation

The RFM metrics provide a comprehensive view of customer purchasing
behavior. Recency measures how recently a customer made a purchase,
Frequency indicates how often the customer purchases, and Monetary
represents the total amount spent by the customer.

Together, these three metrics help distinguish customers based on their
engagement and value to the business. Customers with low recency values,
high purchase frequency, and high monetary value are generally the most
valuable customers, while customers with high recency values and low
purchase frequency may require re-engagement strategies.

These RFM metrics form the foundation for assigning customer scores and
performing advanced customer segmentation in the subsequent stages of
the analysis.

Business Recommendation

- Use Recency to identify inactive customers who may benefit from
  re-engagement campaigns.
- Reward customers with high purchase frequency through loyalty programs
  and exclusive incentives.
- Prioritize customers with high monetary value using personalized
  promotions and premium customer experiences.
- Combine Recency, Frequency, and Monetary metrics to create meaningful
  customer segments that support targeted marketing and customer
  retention strategies.

===============================================================================
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
How can customers be scored based on their Recency, Frequency, and
Monetary (RFM) metrics?

Business Objective:
Assign Recency, Frequency, and Monetary (RFM) scores to each customer
using quintile-based ranking. These standardized scores enable the
business to compare customer value consistently and serve as the
foundation for advanced customer segmentation and targeted marketing
strategies.

===============================================================================
*/

WITH rfm_metrics AS (
    SELECT
        user_id,
        DATEDIFF(
            (SELECT MAX(date) FROM ecommerce),
            MAX(date)
        ) AS recency,
        COUNT(*) AS frequency,
        SUM(price) AS monetary
    FROM ecommerce
    WHERE event_type = 'purchase'
    GROUP BY user_id
)

SELECT
    user_id,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency) AS f_score,
    NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM rfm_metrics;

-- Result:
--
-- +-----------+----------+-----------+----------+---------+---------+---------+
-- | user_id   | recency  | frequency | monetary | r_score | f_score | m_score |
-- +-----------+----------+-----------+----------+---------+---------+---------+
-- | 565265346 | 2        | 2         | 11.38    | 5       | 1       | 1       |
-- | 367426338 | 0        | 5         | 43.44    | 5       | 3       | 4       |
-- | 543632944 | 0        | 21        | 55.13    | 5       | 5       | 4       |
-- | 402022792 | 0        | 49        | 187.15   | 5       | 5       | 5       |
-- | 537236049 | 0        | 74        | 435.92   | 5       | 5       | 5       |
-- | ...       | ...      | ...       | ...      | ...     | ...     | ...     |
-- +-----------+----------+-----------+----------+---------+---------+---------+
--
-- The complete result assigns an RFM score (1–5) to every purchasing
-- customer based on their Recency, Frequency, and Monetary metrics.
-- Sample values shown above are taken from the generated output. :contentReference[oaicite:0]{index=0}

/*
Business Interpretation

The RFM scoring process converts raw customer purchase metrics into
standardized scores ranging from 1 to 5, making it easier to compare
customers based on their purchasing behavior.

Customers with an RFM score of 5 have purchased recently, buy more
frequently, or spend more money compared to other customers, while a
score of 1 indicates relatively lower engagement for that metric.

Using quintile-based ranking ensures that the scoring is data-driven,
with customers evenly distributed across five groups for each metric.
This approach eliminates the need for arbitrary threshold values and
provides a consistent framework for evaluating customer behavior.

These standardized RFM scores form the basis for identifying valuable
customer segments such as Champions, Loyal Customers, Potential Loyalists,
At Risk, and Lost Customers.

Business Recommendation

- Prioritize customers with high RFM scores through personalized offers,
  loyalty programs, and premium customer experiences.
- Monitor customers with declining Recency scores and implement
  re-engagement campaigns before they become inactive.
- Use Frequency and Monetary scores to identify opportunities for
  cross-selling, upselling, and customer lifetime value optimization.
- Leverage the combined RFM scores to create actionable customer
  segments that support targeted marketing and retention strategies.

===============================================================================
*/

/*
===============================================================================
Business Question 3
===============================================================================

Question:
How can customers be segmented based on their RFM scores?

Business Objective:
Classify customers into meaningful business segments using their
Recency, Frequency, and Monetary (RFM) scores. Customer segmentation
helps the business identify its most valuable customers, recognize
loyal customers, detect customers at risk of churn, and develop
targeted marketing strategies for each customer segment.

===============================================================================
*/

WITH rfm_metrics AS (
    SELECT
        user_id,
        DATEDIFF(
            (SELECT MAX(date) FROM ecommerce),
            MAX(date)
        ) AS recency,
        COUNT(*) AS frequency,
        SUM(price) AS monetary
    FROM ecommerce
    WHERE event_type = 'purchase'
    GROUP BY user_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm_metrics
)

SELECT
    user_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
            THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2
            THEN 'Potential Loyalists'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2
            THEN 'Hibernating'
        ELSE 'Need Attention'
    END AS customer_segment
FROM rfm_scores;

-- Result:
--
-- +-----------+----------+-----------+----------+---------+---------+---------+----------------------+
-- | user_id   | recency  | frequency | monetary | r_score | f_score | m_score | customer_segment     |
-- +-----------+----------+-----------+----------+---------+---------+---------+----------------------+
-- | 565265346 | 2        | 2         | 11.38    | 5       | 1       | 1       | Potential Loyalists  |
-- | 367426338 | 0        | 5         | 43.44    | 5       | 3       | 4       | Loyal Customers      |
-- | 543632944 | 0        | 21        | 55.13    | 5       | 5       | 4       | Champions            |
-- | 402022792 | 0        | 49        | 187.15   | 5       | 5       | 5       | Champions            |
-- | 537236049 | 0        | 74        | 435.92   | 5       | 5       | 5       | Champions            |
-- | ...       | ...      | ...       | ...      | ...     | ...     | ...     | ...                  |
-- +-----------+----------+-----------+----------+---------+---------+---------+----------------------+
--
-- The complete result classifies every purchasing customer into an
-- RFM segment based on their Recency, Frequency, and Monetary scores.
-- Sample rows shown above are taken from the generated output. :contentReference[oaicite:0]{index=0}

/*
Business Interpretation

RFM segmentation groups customers based on their purchasing behavior,
allowing the business to understand the value and engagement level of
each customer.

Customers classified as Champions represent the most valuable segment,
having purchased recently, purchased frequently, and spent the most.
Loyal Customers consistently engage with the platform and contribute
significantly to revenue. Potential Loyalists have made recent purchases
but require additional engagement to become long-term loyal customers.

Customers categorized as At Risk or Hibernating show signs of declining
engagement and may require targeted retention efforts before they become
inactive. The Need Attention segment represents customers whose behavior
falls between these major groups and may benefit from personalized
marketing strategies.

Business Recommendation

- Reward Champions with exclusive offers, early product access, and VIP
  loyalty programs to maximize customer lifetime value.
- Strengthen relationships with Loyal Customers through personalized
  recommendations and retention campaigns.
- Nurture Potential Loyalists using targeted promotions and follow-up
  communications to encourage repeat purchases.
- Re-engage At Risk and Hibernating customers with win-back campaigns,
  personalized discounts, and reminder emails.
- Continuously monitor customer movement between segments to evaluate
  the effectiveness of retention and marketing initiatives.

===============================================================================
*/

/*
===============================================================================
Business Question 4
===============================================================================

Question:
What is the distribution of customers across different RFM segments?

Business Objective:
Summarize the number and percentage of customers in each RFM segment.
Understanding the distribution of customer segments helps the business
prioritize marketing strategies, allocate retention resources, and
identify opportunities to increase customer lifetime value.

===============================================================================
*/

WITH rfm_metrics AS (
    SELECT
        user_id,
        DATEDIFF(
            (SELECT MAX(date) FROM ecommerce),
            MAX(date)
        ) AS recency,
        COUNT(*) AS frequency,
        SUM(price) AS monetary
    FROM ecommerce
    WHERE event_type = 'purchase'
    GROUP BY user_id
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency) AS f_score,
        NTILE(5) OVER (ORDER BY monetary) AS m_score
    FROM rfm_metrics
),
customer_segments AS (
    SELECT
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'Champions'
            WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3
                THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score <= 2
                THEN 'Potential Loyalists'
            WHEN r_score <= 2 AND f_score >= 3
                THEN 'At Risk'
            WHEN r_score <= 2 AND f_score <= 2
                THEN 'Hibernating'
            ELSE 'Need Attention'
        END AS customer_segment
    FROM rfm_scores
)

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Result:
--
-- +----------------------+----------------+------------+
-- | Customer Segment     | Customer Count | Percentage |
-- +----------------------+----------------+------------+
-- | At Risk              | 5,950          | 23.10%     |
-- | Loyal Customers      | 4,393          | 17.05%     |
-- | Hibernating          | 4,356          | 16.91%     |
-- | Potential Loyalists  | 3,859          | 14.98%     |
-- | Need Attention       | 3,854          | 14.96%     |
-- | Champions            | 3,350          | 13.00%     |
-- +----------------------+----------------+------------+

/*
Business Interpretation

The RFM segmentation reveals a diverse customer base with varying levels
of engagement and purchasing behavior.

The largest segment consists of At Risk customers (23.10%), indicating
that a significant proportion of customers have purchased frequently in
the past but have not made a recent purchase. This presents a major
opportunity for customer retention initiatives.

Loyal Customers account for 17.05% of the customer base, demonstrating
consistent purchasing behavior and strong engagement with the platform.
These customers represent a stable source of recurring revenue.

Hibernating customers (16.91%) show low recent activity and low purchase
frequency, suggesting that many customers have become inactive over time.
Potential Loyalists (14.98%) have recently engaged with the platform but
require additional nurturing to become long-term loyal customers.

Champions represent 13.00% of customers and form the highest-value
segment, characterized by recent purchases, high purchase frequency, and
strong spending behavior. Retaining this segment is essential for
maximizing customer lifetime value.

Business Recommendation

- Prioritize win-back campaigns for At Risk customers using personalized
  offers, reminder emails, and targeted discounts before they churn.
- Continue rewarding Champions and Loyal Customers through VIP programs,
  exclusive promotions, and personalized recommendations to strengthen
  long-term loyalty.
- Nurture Potential Loyalists with follow-up campaigns and cross-selling
  opportunities to encourage more frequent purchases.
- Re-engage Hibernating customers through seasonal promotions and
  personalized marketing campaigns designed to reactivate inactive users.
- Regularly monitor the distribution of RFM segments to evaluate the
  effectiveness of retention and customer engagement strategies.

===============================================================================
*/

/*
===============================================================================
Conclusion
===============================================================================

The RFM Analysis provides a comprehensive understanding of customer
behavior by evaluating how recently customers purchased, how frequently
they purchase, and how much they spend. Compared with basic customer
segmentation, RFM offers a more data-driven approach for identifying
high-value customers and prioritizing business actions.

Key findings from the analysis include:

- The customer base is distributed across six meaningful RFM segments,
  each representing different purchasing behaviors and engagement
  levels.
- At Risk customers represent the largest segment (23.10%), indicating
  a significant opportunity for customer retention and win-back
  campaigns.
- Loyal Customers account for 17.05% of the customer base, providing a
  stable source of recurring revenue.
- Champions represent 13.00% of customers and are the business's most
  valuable customers due to their recent purchases, high purchase
  frequency, and strong spending behavior.
- Potential Loyalists and Need Attention segments present opportunities
  to increase customer engagement through personalized marketing and
  targeted promotions.
- Hibernating customers require re-engagement strategies to reduce
  long-term customer inactivity.

Overall, the RFM Analysis enables the business to move beyond general
customer reporting by creating actionable customer segments that support
personalized marketing, customer retention, and customer lifetime value
optimization.

===============================================================================
*/