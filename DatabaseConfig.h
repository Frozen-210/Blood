#ifndef DATABASECONFIG_H
#define DATABASECONFIG_H

#include <QSettings>
#include <QString>

class DatabaseConfig {
public:
  static QString getDatabaseName() {
    QSettings settings("bloodbound", "BloodDonationApp");
    return settings.value("Database/Name", "bloodbound.db").toString();
  }

  static void setDatabaseName(const QString &name) {
    QSettings settings("bloodbound", "BloodDonationApp");
    settings.setValue("Database/Name", name);
  }

  // Add more configuration methods as needed
};

#endif // DATABASECONFIG_H
