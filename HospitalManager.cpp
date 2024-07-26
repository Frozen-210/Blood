#include "HospitalManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>

Q_LOGGING_CATEGORY(hospitalManager, "database.hospital")

HospitalManager::HospitalManager(QSqlDatabase& db, QObject *parent)
    : QObject(parent), m_db(db)
{
}

bool HospitalManager::insertHospital(const QString &name, const QString &email, const QString &password,
                                     const QString &contactNumber, const QString &address, const QString &city,
                                     const QString &state, const QString &country, const QString &zip,
                                     const QString &license)
{
    QSqlQuery query(m_db);
    query.prepare("INSERT INTO hospitals (name, email, password, contact_number, address, city, state, country, zip, license) "
                  "VALUES (:name, :email, :password, :contact_number, :address, :city, :state, :country, :zip, :license)");

    query.bindValue(":name", name);
    query.bindValue(":email", email);
    query.bindValue(":password", hashPassword(password));
    query.bindValue(":contact_number", contactNumber);
    query.bindValue(":address", address);
    query.bindValue(":city", city);
    query.bindValue(":state", state);
    query.bindValue(":country", country);
    query.bindValue(":zip", zip);
    query.bindValue(":license", license);

    if (query.exec()) {
        qCInfo(hospitalManager) << "Hospital inserted successfully";
        return true;
    } else {
        qCCritical(hospitalManager) << "Error inserting hospital:" << query.lastError().text();
        return false;
    }
}

bool HospitalManager::hospitalLogin(const QString &email, const QString &password)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM hospitals WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(password) == storedPassword) {
            qCInfo(hospitalManager) << "Hospital login successful";
            return true;
        } else {
            qCInfo(hospitalManager) << "Hospital login failed: incorrect password";
            return false;
        }
    } else {
        qCInfo(hospitalManager) << "Hospital login failed: hospital not found";
        return false;
    }
}

QVariantMap HospitalManager::getHospitalData(const QString &email)
{
    QVariantMap hospitalData;
    QSqlQuery query(m_db);
    query.prepare("SELECT name, email, contact_number, address, city, state, country, zip, license "
                  "FROM hospitals WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        hospitalData["name"] = query.value("name").toString();
        hospitalData["email"] = query.value("email").toString();
        hospitalData["contactNumber"] = query.value("contact_number").toString();
        hospitalData["address"] = query.value("address").toString();
        hospitalData["city"] = query.value("city").toString();
        hospitalData["state"] = query.value("state").toString();
        hospitalData["country"] = query.value("country").toString();
        hospitalData["zip"] = query.value("zip").toString();
        hospitalData["license"] = query.value("license").toString();
    } else {
        qCCritical(hospitalManager) << "Error fetching hospital data:" << query.lastError().text();
    }

    return hospitalData;
}

bool HospitalManager::deleteHospital(const QString &email, const QString &password)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM hospitals WHERE email = :email");
    query.bindValue(":email", email);
    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(password) == storedPassword) {
            query.prepare("DELETE FROM hospitals WHERE email = :email");
            query.bindValue(":email", email);
            if (query.exec()) {
                qCInfo(hospitalManager) << "Hospital deleted successfully";
                emit hospitalDeleted(email);
                return true;
            } else {
                qCCritical(hospitalManager) << "Error deleting hospital:" << query.lastError().text();
            }
        } else {
            qCInfo(hospitalManager) << "Incorrect password for hospital deletion";
        }
    } else {
        qCInfo(hospitalManager) << "Hospital not found for deletion";
    }
    return false;
}

bool HospitalManager::changeHospitalPassword(const QString &email, const QString &oldPassword, const QString &newPassword)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM hospitals WHERE email = :email");
    query.bindValue(":email", email);

    if (query.exec() && query.next()) {
        QString storedPassword = query.value("password").toString();
        if (hashPassword(oldPassword) == storedPassword) {
            query.prepare("UPDATE hospitals SET password = :newPassword WHERE email = :email");
            query.bindValue(":newPassword", hashPassword(newPassword));
            query.bindValue(":email", email);
            if (query.exec()) {
                qCInfo(hospitalManager) << "Hospital password changed successfully";
                return true;
            } else {
                qCCritical(hospitalManager) << "Error changing hospital password:" << query.lastError().text();
            }
        } else {
            qCInfo(hospitalManager) << "Incorrect old password for hospital";
        }
    } else {
        qCInfo(hospitalManager) << "Hospital not found for password change";
    }
    return false;
}

bool HospitalManager::updateHospitalProfile(const QString &email, const QVariantMap &hospitalData)
{
    QSqlQuery query(m_db);
    query.prepare("UPDATE hospitals SET name = :name, contact_number = :contactNumber, "
                  "address = :address, city = :city, state = :state, "
                  "country = :country, zip = :zip, license = :license "
                  "WHERE email = :email");
    query.bindValue(":name", hospitalData["name"].toString());
    query.bindValue(":contactNumber", hospitalData["contactNumber"].toString());
    query.bindValue(":address", hospitalData["address"].toString());
    query.bindValue(":city", hospitalData["city"].toString());
    query.bindValue(":state", hospitalData["state"].toString());
    query.bindValue(":country", hospitalData["country"].toString());
    query.bindValue(":zip", hospitalData["zip"].toString());
    query.bindValue(":license", hospitalData["license"].toString());
    query.bindValue(":email", email);

    if (query.exec()) {
        qCInfo(hospitalManager) << "Hospital profile updated successfully";
        return true;
    } else {
        qCCritical(hospitalManager) << "Error updating hospital profile:" << query.lastError().text();
        return false;
    }
}

QVariantList HospitalManager::getHospitalList()
{
    QVariantList hospitals;
    QSqlQuery query(m_db);
    query.prepare("SELECT name, email, city, state FROM hospitals");

    if (query.exec()) {
        while (query.next()) {
            QVariantMap hospital;
            hospital["name"] = query.value("name").toString();
            hospital["email"] = query.value("email").toString();
            hospital["city"] = query.value("city").toString();
            hospital["state"] = query.value("state").toString();
            hospitals.append(hospital);
        }
    } else {
        qCCritical(hospitalManager) << "Error fetching hospital list:" << query.lastError().text();
    }

    return hospitals;
}

QVariantMap HospitalManager::getBloodInventoryLevels(const QString &hospitalEmail)
{
    QVariantMap inventory;
    QSqlQuery query(m_db);
    query.prepare("SELECT blood_group, SUM(blood_amount) as total_amount "
                  "FROM blood_donations "
                  "JOIN users ON blood_donations.user_id = users.id "
                  "JOIN appointments ON appointments.user_id = users.id "
                  "JOIN hospitals ON appointments.hospital_id = hospitals.id "
                  "WHERE hospitals.email = :hospitalEmail "
                  "GROUP BY blood_group");
    query.bindValue(":hospitalEmail", hospitalEmail);

    if (query.exec()) {
        while (query.next()) {
            QString bloodGroup = query.value("blood_group").toString();
            double totalAmount = query.value("total_amount").toDouble();
            inventory[bloodGroup] = totalAmount;
        }
    } else {
        qCCritical(hospitalManager) << "Error fetching blood inventory levels:" << query.lastError().text();
    }

    return inventory;
}

QString HospitalManager::hashPassword(const QString &password)
{
    return QString(QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex());
}
