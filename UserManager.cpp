#include "UserManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include<QDateTime>

Q_LOGGING_CATEGORY(userManager, "database.user")

UserManager::UserManager(QSqlDatabase& db, QObject *parent)
    : QObject(parent), m_db(db)
{
}

bool UserManager::insertUser(const QString &name, const QString &email, const QString &password, const QString &bloodGroup, const QString &healthInfo)
{
    QSqlQuery query(m_db);
    query.prepare("INSERT INTO users (name, email, password, blood_group, health_info) "
                  "VALUES (:name, :email, :password, :blood_group, :health_info)");
    query.bindValue(":name", name);
    query.bindValue(":email", email);
    query.bindValue(":password", hashPassword(password));
    query.bindValue(":blood_group", bloodGroup);
    query.bindValue(":health_info", healthInfo);

    if (query.exec()) {
        qCInfo(userManager) << "User inserted successfully";
        return true;
    } else {
        qCCritical(userManager) << "Error inserting user:" << query.lastError().text();
        return false;
    }
}

bool UserManager::userLogin(const QString &email, const QString &password)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM users WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(password) == storedPassword) {
            qCInfo(userManager) << "User login successful";
            return true;
        } else {
            qCInfo(userManager) << "User login failed: incorrect password";
            return false;
        }
    } else {
        qCInfo(userManager) << "User login failed: user not found";
        return false;
    }
}

QVariantMap UserManager::getUserData(const QString &email)
{
    QVariantMap userData;
    QSqlQuery query(m_db);
    query.prepare("SELECT name, email, blood_group, health_info, contact_number, address "
                  "FROM users WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        userData["name"] = query.value("name").toString();
        userData["email"] = query.value("email").toString();
        userData["bloodGroup"] = query.value("blood_group").toString();
        userData["healthInfo"] = query.value("health_info").toString();
        userData["contactNumber"] = query.value("contact_number").toString();
        userData["address"] = query.value("address").toString();
    } else {
        qCCritical(userManager) << "Error fetching user data:" << query.lastError().text();
    }

    return userData;
}

bool UserManager::deleteUser(const QString &email, const QString &password)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM users WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(password) == storedPassword) {
            query.prepare("DELETE FROM users WHERE email = :email");
            query.bindValue(":email", email);
            if (query.exec()) {
                qCInfo(userManager) << "User deleted successfully";
                emit userDeleted(email);
                return true;
            } else {
                qCCritical(userManager) << "Error deleting user:" << query.lastError().text();
            }
        } else {
            qCInfo(userManager) << "Incorrect password for user deletion";
        }
    } else {
        qCInfo(userManager) << "User not found for deletion";
    }
    return false;
}

bool UserManager::changeUserPassword(const QString &email, const QString &oldPassword, const QString &newPassword)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM users WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(oldPassword) == storedPassword) {
            query.prepare("UPDATE users SET password = :newPassword WHERE email = :email");
            query.bindValue(":newPassword", hashPassword(newPassword));
            query.bindValue(":email", email);
            if (query.exec()) {
                qCInfo(userManager) << "User password changed successfully";
                return true;
            } else {
                qCCritical(userManager) << "Error changing user password:" << query.lastError().text();
            }
        } else {
            qCInfo(userManager) << "Incorrect old password for user";
        }
    } else {
        qCInfo(userManager) << "User not found for password change";
    }
    return false;
}

bool UserManager::updateUserProfile(const QString &email, const QVariantMap &userData)
{
    QSqlQuery query(m_db);
    query.prepare("UPDATE users SET name = :name, blood_group = :bloodGroup, "
                  "health_info = :healthInfo, contact_number = :contactNumber, "
                  "address = :address WHERE email = :email");
    query.bindValue(":name", userData["name"].toString());
    query.bindValue(":bloodGroup", userData["bloodGroup"].toString());
    query.bindValue(":healthInfo", userData["healthInfo"].toString());
    query.bindValue(":contactNumber", userData["contactNumber"].toString());
    query.bindValue(":address", userData["address"].toString());
    query.bindValue(":email", email);

    if (query.exec()) {
        qCInfo(userManager) << "User profile updated successfully";
        return true;
    } else {
        qCCritical(userManager) << "Error updating user profile:" << query.lastError().text();
        return false;
    }
}

QVariantList UserManager::searchDonors(const QString &bloodGroup, const QString &location)
{
    QVariantList donors;
    QSqlQuery query(m_db);
    query.prepare("SELECT name, email, blood_group, address FROM users "
                  "WHERE blood_group = :bloodGroup AND address LIKE :location");
    query.bindValue(":bloodGroup", bloodGroup);
    query.bindValue(":location", "%" + location + "%");

    if (query.exec()) {
        while (query.next()) {
            QVariantMap donor;
            donor["name"] = query.value("name").toString();
            donor["email"] = query.value("email").toString();
            donor["bloodGroup"] = query.value("blood_group").toString();
            donor["address"] = query.value("address").toString();
            donors.append(donor);
        }
    } else {
        qCCritical(userManager) << "Error searching donors:" << query.lastError().text();
    }

    return donors;
}

int UserManager::getUserTotalDonations(const QString &email)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT COUNT(*) FROM blood_donations "
                  "JOIN users ON blood_donations.user_id = users.id "
                  "WHERE users.email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    } else {
        qCCritical(userManager) << "Error fetching user total donations:" << query.lastError().text();
        return 0;
    }
}

QString UserManager::getUserLastDonation(const QString &email)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT MAX(donation_date) FROM blood_donations "
                  "JOIN users ON blood_donations.user_id = users.id "
                  "WHERE users.email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        return query.value(0).toDateTime().toString("yyyy-MM-dd");
    } else {
        qCCritical(userManager) << "Error fetching user last donation:" << query.lastError().text();
        return "N/A";
    }
}

QString UserManager::hashPassword(const QString &password)
{
    return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
}
