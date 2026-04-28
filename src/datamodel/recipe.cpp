/*
 * Copyright 2025 Martin Hoeher <martin@rpdev.net>
 *
 * This file is part of OpenTodoList.
 *
 * OpenTodoList is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 *
 * OpenTodoList is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenTodoList.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "recipe.h"

#include <QVariant>
#include <utility>

/**
 * @brief Default constructor for RecipeIngredient.
 *
 * Constructs a new RecipeIngredient object with amount initialized to 0.0.
 */
RecipeIngredient::RecipeIngredient() {}

/**
 * @brief Constructs a new RecipeIngredient object.
 *
 * @param amount The quantity of the ingredient
 * @param unit The unit of measurement for the ingredient (e.g., "g", "ml", "cups")
 * @param name The name of the ingredient
 */
RecipeIngredient::RecipeIngredient(double amount, const QString& unit, const QString& name)
    : m_amount(amount), m_unit(unit), m_name(name)
{
}

/**
 * @brief Copy constructor for RecipeIngredient.
 *
 * Creates a new RecipeIngredient by copying the values from another instance.
 *
 * @param other The RecipeIngredient instance to copy from.
 */
RecipeIngredient::RecipeIngredient(const RecipeIngredient& other)
    : m_amount(other.m_amount),
      m_unit(other.m_unit),
      m_name(other.m_name),
      m_isHeading(other.m_isHeading),
      m_additionalProperties(other.m_additionalProperties)
{
}

/**
 * @brief Assignment operator for RecipeIngredient.
 *
 * Assigns the values from another RecipeIngredient object to this one.
 * Performs a member-wise copy of amount, unit and name if the source
 * object is different from this object.
 *
 * @param other The RecipeIngredient object to copy from
 * @return RecipeIngredient& A reference to this object after assignment
 */
RecipeIngredient& RecipeIngredient::operator=(const RecipeIngredient& other)
{
    if (this != &other) {
        m_amount = other.m_amount;
        m_unit = other.m_unit;
        m_name = other.m_name;
        m_isHeading = other.m_isHeading;
        m_additionalProperties = other.m_additionalProperties;
    }
    return *this;
}

/**
 * @brief Move constructor for RecipeIngredient.
 *
 * Creates a new RecipeIngredient by moving the contents of another instance.
 *
 * @param other The RecipeIngredient instance to move from.
 *
 * This constructor moves the unit and name from the source object and copies the amount.
 * After the move, the source object remains in a valid but unspecified state.
 */
RecipeIngredient::RecipeIngredient(RecipeIngredient&& other) noexcept
    : m_amount(other.m_amount),
      m_unit(std::move(other.m_unit)),
      m_name(std::move(other.m_name)),
      m_isHeading(std::move(other.m_isHeading)),
      m_additionalProperties(std::move(other.m_additionalProperties))
{
}

/**
 * @brief Move assignment operator for RecipeIngredient.
 *
 * Assigns the contents of another RecipeIngredient object to this one using move semantics.
 * If the source object is the same as this object, no assignment is performed.
 *
 * @param other The RecipeIngredient to move from
 * @return RecipeIngredient& A reference to this object after the assignment
 * @noexcept This operation does not throw exceptions
 */
RecipeIngredient& RecipeIngredient::operator=(RecipeIngredient&& other) noexcept
{
    if (this != &other) {
        m_amount = other.m_amount;
        m_unit = std::move(other.m_unit);
        m_name = std::move(other.m_name);
        m_isHeading = std::move(other.m_isHeading);
        m_additionalProperties = std::move(other.m_additionalProperties);
    }
    return *this;
}

/**
 * @brief Equality comparison operator for RecipeIngredient.
 *
 * Compares if two RecipeIngredient objects are equal by checking if their
 * amount, unit, and name properties match.
 *
 * @param other The RecipeIngredient object to compare with
 * @return true if the ingredients are equal, false otherwise
 */
bool RecipeIngredient::operator==(const RecipeIngredient& other) const
{
    return m_amount == other.m_amount && m_unit == other.m_unit && m_name == other.m_name
            && m_isHeading == other.m_isHeading;
}

/**
 * @brief Inequality operator for comparing two RecipeIngredient objects
 *
 * @param other The RecipeIngredient object to compare with
 * @return true if the ingredients are not equal
 * @return false if the ingredients are equal
 */
