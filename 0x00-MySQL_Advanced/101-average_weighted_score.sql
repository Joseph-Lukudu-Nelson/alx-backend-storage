-- A SQL that creates a stored procedure called ComputeAverageWeightedScoreForUsers that computes and stores the average weighted score for all students.

-- Delimiter to change the default delimiter from semicolon to //
DELIMITER //

-- Create the stored procedure
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE user_id INT;
    DECLARE total_score DECIMAL(10, 2);
    DECLARE total_weight DECIMAL(10, 2);
    DECLARE average_score DECIMAL(10, 2);
    
    -- Cursor declaration
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @finished = 1;
    
    -- Open the cursor
    OPEN cur;
    
    -- Initialize the variables
    SET total_score = 0;
    SET total_weight = 0;
    
    -- Loop through the users
    users_loop: LOOP
        -- Fetch the next user_id
        FETCH cur INTO user_id;
        
        -- Check if there are no more rows to process
        IF @finished = 1 THEN
            LEAVE users_loop;
        END IF;
        
        -- Calculate the total weighted score for the current user_id
        SELECT SUM(score * weight) INTO total_score
        FROM scores
        WHERE user_id = user_id;
        
        -- Calculate the total weight for the current user_id
        SELECT SUM(weight) INTO total_weight
        FROM scores
        WHERE user_id = user_id;
        
        -- Calculate the average weighted score
        IF total_weight > 0 THEN
            SET average_score = total_score / total_weight;
        ELSE
            SET average_score = 0;
        END IF;
        
        -- Insert or update the average weighted score in the users_average_scores table
        INSERT INTO users_average_scores (user_id, average_weighted_score)
        VALUES (user_id, average_score)
        ON DUPLICATE KEY UPDATE average_weighted_score = average_score;
        
        -- Reset the variables for the next iteration
        SET total_score = 0;
        SET total_weight = 0;
    END LOOP;
    
    -- Close the cursor
    CLOSE cur;
    
    -- Output a message indicating the completion of the procedure
    SELECT 'Average weighted scores computed and stored for all users.';
END //

-- Reset the delimiter to semicolon
DELIMITER ;
