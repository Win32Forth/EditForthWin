#include "ForthStackEffect.h"

#include <QCoreApplication>
#include <QTextStream>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    QTextStream out(stdout);
    QTextStream err(stderr);
    const QStringList fails = ForthStackEffect::selfCheckFailures();
    if (fails.isEmpty()) {
        out << "stack-check-ok\n";
        return 0;
    }
    for (const QString &fail : fails)
        err << fail << "\n";
    err << fails.size() << " failed\n";
    return 1;
}
