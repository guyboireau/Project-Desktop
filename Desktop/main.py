import requests
from tkinter import *


class YGOPRODeckApp:
    def init(self, master):
        self.master = master
        master.title("YGOPRODeck Pack Opener")

        # Créer un bouton pour ouvrir un pack de cartes
        self.open_pack_button = Button(master, text="Ouvrir un Pack", command=self.open_pack)
        self.open_pack_button.pack()

        # Créer une zone de texte pour afficher les cartes
        self.cards_text = Text(master)
        self.cards_text.pack()

    def open_pack(self):
        # Récupérer une liste de cartes aléatoires depuis l'API de YGOPRODeck
        API_URL = 'https://db.ygoprodeck.com/api/v7/randompack.php'
        params = {'num': 5}  # nombre de cartes à récupérer
        response = requests.get(API_URL, params=params)

        # Afficher les cartes à l'utilisateur s'il n'y a pas eu d'erreur de réponse
        if response.status_code == 200:
            data = response.json()
            cards = data['data']

            self.cards_text.delete('1.0', END)  # Effacer le texte existant dans la zone de texte

            for card in cards:
                self.cards_text.insert(END, f"{card['name']} - {card['type']} - {card['attribute']} - {card['race']}\n")
        else:
            # Gérer les erreurs de réponse de l'API
            self.cards_text.delete('1.0', END)
            self.cards_text.insert(END, "Erreur lors de la récupération des cartes. Veuillez réessayer plus tard.")

root = Tk()
app = YGOPRODeckApp(root)
root.mainloop()