#include "DatabaseManager.h"
#include "DatabaseConfig.h"
#include "DatabaseError.h"
#include <QFile>
#include <QSqlError>
#include <QSqlQuery>

Q_LOGGING_CATEGORY(dbManager, "database.manager")

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {}

DatabaseManager::~DatabaseManager() { close(); }

bool DatabaseManager::initialize() {
  QString dbName = DatabaseConfig::getDatabaseName();
  m_database = QSqlDatabase::addDatabase("QSQLITE");
  m_database.setDatabaseName(dbName);

  if (!m_database.open()) {
    qCCritical(dbManager) << "Error opening database:"
                          << m_database.lastError().text();
    throw DatabaseError(DatabaseError::ErrorType::ConnectionError,
                        "Failed to open database");
  }

  if (!createTables()) {
    throw DatabaseError(DatabaseError::ErrorType::QueryError,
                        "Failed to create tables");
  }

  m_userManager = std::make_unique<UserManager>(m_database);
  m_hospitalManager = std::make_unique<HospitalManager>(m_database);
  m_donationManager = std::make_unique<DonationManager>(m_database);
  m_appointmentManager = std::make_unique<AppointmentManager>(m_database);

  setupConnections();

  qCInfo(dbManager) << "Database initialized successfully";
  return true;
}

void DatabaseManager::close() {
  if (m_database.isOpen()) {
    m_database.close();
    qCInfo(dbManager) << "Database closed";
  }
}

bool DatabaseManager::createTables() {
  QSqlQuery query;

  // Users table
  if (!query.exec("CREATE TABLE IF NOT EXISTS users ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "name TEXT NOT NULL, "
                  "email TEXT UNIQUE NOT NULL, "
                  "password TEXT NOT NULL, "
                  "blood_group TEXT NOT NULL, "
                  "health_info TEXT, "
                  "contact_number TEXT, "
                  "address TEXT)")) {
    qCCritical(dbManager) << "Error creating users table:"
                          << query.lastError().text();
    return false;
  }

  // Hospitals table
  if (!query.exec("CREATE TABLE IF NOT EXISTS hospitals ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "name TEXT NOT NULL, "
                  "email TEXT UNIQUE NOT NULL, "
                  "password TEXT NOT NULL, "
                  "contact_number TEXT NOT NULL, "
                  "address TEXT NOT NULL, "
                  "city TEXT NOT NULL, "
                  "state TEXT NOT NULL, "
                  "country TEXT NOT NULL, "
                  "zip TEXT NOT NULL, "
                  "license TEXT NOT NULL)")) {
    qCCritical(dbManager) << "Error creating hospitals table:"
                          << query.lastError().text();
    return false;
  }

  // Blood donations table
  if (!query.exec("CREATE TABLE IF NOT EXISTS blood_donations ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "user_id INTEGER NOT NULL, "
                  "donation_date DATETIME NOT NULL, "
                  "blood_amount REAL NOT NULL, "
                  "FOREIGN KEY (user_id) REFERENCES users(id))")) {
    qCCritical(dbManager) << "Error creating blood_donations table:"
                          << query.lastError().text();
    return false;
  }

  // Appointments table
  if (!query.exec("CREATE TABLE IF NOT EXISTS appointments ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "user_id INTEGER NOT NULL, "
                  "hospital_id INTEGER NOT NULL, "
                  "appointment_date DATETIME NOT NULL, "
                  "health_condition TEXT, "
                  "status TEXT DEFAULT 'scheduled', "
                  "FOREIGN KEY (user_id) REFERENCES users(id), "
                  "FOREIGN KEY (hospital_id) REFERENCES hospitals(id))")) {
    qCCritical(dbManager) << "Error creating appointments table:"
                          << query.lastError().text();
    return false;
  }

  qCInfo(dbManager) << "All tables created successfully";
  return true;
}

void DatabaseManager::setupConnections() {
  connect(m_userManager.get(), &UserManager::userDeleted,
          m_appointmentManager.get(),
          &AppointmentManager::removeUserAppointments);
  connect(m_hospitalManager.get(), &HospitalManager::hospitalDeleted,
          m_appointmentManager.get(),
          &AppointmentManager::removeHospitalAppointments);
}

bool DatabaseManager::backupDatabase(const QString &backupPath) {
  if (!m_database.isOpen()) {
    qCCritical(dbManager) << "Database is not open";
    return false;
  }

  if (!QFile::copy(m_database.databaseName(), backupPath)) {
    qCCritical(dbManager) << "Failed to create database backup";
    return false;
  }

  qCInfo(dbManager) << "Database backup created successfully at" << backupPath;
  return true;
}

bool DatabaseManager::isDatabaseConnected() const {
  return m_database.isOpen();
}

QString DatabaseManager::getLastError() const { return m_lastError; }
