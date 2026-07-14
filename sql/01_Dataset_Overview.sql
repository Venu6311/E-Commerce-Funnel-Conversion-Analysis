/*
=========================================================
Project : E-Commerce Funnel Conversion Analysis

File    : 01_Dataset_Overview.sql

Objective:
Understand the dataset before performing exploratory
data analysis and funnel analysis.

Dataset:
October 2019 E-Commerce Events Dataset

Author:
Venu

=========================================================
*/


/*
=========================================================
Business Question 1
How many total events are present in the dataset?
=========================================================
*/

SELECT COUNT(*) AS total_events
FROM ecommerce;
/*
=========================================================
Business Question 1
=========================================================

Question:
How many total customer events were recorded during October 2019?
*/

SELECT COUNT(*) AS total_events
FROM ecommerce;

-- Result: 3,888,534

/*
Business Interpretation

The dataset contains 3,888,534 customer events recorded during October 2019.

Each event represents a customer interaction such as viewing a product,
adding it to the cart, removing it from the cart, or completing a purchase.

This metric represents the overall customer activity on the platform and
serves as the baseline for all subsequent analyses, including customer
behavior, funnel conversion, and root cause analysis.
*/

/*
===============================================================================
Business Question 2
===============================================================================

Question:
How many unique users visited the platform during October 2019?

Business Objective:
Determine the total number of unique customers who interacted with the platform.

===============================================================================
*/

SELECT COUNT(DISTINCT user_id) AS unique_users
FROM ecommerce;

-- Result:
-- 399,634 

/*

/*
Business Interpretation

A total of 399,634 unique customers interacted with the platform during
October 2019.

This metric represents the platform's customer reach and indicates the
number of individual users who performed at least one activity, such as
viewing a product, adding a product to the cart, removing it from the cart,
or completing a purchase.

Understanding the total number of unique users provides the foundation for
analyzing customer engagement, shopping behavior, and conversion rates
throughout the e-commerce funnel.

===============================================================================
*/

===============================================================================
Business Question 3
===============================================================================

Question:
How many unique shopping sessions were created during October 2019?

===============================================================================
*/

SELECT COUNT(DISTINCT user_session) AS unique_sessions
FROM ecommerce;

-- Result:
-- 873,960

/*
Business Interpretation

Customers initiated 873,960 unique shopping sessions during October 2019.

Each session represents an individual shopping journey on the platform,
regardless of whether the customer completed a purchase.

This metric is important because funnel conversion rates are measured at the
session level. It helps evaluate how effectively shopping sessions progress
through different stages of the funnel, from product view to purchase.

===============================================================================
*/

/*
===============================================================================
Business Question 4
===============================================================================

Question:
How many unique products are available on the platform during October 2019?

Business Objective:
Determine the total number of unique products that customers interacted with
during the analysis period. This helps understand the size of the product
catalog and serves as a baseline for product-level performance analysis.

===============================================================================
*/

SELECT COUNT(DISTINCT product_id) AS unique_products
FROM ecommerce;

-- Result:
-- 41,894

/*
Business Interpretation

A total of 41,894 unique products were interacted with by customers during
October 2019.

This metric represents the diversity of products available on the platform
that generated at least one customer interaction, such as a product view,
cart addition, cart removal, or purchase.

Understanding the total number of unique products helps evaluate product
catalog size and forms the foundation for analyzing product popularity,
conversion rates, and overall product performance.

===============================================================================
*/

/*
===============================================================================
Business Question 5
===============================================================================

Question:
What is the distribution of customer events across different event types?

Business Objective:
Understand how customer interactions are distributed across each stage of
the shopping journey. This helps identify the most common customer actions
and provides an overview of user behavior before performing funnel analysis.

===============================================================================
*/

SELECT
    event_type,
    COUNT(*) AS total_events,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM ecommerce),
        2
    ) AS event_percentage
FROM ecommerce
GROUP BY event_type
ORDER BY total_events DESC;

-- Result:
-- +-------------------+--------------+------------------+
-- | Event Type        | Total Events | Event Percentage |
-- +-------------------+--------------+------------------+
-- | view              | 1,862,047    | 47.89%           |
-- | cart              | 1,203,756    | 30.96%           |
-- | remove_from_cart  |   577,470    | 14.85%           |
-- | purchase          |   245,261    |  6.31%           |
-- +-------------------+--------------+------------------+

/*
Business Interpretation

Product views account for the largest share of customer interactions,
representing 47.89% of all recorded events. Cart additions account for
30.96%, followed by cart removals at 14.85%, while purchases represent
only 6.31% of the total customer interactions.

The progressive decline in event counts across successive stages indicates
that a significant proportion of customers do not complete the purchase
journey. This suggests the presence of customer drop-offs as users move
through the shopping funnel.

These findings provide an initial understanding of customer behavior and
serve as the foundation for detailed funnel conversion analysis. In the
next phase of the project, we will quantify conversion rates between each
funnel stage and identify the key factors contributing to customer drop-offs.

===============================================================================
*/

/*
===============================================================================
Business Question 6
===============================================================================

Question:
What is the date range of the dataset?

Business Objective:
Identify the start and end dates of the dataset to understand the analysis
period and verify that all customer events fall within the expected time frame.

===============================================================================
*/

SELECT
    MIN(event_time) AS start_date,
    MAX(event_time) AS end_date
FROM ecommerce;

-- Result:
-- Start Date : 2019-10-01 05:30:00+05:30
-- End Date   : 2019-11-01 05:29:54+05:30

/*
Business Interpretation

The dataset contains customer interaction records from 2019-10-01 05:30:00+05:30 to 2019-11-01 05:29:54+05:30,
covering the complete analysis period of October 2019.

Verifying the date range confirms that all subsequent analyses, including
customer behavior, funnel conversion, and root cause analysis, are performed
within the intended time period. This validation ensures the accuracy and
consistency of business insights derived from the dataset.

===============================================================================
*/