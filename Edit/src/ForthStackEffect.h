#pragma once

#include <QString>
#include <QStringList>

// Deterministic data-stack model for Ask Forth. Same rules as the Mac
// ForthStackEffect checker: each colon starts empty, an underflow is an
// input, and a comment marked copy is the one to keep.
namespace ForthStackEffect {

QString promptRule();
// Empty when the text has no closed colon definition.
QString report(const QString &source);
QString toolResult(const QString &source);
QStringList selfCheckFailures();

} // namespace ForthStackEffect
