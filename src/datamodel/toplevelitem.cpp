/*
 * Copyright 2020 Martin Hoeher <martin@rpdev.net>
 +
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

#include "toplevelitem.h"

#include <QMetaEnum>

/**
 * @brief Constructor.
 */
TopLevelItem::TopLevelItem(const QString& filename, QObject* parent)
    : ComplexItem(filename, parent), m_color(White)
{
    connect(this, &TopLevelItem::colorChanged, this, &ComplexItem::changed);
}

/**
 * @brief Constructor.
 */
TopLevelItem::TopLevelItem(QObject* parent) : TopLevelItem(QString(), parent) {}

/**
 * @brief Constructor.
 */
TopLevelItem::TopLevelItem(const QDir& dir, QObject* parent)
    : ComplexItem(dir, parent), m_color(White)
{
    connect(this, &TopLevelItem::colorChanged, this, &ComplexItem::changed);
}

/**
 * @brief Destructor.
 */
TopLevelItem::~TopLevelItem() {}

QUuid TopLevelItem::parentId() const
{
    return m_libraryId;
}

/**
 * @brief The color of the item.
 */
TopLevelItem::Color TopLevelItem::color() const
{
    return m_color;
}

/**
 * @brief Set the item color.
 */
void TopLevelItem::setColor(const Color& color)
{
    if (m_color != color) {
        m_color = color;
        emit colorChanged();
    }
}

void TopLevelItem::setColor(const QString& color)
{
    QMetaEnum e = QMetaEnum::fromType<Color>();
    bool ok;
    Color c = static_cast<Color>(e.keysToValue(qUtf8Printable(color), &ok));
    if (ok) {
        setColor(c);
    }
}

/**
 * @brief Removes a tag from the item by index (backward-compatibility wrapper).
 */
void TopLevelItem::removeTagAt(int index)
{
    Q_ASSERT(index >= 0 && index < tags().length());
    removeTag(tags().at(index));
}

/**
 * @brief Returns true if the item has been tagged with the given @p tag.
 */
bool TopLevelItem::hasTag(const QString& tag) const
{
    return tags().contains(tag.trimmed().toLower());
}

/**
 * @brief The ID of the library the item belongs to.
 */
QUuid TopLevelItem::libraryId() const
{
    return m_libraryId;
}

/**
 * @brief Set the library ID.
 */
void TopLevelItem::setLibraryId(const QUuid& libraryId)
{
    if (m_libraryId != libraryId) {
        m_libraryId = libraryId;
        emit libraryIdChanged();
    }
}

Item* TopLevelItem::copyTo(const QDir& targetDirectory, const QUuid& targetLibraryUuid,
                           const QUuid& targetItemUid)
{
    auto result = ComplexItem::copyTo(targetDirectory, targetLibraryUuid, targetItemUid);
    auto topLevelItem = qobject_cast<TopLevelItem*>(result);

    if (topLevelItem) {
        topLevelItem->m_libraryId = targetLibraryUuid;
    }

    return result;
}

QVariantMap TopLevelItem::toMap() const
{
    auto result = ComplexItem::toMap();

    QMetaEnum e = QMetaEnum::fromType<Color>();
    result["color"] = QString(e.valueToKey(m_color));

    return result;
}

void TopLevelItem::fromMap(QVariantMap map)
{
    ComplexItem::fromMap(map);

    setColor(map.value("color", m_color).toString());
}
