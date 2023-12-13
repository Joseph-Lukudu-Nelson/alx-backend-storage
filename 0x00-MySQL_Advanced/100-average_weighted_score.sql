-- A SQL Script that creates a stored procedure called ComputeAverageWeightedScoreForUser that computes and stores the average weighted score for a student.

-- Delimiter to change the default delimiter from semicolon to //
DELIMITER //

-- Create the stored procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_score DECIMAL(10, 2);
    DECLARE total_weight DECIMAL(10, 2);
    DECLARE average_score DECIMAL(10, 2);
    
    -- Calculate the total weighted score
    SELECT SUM(score * weight) INTO total_score
    FROM scores
    WHERE user_id = user_id;
    
    -- Calculate the total weight
    SELECT SUM(weight) INTO total_weight
    FROM scores
    WHERE user_id = user_id;
    
    -- Calculate the average weighted score
    IF total_weight > 0 THEN
        SET average_score = total_score / total_weight;
    ELSE
        SET average_score = 0;
    END IF;
    
    -- Insert or update the average weighted score in the users table
    INSERT INTO users_average_scores (user_id, average_weighted_score)
    VALUES (user_id, average_score)
    ON DUPLICATE KEY UPDATE average_weighted_score = average_score;
    
    -- Output the computed average weighted score
    SELECT average_score AS 'Average Weighted Score';
END //

-- Reset the delimiter to semicolon
DELIMITER ;
