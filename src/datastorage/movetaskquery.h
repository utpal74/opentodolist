/*
 * Copyright 2024 Martin Hoeher <martin@rpdev.net>
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

#ifndef DATASTORAGE_MOVETASKQUERY_H_
#define DATASTORAGE_MOVETASKQUERY_H_

#include <QObject>

#include "datamodel/item.h"
#include "datastorage/itemsquery.h"

class Task;
class Todo;

class MoveTaskQuery : public ItemsQuery
{
    Q_OBJECT
public:
    explicit MoveTaskQuery(QObject* parent = nullptr);

    void moveTask(Task* task, Todo* todo);

signals:

protected:
    // ItemsQuery interface
    void run() override;

private:
    ItemCacheEntry m_entry;
    QUuid m_targetUid;
};

#endif // DATASTORAGE_MOVETASKQUERY_H_
