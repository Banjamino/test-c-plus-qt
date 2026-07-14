#ifndef APP_UI_MAIN_WINDOW_HPP
#define APP_UI_MAIN_WINDOW_HPP

#include <QMainWindow>

namespace app::ui {

/// Minimal main window that demonstrates a signal/slot connection and hosts a
/// QML view. Exists to give Clazy (Qt semantics) and qmllint (QML) real input
/// for the static-analysis gates. Replace with the real UI as development starts.
class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MainWindow(QWidget* parent = nullptr);

private slots:
    void onComputeRequested();

private:
    int computeSum() const;
};

}  // namespace app::ui

#endif  // APP_UI_MAIN_WINDOW_HPP
