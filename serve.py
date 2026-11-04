# Sert Lettrage Vié sur http://localhost:8765 et ouvre les 3MF exportés dans Bambu Studio.
# Usage : python3 serve.py  (reconstruit la page avec build.py au démarrage)
import os, re, subprocess, sys, webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = 8765
ORIGINE = f"http://localhost:{PORT}"
ici = os.path.dirname(os.path.abspath(__file__))
dossier = os.path.join(os.path.expanduser("~"), "Downloads", "Lettrage Vié")
# Nom de l'application sur macOS : on essaie les variantes connues, puis l'application par défaut des .3mf
APPS = [os.environ.get("BAMBU_APP"), "BambuStudio", "Bambu Studio"]


class Gestion(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path not in ("/", "/index.html"):
            return self.send_error(404)
        page = open(os.path.join(ici, "lettrage-vie.html"), "rb").read()
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(page)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(page)

    def do_POST(self):
        # Seule la page servie ici peut envoyer un fichier : même origine et en-tête propre à l'outil
        if self.path != "/bambu" or self.headers.get("Origin") != ORIGINE or self.headers.get("X-Lettrage") != "1":
            return self.send_error(403)
        taille = int(self.headers.get("Content-Length") or 0)
        if not 0 < taille <= 200 * 1024 * 1024:
            return self.send_error(413)
        nom = re.sub(r"[^a-z0-9-]", "", (self.headers.get("X-Nom") or "lettrage").lower())[:60] or "lettrage"
        os.makedirs(dossier, exist_ok=True)
        chemin = os.path.join(dossier, nom + ".3mf")
        with open(chemin, "wb") as f:
            f.write(self.rfile.read(taille))
        try:
            if sys.platform == "darwin":
                essais = [["open", "-a", a, chemin] for a in APPS if a] + [["open", chemin]]
                if not any(subprocess.run(c, capture_output=True).returncode == 0 for c in essais):
                    raise RuntimeError("aucune application trouvée pour les .3mf")
            elif os.name == "nt":
                os.startfile(chemin)
            else:
                subprocess.run(["xdg-open", chemin], check=True)
            ok, msg = True, chemin
        except Exception as e:
            ok, msg = False, f"{chemin} enregistré, mais Bambu Studio ne s'est pas ouvert ({e})"
        corps = msg.encode()
        self.send_response(200 if ok else 500)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(corps)))
        self.end_headers()
        self.wfile.write(corps)

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    subprocess.run([sys.executable, os.path.join(ici, "build.py")], check=True)
    serveur = ThreadingHTTPServer(("127.0.0.1", PORT), Gestion)
    print(f"Lettrage Vié : {ORIGINE}  (Ctrl+C pour arrêter)")
    webbrowser.open(ORIGINE)
    try:
        serveur.serve_forever()
    except KeyboardInterrupt:
        pass
