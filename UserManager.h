#pragma once

#include <QLoggingCategory>
#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>

Q_DECLARE_LOGGING_CATEGORY(userManager)

class UserManager : public QObject {
  Q_OBJECT

public:
  explicit UserManager(QSqlDatabase &db, QObject *parent = nullptr);

  Q_INVOKABLE bool insertUser(const QString &name, const QString &email,
                              const QString &password,
                              const QString &bloodGroup,
                              const QString &healthInfo);
  Q_INVOKABLE bool userLogin(const QString &email, const QString &password);
  Q_INVOKABLE QVariantMap getUserData(const QString &email);
  Q_INVOKABLE bool deleteUser(const QString &email, const QString &password);
  Q_INVOKABLE bool changeUserPassword(const QString &email,
                                      const QString &oldPassword,
                                      const QString &newPassword);
  Q_INVOKABLE bool updateUserProfile(const QString &email,
                                     const QVariantMap &userData);
  Q_INVOKABLE QVariantList searchDonors(const QString &bloodGroup,
                                        const QString &location);
  Q_INVOKABLE int getUserTotalDonations(const QString &email);
  Q_INVOKABLE QString getUserLastDonation(const QString &email);

signals:
  void userDeleted(const QString &userEmail);

private:
  QSqlDatabase &m_db;
  QString hashPassword(const QString &password);
};
