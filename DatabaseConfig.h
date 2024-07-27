#ifndef DATABASECONFIG_H
#define DATABASECONFIG_H

#include <QSettings>
#include <QString>

class DatabaseConfig {
public:
  static QString getDatabaseName() {
    QSettings settings("YourCompany", "BloodDonationApp");
    return settings.value("Database/Name", "appdatabase.db").toString();
  }

  static void setDatabaseName(const QString &name) {
    QSettings settings("YourCompany", "BloodDonationApp");
    settings.setValue("Database/Name", name);
  }

  // Add more configuration methods as needed
};

#endif // DATABASECONFIG_H
