import tkinter as tk
import requests
import random
from PIL import Image, ImageTk

class MainController:
    def __init__(self, root):
        self.root = root
        self.cards = []
        self.pack_url = 'https://db.ygoprodeck.com/api/v7/cardinfo.php?cardset='
        self.pack_names = ['LOB', 'MRD', 'SDY', 'SDK', 'SYE']
        self.current_pack = tk.StringVar()
        self.current_pack.set(self.pack_names[0])
        self.create_widgets()

    def create_widgets(self):
        # Crée une liste déroulante pour choisir le pack de cartes
        pack_label = tk.Label(self.root, text="Choisissez un pack de cartes : ")
        pack_label.grid(row=0, column=0, padx=5, pady=5)
        pack_menu = tk.OptionMenu(self.root, self.current_pack, *self.pack_names)
        pack_menu.grid(row=0, column=1, padx=5, pady=5)

        # Crée un bouton pour ouvrir un pack de cartes
        open_pack_button = tk.Button(self.root, text="Ouvrir un pack", command=self.open_pack)
        open_pack_button.grid(row=1, column=0, columnspan=2, padx=5, pady=5)

        # Crée une zone de texte pour afficher les cartes ouvertes
        self.card_text = tk.Text(self.root, width=50, height=10)
        self.card_text.grid(row=2, column=0, columnspan=2, padx=5, pady=5)

    def open_pack(self):
        # Récupère le nom du pack sélectionné dans la liste déroulante
        selected_pack = self.current_pack.get()
        # Récupère l'URL de l'API pour ce pack de cartes
        url = self.pack_url + selected_pack
        # Effectue une requête HTTP pour récupérer les informations sur le pack de cartes
        response = requests.get(url)
        data = response.json()
        # Sélectionne 5 cartes aléatoires à partir du pack
        pack_cards = random.sample(data['data'], 5)
        # Ajoute les cartes au texte d'affichage
        for card in pack_cards:
            self.cards.append(card['name'])
            # Récupère l'image de la carte depuis son URL
            card_image = Image.open(requests.get(card['card_images'][0]['image_url'], stream=True).raw)
            # Réduit la taille de l'image pour l'afficher dans la zone de texte
            card_image = card_image.resize((100, 146), Image.ANTIALIAS)
            card_photo = ImageTk.PhotoImage(card_image)
            self.card_text.image_create(tk.END, image=card_photo)
            self.card_text.insert(tk.END, '\n' + card['name'] + '\n\n')
            self.card_text.image = card_photo  # Garde une référence à l'image pour éviter qu'elle ne soit supprimée
            

