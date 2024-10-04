import tkinter as tk
import time, threading, pyautogui, keyboard, json, os
from datetime import datetime

if not os.path.exists("DATA"):
    os.makedirs("DATA")

class AutoClickerApp:
    def __init__(self, root):
        self.root = root
        self.root.geometry("250x150+0+0")
        self.root.title("AutoClicker")
        self.click_count = 0
        self.is_running = False
        self.start_time = None
        self.elapsed_time = 0
        self.best_time = 0
        self.record_file = None
        self.lbl_click_count = tk.Label(root, text="Clicks: 0", font=("Arial", 12))
        self.lbl_click_count.pack(pady=5)
        self.lbl_elapsed_time = tk.Label(root, text="Thời gian: 00:00:00", font=("Arial", 12))
        self.lbl_elapsed_time.pack(pady=5)
        self.lbl_best_time = tk.Label(root, text="Kỉ lục: 00:00:00", font=("Arial", 12))
        self.lbl_best_time.pack(pady=5)
        self.btn_reset = tk.Button(root, text="RESET", command=self.reset_time, state=tk.DISABLED)
        self.btn_reset.pack(pady=10)
        keyboard.add_hotkey('F8', self.toggle_clicking)

    def toggle_clicking(self):
        if self.is_running:
            self.stop_clicking()
        else:
            self.start_clicking()

    def start_clicking(self):
        self.is_running = True
        self.start_time = time.time()
        self.click_count = 0
        self.record_file = f"DATA/click_record_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        self.btn_reset.config(state=tk.DISABLED)
        threading.Thread(target=self.click_mouse).start()
        threading.Thread(target=self.update_time).start()

    def stop_clicking(self):
        self.is_running = False
        self.elapsed_time = time.time() - self.start_time
        if self.elapsed_time > self.best_time:
            self.best_time = self.elapsed_time
        self.btn_reset.config(state=tk.NORMAL)

        with open(self.record_file, 'a') as file:
            data = {"action": "STOP", "elapsed_time": self.format_time(self.elapsed_time), "clicks": self.click_count}
            json.dump(data, file)
            file.write("\n")

    def reset_time(self):
        self.elapsed_time = 0
        self.click_count = 0
        self.lbl_click_count.config(text="Clicks: 0")
        self.lbl_elapsed_time.config(text="Thời gian: 00:00:00")
        self.btn_reset.config(state=tk.DISABLED)

        with open(self.record_file, 'a') as file:
            data = {"action": "RESET"}
            json.dump(data, file)
            file.write("\n")

    def click_mouse(self):
        with open(self.record_file, 'w') as file:
            json.dump({"action": "START"}, file)
            file.write("\n")
        
        while self.is_running:
            pyautogui.click()
            self.click_count += 1
            self.lbl_click_count.config(text=f"Clicks: {self.click_count}")
            time.sleep(0.1)  

    def update_time(self):
        while self.is_running:
            self.elapsed_time = time.time() - self.start_time
            self.lbl_elapsed_time.config(text=f"Thời gian: {self.format_time(self.elapsed_time)}")
            if self.best_time > 0:
                self.lbl_best_time.config(text=f"Kỉ lục: {self.format_time(self.best_time)}")
            time.sleep(1)

    def format_time(self, seconds):
        h = int(seconds // 3600)
        m = int((seconds % 3600) // 60)
        s = int(seconds % 60)
        return f"{h:02}:{m:02}:{s:02}"

if __name__ == "__main__":
    root = tk.Tk()
    app = AutoClickerApp(root)
    root.mainloop()
