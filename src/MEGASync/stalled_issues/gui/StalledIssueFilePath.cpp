#include "StalledIssueFilePath.h"
#include "ui_StalledIssueFilePath.h"

#include "Utilities.h"
#include "Platform.h"

#include <QPainter>
#include <QPoint>

StalledIssueFilePath::StalledIssueFilePath(QWidget *parent) :
    StalledIssueBaseDelegateWidget(parent),
    ui(new Ui::StalledIssueFilePath)
{
    ui->setupUi(this);
    ui->filePathAction->hide();

    ui->moveLines->installEventFilter(this);
    ui->lines->installEventFilter(this);

    ui->filePathContainer->installEventFilter(this);

    auto openIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/StalledIssues/ic-open-outside.png"));
    ui->filePathAction->setPixmap(openIcon.pixmap(ui->filePathAction->size()));
    ui->moveFilePathAction->setPixmap(openIcon.pixmap(ui->moveFilePathAction->size()));
}

StalledIssueFilePath::~StalledIssueFilePath()
{
    delete ui;
}

void StalledIssueFilePath::fillFilePath()
{
    //The file path always get the first StalledIssueDataPtr
    const auto& data = getData().getStalledIssueData();

    if(data->mIsCloud)
    {
        auto remoteIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/cloud_upload_item_ico.png"));
        ui->LocalOrRemoteIcon->setPixmap(remoteIcon.pixmap(ui->LocalOrRemoteIcon->size()));

        ui->LocalOrRemoteText->setText(tr("on MEGA:"));
    }
    else
    {
        auto localIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/StalledIssues/PC_ico_rest.png"));
        ui->LocalOrRemoteIcon->setPixmap(localIcon.pixmap(ui->LocalOrRemoteIcon->size()));

        ui->LocalOrRemoteText->setText(tr("Local:"));
    }

    fillPathName(data, ui->filePath);

    QIcon fileTypeIcon;
    auto splittedFile = getData().getFileName().split(QString::fromUtf8("."));
    if(splittedFile.size() != 1)
    {
        fileTypeIcon = Utilities::getCachedPixmap(Utilities::getExtensionPixmapName(
                                                           getData().getFileName(), QLatin1Literal(":/images/drag_")));
    }
    else
    {
        fileTypeIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/color_folder.png"));
    }

    ui->filePathIcon->setPixmap(fileTypeIcon.pixmap(ui->filePathIcon->size()));
}

void StalledIssueFilePath::fillMoveFilePath()
{
    //The file path always get the first StalledIssueDataPtr
    const auto& data = getData().getStalledIssueData();

    if(data->hasMoveInfo())
    {
        fillPathName(data, ui->moveFilePath);
    }
    else
    {
        ui->moveFile->hide();
    }
}

void StalledIssueFilePath::setIndent(int indent)
{
    ui->indent->changeSize(indent,0,QSizePolicy::Fixed, QSizePolicy::Preferred);
    ui->gridLayout->invalidate();
}

void StalledIssueFilePath::refreshUi()
{
    fillFilePath();
    fillMoveFilePath();
}

bool StalledIssueFilePath::eventFilter(QObject *watched, QEvent *event)
{
    if(watched == ui->lines && event->type() == QEvent::Paint)
    {
        QPainter p(ui->lines);
        p.setPen(QPen(QColor("#D6D6D6"),1));

        auto width(ui->lines->width());
        auto height(ui->lines->height());

        p.drawLine(QPoint(width/2,0), QPoint(width/2, ui->lines->height()/2));
        p.drawLine(QPoint(width/2,height/2), QPoint(width, height/2));
    }
    else if(watched == ui->moveLines && event->type() == QEvent::Paint)
    {
        QPainter p(ui->moveLines);
        p.setPen(QPen(QColor("#D6D6D6"),1));

        auto width(ui->lines->width());
        auto height(ui->lines->height());

        p.drawLine(QPoint(width/2,0), QPoint(width/2, ui->lines->height()));
        p.drawLine(QPoint(width/2,height/2), QPoint(width, height/2));
    }
    else if(watched == ui->filePathContainer)
    {
       if(event->type() == QEvent::Enter)
       {
           ui->filePathAction->show();
       }
       else if(event->type() == QEvent::Leave)
       {
           ui->filePathAction->hide();
       }
       else if(event->type() == QEvent::MouseButtonRelease)
       {
           const auto& data = getData().getStalledIssueData();

           if(data)
           {
               if(data->mIsCloud)
               {
                   mega::MegaNode* node (MegaSyncApp->getMegaApi()->getNodeByPath(ui->filePath->text().toStdString().c_str()));
                   if (node)
                   {
                       const char* handle = node->getBase64Handle();
                       QString url = QString::fromUtf8("mega://#fm/") + QString::fromUtf8(handle);
                       QtConcurrent::run(QDesktopServices::openUrl, QUrl(url));
                       delete [] handle;
                       delete node;
                   }
               }
               else
               {
                   QtConcurrent::run([=]
                   {
                       if (!data->mIndexPath.isEmpty())
                       {
                           Platform::showInFolder(ui->filePath->text());
                       }
                   });
               }
           }
       }
    }
    return StalledIssueBaseDelegateWidget::eventFilter(watched, event);
}


void StalledIssueFilePath::fillPathName(const StalledIssueDataPtr &data, QLabel* label)
{
    QIcon fileTypeIcon;

    bool mInRed(false);
    auto path = data->mIndexPath;
    if(data->mIsMissing)
    {
        fileTypeIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/ico_question_hover.png"));
        path.append(QString::fromUtf8(" (missing)"));

        mInRed = true;
    }
    else
    {
        if(data->mIsBlocked)
        {
            path.append(QString::fromUtf8(" (blocked)"));

            mInRed = true;
        }

        auto splittedFile = getData().getFileName().split(QString::fromUtf8("."));
        if(splittedFile.size() != 1)
        {
            fileTypeIcon = Utilities::getCachedPixmap(Utilities::getExtensionPixmapName(
                                                          getData().getFileName(), QLatin1Literal(":/images/drag_")));
        }
        else
        {
            fileTypeIcon = Utilities::getCachedPixmap(QLatin1Literal(":/images/color_folder.png"));
        }
    }

    ui->moveFilePathIcon->setPixmap(fileTypeIcon.pixmap(ui->moveFilePathIcon->size()));
    label->setText(path);

    if(mInRed)
    {
        label->setStyleSheet(QStringLiteral("color: red;"));
    }
    else
    {
        label->setStyleSheet(QString());
    }
}
