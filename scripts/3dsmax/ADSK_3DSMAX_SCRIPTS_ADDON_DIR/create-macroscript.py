from pymxs import runtime as rt
from PySide6.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QLabel, QHBoxLayout, QLineEdit, QPushButton, QFileDialog
import qtmax


class PyMaxDockWidget(QMainWindow):
    def __init__(self, parent=None):
        super(PyMaxDockWidget, self).__init__(parent)
        self.setWindowTitle('#render-tools MacroScripter')
        self.initUI()
        
    def initUI(self):
        # Main layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)

        # Title
        title_label = QLabel("Create Macro")
        title_label.setStyleSheet("font-size: 18px; font-weight: bold;")
        layout.addWidget(title_label)

        # File picker
        file_picker_layout = QHBoxLayout()
        self.file_path_input = QLineEdit()
        self.file_path_input.setPlaceholderText("Select a MaxScript file (.ms, .mse, .msx)")
        file_picker_button = QPushButton("Browse")
        file_picker_button.clicked.connect(self.open_file_dialog)
        file_picker_layout.addWidget(self.file_path_input)
        file_picker_layout.addWidget(file_picker_button)
        layout.addLayout(file_picker_layout)

        # Macro name input
        macro_name_label = QLabel("Macro Name:")
        self.macro_name_input = QLineEdit()
        self.macro_name_input.setPlaceholderText("Enter macro name")
        layout.addWidget(macro_name_label)
        layout.addWidget(self.macro_name_input)

        # Buttons
        button_layout = QHBoxLayout()
        create_button = QPushButton("Create")
        create_button.clicked.connect(self.create_macro)
        cancel_button = QPushButton("Cancel")
        cancel_button.clicked.connect(self.close)
        button_layout.addWidget(create_button)
        button_layout.addWidget(cancel_button)
        layout.addLayout(button_layout)
        
        self.resize(400, 50)  # Set the window size to 600x400 pixels
        
    def open_file_dialog(self):
        file_path, _ = QFileDialog.getOpenFileName(
            self, "Select MaxScript File", "", "MaxScript Files (*.ms *.mse *.msx)"
        )
        if file_path:
            self.file_path_input.setText(file_path)

    def create_macro(self):
        file_path = self.file_path_input.text()
        macro_name = self.macro_name_input.text()
        
        if os.path.splitext(file_path)[-1] not in [".ms", ".mse",".msx"]:
            print("Filename must end in .ms, .mse, or .msx!")
            return

        if not file_path or not macro_name:
            print("Both file path and macro name are required!")
            return

        print(f"Creating macro for {macro_name} using file {file_path}")
        
        # Add logic to create the macro here
        scriptName = os.path.basename(file_path)
        print(f"Creating macro for {macro_name} ({file_path}) in {os.getenv('ADSK_3DSMAX_MACROS_ADDON_DIR')}")

        # Write the macro script to a file
        macroFilePath = f'{os.path.join(os.getenv("ADSK_3DSMAX_MACROS_ADDON_DIR"), macro_name.lower().replace(" ","-"))}.mcr'
        with open(macroFilePath, "w") as macroFile:
            macroFile.write(f'macroScript {macro_name.replace(" ","")} category:\"#render-tools\" tooltip:\"{macro_name}\" (\n')
            macroFile.write(f'\tfileIn (\"{scriptName}\") quiet:true\n')
            macroFile.write(")\n")

        print(f"Macro script written to {macroFilePath}!")



def main():
    main_window = qtmax.GetQMaxMainWindow()
    w = PyMaxDockWidget(parent=main_window)
    w.show()

if __name__ == '__main__':
    main()