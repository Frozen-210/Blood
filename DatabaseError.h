// DatabaseError.h
#ifndef DATABASEERROR_H
#define DATABASEERROR_H

#include <QString>

class DatabaseError : public std::exception
{
public:
    enum class ErrorType {
        ConnectionError,
        QueryError,
        DataError,
        UnknownError
    };

    DatabaseError(ErrorType type, const QString& message)
        : m_type(type), m_message(message) {}

    ErrorType type() const { return m_type; }
    QString message() const { return m_message; }

    const char* what() const noexcept override {
        return m_message.toUtf8().constData();
    }

private:
    ErrorType m_type;
    QString m_message;
};

#endif // DATABASEERROR_H
