#include "ui/main_window.hpp"

#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>

#include "app/calculator.hpp"

namespace app::ui {

MainWindow::MainWindow(QWidget* parent) : QMainWindow(parent) {
    auto* central = new QWidget(this);
    auto* layout = new QVBoxLayout(central);

    auto* button = new QPushButton(tr("Compute"), central);
    layout->addWidget(button);

    setCentralWidget(central);

    // Correct Qt5/Qt6 functor connect syntax — Clazy verifies signal/slot use.
    connect(button, &QPushButton::clicked, this, &MainWindow::onComputeRequested);
}

void MainWindow::onComputeRequested() {
    // Uses the tested library unit so the UI links against real logic.
    const int result = computeSum();
    setWindowTitle(tr("Result: %1").arg(result));
}

int MainWindow::computeSum() const {
    const app::Calculator calc;
    return calc.add(2, 3);
}

}  // namespace app::ui
