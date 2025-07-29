-- TO GENERATE UUID:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Country Table for regional units.
-- EG: (uuid, 'India', 'IN')
CREATE TABLE Country
(
	-- country_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	country_id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL,
	code VARCHAR(3) UNIQUE NOT NULL
);

-- QUANTITY FORMAT TABLE
-- EG: (uuid, 'kgs', 'kilograms', country_uuid<IN>, DATE, DATE)
CREATE TABLE QuantityFormat
(
	-- quantity_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	quantity_id SERIAL PRIMARY KEY,
	value VARCHAR(10),
	name VARCHAR(20),
	country_ref_id INT REFERENCES Country(country_id),

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

-- CATEGORIZING THE RECIPES PROPERLY
-- EG: (uuid, 'Italian'), (uuid, 'Chinese')
CREATE TABLE RecipeCategory
(
	-- recipeCategory_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	recipeCategory_id SERIAL PRIMARY KEY,
	name VARCHAR(50) UNIQUE NOT NULL
);

-- THE COOK UPLOADING THE RECIPES, AND SOME DETAILS ABOUT THE SAME.
-- EG: (uuid, 'Shruti', 'Shah', 21, '9876543212', 'Hello', DATE, DATE)
CREATE TABLE Cook
(
	-- cook_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	cook_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	age INT,
	phone_number VARCHAR(16),  --@Revisit
	bio TEXT,

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

-- THE RECIPES UPLOADED INTO THE DATABASE
-- EG: (uuid, 'Aloo Paratha', DATE, category_uuid<DROPDOWN>, cook_uuid, DATE, DATE)
CREATE TABLE Recipe
(
	-- recipe_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	recipe_id SERIAL PRIMARY KEY,
	recipe_name VARCHAR(100),

	created_date DATE DEFAULT NOW(),

	category_ref_id INT REFERENCES RecipeCategory(recipeCategory_id),
	cook_red_id INT REFERENCES Cook(cook_id) ON DELETE SET NULL,

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

-- INGREDIENTS IS ALREADY PRE-FILLED IN THE DB. COOK HAVE TO CHOOSE FROM THE DROPDOWN SHOWN TO HIM/HER.
-- EG: (uuid, 'Onions', DATE, DATE)
CREATE TABLE Ingredients (
	-- ingredient_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	ingredient_id SERIAL PRIMARY KEY,
	name VARCHAR(200) UNIQUE NOT NULL,

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Composition
(
	-- composition_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	composition_id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IngredientCompositionMapping
(
	ingredient_ref_id INT REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE,
	composition_ref_id INT REFERENCES Composition(composition_id) ON DELETE CASCADE,
	PRIMARY KEY (ingredient_ref_id, composition_ref_id)	
);

CREATE TABLE Allergy
(
	-- allergy_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	allergy_id SERIAL PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IngredientsAllergyMapping
(
	ingredient_ref_id INT REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE,
	allergy_ref_id INT REFERENCES Allergy(allergy_id) ON DELETE CASCADE,
	PRIMARY KEY (ingredient_ref_id, allergy_ref_id)	
);

-- THE STEPS TO COOK IS ASSOCIATED WITH THE RECIPES AND MAPPED TOGETHER WITH IT.
-- EG: (uuid, 1, 'Cutting Vegs', 'Onions, Tomatoes are all is to chopped finely')
CREATE TABLE StepsToCook
(
	-- stepsToCook_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	stepsToCook_id SERIAL PRIMARY KEY,
	step_number INT,
	title VARCHAR(100),
	description TEXT,

	recipe_ref_id INT REFERENCES Recipe(recipe_id) ON DELETE CASCADE,

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

-- THESE ARE THE END USERS FOR THE RECIPES.
-- EG: (uuid, 'Jai', 'Shah', DATE, DATE)
CREATE TABLE Users
(
	-- user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	user_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),

	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

-- THIS TABLE IS PURELY FOR MAPPING THE USERS AND THE RECIPES.
-- EG: (user_uuid, recipe_uuid)
CREATE TABLE UserLikedRecipeMappings
(
	user_ref_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
	recipe_ref_id INT REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
	UNIQUE (user_ref_id, recipe_ref_id)
);

-- THIS IS PRE-FILLED AS WELL. 1 TO 5 ONLY.
-- EG: (uuid, 1), (uuid, 2), (uuid, 3), (uuid, 4), (uuid, 5).
CREATE TABLE RatingValue
(
	-- ratingValue_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	ratingValue_id SERIAL PRIMARY KEY,
	value INT CHECK (value BETWEEN 1 AND 5) UNIQUE
);

-- THIS TABLE IS PURELY FOR MAPPING THE USERS AND THE RECIPES.
-- EG: (ratingValue_uuid, recipe_uuid, user_uuid)
CREATE TABLE UserRatingRecipeMappings
(
	ratingValue_ref_id INT REFERENCES RatingValue(ratingValue_id) ON DELETE CASCADE,
	recipe_ref_id INT REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
	user_ref_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
	UNIQUE (recipe_ref_id, user_ref_id)
);

-- TAGS ARE BASICALLY SOME KEYWORDS ASSOCIATED WITH THE RECIPE. THERE CAN SOME PRE-DEFINED, AND SOME USER-DEFINED AS WELL.
-- EG: (uuid, 'Healthy'), (uuid, 'Non-Veg'), (uuid, 'Veg'), etc.
CREATE TABLE Tags
(
	-- tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	tag_id SERIAL PRIMARY KEY,
	tag_name VARCHAR(20) UNIQUE NOT NULL 
);

-- THIS TABLE IS PURELY FOR MAPPING THE RECIPES AND THE TAGS.
-- EG: (user_uuid, tag_uuid)
CREATE TABLE RecipeTagsMappings
(
	recipe_ref_id INT REFERENCES Recipe(recipe_id) ON DELETE CASCADE,
	tag_ref_id INT REFERENCES Tags(tag_id) ON DELETE CASCADE,
	PRIMARY KEY (recipe_ref_id, tag_ref_id)
);

-- MEDIA IS TO BASICALLY STORE THE IMAGES RELATED TO THE RESPECTIVE RECIPES.
-- EG: (uuid, 'iuytfeoweurnvi2uh42y6537645', true, 'Health Veg Salad', recipe_uuid)
CREATE TABLE Media
(
	-- media_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
	media_id SERIAL PRIMARY KEY,
	image_url VARCHAR(100),
	is_thumbnail BOOLEAN,
	description VARCHAR(200),

	reciep_ref_id INT REFERENCES Recipe(recipe_id) ON DELETE CASCADE
);
