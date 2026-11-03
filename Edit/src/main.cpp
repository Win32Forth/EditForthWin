#include "MainWindow.h"

#include <QApplication>
#include <QFileInfo>
#include <QStandardPaths>

int main(int argc, char *argv[]) {
    Q_UNUSED(argc);
    Q_UNUSED(argv);
    QApplication app(argc, argv);
    QApplication::setApplicationName(QStringLiteral("EditForthWin"));
    QApplication::setOrganizationName(QStringLiteral("Win32Forth"));

    MainWindow window;
    window.resize(960, 700);
    window.show();

    const QStringList args = QApplication::arguments();
    for (int i = 1; i < args.size(); ++i)
        window.openFile(args.at(i));
    if (window.tabCount() == 0) {
        const QString start = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) +
                              QStringLiteral("/EditForthWin/Docs/GettingStarted.txt");
        if (QFileInfo::exists(start))
            window.openFile(start);
        else
            window.newFile();
    }

    return app.exec();
}
