# Assemble lettrage-vie.html : injecte les polices OFL (base64) listées dans fonts/polices.json.
import base64, json, os
ici = os.path.dirname(os.path.abspath(__file__))
manifeste = json.load(open(os.path.join(ici, 'fonts', 'polices.json'), encoding='utf-8'))
polices = [dict(p, data=base64.b64encode(open(os.path.join(ici, 'fonts', p['fichier']), 'rb').read()).decode()) for p in manifeste]
s = open(os.path.join(ici, 'lettrage-vie.source.html'), encoding='utf-8').read().replace('/*FONTS*/[]', json.dumps(polices, ensure_ascii=False))
open(os.path.join(ici, 'lettrage-vie.html'), 'w', encoding='utf-8').write(s)
print(len(s), 'octets')
