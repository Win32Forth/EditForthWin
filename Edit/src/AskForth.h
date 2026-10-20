#pragma once

#include "AskForthEmbed.h"

#include <QPointer>
#include <QString>
#include <QVariantMap>
#include <QWidget>

#include <functional>

class CodeEdit;
class QCheckBox;
class QComboBox;
class QLabel;
class QPlainTextEdit;
class QPushButton;
class QShortcut;
class QThread;

// Trailing Ask Forth inspector. Replies stream into
// Documents/EditForthWin/AskForth/AskForth-N.fth.
class AskForthPanel : public QWidget {
    Q_OBJECT
public:
    struct Profile {
        QString id;
        QString name;
        QString provider;
        QString model;
        QString base;
        double temperature = 0.3;
    };

    explicit AskForthPanel(QWidget *parent = nullptr);
    ~AskForthPanel() override;

    void prepareEnvironment();
    void appendPageUrl(const QString &url);
    void setForthExeFinder(const std::function<QString()> &finder);
    void setFileOpener(const std::function<CodeEdit *(const QString &path)> &opener);
    void setFloating(bool floating);

signals:
    void placeToggleRequested();

protected:
    void showEvent(QShowEvent *event) override;

private:
    void buildUi();
    void reloadProfiles();
    void selectProfile(int index);
    void editModels();
    void editLibrary();
    void openOutputFolder();
    void ask();
    void enhance();
    void stop();
    void refreshBanner();
    void finishBanner(const QString &chat);
    void startIndex(bool force);
    void setBanner(const QString &text);
    void setStatus(const QString &text);
    Profile profileById(const QString &id) const;
    QVariantMap jobFor(const Profile &profile, const QString &system, const QString &user, const QString &rag,
                       bool enhance) const;
    void launch(const QVariantMap &job);
    void startEnhance(const QString &transcript);
    bool beginStreamFile(const QString &header);
    void setBusy(bool busy, const QString &askTitle);
    void applyStreamBody(const QString &full);
    void insertAudit(const QString &comments);
    void saveAskFile();
    QString activeId() const;

    class Worker;
    Worker *m_worker = nullptr;
    QThread *m_thread = nullptr;
    AskForthIndexer *m_indexer = nullptr;
    QThread *m_indexThread = nullptr;
    QString m_indexNote;

    QLabel *m_banner = nullptr;
    QLabel *m_caption = nullptr;
    QLabel *m_status = nullptr;
    QLabel *m_file = nullptr;
    QComboBox *m_models = nullptr;
    QCheckBox *m_library = nullptr;
    QCheckBox *m_urls = nullptr;
    QCheckBox *m_web = nullptr;
    QCheckBox *m_tools = nullptr;
    QCheckBox *m_showTranscript = nullptr;
    QPushButton *m_libraryButton = nullptr;
    QPushButton *m_place = nullptr;
    QPushButton *m_ask = nullptr;
    QPushButton *m_stopAsk = nullptr;
    QPushButton *m_enhance = nullptr;
    QPushButton *m_stopEnhance = nullptr;
    QPlainTextEdit *m_prompt = nullptr;
    QPlainTextEdit *m_transcript = nullptr;
    class QSplitter *m_promptSplit = nullptr;
    bool m_promptSplitReady = false;
    QWidget *m_transcriptBox = nullptr;

    std::function<QString()> m_exeFinder;
    std::function<CodeEdit *(const QString &)> m_openFile;

    QPointer<CodeEdit> m_edit;
    QString m_askPath;
    QString m_reply;
    int m_bodyStart = 0;
    bool m_busy = false;
    bool m_stopped = false;
    QString m_phase;
    QString m_pendingBody;
    bool m_bodyDirty = false;
    class QTimer *m_paint = nullptr;
    class QNetworkAccessManager *m_nam = nullptr;
    QShortcut *m_esc = nullptr;
};
