#include "AppointmentManager.h"
#include <QDateTime>
#include <QSqlError>
#include <QSqlQuery>

Q_LOGGING_CATEGORY(appointmentManager, "database.appointment")

AppointmentManager::AppointmentManager(QSqlDatabase &db, QObject *parent)
    : QObject(parent), m_db(db) {}

bool AppointmentManager::scheduleAppointment(const QString &userEmail,
                                             const QString &hospitalEmail,
                                             const QDateTime &appointmentDate) {
  QSqlQuery query(m_db);
  query.prepare(
      "INSERT INTO appointments (user_id, hospital_id, appointment_date) "
      "SELECT u.id, h.id, :appointmentDate "
      "FROM users u, hospitals h "
      "WHERE u.email = :userEmail AND h.email = :hospitalEmail");
  query.bindValue(":userEmail", userEmail);
  query.bindValue(":hospitalEmail", hospitalEmail);
  query.bindValue(":appointmentDate", appointmentDate);

  if (query.exec()) {
    qCInfo(appointmentManager) << "Appointment scheduled successfully";
    return true;
  } else {
    qCCritical(appointmentManager)
        << "Error scheduling appointment:" << query.lastError().text();
    return false;
  }
}

QVariantList AppointmentManager::getUserAppointments(const QString &userEmail) {
  QVariantList appointments;
  QSqlQuery query(m_db);
  query.prepare("SELECT a.id, a.appointment_date, h.name as hospital_name "
                "FROM appointments a "
                "JOIN hospitals h ON a.hospital_id = h.id "
                "JOIN users u ON a.user_id = u.id "
                "WHERE u.email = :userEmail "
                "ORDER BY a.appointment_date");
  query.bindValue(":userEmail", userEmail);

  if (query.exec()) {
    while (query.next()) {
      QVariantMap appointment;
      appointment["id"] = query.value("id").toInt();
      appointment["date"] = query.value("appointment_date").toDateTime();
      appointment["hospitalName"] = query.value("hospital_name").toString();
      appointments.append(appointment);
    }
  } else {
    qCCritical(appointmentManager)
        << "Error fetching user appointments:" << query.lastError().text();
  }

  return appointments;
}

QVariantList
AppointmentManager::getHospitalAppointments(const QString &hospitalEmail) {
  QVariantList appointments;
  QSqlQuery query(m_db);
  query.prepare(
      "SELECT a.id, a.appointment_date, u.name as user_name, u.blood_group "
      "FROM appointments a "
      "JOIN users u ON a.user_id = u.id "
      "JOIN hospitals h ON a.hospital_id = h.id "
      "WHERE h.email = :hospitalEmail "
      "ORDER BY a.appointment_date");
  query.bindValue(":hospitalEmail", hospitalEmail);

  if (query.exec()) {
    while (query.next()) {
      QVariantMap appointment;
      appointment["id"] = query.value("id").toInt();
      appointment["date"] = query.value("appointment_date").toDateTime();
      appointment["userName"] = query.value("user_name").toString();
      appointment["bloodGroup"] = query.value("blood_group").toString();
      appointments.append(appointment);
    }
  } else {
    qCCritical(appointmentManager)
        << "Error fetching hospital appointments:" << query.lastError().text();
  }

  return appointments;
}

bool AppointmentManager::cancelAppointment(int appointmentId) {
  QSqlQuery query(m_db);
  query.prepare("DELETE FROM appointments WHERE id = :appointmentId");
  query.bindValue(":appointmentId", appointmentId);

  if (query.exec()) {
    qCInfo(appointmentManager) << "Appointment cancelled successfully";
    return true;
  } else {
    qCCritical(appointmentManager)
        << "Error cancelling appointment:" << query.lastError().text();
    return false;
  }
}

QVariantList
AppointmentManager::getAvailableTimeSlots(const QString &hospitalEmail,
                                          const QDate &date) {
  QVariantList availableSlots;
  QSqlQuery query(m_db);
  query.prepare(
      "SELECT DISTINCT TIME(appointment_date) as slot_time "
      "FROM appointments a "
      "JOIN hospitals h ON a.hospital_id = h.id "
      "WHERE h.email = :hospitalEmail AND DATE(appointment_date) = :date "
      "ORDER BY slot_time");
  query.bindValue(":hospitalEmail", hospitalEmail);
  query.bindValue(":date", date);

  if (query.exec()) {
    QSet<QTime> bookedSlots;
    while (query.next()) {
      bookedSlots.insert(query.value("slot_time").toTime());
    }

    // Generate all possible time slots (e.g., every 30 minutes from 9:00 to
    // 17:00)
    QTime startTime(9, 0);
    QTime endTime(17, 0);
    while (startTime <= endTime) {
      if (!bookedSlots.contains(startTime)) {
        availableSlots.append(startTime.toString("hh:mm"));
      }
      startTime = startTime.addSecs(30 * 60);
    }
  } else {
    qCCritical(appointmentManager)
        << "Error fetching available time slots:" << query.lastError().text();
  }

  return availableSlots;
}

void AppointmentManager::removeUserAppointments(const QString &userEmail) {
  QSqlQuery query(m_db);
  query.prepare("DELETE FROM appointments WHERE user_id = (SELECT id FROM "
                "users WHERE email = :email)");
  query.bindValue(":email", userEmail);

  if (!query.exec()) {
    qCritical() << "Failed to remove user appointments:"
                << query.lastError().text();
  }
}

void AppointmentManager::removeHospitalAppointments(
    const QString &hospitalEmail) {
  QSqlQuery query(m_db);
  query.prepare("DELETE FROM appointments WHERE hospital_id = (SELECT id FROM "
                "hospitals WHERE email = :email)");
  query.bindValue(":email", hospitalEmail);

  if (!query.exec()) {
    qCritical() << "Failed to remove hospital appointments:"
                << query.lastError().text();
  }
}
bool AppointmentManager::scheduleAppointment(const QString &userEmail,
                                             const QString &hospitalEmail,
                                             const QString &appointmentDate,
                                             const QString &healthCondition) {
  QSqlQuery query(m_db);
  query.prepare("INSERT INTO appointments (user_id, hospital_id, "
                "appointment_date, health_condition) "
                "SELECT u.id, h.id, :appointmentDate, :healthCondition "
                "FROM users u, hospitals h "
                "WHERE u.email = :userEmail AND h.email = :hospitalEmail");
  query.bindValue(":userEmail", userEmail);
  query.bindValue(":hospitalEmail", hospitalEmail);
  query.bindValue(":appointmentDate", appointmentDate);
  query.bindValue(":healthCondition", healthCondition);

  if (query.exec()) {
    qCInfo(appointmentManager) << "Appointment scheduled successfully";
    return true;
  } else {
    qCCritical(appointmentManager)
        << "Error scheduling appointment:" << query.lastError().text();
    return false;
  }
}
