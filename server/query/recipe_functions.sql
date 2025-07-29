/*
Function 1: GET AVERAGE RATING OF A RECIPE
- Purpose: To calculate the average rating of a recipe based on user feedback.
- Problem Statement: Users rate recipes from 1 to 5. We want to display the average rating on the recipe detail page.
- Without Function: You’d have to write a complex JOIN and AVG() query every time in your application logic.
- Why?: There will be frequent LIKES BY VARIOUS USERS across the application, so making this A FUNCTION WOULD BENEFIT TO AVOID repeatative operations.
*/
-- WITH FUNCTIONS
CREATE OR REPLACE FUNCTION get_average_rating(recipe_id_input INT)
RETURNS NUMERIC AS $$
DECLARE
    avg_rating NUMERIC;
BEGIN
    SELECT AVG(rv.value)
    INTO avg_rating
    FROM UserRatingRecipeMappings urrm
    JOIN RatingValue rv ON urrm.ratingValue_ref_id = rv.ratingValue_id
    WHERE urrm.recipe_ref_id = recipe_id_input;

    RETURN COALESCE(avg_rating, 0);
END;
$$ LANGUAGE plpgsql;

------------------------
select get_average_rating(1)
-----------------------


/*
Function 2: Get Recipes by Tag Name
- Purpose: To fetch all recipes associated with a specific tag like "Spicy", "Healthy", etc.
- Problem Statement: Users want to filter recipes by tags.
- Without Function: 
*/

-- WITH FUNCTION:
CREATE OR REPLACE FUNCTION get_recipes_by_tag(tag_input VARCHAR)
RETURNS TABLE(recipe_id INT, recipe_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT r.recipe_id, r.recipe_name
    FROM Recipe r
    JOIN RecipeTagsMappings rtm ON r.recipe_id = rtm.recipe_ref_id
    JOIN Tags t ON rtm.tag_ref_id = t.tag_id
    WHERE t.tag_name = tag_input ; --with no lock
END;
$$ LANGUAGE plpgsql;






