/*
STORED PROCEDURE 1: Add a New Recipe with Ingredients

1. PURPOSE: To encapsulate the logic of inserting a new recipe along with its ingredients in a single transaction.
2. USE CASE: When a user submits a new recipe, we want to ensure both the recipe and its ingredients are inserted together.
3. WITHOUT STORED PROCEDURE: Developers would need to write multiple insert statements manually, increasing the risk of partial inserts or inconsistent data.
4. HOW TO IDENTIFY: Use stored procedures when multiple related operations need to be executed together reliably.
*/

CREATE OR REPLACE PROCEDURE add_new_recipe_with_ingredients(
    recipe_title TEXT,
    recipe_description TEXT,
    recipe_category_id INT,
    ingredient_list TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_recipe_id INT;
    ingredient_name TEXT;
BEGIN
    -- Insert into recipes table
    INSERT INTO recipes (title, description, category_id)
    VALUES (recipe_title, recipe_description, recipe_category_id)
    RETURNING recipe_id INTO new_recipe_id;

    -- Insert ingredients
    FOREACH ingredient_name IN ARRAY ingredient_list
    LOOP
        INSERT INTO recipe_ingredients (recipe_id, ingredient_name)
        VALUES (new_recipe_id, ingredient_name);
    END LOOP;
END;
$$;


/*
STORED PROCEDURE 2: Archive Old Feedback

1. PURPOSE: Move feedback older than a certain date to an archive table.
2. USE CASE: To keep the main feedback table optimized and lightweight.
3. WITHOUT STORED PROCEDURE: Manual deletion or archiving would be error-prone and inconsistent.
4. HOW TO IDENTIFY: Use stored procedures for scheduled maintenance tasks or data migrations.
*/

CREATE OR REPLACE PROCEDURE archive_old_feedback(cutoff_date DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Move old feedback to archive
    INSERT INTO feedback_archive (feedback_id, user_name, email, message, submitted_at)
    SELECT feedback_id, user_name, email, message, submitted_at
    FROM userfeedback
    WHERE submitted_at < cutoff_date;

    -- Delete from original table
    DELETE FROM userfeedback
    WHERE submitted_at < cutoff_date;
END;
$$;

/*
STORED PROCEDURE 3: Update Recipe Rating

1. PURPOSE: Update the average rating of a recipe based on new user input.
2. USE CASE: When a user submits a new rating, we want to recalculate the average rating.
3. WITHOUT STORED PROCEDURE: The logic would be repeated in multiple places, increasing maintenance overhead.
4. HOW TO IDENTIFY: Use stored procedures when business logic needs to be reused consistently.
*/

CREATE OR REPLACE PROCEDURE update_recipe_rating(
    target_recipe_id INT,
    new_rating INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    total_rating INT;
    rating_count INT;
BEGIN
    -- Insert new rating
    INSERT INTO recipe_ratings (recipe_id, rating)
    VALUES (target_recipe_id, new_rating);

    -- Recalculate average
    SELECT SUM(rating), COUNT(*) INTO total_rating, rating_count
    FROM recipe_ratings
    WHERE recipe_id = target_recipe_id;

    UPDATE recipes
    SET average_rating = total_rating::FLOAT / rating_count
    WHERE recipe_id = target_recipe_id;
END;
$$;
