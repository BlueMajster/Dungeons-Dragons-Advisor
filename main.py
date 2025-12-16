import clips
import tkinter as tk
from tkinter import messagebox
import json
import os

CLIPS_FILE = "knowledge.clp"
JSON_FILE = "data.json"

class RaceAdvisorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("System Ekspertowy: Wybór Rasy D&D")
        self.root.geometry("750x650")
        self.root.configure(bg="#f0f0f0")

        self.setup_gui()

        self.load_json_data()

        self.env = clips.Environment()
        self.load_clips_rules()

        # Start wnioskowania
        self.run_inference()

    def setup_gui(self):
        self.header_frame = tk.Frame(self.root, bg="#333", height=50)
        self.header_frame.pack(fill=tk.X)
        lbl_title = tk.Label(self.header_frame, text="Dungeon & Dragons Advisor", 
                             bg="#333", fg="white", font=("Arial", 14, "bold"))
        lbl_title.pack(pady=10)

        self.content_frame = tk.Frame(self.root, bg="#f0f0f0", padx=20, pady=10)
        self.content_frame.pack(expand=True, fill=tk.BOTH)

        self.lbl_question = tk.Label(self.content_frame, text="Loading...", 
                                     font=("Arial", 16, "bold"), bg="#f0f0f0", wraplength=650)
        self.lbl_question.pack(pady=(20, 10))

        self.lbl_desc = tk.Label(self.content_frame, text="", 
                                 font=("Arial", 12), bg="#f0f0f0", fg="#555", wraplength=650)
        self.lbl_desc.pack(pady=(0, 20))

        self.history_frame = tk.Frame(self.content_frame, bg="#f0f0f0")
        
        self.lbl_history_title = tk.Label(self.history_frame, text="Inference Path (Your Answers):", 
                                          bg="#f0f0f0", font=("Arial", 10, "bold"), fg="#444")
        self.lbl_history_title.pack(anchor="w")
        
        self.txt_history = tk.Text(self.history_frame, height=8, width=70, font=("Consolas", 10), 
                                   bg="#fff", relief=tk.FLAT, padx=10, pady=10)
        self.txt_history.pack(fill=tk.X)

        # Obszar przycisków
        self.buttons_frame = tk.Frame(self.root, bg="#e0e0e0", pady=20)
        self.buttons_frame.pack(fill=tk.X, side=tk.BOTTOM)

    def load_json_data(self):
        if not os.path.exists(JSON_FILE):
            messagebox.showerror("Błąd", f"Brak pliku {JSON_FILE}!")
            self.root.destroy()
            return
        try:
            with open(JSON_FILE, "r", encoding="utf-8") as f:
                self.data = json.load(f)
        except Exception as e:
            messagebox.showerror("Błąd JSON", str(e))

    def load_clips_rules(self):
        try:
            self.env.load(CLIPS_FILE)
            self.env.reset()
        except Exception as e:
            messagebox.showerror("Błąd CLIPS", f"Nie można załadować reguł: {e}")
            self.root.destroy()

    def run_inference(self):
        """Główna pętla sterująca."""
        self.env.run()
        
        # żądania UI (ui-request)
        request_fact = None
        for fact in self.env.facts():
            if fact.template.name == 'ui-request':
                request_fact = fact
                break
        
        if request_fact:
            self.update_interface(request_fact)
        else:
            self.lbl_question.config(text="End of Path (No Rules).")
            self.clear_buttons()

    def update_interface(self, fact):
        """Tłumaczy fakt CLIPS na wygląd okna."""
        req_type = str(fact['type'])
        req_id = str(fact['id'])
        options = fact['options']
        
        self.clear_buttons()

        if req_type == 'question':
            self.history_frame.pack_forget() # Ukryj pole historii
            
            text = self.data['questions'].get(req_id, f"MISSING: {req_id}")
            self.lbl_question.config(text=text, fg="black")
            self.lbl_desc.config(text="")
            
            # Przyciski
            side_pack = tk.TOP
            fill_opt = tk.X
            
            for opt in options:
                val = str(opt)
                btn_label = self.data.get('answers', {}).get(val, val.replace("_", " "))
                
                # Kolory
                btn_col = "#2196F3"
                if val == 'yes': btn_col = "#4CAF50"
                elif val == 'no': btn_col = "#f44336"
                
                btn = tk.Button(self.buttons_frame, text=btn_label, font=("Arial", 11),
                                bg=btn_col, fg="white", 
                                wraplength=180,
                                height=4,
                                width=25,
                                command=lambda v=val: self.submit_answer(req_id, v))
                btn.pack(side=side_pack, padx=10, pady=5, fill=fill_opt)

        elif req_type == 'result':
            # Dane wyniku
            res = self.data['results'].get(req_id, {"title": req_id, "desc": ""})
            self.lbl_question.config(text=f"YOUR RESULT: {res['title']}", fg="#2E7D32")
            self.lbl_desc.config(text=res['desc'])
            
            history_text = self.get_reasoning_history()
            
            self.txt_history.config(state=tk.NORMAL)
            self.txt_history.delete("1.0", tk.END)
            self.txt_history.insert(tk.END, history_text)
            self.txt_history.config(state=tk.DISABLED)
            
            # ramka historii
            self.history_frame.pack(fill=tk.BOTH, pady=10)
            
            # Przycisk Reset
            if 'reset' in [str(o) for o in options]:
                btn = tk.Button(self.buttons_frame, text="START AGAIN", 
                                font=("Arial", 12), bg="#607D8B", fg="white",
                                command=self.reset_app)
                btn.pack(pady=20)

    def get_reasoning_history(self):
        """Pobiera fakty user-answer z pamięci CLIPS i tłumaczy je na tekst."""
        history = ""
        
        # Pobieramy wszystkie fakty
        facts = list(self.env.facts())
        
        user_answers = [f for f in facts if f.template.name == 'user-answer']
        
        step = 1
        for ans in user_answers:
            q_id = str(ans['question-id'])
            val = str(ans['value'])
            
            q_text = self.data['questions'].get(q_id, q_id)
            a_text = self.data.get('answers', {}).get(val, val)
            
            history += f"{step}. {q_text}\n   -> ANSWER: {a_text}\n"
            step += 1
            
        return history

    def submit_answer(self, q_id, value):
        for fact in self.env.facts():
            if fact.template.name == 'ui-request':
                fact.retract()
        
        self.env.assert_string(f'(user-answer (question-id {q_id}) (value {value}))')
        self.run_inference()

    def reset_app(self):
        self.env.reset()
        self.run_inference()

    def clear_buttons(self):
        for widget in self.buttons_frame.winfo_children():
            widget.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    app = RaceAdvisorApp(root)
    root.mainloop()