#pragma once

#include "AskForthEmbed.h"

#include <QPointer>
#include <QString>
#include <QStringList>
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
        // Ollama options.num_ctx. OpenAI-compatible calls do not send it.
        int contextTokens = 32768;
    };

    explicit AskForthPanel(QWidget *parent = nullptr);
    ~AskForthPanel() override;

    void prepareEnvironment();
    void appendPageUrl(const QString &url);
    void setForthExeFinder(const std::function<QString()> &finder);
    void setFileOpener(const std::function<CodeEdit *(const QString &path)> &opener);
    void setOpenTabs(const std::function<QStringList()> &tabs);
    void setTabReader(const std::function<bool(const QString &path, QString *text)> &reader);
    void noteFileMoved(CodeEdit *edit, const QString &previousPath);
    void setFloating(bool floating);

signals:
    void placeToggleRequested();

protected:
    void showEvent(QShowEvent *event) override;
    bool eventFilter(QObject *watched, QEvent *event) override;

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
    void applyStreamBody(const QString &full, bool closeParens);
    void refreshReference();
    QString effectiveReference() const;
    QString referenceBlock(const QString &path) const;
    QStringList sessionSettingLines() const;
    bool sessionPresent() const;
    void rememberSession(const QString &path);
    void startNewSession(const QString &message);
    bool detachIfDisplaced(QString *reason);
    bool prepareNewSession(const QString &prompt, const QString &reference);
    bool prepareContinuation(const QString &newPrompt, bool hasPrompt, const QString &reference,
                             const QString &enhanceNote);
    void restoreSnapshot();
    QString sessionContext(const QString &reference) const;
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
    QComboBox *m_reference = nullptr;
    QCheckBox *m_library = nullptr;
    QCheckBox *m_urls = nullptr;
    QCheckBox *m_web = nullptr;
    QCheckBox *m_tools = nullptr;
    QCheckBox *m_showTranscript = nullptr;
    QPushButton *m_libraryButton = nullptr;
    QPushButton *m_place = nullptr;
    QPushButton *m_ask = nullptr;
    QPushButton *m_newSession = nullptr;
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
    std::function<QStringList()> m_openTabs;
    std::function<bool(const QString &path, QString *text)> m_tabReader;

    QPointer<CodeEdit> m_edit;
    QString m_askPath;
    QString m_reply;
    QString m_snapshot;
    QString m_preface;
    bool m_hasSnapshot = false;
    bool m_continued = false;
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
