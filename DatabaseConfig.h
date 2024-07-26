#ifndef DATABASECONFIG_H
#define DATABASECONFIG_H

#include <QString>
#include <QSettings>

class DatabaseConfig
{
public:
    static QString getDatabaseName() {
        QSettings settings("YourCompany", "BloodDonationApp");
        return settings.value("Database/Name", "data.db").toString();
    }

    static void setDatabaseName(const QString& name) {
        QSettings settings("YourCompany", "BloodDonationApp");
        settings.setValue("Database/Name", name);
    }

    // Add more configuration methods as needed
};

#endif // DATABASECONFIG_H
