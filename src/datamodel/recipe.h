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

#ifndef DATAMODEL_RECIPE_H_
#define DATAMODEL_RECIPE_H_

#include <QObject>
#include <QList>
#include <QString>
#include <QtCore/qcontainerfwd.h>
#include <QtCore/qtmetamacros.h>
#include <qqmlregistration.h>

#include "datamodel/toplevelitem.h"

class RecipeIngredient
{
    Q_GADGET
    QML_VALUE_TYPE(recipeIngredient)
    Q_PROPERTY(double amount READ amount WRITE setAmount)
    Q_PROPERTY(QString unit READ unit WRITE setUnit)
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(bool isHeading READ isHeading WRITE setIsHeading)

public:
    RecipeIngredient();
    RecipeIngredient(double amount, const QString& unit, const QString& name);
    RecipeIngredient(const RecipeIngredient& other);
    RecipeIngredient& operator=(const RecipeIngredient& other);
    ~RecipeIngredient() = default;
    RecipeIngredient(RecipeIngredient&& other) noexcept;
    RecipeIngredient& operator=(RecipeIngredient&& other) noexcept;
    bool operator==(const RecipeIngredient& other) const;
    bool operator!=(const RecipeIngredient& other) const;

    double amount() const { return m_amount; }
    void setAmount(double amount) { m_amount = amount; }

    const QString& unit() const { return m_unit; }
    void setUnit(const QString& unit) { m_unit = unit; }

    const QString& name() const { return m_name; }
    void setName(const QString& name) { m_name = name; }

    const bool& isHeading() const { return m_isHeading; }
    void setIsHeading(const bool& isHeading) { m_isHeading = isHeading; }

    QVariantMap toMap() const;
    static RecipeIngredient fromMap(const QVariantMap& map);

    static RecipeIngredient makeHeading(const QString& heading);

private:
    double m_amount = 0.0;
    QString m_unit = QString();
    QString m_name = QString();
    bool m_isHeading = false;
    QVariantMap m_additionalProperties = QVariantMap();
};

using RecipeIngredients = QList<RecipeIngredient>;

using RecipeUtilities = QList<QString>;

class RecipeStep
{
    Q_GADGET
    QML_VALUE_TYPE(recipeStep)

    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(QList<RecipeIngredient> ingredients READ ingredients WRITE setIngredients)
    Q_PROPERTY(QList<QString> utilities READ utilities WRITE setUtilities)

public:
    RecipeStep() = default;
    RecipeStep(const QString& description, const RecipeIngredients& ingredients,
               const RecipeUtilities& utilities);
    RecipeStep(const RecipeStep& other);
    RecipeStep& operator=(const RecipeStep& other);
    ~RecipeStep() = default;
    RecipeStep(RecipeStep&& other) noexcept;
    RecipeStep& operator=(RecipeStep&& other) noexcept;

    bool operator==(const RecipeStep& other) const;
    bool operator!=(const RecipeStep& other) const;

    const QString& description() const { return m_description; }
    void setDescription(const QString& description) { m_description = description; }

    const RecipeIngredients& ingredients() const { return m_ingredients; }
    void setIngredients(const RecipeIngredients& ingredients) { m_ingredients = ingredients; }

    const RecipeUtilities& utilities() const { return m_utilities; }
    void setUtilities(const RecipeUtilities& utilities) { m_utilities = utilities; }

    QVariantMap toMap() const;
    static RecipeStep fromMap(const QVariantMap& map);

private:
    QString m_description = QString();
    RecipeIngredients m_ingredients = RecipeIngredients();
    RecipeUtilities m_utilities = RecipeUtilities();
    QVariantMap m_additionalProperties = QVariantMap();
};

using RecipeSteps = QList<RecipeStep>;

class Recipe : public TopLevelItem
{
    Q_OBJECT
    QML_ELEMENT

public:
    Q_PROPERTY(QList<RecipeStep> steps READ steps WRITE setSteps NOTIFY stepsChanged)
    Q_PROPERTY(QList<RecipeIngredient> ingredients READ ingredients WRITE setIngredients NOTIFY
                       ingredientsChanged)
    Q_PROPERTY(QList<QString> utilities READ utilities WRITE setUtilities NOTIFY utilitiesChanged)
    Q_PROPERTY(int yieldCount READ yieldCount WRITE setYieldCount NOTIFY yieldCountChanged)
    Q_PROPERTY(QString yieldUnit READ yieldUnit WRITE setYieldUnit NOTIFY yieldUnitChanged)

public:
    explicit Recipe(QObject* parent = nullptr);
    explicit Recipe(const QString& filename, QObject* parent = nullptr);
    explicit Recipe(const Recipe& other);
    explicit Recipe(const QDir& dir, QObject* parent = nullptr);
    Recipe(Recipe&& other) noexcept;
    ~Recipe() override = default;

    const RecipeSteps& steps() const;
    void setSteps(const RecipeSteps& steps);

    const RecipeIngredients& ingredients() const;
    void setIngredients(const RecipeIngredients& ingredients);

    const RecipeUtilities& utilities() const;
    void setUtilities(const RecipeUtilities& utilities);

    int yieldCount() const;
    void setYieldCount(int yieldCount);

    const QString& yieldUnit() const;
    void setYieldUnit(const QString& yieldUnit);

    QVariantMap toMap() const override;
    void fromMap(QVariantMap map) override;

    Q_INVOKABLE RecipeIngredient createIngredient(const QString& name = QString(),
                                                  const QString& unit = QString(),
                                                  double amount = 0) const;
    Q_INVOKABLE RecipeStep createStep(const QString& description = QString()) const;

signals:
    void stepsChanged();
    void ingredientsChanged();
    void utilitiesChanged();
    void yieldCountChanged();
    void yieldUnitChanged();

private:
    RecipeSteps m_steps;
    RecipeIngredients m_ingredients;
    RecipeUtilities m_utilities;
    int m_yieldCount = 0;
    QString m_yieldUnit = QString();
};

#endif // DATAMODEL_RECIPE_H_
