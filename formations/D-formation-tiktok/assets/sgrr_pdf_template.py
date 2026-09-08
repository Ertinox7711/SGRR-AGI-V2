#!/usr/bin/env python3
"""
Template PDF SGRR — reproduit fidèlement le format Risen Consulting :
fond dégradé bleu marine -> noir, logo SGRR (fin, transparent) en haut à droite,
titre Quicksand Bold en haut à gauche (mot-clé court, 1-3 mots), bullets Quicksand
Regular avec puces rondes — bullets = PHRASES COMPLÈTES et détaillées (2-3 lignes
chacune), ton direct/conversationnel, PAS de fragments synthétiques.
Structure confirmée sur 4 leçons Risen (Personal Branding, Où Recruter, Marketing
TikTok, Déléguer les Messages) — cohérente à 100% : titre court + 3-4 bullets longs,
pas d'images/captures dans les slides, texte seul.

Usage:
    from sgrr_pdf_template import build_pdf
    slides = [("Titre court", ["Phrase complète et détaillée expliquant le point,
                                 sur 2-3 lignes si besoin, ton direct.", ...]), ...]
    build_pdf(slides, "sortie.pdf")
"""
import io
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import img2pdf

W, H = 2400, 1350  # ratio 16:9 comme la référence

ASSETS_DIR = os.path.dirname(os.path.abspath(__file__))
FONT_DIR = os.path.join(ASSETS_DIR, "fonts")
# Police confirmée par extraction directe des métadonnées PDF Risen (pdffonts),
# pas par comparaison visuelle -> Poppins-Bold (titres) / Poppins-Regular (corps),
# cohérent sur 5 PDF différents vérifiés (marketing_tiktok, personal_branding,
# ou_recruter, objections, compte_modele). Baloo 2 et Quicksand étaient de
# mauvaises hypothèses visuelles, écartées.
FONT_TITLE = os.path.join(FONT_DIR, "Poppins-Bold.ttf")
FONT_BOLD = os.path.join(FONT_DIR, "Poppins-ExtraBold.ttf")
FONT_MEDIUM = os.path.join(FONT_DIR, "Poppins-Regular.ttf")
FONT_REGULAR = os.path.join(FONT_DIR, "Poppins-Regular.ttf")
LOGO_PATH = os.path.join(ASSETS_DIR, "sgrr-logo.png")


def make_gradient_bg():
    """Dégradé horizontal bleu marine (gauche) -> noir (droite), avec un glow
    radial doux en bas-gauche, identique au style Risen."""
    navy = (14, 32, 58)
    black = (4, 5, 8)
    grad = Image.new("RGB", (W, 1))
    for x in range(W):
        t = min(1.0, (x / W) * 1.25)
        r = int(navy[0] * (1 - t) + black[0] * t)
        g = int(navy[1] * (1 - t) + black[1] * t)
        b = int(navy[2] * (1 - t) + black[2] * t)
        grad.putpixel((x, 0), (r, g, b))
    img = grad.resize((W, H))

    # glow doux en bas à gauche
    halo = Image.new("L", (W, H), 0)
    hd = ImageDraw.Draw(halo)
    cx, cy, rad = int(W * 0.02), int(H * 0.85), int(W * 0.3)
    hd.ellipse([cx - rad, cy - rad, cx + rad, cy + rad], fill=45)
    halo = halo.filter(ImageFilter.GaussianBlur(220))
    navy_layer = Image.new("RGB", (W, H), (28, 65, 120))
    img = Image.composite(navy_layer, img, halo)
    return img


def wrap_text(draw, text, font, max_width):
    words = text.split(" ")
    lines, cur = [], ""
    for w in words:
        test = (cur + " " + w).strip()
        bbox = draw.textbbox((0, 0), test, font=font)
        if bbox[2] - bbox[0] <= max_width:
            cur = test
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


def draw_rich_line(draw, x, y, text, font_reg, font_bold, fill, max_width, line_height):
    """Découpe le texte en segments **gras** et les dessine avec wrapping.
    Retourne le y final après la dernière ligne."""
    # Tokenize en gardant les marqueurs **
    parts = []
    buf = ""
    bold = False
    i = 0
    while i < len(text):
        if text[i:i+2] == "**":
            parts.append((buf, bold))
            buf = ""
            bold = not bold
            i += 2
        else:
            buf += text[i]
            i += 1
    parts.append((buf, bold))

    # Construire un flux de mots avec leur style
    words = []
    for seg_text, seg_bold in parts:
        for w in seg_text.split(" "):
            if w != "":
                words.append((w, seg_bold))

    cur_line = []
    cur_width = 0
    space_w = draw.textbbox((0, 0), " ", font=font_reg)[2]

    def flush_line(line_words, yy):
        xx = x
        for w, b in line_words:
            f = font_bold if b else font_reg
            draw.text((xx, yy), w, font=f, fill=fill)
            bbox = draw.textbbox((0, 0), w + " ", font=f)
            xx += bbox[2] - bbox[0]
        return yy + line_height

    for w, b in words:
        f = font_bold if b else font_reg
        wbbox = draw.textbbox((0, 0), w, font=f)
        ww = wbbox[2] - wbbox[0]
        if cur_width + ww > max_width and cur_line:
            y = flush_line(cur_line, y)
            cur_line = [(w, b)]
            cur_width = ww + space_w
        else:
            cur_line.append((w, b))
            cur_width += ww + space_w
    if cur_line:
        y = flush_line(cur_line, y)
    return y


