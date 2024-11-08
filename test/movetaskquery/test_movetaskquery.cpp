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

#include <QObject>
#include <QSignalSpy>
#include <QTest>

#include "datamodel/library.h"
#include "datamodel/task.h"
#include "datamodel/todo.h"
#include "datamodel/todolist.h"
#include "datastorage/cache.h"
#include "datastorage/getitemquery.h"
#include "datastorage/getitemsquery.h"
#include "datastorage/insertorupdateitemsquery.h"
#include "datastorage/movetaskquery.h"

class MoveTaskQueryTest : public QObject
{
    Q_OBJECT

private slots:

    void initTestCase() {}
    void init() {}
    void run();
    void cleanup() {}
    void cleanupTestCase() {}
};

void MoveTaskQueryTest::run()
{
    QTemporaryDir tmpDir;
    Cache cache;
    cache.setCacheDirectory(tmpDir.path());
    cache.setCacheSize(1024 * 1024);
    QVERIFY(cache.open());

    Library lib;
    TodoList todoList;
    todoList.setTitle("A todo list");
    todoList.setLibraryId(lib.uid());
    Todo todo;
    todo.setTitle("A todo");
    todo.setTodoListUid(todoList.uid());
    Todo todo2;
    todo.setTitle("Another todo");
    todo.setTodoListUid(todoList.uid());
    Task task;
    task.setTitle("A task");
    task.setTodoUid(todo.uid());

    {
        auto q = new InsertOrUpdateItemsQuery;
        QSignalSpy finished(q, &InsertOrUpdateItemsQuery::finished);
        QSignalSpy destroyed(q, &InsertOrUpdateItemsQuery::destroyed);

        q->add(&lib);
        q->add(&todoList);
        q->add(&todo);
        q->add(&todo2);
        q->add(&task);
        cache.run(q);

        QVERIFY(destroyed.wait());
        QCOMPARE(finished.count(), 1);
    }

    {
        auto q = new GetItemQuery();
        q->setUid(task.uid());
        QSignalSpy itemLoaded(q, &GetItemQuery::itemLoaded);
        cache.run(q);
        QVERIFY(itemLoaded.wait());
        ItemPtr item(Item::decache(itemLoaded.value(0).value(0)));
        QVERIFY(item != nullptr);
        QCOMPARE(item->uid(), task.uid());
        QCOMPARE(item->parentId(), todo.uid());
    }

    {
        auto q = new MoveTaskQuery;
        QSignalSpy finished(q, &InsertOrUpdateItemsQuery::finished);

        q->moveTask(&task, &todo2);
        cache.run(q);

        QVERIFY(finished.wait());
    }

    {
        auto q = new GetItemQuery();
        q->setUid(task.uid());
        QSignalSpy itemLoaded(q, &GetItemQuery::itemLoaded);
        cache.run(q);
        QVERIFY(itemLoaded.wait());
        ItemPtr item(Item::decache(itemLoaded.value(0).value(0)));
        QVERIFY(item != nullptr);
        QCOMPARE(item->uid(), task.uid());
        QCOMPARE(item->parentId(), todo2.uid());
    }

    {
        auto q = new GetItemsQuery;
        QSignalSpy itemsAvailable(q, &GetItemsQuery::itemsAvailable);
        QSignalSpy destroyed(q, &GetItemsQuery::destroyed);
        q->setParent(todo.uid());
        cache.run(q);
        QVERIFY(destroyed.wait());
        auto items = itemsAvailable.at(0).at(0).toList();
        QCOMPARE(items.length(), 0);
    }

    {
        auto q = new GetItemsQuery;
        QSignalSpy itemsAvailable(q, &GetItemsQuery::itemsAvailable);
        QSignalSpy destroyed(q, &GetItemsQuery::destroyed);
        q->setParent(todo2.uid());
        cache.run(q);
        QVERIFY(destroyed.wait());
        auto items = itemsAvailable.at(0).at(0).toList();
        QCOMPARE(items.length(), 1);
    }
}

QTEST_MAIN(MoveTaskQueryTest)
#include "test_movetaskquery.moc"
