/*
 * Copyright 2025 Martin Hoeher <martin@rpdev.net>
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

#ifndef UTILITIES_NETWORKUTILS_H_
#define UTILITIES_NETWORKUTILS_H_

#include <QNetworkAccessManager>
#include <QtNetwork/qnetworkaccessmanager.h>

namespace NetworkUtils {

class NetworkAccessManager : public QNetworkAccessManager
{
public:
    explicit NetworkAccessManager(QObject* parent = nullptr);
    explicit NetworkAccessManager(bool& ignoreSslErrors, QObject* parent = nullptr);

    NetworkAccessManager(const NetworkAccessManager&) = delete;
    NetworkAccessManager(NetworkAccessManager&&) = delete;
    NetworkAccessManager& operator=(const NetworkAccessManager&) = delete;
    NetworkAccessManager& operator=(NetworkAccessManager&&) = delete;

    bool defaultIgnoreSslErrors() const;
    void setDefaultIgnoreSslErrors(bool newDefaultIgnoreSslErrors);

    // QNetworkAccessManager interface
protected:
    QNetworkReply* createRequest(Operation op, const QNetworkRequest& request,
                                 QIODevice* outgoingData) override;

private:
    bool& m_ignoreSslErrors; // A reference to a bool flag indicating if we shall ignore SSL errors.
    bool m_defaultIgnoreSslErrors =
            false; // The "default" for ignoring SSL errors and the user did not
                   // provide a reference to a bool flag in the constructor.

    void setupNetworkAccessManager();
};

} // namespace NetworkUtils

#endif // UTILITIES_NETWORKUTILS_H_