bool RecipeIngredient::operator!=(const RecipeIngredient& other) const
{
    return !(*this == other);
}

/**
 * @brief Converts the recipe ingredient to a QVariantMap.
 *
 * This method serializes the recipe ingredient's properties into a map
 * representation that can be used for storage or data transfer.
 *
 * @return QVariantMap containing:
 *         - "amount": The quantity of the ingredient
 *         - "unit": The unit of measurement
 *         - "name": The name of the ingredient
 *        - "isHeading": Whether this ingredient is a heading
 */
QVariantMap RecipeIngredient::toMap() const
{
    QVariantMap map = m_additionalProperties;
    map["amount"] = m_amount;
    map["unit"] = m_unit;
    map["name"] = m_name;
    map["isHeading"] = m_isHeading;
    return map;
}

/**
 * @brief Creates a RecipeIngredient instance from a QVariantMap.
 *
 * @param map The QVariantMap containing the ingredient data with the following keys:
 *            - "amount": Double value representing the quantity of the ingredient
 *            - "unit": String value representing the unit of measurement
 *            - "name": String value representing the name of the ingredient
 *           - "isHeading": Boolean value indicating if this ingredient is a heading
 *
 * @return RecipeIngredient A new RecipeIngredient instance initialized with the map data
 */
RecipeIngredient RecipeIngredient::fromMap(const QVariantMap& map)
{
    QVariantMap m_additionalProperties = map;
    double amount_ = m_additionalProperties.take("amount").toDouble();
    QString unit_ = m_additionalProperties.take("unit").toString();
    QString name_ = m_additionalProperties.take("name").toString();
    bool isHeading_ = m_additionalProperties.take("isHeading").toBool();

    auto result = RecipeIngredient(amount_, unit_, name_);
    result.m_isHeading = isHeading_;
    result.m_additionalProperties = m_additionalProperties;
    return result;
}

/**
 * @brief Constructs a new recipe step.
 *
 * @param description The description of the step to be performed.
 * @param ingredients List of ingredients required for this step.
 * @param utilities List of utilities (tools, equipment) needed for this step.
 */
RecipeStep::RecipeStep(const QString& description, const RecipeIngredients& ingredients,
                       const RecipeUtilities& utilities)
    : m_description(description), m_ingredients(ingredients), m_utilities(utilities)
{
}

/**
 * @brief Copy constructor for RecipeStep.
 *
 * Creates a new RecipeStep object by copying the values from another RecipeStep.
 *
 * @param other The RecipeStep object to copy from.
 */
RecipeStep::RecipeStep(const RecipeStep& other)
    : m_description(other.m_description),
      m_ingredients(other.m_ingredients),
      m_utilities(other.m_utilities),
      m_additionalProperties(other.m_additionalProperties)
{
}

/**
 * @brief Assignment operator for RecipeStep.
 *
 * Assigns the contents of another RecipeStep to this one. This operator performs
 * a deep copy of the description, ingredients, and utilities.
 *
 * @param other The RecipeStep to copy from
 * @return RecipeStep& A reference to this RecipeStep after the assignment
 */
RecipeStep& RecipeStep::operator=(const RecipeStep& other)
{
    if (this != &other) {
        m_description = other.m_description;
        m_ingredients = other.m_ingredients;
        m_utilities = other.m_utilities;
        m_additionalProperties = other.m_additionalProperties;
    }
    return *this;
}

/**
 * @brief Move constructor for RecipeStep.
 *
 * Creates a new RecipeStep by moving the contents from another RecipeStep object.
 * After the move, the other object is left in a valid but unspecified state.
 *
 * @param other The RecipeStep object to move from.
 */
RecipeStep::RecipeStep(RecipeStep&& other) noexcept
    : m_description(std::move(other.m_description)),
      m_ingredients(std::move(other.m_ingredients)),
      m_utilities(std::move(other.m_utilities)),
      m_additionalProperties(std::move(other.m_additionalProperties))
{
}

/**
 * @brief Move assignment operator for RecipeStep.
 *
 * Moves the contents of another RecipeStep object into this one.
 *
 * @param other The RecipeStep object to move from
 * @return RecipeStep& A reference to this object after the move
 *
 * @note This operation is noexcept and will leave the source object in a valid but unspecified
 * state
 */
