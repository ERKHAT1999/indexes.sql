CREATE DATABASE UserAnalytics;
GO

USE UserAnalytics;
GO
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    registration_date DATE NOT NULL
);
CREATE TABLE events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    event_date DATE NOT NULL,
    event_type NVARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
INSERT INTO users (registration_date) VALUES
('2024-01-01'),
('2024-01-10'),
('2024-02-05'),
('2024-02-20'),
('2024-03-01'),
('2024-03-15');
INSERT INTO events (user_id, event_date, event_type) VALUES
(1, '2024-01-01', 'login'),
(1, '2024-02-01', 'login'),
(1, '2024-03-01', 'login'),

(2, '2024-01-10', 'login'),
(2, '2024-01-20', 'login'),

(3, '2024-02-05', 'login'),
(3, '2024-03-05', 'login'),

(4, '2024-02-20', 'login'),

(5, '2024-03-01', 'login'),
(5, '2024-03-10', 'login'),

(6, '2024-03-15', 'login');
SELECT
    FORMAT(event_date, 'yyyy-MM') AS month,
    COUNT(DISTINCT user_id) AS active_users
FROM events
GROUP BY FORMAT(event_date, 'yyyy-MM')
ORDER BY month;

SELECT
    user_id,
    FORMAT(MIN(event_date), 'yyyy-MM') AS cohort_month
FROM events
GROUP BY user_id;

WITH first_activity AS (
    SELECT
        user_id,
        MIN(event_date) AS first_date
    FROM events
    GROUP BY user_id
),
activity_months AS (
    SELECT
        e.user_id,
        DATEDIFF(MONTH, f.first_date, e.event_date) AS month_number
    FROM events e
    JOIN first_activity f ON e.user_id = f.user_id
)
SELECT
    month_number,
    COUNT(DISTINCT user_id) AS retained_users
FROM activity_months
GROUP BY month_number
ORDER BY month_number;

WITH last_activity AS (
    SELECT
        user_id,
        MAX(event_date) AS last_date
    FROM events
    GROUP BY user_id
)
SELECT
    user_id
FROM last_activity
WHERE DATEDIFF(MONTH, last_date, GETDATE()) >= 2;

SELECT
    user_id,
    event_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date) AS visit_number
FROM events;

