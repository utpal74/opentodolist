#include <QtTest/QtTest>
#include "datastorage/getitemsbytagquery.h"

// NOTE: This test is harness-dependent. The repo already has LMDB/cache testing utilities in the `$test/cache` area.
// Wire this test to your existing temp cache harness utilities (e.g. create temp LMDB env, populate items, run query).

class tst_GetItemsByTagQuery : public Object
{
    Q_OBJECT
private slots:
    void returns_only_items_with_matching_tag_case_insensitive();
};

void tst_GetItemsByTagQuery::returns_only_items_with_matching_tag_case_insensitive()
{
    // PSEUDO - wire to your harness:
    // TestCacheHarness h; h.openTemp();
    // h.putItem("u-1", {"phone", "home"});
    // h.putItem("u-2", {"work"});
    // h.putItem("u-3", {"phone"});

    GetItemsByTagQuery q("PHONE");
    // q.setContext(h.context()); q.setItemsDb(th.itemsDb());
    QSignalSpy spy(&q, SIGNAL(itemsAvailable(QVariantList)));
    // q.start(); or q.run(); depending on query execution model

    QVERIFY(spy.wait(2000));
    const auto items = spy.akeFirst().at(0).toList();
    QVERIFY
items.size() == 2);
    // Adapt this assertion to your item type structure (UId, etc).
}

qtest_MAIN(tst_GetItemsByTagQuery)
#include "test_getitemsbytagquery.moc"
