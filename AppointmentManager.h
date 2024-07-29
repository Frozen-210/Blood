#pragma once

#include "qtmetamacros.h"
#include <QLoggingCategory>
#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>

Q_DECLARE_LOGGING_CATEGORY(appointmentManager)

class AppointmentManager : public QObject {
  Q_OBJECT

public:
  explicit AppointmentManager(QSqlDatabase &db, QObject *parent = nullptr);

  // When no healthCondition are given calls this function

  Q_INVOKABLE bool scheduleAppointment(const QString &userEmail,
                                       const QString &hospitalEmail,
                                       const QDateTime &appointmentDate);

  Q_INVOKABLE QVariantList getUserAppointments(const QString &userEmail);
  Q_INVOKABLE QVariantList
  getHospitalAppointments(const QString &hospitalEmail);
  Q_INVOKABLE bool cancelAppointment(int appointmentId);
  Q_INVOKABLE QVariantList getAvailableTimeSlots(const QString &hospitalEmail,
                                                 const QDate &date);
  Q_INVOKABLE bool scheduleAppointment(const QString &userEmail,
                                       const QString &hospitalEmail,
                                       const QString &appointmentDate,
                                       const QString &healthCondition);

public slots:
  void removeUserAppointments(const QString &userEmail);
  void removeHospitalAppointments(const QString &hospitalEmail);

private:
  QSqlDatabase &m_db;
};
