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

#include "datastorage/movetaskquery.h"

#include <QtCore/qsharedpointer.h>
#include <qlmdb/cursor.h>
#include <qlmdb/database.h>
#include <qlmdb/transaction.h>

#include "datamodel/task.h"
#include "datamodel/todo.h"
#include "datastorage/itemsquery.h"

/**
 * @class MoveTaskQuery
 *
 * @brief Move tasks into another todo.
 * This query can be used to move a task into another todo.
 **/

/**
 * @brief Constructor.
 */
MoveTaskQuery::MoveTaskQuery(QObject* parent) : ItemsQuery { parent }, m_entry(), m_targetUid() {}

/**
 * @brief Move the given @p task into the @p todo.
 *
 * @warning The todo must be in the same library as the current task's parent.
 */
void MoveTaskQuery::moveTask(Task* task, Todo* todo)
{
    Q_CHECK_PTR(task);
    Q_CHECK_PTR(task);
    m_entry = task->encache();
    m_targetUid = todo->uid();
}

/**
 * @brief Implementation of ItemsQuery::run().
 */
void MoveTaskQuery::run()
{
    QLMDB::Transaction t(*context());

    auto task = Item::decache<Task>(m_entry);

    if (task) {
        // "Unlink" from previous parent:
        QLMDB::Cursor childrenCursor(t, *children());
        auto result = childrenCursor.find(task->todoUid().toByteArray(), task->uid().toByteArray());
        if (result.isValid()) {
            childrenCursor.remove();
        }

        // Set new parent:
        task->setTodoUid(m_targetUid);
        // Save to DB:
        items()->put(t, task->uid().toByteArray(), task->encache().toByteArray());
        children()->put(t, m_targetUid.toByteArray(), task->uid().toByteArray());
        // Save to disk:
        task->save();
        // Mark todo as changed:
        markAsChanged(&t, task->uid().toByteArray());
    }
}
