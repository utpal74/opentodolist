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

#include <QObject>
#include <QTest>
#include <QTemporaryDir>
#include <QtTest/qtestcase.h>
#include <QSignalSpy>

#include "datamodel/recipe.h"

class RecipeTest : public QObject
{
    Q_OBJECT

private slots:

    void initTestCase() {}
    void init() {}
    void testProperties();
    void testPersistence();
    void cleanup() {}
    void cleanupTestCase() {}
};

void RecipeTest::testPersistence()
{
    // Test persistence: create a Recipe, set properties, save and reload
    QTemporaryDir tempDir;
    QVERIFY(tempDir.isValid());

    QString filePath = tempDir.path() + "/recipe.json";

    // Create and set properties
    Recipe recipe;

    // Check default property values before setting
    QCOMPARE(recipe.title(), QString());
    QCOMPARE(recipe.notes(), QString());
    QCOMPARE(recipe.ingredients(), {});
    QCOMPARE(recipe.utilities(), {});
    QCOMPARE(recipe.steps(), {});

    recipe.setTitle("Test Recipe");
    recipe.setNotes("Mix ingredients and bake.");
    recipe.setIngredients({ RecipeIngredient(500, "g", "Flour"),
                            RecipeIngredient(100, "g", "Sugar"), RecipeIngredient(1, "", "Eggs") });

    recipe.setUtilities({ "Oven", "Bowl" });
    recipe.setSteps({ RecipeStep("Mix ingredients",
                                 { RecipeIngredient(500, "g", "Flour"),
                                   RecipeIngredient(100, "g", "Sugar") },
                                 { "Bowl" }),
                      RecipeStep("Bake", {}, { "Oven" }) });

    // Persist into a variant and restore from it
    Recipe loadedRecipe;
    loadedRecipe.fromVariant(recipe.toVariant());

    // Check properties
    QCOMPARE(loadedRecipe.title(), QString("Test Recipe"));
    RecipeIngredients expectedIngredients = { RecipeIngredient(500, "g", "Flour"),
                                              RecipeIngredient(100, "g", "Sugar"),
                                              RecipeIngredient(1, "", "Eggs") };
    QCOMPARE(loadedRecipe.ingredients(), expectedIngredients);
    QCOMPARE(loadedRecipe.notes(), QString("Mix ingredients and bake."));
}

void RecipeTest::testProperties()
{
    // Test default property values
    Recipe recipe;
    QCOMPARE(recipe.title(), QString());
    QCOMPARE(recipe.notes(), QString());
    QCOMPARE(recipe.ingredients(), RecipeIngredients {});
    QCOMPARE(recipe.utilities(), QStringList {});
    QCOMPARE(recipe.steps(), RecipeSteps {});

    // Test setting and getting title, and signal emission
    QSignalSpy titleSpy(&recipe, SIGNAL(titleChanged()));
    recipe.setTitle("Chocolate Cake");
    QCOMPARE(recipe.title(), QString("Chocolate Cake"));
    QCOMPARE(titleSpy.count(), 1);

    // Test setting and getting notes, and signal emission
    QSignalSpy notesSpy(&recipe, SIGNAL(notesChanged()));
    recipe.setNotes("Bake at 180°C for 30 minutes.");
    QCOMPARE(recipe.notes(), QString("Bake at 180°C for 30 minutes."));
    QCOMPARE(notesSpy.count(), 1);

    // Test setting and getting ingredients, and signal emission
    QSignalSpy ingredientsSpy(&recipe, SIGNAL(ingredientsChanged()));
    RecipeIngredients ingredients = { RecipeIngredient(200, "g", "Chocolate"),
                                      RecipeIngredient(100, "g", "Butter") };
    recipe.setIngredients(ingredients);
    QCOMPARE(recipe.ingredients(), ingredients);
    QCOMPARE(ingredientsSpy.count(), 1);

    // Test setting and getting utilities, and signal emission
    QSignalSpy utilitiesSpy(&recipe, SIGNAL(utilitiesChanged()));
    QStringList utilities = { "Oven", "Mixing Bowl" };
    recipe.setUtilities(utilities);
    QCOMPARE(recipe.utilities(), utilities);
    QCOMPARE(utilitiesSpy.count(), 1);

    // Test setting and getting steps, and signal emission
    QSignalSpy stepsSpy(&recipe, SIGNAL(stepsChanged()));
    RecipeSteps steps = { RecipeStep("Melt chocolate", { RecipeIngredient(200, "g", "Chocolate") },
                                     { "Mixing Bowl" }),
                          RecipeStep("Bake", {}, { "Oven" }) };
    recipe.setSteps(steps);
    QCOMPARE(recipe.steps(), steps);
    QCOMPARE(stepsSpy.count(), 1);
}

QTEST_MAIN(RecipeTest)
#include "test_recipe.moc"
