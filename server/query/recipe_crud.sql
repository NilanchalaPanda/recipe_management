
-- INSERTING THE COUNTRY DATA INTO THE DB
INSERT INTO Country (name, code) VALUES
('India', 'IN'),
('Italy', 'IT'),
('Mexico', 'MX'),
('Japan', 'JP'),
('France', 'FR');
SELECT * FROM Country;

-- Insert into QuantityFormat
INSERT INTO QuantityFormat (value, name, country_ref_id) VALUES
('g', 'grams', 1),
('pcs', 'pieces', 1),
('oz', 'ounces', 2),
('l', 'liters', 3),
('kg', 'kilograms', 4),
('tsp', 'teaspoons', 5),
('lbounds', 'lbounds', 2);
-- SELECT * FROM QuantityFormat;

-- Insert into RecipeCategory
INSERT INTO RecipeCategory (name) VALUES
('Breakfast'),
('Lunch'),
('Dinner'),
('Dessert'),
('Snacks');
-- SELECT * FROM RecipeCategory;

-- Inserting the data for COOK
INSERT INTO Cook (first_name, last_name, age, phone_number, bio) VALUES
('Iliyas', 'Shah', 21, '+91-9876543210', 'Specializes in Mughlai cuisine with 5 years of experience.'),
('Rajchandra', 'Rajput', 30, '+39-3456789012', 'Expert in Italian street food and pasta dishes.'),
('Vivek', 'Yadav', 20, '+52-1234567890', 'Young and passionate about Mexican fusion cooking.'),
('Vijay', 'Rust', 35, '+81-8765432109', 'Japanese culinary artist with a flair for sushi and ramen.'),
('Sarth', 'Shetty', 30, '+33-6543210987', 'French-trained chef with a love for pastries and desserts.');
-- SELECT * FROM Cook;

-- INSERTING SOME SEED RECIPES INTO THE DB
INSERT INTO Recipe (recipe_id, recipe_name, cook_red_id, category_ref_id) VALUES
(1, 'Masala Dosa', 1, 1),
(2, 'Spaghetti Carbonara', 2, 2),
(3, 'Tacos', 3, 3),
(4, 'Sushi', 4, 3),
(5, 'Crepes', 5, 4);
-- SELECT * FROM Recipe;

-- Insert into Ingredients
INSERT INTO Ingredients (name) VALUES
('Onions'),
('Tomatoes'),
('Garlic'),
('Rice'),
('Eggs'),
('Chicken'),
('Seaweed'),
('Flour');
-- SELECT * FROM Ingredients;

-- Insert into Composition
INSERT INTO Composition (name) VALUES
('Fried Rice'),
('Tomato Omelette'),
('Garlic Chicken'),
('Veg Pulao'),
('Boiled Eggs');
SELECT * FROM Composition;

INSERT INTO IngredientCompositionMapping (ingredient_ref_id, composition_ref_id) VALUES
(1, 1),  -- Onions in Fried Rice
(2, 2),  -- Tomatoes in Tomato Omelette
(3, 3),  -- Garlic in Garlic Chicken
(4, 4),  -- Rice in Veg Pulao
(5, 5);  -- Eggs in Boiled Eggs
SELECT * FROM IngredientCompositionMapping;

-- Insert into Allergy
INSERT INTO Allergy (name) VALUES
('Gluten'),
('Egg'),
('Seafood'),
('Dairy'),
('Nuts');
SELECT * FROM Allergy;

-- INSERTING INTO THE MAPPING TABLE
INSERT INTO IngredientsAllergyMapping (ingredient_ref_id, allergy_ref_id) VALUES
(5, 1),  -- Eggs → Gluten
(2, 2),  -- Tomatoes → Egg
(4, 3),  -- Rice → Seafood
(1, 1),  -- Onions → Gluten
(3, 4);  -- Garlic → Dairy
SELECT * FROM IngredientsAllergyMapping


-- Fried Rice (recipe_id = 1)
INSERT INTO StepsToCook (step_number, title, description, recipe_ref_id) VALUES
(1, 'Soak Rice', 'Soak rice in water for at least 30 minutes.', 1),
(2, 'Cook Rice', 'Boil the soaked rice until it is 90% cooked.', 1),
(3, 'Stir-Fry Vegetables', 'Sauté onions, garlic, and vegetables in oil.', 1),
(4, 'Mix and Fry', 'Add cooked rice and soy sauce, stir-fry for 5 minutes.', 1);