def draw_slide(title, bullets, brand_logo=LOGO_PATH, footer=None, kicker=None):
    img = make_gradient_bg().convert("RGBA")
    draw = ImageDraw.Draw(img)

    font_title = ImageFont.truetype(FONT_TITLE, 76)
    font_kicker = ImageFont.truetype(FONT_MEDIUM, 30)
    font_bullet = ImageFont.truetype(FONT_MEDIUM, 38)
    font_bullet_bold = ImageFont.truetype(FONT_BOLD, 38)

    margin_x = 130

    # Logo en haut à gauche
    logo_w = 0
    if brand_logo and os.path.exists(brand_logo):
        logo = Image.open(brand_logo).convert("RGBA")
        # Le PNG source a beaucoup d'espace transparent autour du contenu réel
        # (canvas 2172x724, glyphes ~1244x526) -> on crop au bbox réel d'abord.
        bbox = logo.getbbox()
        if bbox:
            logo = logo.crop(bbox)
        # Référence Risen : logo net et contrasté. Le trait source SGRR est très
        # fin (ligne géométrique) -> à ~80px de haut l'anti-aliasing le dilue trop.
        # On épaissit légèrement le masque alpha (MaxFilter = dilatation) avant de
        # forcer une couleur bleu vif pleine opacité dessus.
        r, g, b, a = logo.split()
        a = a.filter(ImageFilter.MaxFilter(5))
        a = a.point(lambda v: 255 if v > 40 else 0)
        target_r, target_g, target_b = 90, 175, 235  # bleu vif façon Risen
        solid = Image.new("RGBA", logo.size, (target_r, target_g, target_b, 255))
        logo = Image.merge("RGBA", (*solid.split()[:3], a))
        logo_h = 90
        ratio = logo_h / logo.height
        logo = logo.resize((int(logo.width * ratio), logo_h), Image.LANCZOS)
        img.alpha_composite(logo, (margin_x, 45))
        logo_w = logo.width

    y_title = 140 + (logo_w > 0) * 110  # laisse la place au logo au-dessus du titre
    if kicker:
        draw.text((margin_x, 90 + (logo_w > 0) * 110), kicker.upper(), font=font_kicker, fill=(120, 160, 210))
        y_title = 140 + (logo_w > 0) * 110

    # Titre (peut wrapper sur 2 lignes)
    max_title_w = W - margin_x * 2
    title_lines = wrap_text(draw, title, font_title, max_title_w)
    ty = y_title
    for line in title_lines:
        draw.text((margin_x, ty), line, font=font_title, fill=(255, 255, 255))
        ty += 92

    # Bullets
    y = ty + 90
    max_w = W - margin_x * 2 - 80
    line_height = 52
    for b in bullets:
        bx = margin_x + 22
        draw.ellipse([bx, y + 16, bx + 12, y + 28], fill=(235, 235, 240))
        text_x = margin_x + 60
        y_end = draw_rich_line(draw, text_x, y, b, font_bullet, font_bullet_bold,
                                (225, 227, 232), max_w, line_height)
        y = y_end + 34  # espace entre bullets

    if footer:
        draw.text((margin_x, H - 80), footer, font=ImageFont.truetype(FONT_REGULAR, 26), fill=(110, 120, 140))

    return img.convert("RGB")


def build_pdf(slides, out_path, brand_logo=LOGO_PATH, footer=None):
    """slides: liste de tuples (title, bullets_list) ou (title, bullets_list, kicker)."""
    buf_list = []
    for entry in slides:
        if len(entry) == 3:
            title, bullets, kicker = entry
        else:
            title, bullets = entry
            kicker = None
        im = draw_slide(title, bullets, brand_logo=brand_logo, footer=footer, kicker=kicker)
        buf = io.BytesIO()
        im.save(buf, format="PNG")
        buf_list.append(buf.getvalue())
    with open(out_path, "wb") as f:
        f.write(img2pdf.convert(buf_list))
    print("saved", out_path)


if __name__ == "__main__":
    pass