RecipeStep& RecipeStep::operator=(RecipeStep&& other) noexcept
{
    if (this != &other) {
        m_description = std::move(other.m_description);
        m_ingredients = std::move(other.m_ingredients);
        m_utilities = std::move(other.m_utilities);
        m_additionalProperties = std::move(other.m_additionalProperties);
    }
    return *this;
}

/**
 * @brief Compares this recipe step with another for equality.
 *
 * Two recipe steps are considered equal if they have the same description,
 * ingredients, and utilities.
 *
 * @param other The other recipe step to compare with
 * @return true if the recipe steps are equal, false otherwise
 */
bool RecipeStep::operator==(const RecipeStep& other) const
{
    return m_description == other.m_description && m_ingredients == other.m_ingredients
            && m_utilities == other.m_utilities;
}

/**
 * @brief Inequality comparison operator for recipe steps.
 *
 * @param other The recipe step to compare with.
 * @return true if the recipe steps are not equal, false otherwise.
 */
bool RecipeStep::operator!=(const RecipeStep& other) const
{
    return !(*this == other);
}

/**
 * @brief Converts the recipe step to a QVariantMap representation.
 *
 * This method serializes the recipe step's data into a map structure that can be easily
 * stored or transmitted. The resulting map contains the following keys:
 * - "description": The text description of the step
 * - "ingredients": A list of ingredients, where each ingredient is converted to its map
 * representation
 * - "utilities": A list of utilities (tools/equipment) needed for this step
 *
 * @return QVariantMap containing the serialized data of the recipe step
 */
QVariantMap RecipeStep::toMap() const
{
    QVariantMap map = m_additionalProperties;
    map["description"] = m_description;

    QVariantList ingredientsList;
    for (const RecipeIngredient& ingredient : m_ingredients) {
        ingredientsList.append(ingredient.toMap());
    }
    map["ingredients"] = ingredientsList;

    QVariantList utilitiesList;
    for (const QString& utility : m_utilities) {
        utilitiesList.append(utility);
    }
    map["utilities"] = utilitiesList;

    return map;
}

/**
 * @brief Creates a RecipeStep object from a QVariantMap.
 *
 * This static factory method constructs a RecipeStep instance from a map containing
 * the following key-value pairs:
 * - "description": QString containing the step description
 * - "ingredients": List of maps, each representing a RecipeIngredient
 * - "utilities": List of strings representing required utilities
 *
 * @param map The QVariantMap containing the recipe step data
 * @return RecipeStep A new RecipeStep instance initialized with the data from the map
 */
RecipeStep RecipeStep::fromMap(const QVariantMap& map)
{
    QVariantMap additionalProperties = map;

    QString description_ = additionalProperties.take("description").toString();

    RecipeIngredients ingredients_;
    QVariantList ingredientsList = additionalProperties.take("ingredients").toList();
    for (const QVariant& ingredientVar : ingredientsList) {
        QVariantMap ingredientMap = ingredientVar.toMap();
        ingredients_.append(RecipeIngredient::fromMap(ingredientMap));
    }

    RecipeUtilities utilities_;
    QVariantList utilitiesList = additionalProperties.take("utilities").toList();
    for (const QVariant& utilityVar : utilitiesList) {
        utilities_.append(utilityVar.toString());
    }

    auto result = RecipeStep(description_, ingredients_, utilities_);
    result.m_additionalProperties = additionalProperties;
    return result;
}

/**
 * @brief Default constructor for Recipe class
 *
 * Creates a new Recipe instance with an empty title
 *
 * @param parent The parent QObject for memory management (optional, defaults to nullptr)
 */
Recipe::Recipe(QObject* parent) : Recipe(QString(), parent) {}

/**
 * @brief Constructs a new Recipe object.
 *
 * Creates a new Recipe instance with the specified filename and parent object.
 * The constructor initializes the recipe's steps, ingredients, and utilities lists
 * and sets up signal connections to track changes in these properties.
 *
 * @param filename The path to the file associated with this recipe
 * @param parent The parent QObject (default: nullptr)
 */
Recipe::Recipe(const QString& filename, QObject* parent)
    : TopLevelItem(filename, parent), m_steps(), m_ingredients(), m_utilities()
{
    connect(this, &Recipe::stepsChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::ingredientsChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::utilitiesChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::yieldCountChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::yieldUnitChanged, this, &TopLevelItem::changed);
}

