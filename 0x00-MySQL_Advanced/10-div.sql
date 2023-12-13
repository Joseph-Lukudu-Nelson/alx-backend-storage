-- A SQL Script that Creates a function called SafeDiv that divides the first number by the second number or returns 0 if the second number is equal to 0.

CREATE FUNCTION SafeDiv(a INT, b INT)
RETURNS FLOAT
BEGIN
    -- Declare a variable to store the result
    DECLARE result FLOAT;
    
    -- Check if the second number is equal to 0
    IF b = 0 THEN
        -- If the second number is 0, set the result to 0
        SET result = 0;
    ELSE
        -- If the second number is not 0, perform the division and assign the result to the variable
        SET result = a / b;
    END IF;
    
    -- Return the value of the result
    RETURN result;
END;
