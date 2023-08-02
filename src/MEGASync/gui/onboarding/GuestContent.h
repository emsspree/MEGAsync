#ifndef GUESTCONTENT_H
#define GUESTCONTENT_H

#include "qml/QmlDialogWrapper.h"

class GuestContent : public QMLComponent
{
    Q_OBJECT

public:

    explicit GuestContent(QObject *parent = 0);
    ~GuestContent();

    QUrl getQmlUrl() override;

    QString contextName() override;

    Q_INVOKABLE void onAboutMEGAClicked();
    Q_INVOKABLE void onPreferencesClicked();
    Q_INVOKABLE void onExitClicked();

};

#endif // GUESTCONTENT_H
