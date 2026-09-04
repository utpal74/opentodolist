#include <QtTest/QtTest>
#include "datamodel/item.h"

class tst_ItemTags : public Object
{
    Q_OBJECT
private slots:
    void addTag_valid_normalizes();
    void addTag_invalid_rejected_sets_error();
    void addTag_empty_rejected_sets_error();
    void addTag_deduplicates();
    void max_20_tags_enforced();
    void toMap_persists_only_when_non_empty();
    void fromMap_missing_tags_is_empty();
    void fromMap_sanitizes_invalid_and_truncates_to_20();
};

void tst_ItemTags::addTag_valid_normalizes()
{
    Item item;
    QVERIFY(item.addTag("  Urgent  "));
    QCOMPARE(item.tags(), QStringList({"urgent"}));
    QCOMPARE(item.tagsLastError(), QString(""));
}

void tst_ItemTags::addTag_invalid_rejected_sets_error()
{
    Item item;
    QVERIFY(!item.addTag("proj$ct"));
    QCOMPARE(item.tags().size(), 0);
    QVERIFY(item.tagsLastError().contains("invalid characters"));
}

void tst_ItemTags::addTag_empty_rejected_sets_error()
{
    Item item;
    QVERIFY
        !        item.addTag("   "));
    QCOMPARE(item.tags().size(), 0);
    QCOMPARE(item.tagsLastError(), QString("Tag must not be empty."));
}

void tst_ItemTags::addTag_deduplicates()
{
    Item item;
    QVERIFY
        item.addTag("Urgent"));
    QVERIFY
        item.addTag("urgent")); // should be no-op success
    QCOMPARE(item.tags(), QStringList({"urgent"}));
    QCOMPARE(item.tagsLastError(), QString(""));
}

void tst_ItemTags::max_20_tags_enforced()
{
    Item item;
    for (int i = 1; i <= 20; ++i) {
        QVERIFY
            item.addTag(QString("t%1").arg(i)));
    }
    QVERIFY(!item.addTag("extra"));
    QCOMPARE(item.tags().size(), 20);
    QCOMPARE(item.tagsLastError(), QString("Maximum 20 tags per item."));
}

void tst_ItemTags::toMap_persists_only_when_non_empty()
{
    Item item;
    auto m0 = item.toMap();
    QVERIFY(!m0.contains("tags"));

    item.setTags({"urgent", "backend"});
    auto m = item.toMap();
    QVERIFY(m.contains("tags"));
    QCOMPARE(m.value("tags").toStringList(), QStringList({"urgent", "backend"}));
}

void tst_ItemTags::fromMap_missing_tags_is_empty()
{
    Item item;
    QVariantMap legacy;
    legacy["title"] = "Legacy";
    item.fromMap(legacy);
    QCOMPARE(item.tags(), QStringList({}));
}

void tst_ItemTags::fromMap_sanitizes_invalid_and_truncates_to_20()
{
    QVariantMap map;
    map["tags"] = QStringList({"ok", "bad$", "OK", "",
                            "t01","t02","t03","t04","t05","t06","t07","t08","t09","t10",
                            "t11","t12","t13","t14","t15","t16","t17","t18","t19","t20","t21" });
    Item item;
    item.fromMap(map);
    QVERIFY(item.tags().contains("ok"));
    QVERIFY
        !        item.tags().contains("bad$"));
    QCOMPARE(item.tags().size(), 20);
}

QTEST_MAIN(tst_ItemTags)
#include "test_item_tags.moc"
