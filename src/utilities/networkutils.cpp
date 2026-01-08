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

#include "networkutils.h"
#include <QtNetwork/qnetworkaccessmanager.h>
#include <QtNetwork/qnetworkreply.h>
#include <QSslConfiguration>
#include <QtNetwork/qsslconfiguration.h>
#include <QtNetwork/qsslsocket.h>

namespace NetworkUtils {

/**
 * @brief Creates a more or less "default" network access manager.
 *
 * This creates a network manager which acts more or less like a default constructed
 * QNetworkAccessManager. The resulting manager will be owned by the @p parent.
 */
NetworkAccessManager::NetworkAccessManager(QObject* parent)
    : QNetworkAccessManager(parent), m_ignoreSslErrors(m_defaultIgnoreSslErrors)
{
    setupNetworkAccessManager();
}

/**
 * @brief Create a network access manager which validates SSL connections based on a boolean flag.
 *
 * This creates a new network access manager owned by @p parent. Depending on the boolean
 * reference flag @p ignoreSslErrors, SSL connection errors are ignored or not.
 *
 * @note The bool value must outlive the manager! If you need to create a manager which
 *       you want to configure once with a fixed value, use the appropriate constructor.
 */
NetworkAccessManager::NetworkAccessManager(bool& ignoreSslErrors, QObject* parent)
    : QNetworkAccessManager(parent), m_ignoreSslErrors(ignoreSslErrors)
{
    setupNetworkAccessManager();
}

QNetworkReply* NetworkAccessManager::createRequest(Operation op, const QNetworkRequest& request,
                                                   QIODevice* outgoingData)
{
    auto reply = QNetworkAccessManager::createRequest(op, request, outgoingData);
    if (m_ignoreSslErrors) {
        QSslConfiguration sslConfig = QSslConfiguration::defaultConfiguration();
        sslConfig.setPeerVerifyMode(QSslSocket::VerifyNone);
        reply->setSslConfiguration(sslConfig);
    }
    return reply;
}

/**
 * @brief The default if SSL error shall be ignored.
 *
 * This value is used if the default constructor was used. Otherwise, the value
 * is actually controlled by the reference passed in the contructor.
 */
bool NetworkAccessManager::defaultIgnoreSslErrors() const
{
    return m_defaultIgnoreSslErrors;
}

/**
 * @brief Set if SSL errors shall be ignored.
 *
 * This sets the appropriate value to @p newDefaultIgnoreSslErrors. Note that if the
 * constructor which allows a reference to a flag being passed in was used, this has no
 * effect.
 */
void NetworkAccessManager::setDefaultIgnoreSslErrors(bool newDefaultIgnoreSslErrors)
{
    m_defaultIgnoreSslErrors = newDefaultIgnoreSslErrors;
}

void NetworkAccessManager::setupNetworkAccessManager()
{
    setRedirectPolicy(QNetworkRequest::NoLessSafeRedirectPolicy);

    connect(this, &QNetworkAccessManager::sslErrors, this,
            [=](QNetworkReply* reply, const QList<QSslError>& errors) {
                if (m_ignoreSslErrors) {
                    reply->ignoreSslErrors(errors);
                }
            });
}

} // namespace NetworkUtils
