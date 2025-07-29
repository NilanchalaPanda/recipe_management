# 🍳 Advanced Recipe Management Database Schema [(PPT Link)](https://www.canva.com/design/DAGueUDk5TQ/TrDUEdv2IZiqcUwB2YAVNQ/edit?utm_content=DAGueUDk5TQ&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

Welcome to the **Recipe Management System**, a fully normalized, scalable, and extensible PostgreSQL database schema designed to manage recipes, cooks, ingredients, allergies, user interactions, and more — all while utilizing **advanced SQL features**.

---

## 📘 Overview

This schema simulates a real-world recipe platform and supports features such as:

- 🧑‍🍳 Multiple cooks & recipes
- 🥘 Recipe steps and media
- 🏷️ Tags, ratings, and user interactions
- ⚠️ Ingredient compositions & allergy details
- 📐 Quantity formats per country

---

## ⚙️ Topcis Covered in **PostgreSQL** 14+
- **UUIDs** for primary keys
- Usage of **Materialized Views**
- How to use **Storoed Procedures**
- **Triggers** for automatic `updated_at`
- **CRUD Operations** via SQL functions

---

## 🧱 Schema Snapshot

The schema is modular and consists of:

| Category           | Tables                                                                 |
|--------------------|------------------------------------------------------------------------|
| Core Entities       | `Recipe`, `Cook`, `Users`, `Ingredients`, `StepsToCook`, `Media`       |
| Metadata            | `Country`, `QuantityFormat`, `RecipeCategory`, `Tags`, `RatingValue`   |
| Mappings            | `UserLikedRecipeMappings`, `UserRatingRecipe`, `RecipeTags`            |
| Advanced Relations  | `IngredientAllergy`, `IngredientComposition`                            |
| Enhancements        | Materialized Views, Triggers, Procedures, Functions                     |

---

## ✨ Advanced Features Highlight

### 🔁 Trigger-Based `updated_at`
All tables with an `updated_at` column automatically update this timestamp on row modification using a reusable PL/pgSQL trigger.

### 📊 Materialized View
Efficiently fetch the **average rating per recipe** using the `RecipeAverageRatings` materialized view.

```sql
REFRESH MATERIALIZED VIEW RecipeAverageRatings;
```

### 📦 Stored Procedure
Add new recipes with cooking steps using a single stored procedure call:

```sql
CALL AddRecipeWithSteps('Pasta', 'category-uuid', 'cook-uuid', ARRAY['Boil water'], ARRAY['Bring water to boil']);
```

### 🧾 CRUD Functions
All core operations for Recipe are abstracted into PostgreSQL functions for clean backend integrations.


##### 📌 Author - [Nilanchal Panda](https://www.linkedin.com/in/nilanchal-panda/)