/**
 * @brief Copy constructor for Recipe class.
 *
 * Creates a new Recipe object as a copy of an existing one.
 * The new Recipe instance will have the same parent, steps, ingredients,
 * and utilities as the source Recipe.
 *
 * @param other The Recipe object to copy from
 */
Recipe::Recipe(const Recipe& other)
    : TopLevelItem(other.parent()),
      m_steps(other.m_steps),
      m_ingredients(other.m_ingredients),
      m_utilities(other.m_utilities)
{
}

/**
 * @brief Constructs a Recipe object.
 *
 * Creates a new Recipe instance with the specified directory and parent object.
 * Sets up signal connections to track changes in steps, ingredients, and utilities.
 *
 * @param dir The directory associated with the recipe
 * @param parent The parent QObject (default is nullptr)
 */
Recipe::Recipe(const QDir& dir, QObject* parent)
    : TopLevelItem(dir, parent), m_steps(), m_ingredients(), m_utilities()
{
    connect(this, &Recipe::stepsChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::ingredientsChanged, this, &TopLevelItem::changed);
    connect(this, &Recipe::utilitiesChanged, this, &TopLevelItem::changed);
}

/**
 * @brief Move constructor for Recipe class.
 *
 * Constructs a new Recipe by transferring the contents of another Recipe object.
 *
 * @param other The Recipe object to move from.
 *
 * The constructor moves the following members:
 * - steps
 * - ingredients
 * - utilities
 *
 * The parent from the other object is copied to initialize the TopLevelItem base class.
 */
Recipe::Recipe(Recipe&& other) noexcept
    : TopLevelItem(other.parent()),
      m_steps(std::move(other.m_steps)),
      m_ingredients(std::move(other.m_ingredients)),
      m_utilities(std::move(other.m_utilities))
{
}

/**
 * @brief Get the recipe steps.
 *
 * @return RecipeSteps Returns the collection of steps that make up the recipe.
 */
const RecipeSteps& Recipe::steps() const
{
    return m_steps;
}

/**
 * @brief Sets the steps of the recipe.
 *
 * Updates the recipe steps with the provided sequence and emits a stepsChanged signal
 * to notify listeners about the modification.
 *
 * @param steps The new sequence of recipe steps to be set
 */
void Recipe::setSteps(const RecipeSteps& steps)
{
    m_steps = steps;
    emit stepsChanged();
}

/**
 * @brief Get the ingredients of the recipe.
 *
 * This method returns the list of ingredients associated with the recipe.
 *
 * @return RecipeIngredients The collection of ingredients in the recipe.
 */
const RecipeIngredients& Recipe::ingredients() const
{
    return m_ingredients;
}

/**
 * @brief Sets the ingredients of the recipe
 *
 * This method updates the recipe's ingredients with the provided list and notifies
 * observers of the change by emitting the ingredientsChanged signal.
 *
 * @param ingredients The new list of ingredients to be set for the recipe
 */
void Recipe::setIngredients(const RecipeIngredients& ingredients)
{
    m_ingredients = ingredients;
    emit ingredientsChanged();
}

/**
 * @brief Get the utilities associated with the recipe.
 *
 * @return RecipeUtilities The utilities (tools, equipment, etc.) needed for the recipe.
 */
const RecipeUtilities& Recipe::utilities() const
{
    return m_utilities;
}

/**
 * @brief Sets the utilities needed for the recipe.
 *
 * This method updates the utilities associated with the recipe. If the new utilities
 * differ from the current ones, it emits the utilitiesChanged signal.
 *
 * @param utilities The new RecipeUtilities to be set for the recipe
 */
void Recipe::setUtilities(const RecipeUtilities& utilities)
{
    if (m_utilities != utilities) {
        m_utilities = utilities;
        emit utilitiesChanged();
    }
}

/**
 * @brief Serializes the Recipe object into a QVariantMap.
 *
 * This method converts the Recipe object into a key-value map representation,
 * which can be used for storage or data transfer. It includes:
 * - Base class (TopLevelItem) serialization
 * - List of recipe steps
 * - List of recipe ingredients
 * - Utilities used in the recipe
 *
 * @return QVariantMap containing the serialized recipe data with keys:
 *         - "steps": List of serialized RecipeStep objects
 *         - "ingredients": List of serialized RecipeIngredient objects
 *         - "utilities": List of utilities used in the recipe
 *         - All keys from TopLevelItem serialization
 */
