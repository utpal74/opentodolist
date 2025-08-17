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
#include <QVector>
#include <QString>
#include <QtCore/qcontainerfwd.h>
#include <qqmlregistration.h>

#include "datamodel/toplevelitem.h"

class RecipeIngredient
{
    Q_GADGET
    Q_PROPERTY(double amount READ amount WRITE setAmount)
    Q_PROPERTY(QString unit READ unit WRITE setUnit)
    Q_PROPERTY(QString name READ name WRITE setName)

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

    QString unit() const { return m_unit; }
    void setUnit(const QString& unit) { m_unit = unit; }

    QString name() const { return m_name; }
    void setName(const QString& name) { m_name = name; }

    QVariantMap toMap() const;
    static RecipeIngredient fromMap(const QVariantMap& map);

private:
    double m_amount;
    QString m_unit;
    QString m_name;
};

using RecipeIngredients = QVector<RecipeIngredient>;

class RecipeStep
{
    Q_GADGET

    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(RecipeIngredients ingredients READ ingredients WRITE setIngredients)
    Q_PROPERTY(QVector<QString> utilities READ utilities WRITE setUtilities)

public:
    RecipeStep() = default;
    RecipeStep(const QString& description, const RecipeIngredients& ingredients,
               const QVector<QString>& utilities);
    RecipeStep(const RecipeStep& other);
    RecipeStep& operator=(const RecipeStep& other);
    ~RecipeStep() = default;
    RecipeStep(RecipeStep&& other) noexcept;
    RecipeStep& operator=(RecipeStep&& other) noexcept;

    bool operator==(const RecipeStep& other) const;
    bool operator!=(const RecipeStep& other) const;

    QString description() const { return m_description; }
    void setDescription(const QString& description) { m_description = description; }

    RecipeIngredients ingredients() const { return m_ingredients; }
    void setIngredients(const RecipeIngredients& ingredients) { m_ingredients = ingredients; }

    QVector<QString> utilities() const { return m_utilities; }
    void setUtilities(const QVector<QString>& utilities) { m_utilities = utilities; }

    QVariantMap toMap() const;
    static RecipeStep fromMap(const QVariantMap& map);

private:
    QString m_description;
    RecipeIngredients m_ingredients;
    QVector<QString> m_utilities;
};

using RecipeSteps = QVector<RecipeStep>;

using RecipeUtilities = QVector<QString>;

class Recipe : public TopLevelItem
{
    Q_OBJECT

public:
    Q_PROPERTY(RecipeSteps steps READ steps WRITE setSteps NOTIFY stepsChanged)
    Q_PROPERTY(RecipeIngredients ingredients READ ingredients WRITE setIngredients NOTIFY
                       ingredientsChanged)
    Q_PROPERTY(RecipeUtilities utilities READ utilities WRITE setUtilities NOTIFY utilitiesChanged)

public:
    Recipe(QObject* parent = nullptr);
    Recipe(const QString& filename, QObject* parent = nullptr);
    Recipe(const Recipe& other);
    Recipe(const QDir& dir, QObject* parent = nullptr);
    Recipe(Recipe&& other) noexcept;
    ~Recipe() override = default;

    RecipeSteps steps() const;
    void setSteps(const RecipeSteps& steps);

    RecipeIngredients ingredients() const;
    void setIngredients(const RecipeIngredients& ingredients);

    RecipeUtilities utilities() const;
    void setUtilities(const RecipeUtilities& utilities);

    QVariantMap toMap() const override;
    void fromMap(QVariantMap map) override;

signals:
    void stepsChanged();
    void ingredientsChanged();
    void utilitiesChanged();

private:
    RecipeSteps m_steps;
    RecipeIngredients m_ingredients;
    RecipeUtilities m_utilities;
};

#endif // DATAMODEL_RECIPE_H_
