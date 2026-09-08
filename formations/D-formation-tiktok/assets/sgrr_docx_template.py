#!/usr/bin/env python3
"""
Template DOCX SGRR — même identité visuelle que le PDF (logo à gauche, fond
sombre, titres Poppins Bold, bullets Poppins Regular avec segments en gras
ExtraBold), mais éditable dans Word par Mathieu (texte réel, pas une image).

Compromis assumé vs le PDF : le dégradé navy->noir devient un fond SOLIDE
(Word ne supporte pas nativement un dégradé de fond par page) — même famille
de couleur (bleu marine très foncé), rendu très proche à l'oeil.

Usage:
    from sgrr_docx_template import build_docx
    slides = [("Titre court", ["Bullet **avec du gras** ici.", ...]), ...]
    build_docx(slides, "sortie.docx", chapter_title="Chapitre 1 : ...")
"""
import os
import re
from docx import Document
from docx.shared import Pt, Inches, RGBColor, Emu
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

ASSETS_DIR = os.path.dirname(os.path.abspath(__file__))
LOGO_PATH = os.path.join(ASSETS_DIR, "sgrr-logo.png")

BG_COLOR = "0A1628"       # navy très foncé (proxy du dégradé PDF)
TITLE_COLOR = RGBColor(0xFF, 0xFF, 0xFF)
BODY_COLOR = RGBColor(0xE1, 0xE3, 0xE8)
KICKER_COLOR = RGBColor(0x78, 0xA0, 0xD2)

FONT_TITLE = "Poppins Bold"
FONT_BOLD = "Poppins ExtraBold"
FONT_REGULAR = "Poppins"


def _set_document_background(doc, hex_color):
    """Fond de page sombre sur tout le document (w:background)."""
    background = OxmlElement("w:background")
    background.set(qn("w:color"), hex_color)
    doc.element.insert(0, background)


def _set_run_font(run, name):
    run.font.name = name
    rPr = run._element.get_or_add_rPr()
    rFonts = rPr.find(qn("w:rFonts"))
    if rFonts is None:
        rFonts = OxmlElement("w:rFonts")
        rPr.append(rFonts)
    rFonts.set(qn("w:eastAsia"), name)
    rFonts.set(qn("w:ascii"), name)
    rFonts.set(qn("w:hAnsi"), name)
    rFonts.set(qn("w:cs"), name)


def _add_logo(doc, width_in=1.15):
    if os.path.exists(LOGO_PATH):
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        p.paragraph_format.space_after = Pt(6)
        run = p.add_run()
        run.add_picture(LOGO_PATH, width=Inches(width_in))


def _add_rich_bullet(doc, text, bullet=True):
    """Découpe **gras** en runs Poppins ExtraBold, le reste en Poppins Regular."""
    p = doc.add_paragraph(style="List Bullet" if bullet else None)
    p.paragraph_format.space_after = Pt(10)
    p.paragraph_format.line_spacing = 1.25
    parts = re.split(r"(\*\*[^*]+\*\*)", text)
    for part in parts:
        if not part:
            continue
        bold = part.startswith("**") and part.endswith("**")
        content = part[2:-2] if bold else part
        run = p.add_run(content)
        run.font.size = Pt(13)
        run.font.color.rgb = BODY_COLOR
        _set_run_font(run, FONT_BOLD if bold else FONT_REGULAR)
        run.bold = bold
    return p


def add_slide(doc, title, bullets, kicker=None, new_page=True):
    if new_page:
        doc.add_page_break()
    _add_logo(doc)
    if kicker:
        kp = doc.add_paragraph()
        kr = kp.add_run(kicker.upper())
        kr.font.size = Pt(11)
        kr.font.color.rgb = KICKER_COLOR
        _set_run_font(kr, FONT_REGULAR)
        kp.paragraph_format.space_after = Pt(2)

    tp = doc.add_paragraph()
    tr = tp.add_run(title)
    tr.font.size = Pt(30)
    tr.font.color.rgb = TITLE_COLOR
    tr.bold = True
    _set_run_font(tr, FONT_TITLE)
    tp.paragraph_format.space_after = Pt(18)
    tp.paragraph_format.space_before = Pt(4)

    for b in bullets:
        _add_rich_bullet(doc, b)


def build_docx(slides, out_path, chapter_title=None):
    """slides: liste de tuples (title, bullets_list) ou (title, bullets_list, kicker)."""
    doc = Document()

    # Marges + fond sombre document entier
    for section in doc.sections:
        section.left_margin = Inches(0.9)
        section.right_margin = Inches(0.9)
        section.top_margin = Inches(0.7)
        section.bottom_margin = Inches(0.7)
    _set_document_background(doc, BG_COLOR)

    # Style de base : texte clair par défaut (au cas où Mathieu tape du texte brut)
    normal = doc.styles["Normal"]
    normal.font.name = FONT_REGULAR
    normal.font.size = Pt(13)
    normal.font.color.rgb = BODY_COLOR

    # Style des puces : couleur claire aussi
    try:
        bullet_style = doc.styles["List Bullet"]
        bullet_style.font.color.rgb = BODY_COLOR
        bullet_style.font.size = Pt(13)
    except KeyError:
        pass

    if chapter_title:
        _add_logo(doc, width_in=1.4)
        cp = doc.add_paragraph()
        cr = cp.add_run(chapter_title)
        cr.font.size = Pt(40)
        cr.font.color.rgb = TITLE_COLOR
        cr.bold = True
        _set_run_font(cr, FONT_TITLE)
        cp.paragraph_format.space_before = Pt(80)

    first = True
    for entry in slides:
        if len(entry) == 3:
            title, bullets, kicker = entry
        else:
            title, bullets = entry
            kicker = None
        add_slide(doc, title, bullets, kicker=kicker, new_page=not (first and chapter_title is None) or not first)
        first = False

    doc.save(out_path)
    print("saved", out_path)


if __name__ == "__main__":
    pass
