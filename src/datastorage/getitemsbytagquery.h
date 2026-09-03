/*
 * Copyright 2024 Martin Hoeher <martin@rpdev.net>
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

#ifndef DATASTORAGE_GETITEMSBYTAGQUERY_H_
#define DATASTORAGE_GETITEMSBYTAGQUERY_H_

#include <QObject>
#include <QString>

#include "datastorage/itemsquery.h"

/**
 * @brief Query that scans all cached items and returns those tagged with a given tag.
 *
 * The tag is normalized (trimmed + lowercased) before matching. Items are returned as
 * a QVariantList of ItemCacheEntry values via the itemsAvailable() signal.
 */
class GetItemsByTagQuery : public ItemsQuery
{
    Q_OBJECT
public:
    explicit GetItemsByTagQuery(const QString& tag, QObject* parent = nullptr);

    QString tag() const;

signals:
    void itemsAvailable(QVariantList items);

protected:
    void run() override;

private:
    QString m_tag;
};

#endif // DATASTORAGE_GETITEMSBYTAGQUERY_H_