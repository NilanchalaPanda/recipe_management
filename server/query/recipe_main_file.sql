-- To generate uuid:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- QUANTITY FORMAT TABLE: (1, 'gms', 'grams'), (1, 'units', 'units');
-- In the QuantityFormat table, the unit that is used to define about the ingredient used is stored.
-- TODO: Further I have add different countries unit as well. Like pounds, etc.
CREATE TABLE IF NOT EXISTS QuantityFormat (
	quantity_id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	value VARCHAR(10),
	name VARCHAR(10)
);

-- ENUM TYPE FOR RECIPE TYPES
CREATE TYPE RecipeType AS ENUM (
	'Veg',
	'Non-Veg',
	'Italian',
	'Chinese'
);

-- RECIPE TABLE : (uuid, 'Palak Paneer', '2020-11-02', 'Veg', cook_uuid)
-- This table is used to store all the Recipes listed or already seeded into the Database by the Admin.
CREATE TABLE IF NOT EXISTS Recipe (
	-- PRIMARY COLUMNS
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	recipe_name VARCHAR(50),
	created_date DATE DEFAULT NOW(),
	recipeType RecipeType, 
	
	-- RELATIONS
	cook_id UUID,
	FOREIGN KEY (cook_id) REFERENCES Cook(id)
);

-- INGREDIENTS TABLE : (uuid, 'onion', 'etc, etc, etc.', 'etc, etc, etc.')
-- This is an already PRE-FILLED dataset of ingredients that the cook will choose from while adding a recipe.
-- TODO 1: Further I have to add different categories in these Ingredients as well - like general, veg, non-veg, etc. 
-- TODO 2: Composition and allergies should have different table, with a MAPPINGS TABLE OF THEM WITH INGREDIENTS.
CREATE TABLE Ingredients (
	-- PRIMARY COLUMNS
	ingredient_id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	name VARCHAR(200),
	
	-- composition VARCHAR(500),
	-- allergies VARCHAR(300),
);


-- COOK TABLE : (uuid, 'Neelam', 'Gandhi', 23, '987654321', 'I am good')
-- This is a simple Cook profile and it is to add different recipes into the application.
CREATE TABLE Cook (
	-- PRIMARY COLUMNS
	id UUID PRIMARY KEY uuid_generate_v1(),
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	age INT,
	phone_number text,-- Can be VARCHAR 16 / INT --> 1 GB [] - @@Revisit
	bio VARCHAR(100),
);

-- STEPS TO COOK : (UUID, 'Saute the onions until golden brown')
CREATE TABLE StepsToCook (
	-- PRIMARY COLUMNS:
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	title VARCHAR(50),
	description TEXT, --@
);

-- USERS: (uuid, 'Sahil Cooks')
-- This is basically a SIMPLE USER, that will just come to the platform and VIEW the reciepes, FAV it if they like.
-- NOT YET COMPLETED. WORK IN PROGRESS!
CREATE TABLE Users (
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	fullname VARCHAR(50),
	firstname  VARCHAR(50), -- Revisit
	lastname  VARCHAR(50)
);

-- UserLikedRecipeMappings : (uuid, user_uuid, recipe_uuid).
-- This is basically to map the recipes liked by the user, it stores the USER_UUID and the RECIPE_UUID.
CREATE TABLE UserLikedRecipeMappings (
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	-- RELATIONS
	user_id UUID,
	recipe_id UUID,
	FOREIGN KEY (user_id) REFERENCES Users(id),
	FOREIGN KEY (recipe_id) REFERENCES Recipe(id),

	UNIQUE (user_id, recipe_id)
);

-- RATINGVALUE ENUM:5 
CREATE TYPE RatingValue AS ENUM ('1', '2', '3', '4', '5');

-- USER RATING TABLE : (uuid, 5, recipe_uuid, user_uuid)
-- This table is to capture the RATING of the USERS for any recipe that they come across.
CREATE TABLE UserRatingRecipe (
	-- PRIMARY COLUMNS
	id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	rating_value RatingValue NOT NULL,

	-- RELATIONS
	recipe_id UUID,
	user_id UUID,
	FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
	FOREIGN KEY (user_id) REFERENCES Users(id)

	-- Optional: Prevent duplicate ratings by same user for same recipe
    UNIQUE (recipe_id, user_id)
);


------------------------------------ QUESTIONS ------------------------------------
/*
	1. Which table would be TRANSACTIONS in here?
	2. How to implement VIEWS in the above basic table structure?
*/