-- Tomato Omelette (recipe_id = 2)
INSERT INTO StepsToCook (step_number, title, description, recipe_ref_id) VALUES
(1, 'Prepare Batter', 'Mix chopped tomatoes, onions, and spices with gram flour.', 2),
(2, 'Heat Pan', 'Grease a pan and heat it on medium flame.', 2),
(3, 'Cook Omelette', 'Pour batter and cook on both sides until golden brown.', 2);

-- Garlic Chicken (recipe_id = 3)
INSERT INTO StepsToCook (step_number, title, description, recipe_ref_id) VALUES
(1, 'Marinate Chicken', 'Marinate chicken with garlic, spices, and yogurt.', 3),
(2, 'Sear Chicken', 'Sear marinated chicken in a hot pan.', 3),
(3, 'Simmer', 'Add water and simmer until chicken is cooked through.', 3),
(4, 'Garnish', 'Garnish with coriander and serve hot.', 3);

-- Veg Pulao (recipe_id = 4)
INSERT INTO StepsToCook (step_number, title, description, recipe_ref_id) VALUES
(1, 'Sauté Spices', 'Heat oil and sauté whole spices.', 4),
(2, 'Add Vegetables', 'Add chopped vegetables and cook for 5 minutes.', 4),
(3, 'Add Rice and Water', 'Add soaked rice and water, bring to a boil.', 4),
(4, 'Cook Covered', 'Cover and cook on low heat until rice is done.', 4);

-- Boiled Eggs (recipe_id = 5)
INSERT INTO StepsToCook (step_number, title, description, recipe_ref_id) VALUES
(1, 'Boil Water', 'Bring a pot of water to a rolling boil.', 5),
(2, 'Add Eggs', 'Gently place eggs into the boiling water.', 5),
(3, 'Cook Eggs', 'Boil for 8–10 minutes depending on desired doneness.', 5),
(4, 'Cool and Peel', 'Transfer to cold water, let cool, then peel.', 5);

-- SELECT * FROM StepsToCook;

-- INSERT SOME DUMMY USERS INTO THE DB
INSERT INTO Users (user_id, first_name, last_name) VALUES
(1, 'Anjali', 'Sharma'),
(2, 'Ravi', 'Kumar'),
(3, 'Sneha', 'Patel'),
(4, 'Amit', 'Verma'),
(5, 'Priya', 'Singh');
-- SELECT * FROM Users;

-- INSERTING THE Recipes LIKED by Users MAPPING TABLE
INSERT INTO UserLikedRecipeMappings (user_ref_id, recipe_ref_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 3),
(4, 4),
(4, 1),
(5, 5);
-- SELECT * FROM UserLikedRecipeMappings;

-- Insert into RatingValue
INSERT INTO RatingValue (value) VALUES
(1),
(2),
(3),
(4),
(5);
-- SELECT * FROM RatingValue;


-- RATING THE RECIPES BY USERS
INSERT INTO UserRatingRecipeMappings (user_ref_id, recipe_ref_id, ratingValue_ref_id) VALUES
(1, 1, 5),
(2, 2, 4),
(3, 3, 3),
(4, 4, 5),
(5, 5, 4);
-- SELECT * FROM UserRatingRecipeMappings;

-- Insert into Tags
INSERT INTO Tags (tag_name) VALUES
('Spicy'),
('Vegetarian'),
('Quick'),
('Healthy'),
('Traditional');
-- SELECT * FROM Tags;

-- INSERTING INTO TEH RECIPE AND TAGS MAPPING TABLE 
INSERT INTO RecipeTagsMappings (recipe_ref_id, tag_ref_id) VALUES
(1, 1),  -- Fried Rice → e.g., "Asian"
(2, 3),  -- Tomato Omelette → e.g., "Vegetarian"
(3, 4),  -- Garlic Chicken → e.g., "Spicy"
(4, 5),  -- Veg Pulao → e.g., "Rice Dish"
(5, 2);  -- Boiled Eggs → e.g., "Protein"
-- SELECT * FROM RecipeTagsMappings;