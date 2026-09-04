#include <QtTest/QtTest>
#include <QStandardItemModel>
#include "models/itemssortfiltermodel.h"
#include "models/itemsmodel.h"

class tst_ItemsSortFilterModel_FilterTag : public Object
{
    Q_OBJECT
private slots:
    void filterTag_filters_by_TagsRole_case_insensitive();
};

static QStandardItemModel * buildSource(Object * parent)
{
    auto *m = new QStandardItemModel(parent);

    auto addRow = [&](const QString &title, const QStringList &tags) {
        auto *it = new QStandardItem(title);
        it->setData(tags, ItemsModel::TagsRole);
        m->appendRow(it);
    };

    addRow("A", {"urgent", "backend"});
    addRow("B", {"backend"});
    addRow("C", {});
    return m;
}

void tst_ItemsSortFilterModel_FilterTag::filterTag_filters_by_TagsRole_case_insensitive()
{
    QScopedPointer<QStandardItemModel> source(buildSource(this));

    ItemsSortFilterModel proxy;
    proxy.setSourceModel(source.data());

    QCOMPARE(proxy.rowCount(), 3);

    proxy.setFilterTag("Urgent");
    QCOMPARE(proxy.rowCount(), 1);
    QCOMPARE(proxy.index(0, 0).data().toString(), QString("A"));

    proxy.setFilterTag("");
    QCOMPARE(proxy.rowCount(), 3);
}

QTEST_MAIN(tst_ItemsSortFilterModel_FilterTag)
#include "test_itemssortfiltermodel_filtertag.moc"
