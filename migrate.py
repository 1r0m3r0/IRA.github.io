import re
import subprocess
from pathlib import Path

# old path -> new path
MOVES = {
    "demo-trading-bot.html": "proyectos/demo-trading-bot.html",
    "demo-defi-dashboard.html": "proyectos/demo-defi-dashboard.html",
    "demo-risk-analytics.html": "proyectos/demo-risk-analytics.html",
    "demo-crypto-payment.html": "proyectos/demo-crypto-payment.html",
    "demo-market-sentiment.html": "proyectos/demo-market-sentiment.html",
    "demo-blockchain-explorer.html": "proyectos/demo-blockchain-explorer.html",
    "articulo-defi-layer2.html": "articulos/articulo-defi-layer2.html",
    "articulo-estrategias-algoritmicas.html": "articulos/articulo-estrategias-algoritmicas.html",
    "articulo-ml-trading.html": "articulos/articulo-ml-trading.html",
    "Presentaciondetesis.html": "articulos/presentacion-tesis.html",
    "TallerBasico.html": "cursos/taller-blockchain/index.html",
    "1.html": "cursos/taller-blockchain/01-portal-inicio.html",
    "2.html": "cursos/taller-blockchain/02-problema-confianza.html",
    "3.html": "cursos/taller-blockchain/03-construye-tu-cadena.html",
    "4.html": "cursos/taller-blockchain/04-hashing-magico.html",
    "5.html": "cursos/taller-blockchain/05-bitcoin-mineria.html",
    "6.html": "cursos/taller-blockchain/06-wallet-monedero.html",
    "7.html": "cursos/taller-blockchain/07-contratos-inteligentes.html",
    "8.html": "cursos/taller-blockchain/08-defi-banco-sin-ventanillas.html",
    "9.html": "cursos/taller-blockchain/09-tokenizacion-activos.html",
    "10.html": "cursos/taller-blockchain/10-riesgos-y-seguridad.html",
    "11.html": "cursos/taller-blockchain/11-quiz-repaso.html",
    "12.html": "cursos/taller-blockchain/12-certificado.html",
    "c1.html": "cursos/taller-blockchain/nivel2-01-nfts.html",
    "c2.html": "cursos/taller-blockchain/nivel2-02-daos.html",
    "c3.html": "cursos/taller-blockchain/nivel2-03-interoperabilidad.html",
    "c4.html": "cursos/taller-blockchain/nivel2-04-layer2.html",
    "c5.html": "cursos/taller-blockchain/nivel2-05-crea-tu-token.html",
    "c6.html": "cursos/taller-blockchain/nivel2-06-forense-blockchain.html",
    "c7.html": "cursos/taller-blockchain/nivel2-07-carreras-blockchain.html",
    "c8.html": "cursos/taller-blockchain/nivel2-08-escape-room.html",
    "curso-analisis-cuantitativo.html": "cursos/docencia/index.html",
    "articulocientifico.html": "cursos/docencia/articulos-cientificos-economia.html",
    "normal.html": "cursos/docencia/herramientas/laboratorio-pruebas-hipotesis.html",
    "normalidad.html": "cursos/docencia/herramientas/pruebas-normalidad.html",
    "chicuadrado.html": "cursos/docencia/herramientas/prueba-chi-cuadrado.html",
    "pruebast.html": "cursos/docencia/herramientas/prueba-t.html",
    "pruebasz.html": "cursos/docencia/herramientas/prueba-z.html",
    "regresymu.html": "cursos/docencia/herramientas/regresion-lineal-python.html",
    "Logit.html": "cursos/docencia/herramientas/regresion-logistica-python.html",
    "PythonCorr.html": "cursos/docencia/herramientas/correlaciones-python.html",
    "curso-smart-contracts.html": "cursos/smart-contracts/index.html",
    "curso-trading-bots.html": "cursos/trading-bots/index.html",
    "privacidad.html": "legal/privacidad.html",
    "terminos.html": "legal/terminos.html",
    "cookies.html": "legal/cookies.html",
}

def depth(path: str) -> int:
    return path.count("/")

def rel_prefix(new_path: str) -> str:
    return "../" * depth(new_path)

def git_mv_all():
    for old, new in MOVES.items():
        subprocess.run(["git", "mv", old, new], check=True)

def rewrite_links():
    for old, new in MOVES.items():
        p = Path(new)
        text = p.read_text(encoding="utf-8")
        d = depth(new)
        prefix = rel_prefix(new)

        # 1. Links between moved files: rewrite href="OLDNAME.html" (and #anchors)
        for o, n in MOVES.items():
            if o == old:
                continue
            if "/" in o:
                continue
            pattern = re.compile(r'href="' + re.escape(o) + r'(#[^"]*)?"')
            target = prefix + n
            text = pattern.sub(lambda m, t=target: f'href="{t}{m.group(1) or ""}"', text)

        # 2. assets/ references
        if d > 0:
            text = re.sub(r'(href|src)="assets/', rf'\1="{prefix}assets/', text)

        # 3. legal/ references (cookies.html, privacidad.html, terminos.html -> legal/...)
        for legal_old, legal_new in [("cookies.html", "legal/cookies.html"),
                                      ("privacidad.html", "legal/privacidad.html"),
                                      ("terminos.html", "legal/terminos.html")]:
            if new == legal_new:
                continue
            text = re.sub(rf'href="{re.escape(legal_old)}"', f'href="{prefix}{legal_new}"', text)

        # 4. broken styles.css -> assets/css/styles.css
        text = text.replace('href="styles.css"', f'href="{prefix}assets/css/styles.css"')

        # 5. index.html#section anchors (portfolio root index)
        if d > 0:
            text = re.sub(r'href="index\.html(#[^"]*)"', rf'href="{prefix}index.html\1"', text)

        # 6. legal/*.html plain "index.html" (no anchor) -> back to portfolio root
        if new.startswith("legal/"):
            text = re.sub(r'href="index\.html"', f'href="{prefix}index.html"', text)

        p.write_text(text, encoding="utf-8")

if __name__ == "__main__":
    git_mv_all()
    rewrite_links()
    print("Migration done.")
