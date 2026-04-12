/*
 * Copyright 2020-2023 Martin Hoeher <martin@rpdev.net>
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

#ifndef DATAMODEL_COMPLEXITEM_H_
#define DATAMODEL_COMPLEXITEM_H_

#include <QDateTime>
#include <QLoggingCategory>
#include <QObject>
#include <QFutureWatcher>
#include <QString>
#include <QStringList>
#include <QtQml/qqmlregistration.h>
#include <QUrl>

#include "item.h"

/**
 * @brief Represents the result of an attachment operation.
 *
 * This class is used to represent the result of an attachment operation, i.e. attaching a file to
 * an item. It contains information about the original file and the name of the attachment file.
 */
class AttachmentResult
{
    Q_GADGET
    QML_VALUE_TYPE(attachmentResult)
    Q_PROPERTY(QString originalFilePath READ originalFilePath WRITE setOriginalFilePath)
    Q_PROPERTY(QUrl originalFileUrl READ originalFileUrl WRITE setOriginalFileUrl)
    Q_PROPERTY(QString originalFileName READ originalFileName WRITE setOriginalFileName)
    Q_PROPERTY(QString attachmentFileName READ attachmentFileName WRITE setAttachmentFileName)
    Q_PROPERTY(bool valid READ isValid WRITE setValid)
    Q_PROPERTY(bool isImage READ isImage WRITE setIsImage)

public:
    AttachmentResult() = default;
    AttachmentResult(const QString& originalFilePath, const QUrl& originalFileUrl,
                     const QString& originalFileName, const QString& attachmentFileName)
        : m_originalFilePath(originalFilePath),
          m_originalFileUrl(originalFileUrl),
          m_originalFileName(originalFileName),
          m_attachmentFileName(attachmentFileName),
          m_valid(false),
          m_isImage(false)
    {
    }
    AttachmentResult(const AttachmentResult& other) = default;
    AttachmentResult& operator=(const AttachmentResult& other) = default;
    ~AttachmentResult() = default;
    AttachmentResult(AttachmentResult&& other) noexcept = default;
    AttachmentResult& operator=(AttachmentResult&& other) noexcept = default;

    /**
     * @brief The file path to the original file that was attached.
     */
    const QString& originalFilePath() const { return m_originalFilePath; }

    /**
     * @brief The URL to the original file that was attached.
     */
    const QUrl& originalFileUrl() const { return m_originalFileUrl; }

    /**
     * @brief The file name of the original file that was attached.
     */
    const QString& originalFileName() const { return m_originalFileName; }

    /**
     * @brief The file name of the attachment file.
     */
    const QString& attachmentFileName() const { return m_attachmentFileName; }

    /**
     * @brief Indicates if the attachment process was valid.
     *
     * @return true Attachment process was successful and the attachment file is available.
     * @return false There was an issue during the attachment process and the attachment file is not
     * available.
     */
    bool isValid() const { return m_valid; }

    /**
     * @brief Indicates if the attachment is an image.
     *
     * @return true The attachment is an image.
     * @return false The attachment is not an image.
     */
    bool isImage() const { return m_isImage; }

    /**
     * @brief Sets the file name of the attachment file.
     * @param attachmentFileName The file name of the attachment file.
     */
    void setAttachmentFileName(const QString& attachmentFileName)
    {
        m_attachmentFileName = attachmentFileName;
    }

    /**
     * @brief Sets the file path to the original file that was attached.
     * @param originalFilePath The file path to the original file that was attached.
     */
    void setOriginalFilePath(const QString& originalFilePath)
    {
        m_originalFilePath = originalFilePath;
    }

    /**
     * @brief Sets the URL to the original file that was attached.
     * @param originalFileUrl The URL to the original file that was attached.
     */
    void setOriginalFileUrl(const QUrl& originalFileUrl) { m_originalFileUrl = originalFileUrl; }

    /**
     * @brief Sets the file name of the original file that was attached.
     * @param originalFileName The file name of the original file that was attached.
     */
    void setOriginalFileName(const QString& originalFileName)
    {
        m_originalFileName = originalFileName;
    }

    /**
     * @brief Set if the attachment is valid.
     *
     * @param valid Indicates if the attachment process was valid.
     */
    void setValid(bool valid) { m_valid = valid; }

    /**
     * @brief Set if the attachment is an image.
     *
     * @param isImage Indicates if the attachment is an image.
     */
    void setIsImage(bool isImage) { m_isImage = isImage; }

private:
    QString m_originalFilePath = QString();
    QUrl m_originalFileUrl = QUrl();
    QString m_originalFileName = QString();
    QString m_attachmentFileName = QString();
    bool m_valid = false;
    bool m_isImage = false;
};

/**
 * @brief Complex items.
 *
 * The ComplexItem class is used to model more complex items. This class introduces some additional
 * properties that are not required by the simpler Item class but that nevertheless are common to
 * most other item types.
 */
class ComplexItem : public Item
{
    Q_OBJECT

