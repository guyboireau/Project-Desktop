import tkinter as tk
from main_controller import MainController

class MainView:
    def __init__(self, root):
        self.root = root
        self.root.title("Ouvrir un pack Yu-Gi-Oh")
        self.controller = MainController(root)

if __name__ == '__main__':
    root = tk.Tk()
    app = MainView(root)
    root.mainloop()
