/*
TRIGGER 1 : LOG DELETED RECIPES
- Purpose: Keep a log of deleted recipes for audit purposes.
- Problem Statement: If a recipe is deleted, we lose all trace of it.
- With Trigger:
*/

CREATE TABLE DeletedRecipesLog (
    recipe_id INT,
    recipe_name VARCHAR,
    deleted_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION log_deleted_recipe()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO DeletedRecipesLog (recipe_id, recipe_name)
    VALUES (OLD.recipe_id, OLD.recipe_name);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_deleted_recipe
AFTER DELETE ON Recipe
FOR EACH ROW
EXECUTE FUNCTION log_deleted_recipe();


------------------------- #2# -------------------------

/*
Prevent Duplicate Likes
- Purpose: Prevent users from liking the same recipe more than once.
- Problem Statement: Even though there's a UNIQUE constraint, we want to give a custom error message.
- With Trigger:
*/

CREATE OR REPLACE FUNCTION prevent_duplicate_likes()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM UserLikedRecipeMappings
        WHERE user_ref_id = NEW.user_ref_id AND recipe_ref_id = NEW.recipe_ref_id
    ) THEN
        RAISE EXCEPTION 'User has already liked this recipe.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_duplicate_likes
BEFORE INSERT ON UserLikedRecipeMappings
FOR EACH ROW
EXECUTE FUNCTION prevent_duplicate_likes();