    Q_PROPERTY(QDateTime dueTo READ dueTo WRITE setDueTo NOTIFY dueToChanged)
    Q_PROPERTY(QString notes READ notes WRITE setNotes NOTIFY notesChanged)
    Q_PROPERTY(QStringList attachments READ attachments NOTIFY attachmentsChanged)
    Q_PROPERTY(QStringList attachedImages READ attachedImages NOTIFY attachmentsChanged)
    Q_PROPERTY(RecurrencePattern recurrencePattern READ recurrencePattern WRITE setRecurrencePattern
                       NOTIFY recurrencePatternChanged)
    Q_PROPERTY(RecurrenceSchedule recurrenceSchedule READ recurrenceSchedule WRITE
                       setRecurrenceSchedule NOTIFY recurrenceScheduleChanged)
    Q_PROPERTY(QDateTime nextDueTo READ nextDueTo WRITE setNextDueTo NOTIFY nextDueToChanged)
    Q_PROPERTY(
            int recurInterval READ recurInterval WRITE setRecurInterval NOTIFY recurIntervalChanged)
    Q_PROPERTY(QDateTime recurUntil READ recurUntil WRITE setRecurUntil NOTIFY recurUntilChanged)
    Q_PROPERTY(QDateTime effectiveDueTo READ effectiveDueTo NOTIFY effectiveDueToChanged)
    Q_PROPERTY(QDateTime nextEffectiveDueTo READ nextEffectiveDueTo NOTIFY effectiveDueToChanged)
    Q_PROPERTY(bool isFutureInstance READ isFutureInstance NOTIFY effectiveDueToChanged)
    Q_PROPERTY(bool isRecurring READ isRecurring NOTIFY isRecurringChanged)
    Q_PROPERTY(bool newRecurrenceCreated READ newRecurrenceCreated WRITE setNewRecurrenceCreated
                       NOTIFY newRecurrenceCreatedChanged)
    QML_ELEMENT

public:
    /**
     * @brief Determines the recurrence pattern of an item with a due date set.
     */
    enum RecurrencePattern {
        NoRecurrence = 0, //!< The item does not recur.
        RecurDaily, //!< The item recurs daily.
        RecurWeekly, //!< The item recurs weekly.
        RecurMonthly, //!< The item recurs monthly.
        RecurYearly, //!< The item recurs monthly.
        RecurEveryNDays, //!< The item recurs every N days.
        RecurEveryNWeeks, //!< The item recurs every N weeks.
        RecurEveryNMonths, //!< The item recurs every N months.
    };

    Q_ENUM(RecurrencePattern)

    /**
     * @brief Determines the offset to when the next occurrence of the item is scheduled.
     */
    enum RecurrenceSchedule {
        RelativeToOriginalDueDate, //!< The item is scheduled relative to the original due date.
        RelativeToCurrentDate //!< The item is scheduled relative to the current date.
    };

    Q_ENUM(RecurrenceSchedule)

    explicit ComplexItem(QObject* parent = nullptr);
    explicit ComplexItem(const QString& filename, QObject* parent = nullptr);
    explicit ComplexItem(const QDir& dir, QObject* parent = nullptr);
    ~ComplexItem() override;

    QUuid parentId() const override;

    QDateTime dueTo() const;
    void setDueTo(const QDateTime& dueTo);

    const QString& notes();
    void setNotes(const QString& notes);

    const QStringList& attachments() const;
    QStringList attachedImages() const;
    Q_INVOKABLE QString attachmentFileName(const QString& filename) const;
    Q_INVOKABLE QString attachmentFileMarkdownLink(const QString& filename) const;

    // Item interface
    bool deleteItem() override;
    Item* copyTo(const QDir& targetDirectory, const QUuid& targetLibraryUuid,
                 const QUuid& targetItemUid = QUuid()) override;

    RecurrencePattern recurrencePattern() const;
    void setRecurrencePattern(const RecurrencePattern& recurrencePattern);

    RecurrenceSchedule recurrenceSchedule() const;
    void setRecurrenceSchedule(const RecurrenceSchedule& recurrenceSchedule);

    QDateTime nextDueTo() const;
    void setNextDueTo(const QDateTime& nextDueTo);

    int recurInterval() const;
    void setRecurInterval(int recurInterval);

    QDateTime effectiveDueTo() const;
    QDateTime nextEffectiveDueTo(const QDateTime& today = QDateTime()) const;
    bool isRecurring() const;
    bool isFutureInstance() const;

    QDateTime earliestChildDueTo() const;
    void setEarliestChildDueTo(const QDateTime& earliestChildDueTo);

    const QDateTime& recurUntil() const;
    void setRecurUntil(const QDateTime& newRecurUntil);

    Q_INVOKABLE virtual bool canBeMarkedAsDone() const;

    bool newRecurrenceCreated() const;

    Q_INVOKABLE AttachmentResult attachFile(const QString& filename);
    Q_INVOKABLE AttachmentResult attachFile(const QUrl& url);

signals:

    void dueToChanged();
    void notesChanged();
    void attachmentsChanged();
    void recurrencePatternChanged();
    void recurrenceScheduleChanged();
    void nextDueToChanged();
    void recurUntilChanged();
    void recurIntervalChanged();
    void effectiveDueToChanged();
    void isRecurringChanged();
    void earliestChildDueToChanged();

    void newRecurrenceCreatedChanged();

public slots:

    void detachFile(const QString& filename);
    void markCurrentOccurrenceAsDone(const QDateTime& today = QDateTime());

protected:
private:
    QDateTime m_dueTo;
    QString m_notes;
    QStringList m_attachments;
    QDateTime m_earliestChildDueTo;

    // Recurrence handling:
    RecurrencePattern m_recurrencePattern;
    RecurrenceSchedule m_recurrenceSchedule;
    QDateTime m_nextDueTo;
    QDateTime m_recurUntil;
    int m_recurInterval;
    bool m_newRecurrenceCreated;

    void setupConnections();
    void setAttachments(const QStringList& attachments);
    void setNewRecurrenceCreated(bool newNewRecurrenceCreated);
    bool isImage(const QString& filename) const;

protected:
    // Item interface
    QVariantMap toMap() const override;
    void fromMap(QVariantMap map) override;
    QVariantMap getRuntimeData() const override;
    void applyRuntimeData(const QVariantMap& runtimeData) override;

    virtual void markItemAsDone();
};

typedef QSharedPointer<ComplexItem> ComplexItemPtr;

#endif // DATAMODEL_COMPLEXITEM_H_
