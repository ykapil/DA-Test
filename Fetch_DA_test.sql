#Fetch DA test 
#Question 1 

SELECT b.brand_name, COUNT(r.receipt_id) as num_receipts
FROM Brands b
JOIN ReceiptsBrands rb ON b.brand_id = rb.brand_id
JOIN Receipts r ON rb.receipt_id = r.receipt_id
WHERE DATE_FORMAT(r.receipt_date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
GROUP BY b.brand_name
ORDER BY num_receipts DESC
LIMIT 5;

#Question 2

SELECT
    current_month.brand_name,
    current_month.num_receipts,
    previous_month.num_receipts as previous_month_num_receipts,
    RANK() OVER (ORDER BY current_month.num_receipts DESC) as current_month_rank,
    RANK() OVER (ORDER BY previous_month.num_receipts DESC) as previous_month_rank
FROM
    (SELECT b.brand_name, COUNT(r.receipt_id) as num_receipts
    FROM Brands b
    JOIN ReceiptsBrands rb ON b.brand_id = rb.brand_id
    JOIN Receipts r ON rb.receipt_id = r.receipt_id
    WHERE DATE_FORMAT(r.receipt_date, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
    GROUP BY b.brand_name) as current_month
LEFT JOIN
    (SELECT b.brand_name, COUNT(r.receipt_id) as num_receipts
    FROM Brands b
    JOIN ReceiptsBrands rb ON b.brand_id = rb.brand_id
    JOIN Receipts r ON rb.receipt_id = r.receipt_id
    WHERE DATE_FORMAT(r.receipt_date, '%Y-%m') = DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m')
    GROUP BY b.brand_name) as previous_month
ON current_month.brand_name = previous_month.brand_name
ORDER BY current_month.num_receipts DESC
LIMIT 5;


#Question 3:

SELECT rewardsReceiptStatus, AVG(total_spent) as avg_spend
FROM Receipts
WHERE rewardsReceiptStatus IN ('Accepted', 'Rejected')
GROUP BY rewardsReceiptStatus;


#Question 4: 

SELECT b.brand_name, SUM(r.total_spent) as total_spend
FROM Brands b
JOIN ReceiptsBrands rb ON b.brand_id = rb.brand_id
JOIN Receipts r ON rb.receipt_id = r.receipt_id
JOIN Users u ON r.user_id = u.user_id
WHERE u.created_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY b.brand_name
ORDER BY total_spend DESC
LIMIT 1;

#Question 5: 

SELECT b.brand_name, COUNT(r.receipt_id) as num_transactions
FROM Brands b
JOIN ReceiptsBrands rb ON b.brand_id = rb.brand_id
JOIN Receipts r ON rb.receipt_id = r.receipt_id
JOIN Users u ON r.user_id = u.user_id
WHERE u.created_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY b.brand_name
ORDER BY num_transactions DESC
LIMIT 1;