QVariantMap Recipe::toMap() const
{
    QVariantMap map = TopLevelItem::toMap();
    // Serialize steps
    QVariantList stepsList;
    for (const RecipeStep& step : m_steps) {
        stepsList.append(QVariant::fromValue(step.toMap()));
    }
    map["steps"] = stepsList;

    // Serialize ingredients
    QVariantList ingredientsList;
    for (const RecipeIngredient& ingredient : m_ingredients) {
        ingredientsList.append(QVariant::fromValue(ingredient.toMap()));
    }
    map["ingredients"] = ingredientsList;
    map["utilities"] = QVariant::fromValue(m_utilities);
    map["yieldUnit"] = m_yieldUnit;
    map["yieldCount"] = m_yieldCount;
    return map;
}

/**
 * @brief Deserializes a Recipe from a QVariantMap.
 *
 * This method populates the Recipe object with data from the provided map.
 * It deserializes the following properties:
 * - Base properties (through TopLevelItem::fromMap)
 * - Recipe steps (as a list of RecipeStep objects)
 * - Recipe ingredients (as a list of RecipeIngredient objects)
 * - Utilities (as a string list)
 *
 * @param map The QVariantMap containing the serialized Recipe data
 */
void Recipe::fromMap(QVariantMap map)
{
    TopLevelItem::fromMap(map);
    // Deserialize steps
    m_steps.clear();
    QVariantList stepsList = map.value("steps").toList();
    for (const QVariant& stepVar : stepsList) {
        m_steps.append(RecipeStep::fromMap(stepVar.toMap()));
    }

    // Deserialize ingredients
    m_ingredients.clear();
    QVariantList ingredientsList = map.value("ingredients").toList();
    for (const QVariant& ingredientVar : ingredientsList) {
        m_ingredients.append(RecipeIngredient::fromMap(ingredientVar.toMap()));
    }

    m_utilities = map.value("utilities").toStringList();
    m_yieldUnit = map.value("yieldUnit").toString();
    m_yieldCount = map.value("yieldCount").toInt();
}

/**
 * @brief Get the yield unit of the recipe.
 *
 * @return const QString& The unit used for the recipe yield (e.g., "servings", "portions")
 */
const QString& Recipe::yieldUnit() const
{
    return m_yieldUnit;
}

/**
 * @brief Set the yield unit of the recipe.
 *
 * Updates the recipe's yield unit and emits a yieldUnitChanged signal to notify
 * listeners about the modification.
 *
 * @param yieldUnit The new yield unit for the recipe
 */
void Recipe::setYieldUnit(const QString& yieldUnit)
{
    if (m_yieldUnit != yieldUnit) {
        m_yieldUnit = yieldUnit;
        emit yieldUnitChanged();
    }
}

/**
 * @brief Get the yield count of the recipe.
 *
 * @return int The number of yields the recipe produces
 */
int Recipe::yieldCount() const
{
    return m_yieldCount;
}

/**
 * @brief Set the yield count of the recipe.
 *
 * Updates the recipe's yield count and emits a yieldCountChanged signal to notify
 * listeners about the modification.
 *
 * @param yieldCount The new yield count for the recipe
 */
void Recipe::setYieldCount(int yieldCount)
{
    if (m_yieldCount != yieldCount) {
        m_yieldCount = yieldCount;
        emit yieldCountChanged();
    }
}

/**
 * @brief Create a new RecipeIngredient instance.
 *
 * @return RecipeIngredient
 */
RecipeIngredient Recipe::createIngredient(const QString& name, const QString& unit,
                                          double amount) const
{
    return RecipeIngredient(amount, unit, name);
}

/**
 * @brief Create a new RecipeStep instance.
 *
 * @return RecipeStep
 */
RecipeStep Recipe::createStep(const QString& description) const
{
    RecipeStep result;
    result.setDescription(description);
    return result;
}

/**
 * @brief Creates a heading RecipeIngredient.
 *
 * This method creates a special RecipeIngredient that serves as a heading. Such "ingredients" are
 * specially rendered and serve as heading to group several ingredients together.
 *
 * @param heading The name of the ingredient.
 * @return RecipeIngredient An ingredient that is marked as heading.
 */
RecipeIngredient RecipeIngredient::makeHeading(const QString& heading)
{
    RecipeIngredient result;
    result.setName(heading);
    result.setIsHeading(true);
    return result;
}
