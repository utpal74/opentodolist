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

#include "jsonutils.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QSaveFile>

namespace JsonUtils {

static Q_LOGGING_CATEGORY(log, "OpenTodoList.JsonUtils", QtWarningMsg);

/**
 * @brief Patch a QVariantMap with another map.
 *
 * This function recursively patches the @p target map with the values from the @p patch map.
 * If a key exists in both maps and both values are maps, it will recursively patch those
 * as well. Otherwise, it will overwrite the value in the target map with the value from
 * the patch map.
 */
static void patchMap(QVariantMap& target, const QVariantMap& patch)
{
    for (auto it = patch.constBegin(); it != patch.constEnd(); ++it) {
        if (target.contains(it.key())
            && target[it.key()].metaType() == QMetaType::fromType<QVariantMap>()
            && it.value().metaType() == QMetaType::fromType<QVariantMap>()) {
            // Recursively patch nested maps
            QVariantMap targetSubMap = target[it.key()].toMap();
            patchMap(targetSubMap, it.value().toMap());
            target[it.key()] = targetSubMap;
        } else {
            target[it.key()] = it.value();
        }
    }
};

/**
 * @brief Write a JSON file, keeping existing properties in the file.
 *
 * This function can be used to write the properties contained in @p data to the
 * filename. If filename points to an existing file, any properties that exist in the
 * file but not in data will be preserved.
 *
 * The intention of this function is to keep a set of files backwards compatible (e.g. if
 * users switch between versions of the application).
 *
 * The function returns true on success or false otherwise.
 *
 * Note that this function will not touch the target file if there are no
 * changes. If you need to know if the file was actually written, pass in a
 * pointer to a boolean via the @p changed parameter.
 */
bool patchJsonFile(const QString& filename, const QVariantMap& data, bool* changed)
{
    bool result = false;
    QFile file(filename);
    QVariantMap properties;
    QByteArray existingFileContent;
    bool hasChanged = false;
    if (file.exists()) {
        if (file.open(QIODevice::ReadOnly)) {
            QJsonParseError error;
            existingFileContent = file.readAll();
            auto doc = QJsonDocument::fromJson(existingFileContent, &error);
            if (error.error == QJsonParseError::NoError) {
                properties = doc.toVariant().toMap();
            } else {
                qCWarning(log) << "Failed to parse" << filename << ":" << error.errorString();
            }
            file.close();
        } else {
            qCWarning(log) << "Failed to open" << filename << "for reading:" << file.errorString();
        }
    }
    patchMap(properties, data);
    auto doc = QJsonDocument::fromVariant(properties);
    auto newFileContent = doc.toJson(QJsonDocument::Indented);
    if (newFileContent != existingFileContent) {
        QFileInfo fi(filename);
        fi.dir().mkpath(".");
        QSaveFile saveFile(filename);
        if (saveFile.open(QIODevice::WriteOnly)) {
            saveFile.write(newFileContent);
            result = saveFile.commit();
            hasChanged = result;
        } else {
            qCWarning(log) << "Failed to open" << filename << "for writing:" << file.errorString();
        }
    } else {
        qCDebug(log) << "File" << filename << "was not changed - "
                     << "skipping rewrite";
        result = true;
    }
    if (changed != nullptr) {
        *changed = hasChanged;
    }
    return result;
}

/**
 * @brief Load a variant map from a JSON file.
 */
QVariantMap loadMap(const QString& filename, bool* ok)
{
    bool success = false;
    QVariantMap result;
    QFile file(filename);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonParseError error;
        auto doc = QJsonDocument::fromJson(file.readAll(), &error);
        if (error.error == QJsonParseError::NoError) {
            result = doc.toVariant().toMap();
            success = true;
        } else {
            qCWarning(log) << "Failed to parse" << filename << ":" << error.errorString();
        }
        file.close();
    } else {
        qCDebug(log) << "Failed to open" << filename << "for reading:" << file.errorString();
    }
    if (ok != nullptr) {
        *ok = success;
    }
    return result;
}

} // namespace JsonUtils
