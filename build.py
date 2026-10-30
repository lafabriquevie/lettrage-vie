# Assemble lettrage-vie.html : injecte les polices OFL (base64) dans le source.
import base64, json, os
ici = os.path.dirname(os.path.abspath(__file__))
polices = {'Pacifico': 'Pacifico-Regular.ttf', 'Lobster': 'Lobster-Regular.ttf', 'Leckerli One': 'LeckerliOne-Regular.ttf'}
data = {nom: base64.b64encode(open(os.path.join(ici, 'fonts', f), 'rb').read()).decode() for nom, f in polices.items()}
s = open(os.path.join(ici, 'lettrage-vie.source.html'), encoding='utf-8').read().replace('/*FONTS*/{}', json.dumps(data))
open(os.path.join(ici, 'lettrage-vie.html'), 'w', encoding='utf-8').write(s)
print(len(s), 'octets')
