-- To generate uuid:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Creating a QuantityFormat Table: (1, 'gms', 'grams'), (1, 'units', 'units');
CREATE TABLE IF NOT EXISTS QuantityFormat (
	quantity_id UUID PRIMARY KEY DEFAULT uuid_generate_v1(),
	value VARCHAR(10),
	name VARCHAR(10)
);

CREATE TYPE RecipeType AS ENUM (
	'Veg',
	'Non-Veg',
	'Italian',
	'Chinese'
);

-- Recipe Table 
CREATE TABLE IF NOT EXISTS Recipe (
	-- PRIMARY COLUMNS
	recipe_id UUID PRIMARY KEY uuid_generate_v1(),
	recipe_name VARCHAR(50),
	created_date DATE DEFAULT NOW()
	recipeType RecipeType, 
	
	-- RELATIONS
	cook_id UUID,
	FOREIGN KEY (cook_id) REFERENCES Cook(id)
)

CREATE TABLE Ingredients (
	-- PRIMARY COLUMNS
	ingredient_id UUID PRIMARY KEY uuid_generate_v1(),
	
)

CREATE TABLE Cook (
	-- PRIMARY COLUMNS
	id UUID PRIMARY KEY uuid_generate_v1(),
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	age INT,
	phone_number text,
	bio VARCHAR(100),

	-- RELATIONS
)












