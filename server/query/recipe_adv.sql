
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Country Table for regional units
CREATE TABLE Country (
    country_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Quantity Format Table
CREATE TABLE QuantityFormat (
    quantity_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    value VARCHAR(10),
    name VARCHAR(20),
    unit_type VARCHAR(20),
    country_ref_id UUID REFERENCES Country(country_id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Recipe Category Table (replaces ENUM)
CREATE TABLE RecipeCategory (
    recipecategory_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Cook Table
CREATE TABLE Cook (
    cook_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    phone_number VARCHAR(16),
    bio TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Recipe Table
CREATE TABLE Recipe (
    recipe_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_name VARCHAR(100),
    created_date DATE DEFAULT NOW(),
    category_ref_id UUID REFERENCES RecipeCategory(recipecategory_id),
    cook_ref_id UUID REFERENCES Cook(cook_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Ingredients Table
CREATE TABLE Ingredients (
    ingredient_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Composition Table
CREATE TABLE Composition (
    composition_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Ingredient Composition Mapping
CREATE TABLE IngredientComposition (
    ingredient_ref_id UUID REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE,
    composition_ref_id UUID REFERENCES Composition(composition_id) ON DELETE CASCADE,
    PRIMARY KEY (ingredient_ref_id, composition_ref_id)
);

-- Allergy Table
CREATE TABLE Allergy (
    allergy_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Ingredient Allergy Mapping
CREATE TABLE IngredientAllergy (
    ingredient_ref_id UUID REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE,
    allergy_ref_id UUID REFERENCES Allergy(allergy_id) ON DELETE CASCADE,
    PRIMARY KEY (ingredient_ref_id, allergy_ref_id)
);

-- Steps to Cook Table
CREATE TABLE StepsToCook (
    stepstocook_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_ref_id UUID REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    step_number INT,
    title VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Users Table
CREATE TABLE Users (
    users_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fullname VARCHAR(100),
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- User Liked Recipe Mapping
CREATE TABLE UserLikedRecipeMappings (
    userlikedrecipemappings_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_ref_id UUID REFERENCES Users(users_id) ON DELETE CASCADE,
    recipe_ref_id UUID REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    UNIQUE (user_ref_id, recipe_ref_id)
);

-- Rating Value Table
CREATE TABLE RatingValue (
    ratingvalue_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    value INT CHECK (value BETWEEN 1 AND 5) UNIQUE
);

-- User Rating Recipe Table
CREATE TABLE UserRatingRecipe (
    userratingrecipe_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    rating_value_ref_id UUID REFERENCES RatingValue(ratingvalue_id) ON DELETE SET NULL,
    recipe_ref_id UUID REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    user_ref_id UUID REFERENCES Users(users_id) ON DELETE CASCADE,
    UNIQUE (recipe_ref_id, user_ref_id)
);

-- Tags Table
CREATE TABLE Tags (
    tags_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Recipe Tags Mapping
CREATE TABLE RecipeTags (
    recipe_ref_id UUID REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    tag_ref_id UUID REFERENCES Tags(tags_id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_ref_id, tag_ref_id)
);

-- Media Table
CREATE TABLE Media (
    media_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipe_ref_id UUID REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
    -- step_id UUID REFERENCES StepsToCook(stepstocook_ref_id) ON DELETE CASCADE,
    media_url TEXT,
    media_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_recipe_name ON Recipe(recipe_name);
CREATE INDEX idx_user_id ON Users(users_id);
CREATE INDEX idx_ingredient_name ON Ingredients(name);


-- ============================================
-- 🔧 ENHANCEMENTS
-- ============================================


-- ============================================
-- 🔁 TRIGGER: Automatically update 'updated_at' on row update
-- ============================================
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to tables with updated_at column
DO $$
DECLARE
    tbl TEXT;
BEGIN
    FOR tbl IN SELECT table_name FROM information_schema.columns
               WHERE column_name = 'updated_at'
               AND table_schema = 'public'
    LOOP
        EXECUTE format('
            CREATE TRIGGER trg_update_%I
            BEFORE UPDATE ON %I
            FOR EACH ROW
            EXECUTE FUNCTION update_modified_column();', tbl, tbl);
    END LOOP;
END$$;

-- ============================================
-- 🧮 MATERIALIZED VIEW: Average rating per recipe
-- ============================================
CREATE MATERIALIZED VIEW IF NOT EXISTS RecipeAverageRatings AS
SELECT
    r.recipe_id AS recipe_id,
    r.recipe_name,
    AVG(CAST(rv.value AS FLOAT)) AS average_rating
FROM Recipe r
JOIN UserRatingRecipe urr ON r.recipe_id = urr.recipe_ref_id
JOIN RatingValue rv ON urr.rating_value_ref_id = rv.ratingvalue_id
GROUP BY r.recipe_id, r.recipe_name;

-- Refresh command:
-- REFRESH MATERIALIZED VIEW RecipeAverageRatings;

-- ============================================
-- ⚙️ STORED PROCEDURE: Add a new recipe with steps
-- ============================================
CREATE OR REPLACE PROCEDURE AddRecipeWithSteps(
    IN recipe_name VARCHAR,
    IN category UUID,
    IN cook UUID,
    IN step_titles TEXT[],
    IN step_descriptions TEXT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_recipe_id UUID := uuid_generate_v4();
    i INT;
BEGIN
    INSERT INTO Recipe(id, recipe_name, category_id, cook_id)
    VALUES (new_recipe_id, recipe_name, category, cook);

    FOR i IN 1..array_length(step_titles, 1) LOOP
        INSERT INTO RecipeSteps(id, step_number, title, description, recipe_id)
        VALUES (uuid_generate_v4(), i, step_titles[i], step_descriptions[i], new_recipe_id);
    END LOOP;
END;
$$;

-- ============================================
-- 🧾 CRUD OPERATIONS: Example for Recipe table
-- ============================================

-- CREATE
CREATE OR REPLACE FUNCTION create_recipe(
    r_name VARCHAR,
    cat_id UUID,
    cook_id UUID
) RETURNS UUID AS $$
DECLARE
    new_id UUID := uuid_generate_v4();
BEGIN
    INSERT INTO Recipe(id, recipe_name, category_id, cook_id)
    VALUES (new_id, r_name, cat_id, cook_id);
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;

-- READ
CREATE OR REPLACE FUNCTION get_recipe_by_id(rid UUID)
RETURNS TABLE(id UUID, recipe_name VARCHAR, created_date DATE, category_id UUID, cook_id UUID) AS $$
BEGIN
    RETURN QUERY SELECT id, recipe_name, created_date, category_id, cook_id FROM Recipe WHERE id = rid;
END;
$$ LANGUAGE plpgsql;

-- UPDATE
CREATE OR REPLACE FUNCTION update_recipe_name(rid UUID, new_name VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE Recipe SET recipe_name = new_name WHERE id = rid;
END;
$$ LANGUAGE plpgsql;

-- DELETE
CREATE OR REPLACE FUNCTION delete_recipe(rid UUID)
RETURNS VOID AS $$
BEGIN
    DELETE FROM Recipe WHERE id = rid;
END;
$$ LANGUAGE plpgsql;

