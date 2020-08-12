# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'insta_login.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(407, 254)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.login_btn = QtWidgets.QPushButton(self.centralwidget)
        self.login_btn.setGeometry(QtCore.QRect(250, 90, 91, 71))
        self.login_btn.setObjectName("login_btn")
        self.Name = QtWidgets.QLabel(self.centralwidget)
        self.Name.setGeometry(QtCore.QRect(70, 10, 291, 61))
        self.Name.setObjectName("Name")
        self.id = QtWidgets.QLabel(self.centralwidget)
        self.id.setGeometry(QtCore.QRect(70, 100, 21, 16))
        self.id.setObjectName("id")
        self.pw = QtWidgets.QLabel(self.centralwidget)
        self.pw.setGeometry(QtCore.QRect(20, 130, 71, 20))
        self.pw.setObjectName("pw")
        self.input_id = QtWidgets.QLineEdit(self.centralwidget)
        self.input_id.setGeometry(QtCore.QRect(110, 100, 113, 21))
        self.input_id.setObjectName("input_id")
        self.input_pw = QtWidgets.QLineEdit(self.centralwidget)
        self.input_pw.setGeometry(QtCore.QRect(110, 130, 113, 21))
        self.input_pw.setObjectName("input_pw")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 407, 26))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.login_btn.setText(_translate("MainWindow", "로그인"))
        self.Name.setText(_translate("MainWindow", "Instagram Login"))
        self.id.setText(_translate("MainWindow", "id"))
        self.pw.setText(_translate("MainWindow", "password"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
