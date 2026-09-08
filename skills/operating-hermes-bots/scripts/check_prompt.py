#!/usr/bin/env python3
"""Preuve sans GPU qu'une regle est dans le prompt systeme de la session Discord vivante d'un profil Hermes.

Usage (WSL) :
  python3 check_prompt.py anw "phrase distinctive"      # profil anw
  python3 check_prompt.py default "phrase distinctive"  # NeverGiveUp
Lecture seule (URI mode=ro). Affiche les 3 dernieres sessions Discord : id, modele, date, taille du prompt,
nombre d'appels d'outils, et OUI/NON pour la phrase cherchee.
"""
import datetime, os, sqlite3, sys


def fmt(ts):
    try:
        return datetime.datetime.fromtimestamp(float(ts)).strftime("%Y-%m-%d %H:%M:%S")
    except (TypeError, ValueError):
        return str(ts)


prof =sys.argv[1] if len(sys.argv) > 1 else "anw"
needle = sys.argv[2] if len(sys.argv) > 2 else ""
home = os.path.expanduser("~/.hermes") if prof == "default" else os.path.expanduser(f"~/.hermes/profiles/{prof}")
db = os.path.join(home, "state.db")
if not os.path.exists(db):
    sys.exit(f"state.db introuvable : {db}")

con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
cur = con.cursor()
cols = [r[1] for r in cur.execute("PRAGMA table_info(sessions)")]
want = ["id", "source", "platform", "model", "created_at", "started_at", "updated_at", "system_prompt", "tool_call_count", "title"]
sel = [c for c in want if c in cols]
if "system_prompt" not in sel:
    sys.exit(f"pas de colonne system_prompt ; colonnes = {cols}")
order = next((c for c in ("created_at", "started_at", "updated_at") if c in cols), "rowid")
src_col = "source" if "source" in cols else ("platform" if "platform" in cols else None)
where = f"WHERE {src_col} LIKE '%discord%'" if src_col else ""
rows = cur.execute(f"SELECT {','.join(sel)} FROM sessions {where} ORDER BY {order} DESC LIMIT 3").fetchall()
if not rows:
    sys.exit("aucune session Discord trouvee")
for i, r in enumerate(rows):
    d = dict(zip(sel, r))
    sp = d.get("system_prompt") or ""
    hit = "-" if not needle else ("OUI" if needle in sp else "NON")
    tag = "VIVANTE" if i == 0 else "ancienne"
    print(f"{tag:8s} session={d.get('id')} model={d.get('model')} date={fmt(d.get('created_at') or d.get('started_at'))} "
          f"prompt={len(sp)} car tool_calls={d.get('tool_call_count')} phrase={hit}")
