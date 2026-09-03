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

#include "datastorage/getitemsbytagquery.h"

#include <qlmdb/cursor.h>
#include <qlmdb/transaction.h>

#include "datamodel/item.h"

GetItemsByTagQuery::GetItemsByTagQuery(const QString& tag, QObject* parent)
    : ItemsQuery(parent), m_tag(tag.trimmed().toLower())
{
    qRegisterMetaType<ItemCacheEntry>();
}

QString GetItemsByTagQuery::tag() const
{
    return m_tag;
}

void GetItemsByTagQuery::run()
{
    if (m_tag.isEmpty()) {
        emit itemsAvailable({});
        return;
    }

    QVariantList result;
    QLMDB::Transaction t(*context(), QLMDB::Transaction::ReadOnly);
    QLMDB::Cursor itemsCursor(t, *items());

    auto it = itemsCursor.first();
    while (it.isValid()) {
        auto entry = ItemCacheEntry::fromByteArray(it.value(), it.key());
        if (entry.valid) {
            auto item = ItemPtr(Item::decache(entry));
            if (item && item->tags().contains(m_tag)) {
                calculateValues(t, &entry, item.data());
                result << QVariant::fromValue(entry);
            }
        }
        it = itemsCursor.next();
    }

    emit itemsAvailable(result);
}