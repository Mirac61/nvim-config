#!/usr/bin/env python3
"""Generate pixel art and Lua data for the Neovim snacks dashboard.

Requires Pillow for generation only; Neovim uses the generated Lua module.
"""
import argparse
from PIL import Image, ImageDraw
import math
import random
from pathlib import Path

BG = (24, 16, 40)


def canvas(w: int, h: int):
    img = Image.new("RGB", (w, h), BG)
    return img, ImageDraw.Draw(img)


def sparkle(d: ImageDraw.ImageDraw, x: int, y: int, color, size: int = 3):
    d.rectangle((x - size, y, x + size, y), fill=color)
    d.rectangle((x, y - size, x, y + size), fill=color)
    d.rectangle((x - 1, y - 1, x + 1, y + 1), fill=color)


def petals(d: ImageDraw.ImageDraw, n: int, seed: int, color, y0: int = 0, y1: int = 48):
    rnd = random.Random(seed)
    for _ in range(n):
        x, y = rnd.randrange(0, 56), rnd.randrange(y0, y1)
        d.rectangle((x, y, x + 1, y), fill=color)


# ------------------------------------------------------------ spiderlily ---
def spider_flower(d: ImageDraw.ImageDraw, cx: int, cy: int, r: int, petal, petal2, stamen, seed=0):
    """Red spider lily: curled petals and long radiating stamens."""
    rnd = random.Random(seed)
    for i in range(6):
        ang = i * 60 + 10
        rad = math.radians(ang)
        dx, dy = math.cos(rad), math.sin(rad)
        px, py = -dy, dx
        tipx, tipy = cx + dx * r, cy + dy * r * 0.8
        d.polygon(
            [
                (cx, cy),
                (cx + dx * r * 0.5 + px * r * 0.22, cy + dy * r * 0.4 + py * r * 0.22),
                (tipx, tipy),
                (cx + dx * r * 0.5 - px * r * 0.22, cy + dy * r * 0.4 - py * r * 0.22),
            ],
            fill=petal,
        )
        d.line((cx + dx * r * 0.4, cy + dy * r * 0.32, tipx, tipy), fill=petal2, width=1)
    for i in range(8):
        ang = i * 45 + 22 + rnd.randrange(-6, 6)
        rad = math.radians(ang)
        dx, dy = math.cos(rad), math.sin(rad) * 0.85
        ex, ey = cx + dx * r * 1.55, cy + dy * r * 1.55
        d.line((cx, cy, ex, ey), fill=stamen, width=1)
        d.rectangle((ex - 1, ey - 1, ex, ey), fill=stamen)


def draw_spiderlily() -> Image.Image:
    """Higanbana: the red spider lily of resurrection."""
    img, d = canvas(56, 48)
    bg1 = (14, 12, 34)
    bg2 = (24, 18, 52)
    moon = (240, 226, 190)
    moon_dim = (200, 186, 156)
    ground = (10, 20, 18)
    stem = (46, 92, 52)
    stem_hi = (72, 128, 74)
    red = (216, 42, 48)
    red2 = (255, 84, 76)
    red_dark = (150, 22, 34)
    stamen = (255, 128, 96)

    # night sky and dim moon
    d.rectangle((0, 0, 55, 16), fill=bg1)
    d.rectangle((0, 16, 55, 32), fill=bg2)
    d.rectangle((0, 32, 55, 47), fill=bg1)
    d.ellipse((38, 3, 54, 19), fill=moon_dim)
    d.ellipse((40, 5, 52, 17), fill=moon)
    for x, y in ((6, 5), (14, 12), (24, 4), (5, 22), (33, 9)):
        d.rectangle((x, y, x + 1, y + 1), fill=(222, 214, 180))

    # ground
    d.ellipse((-6, 38, 62, 52), fill=ground)
    d.line((0, 41, 55, 39), fill=(18, 38, 30), width=1)

    # stems
    for x0, y0, x1, y1 in ((12, 44, 15, 24), (28, 46, 27, 18), (42, 45, 39, 28), (6, 45, 8, 32)):
        d.line((x0, y0, (x0 + x1) // 2, (y0 + y1) // 2), fill=stem, width=2)
        d.line(((x0 + x1) // 2, (y0 + y1) // 2, x1, y1), fill=stem_hi, width=2)

    # blooms
    spider_flower(d, 15, 21, 6, red, red2, stamen, seed=1)
    spider_flower(d, 27, 15, 7, red, red2, stamen, seed=2)
    spider_flower(d, 39, 25, 6, red, red2, stamen, seed=3)
    spider_flower(d, 8, 30, 5, red_dark, red, stamen, seed=4)

    # falling petals
    petals(d, 12, 5, red2, y0=2, y1=44)
    return img


# --------------------------------------------------------------- kitsune ---
def draw_kitsune() -> Image.Image:
    """Fox mask with vermilion markings."""
    img, d = canvas(56, 48)
    bg1 = (22, 16, 46)
    bg2 = (36, 24, 66)
    mask = (248, 242, 236)
    mask_sh = (214, 202, 202)
    red = (212, 52, 58)
    red2 = (255, 96, 88)
    dark = (30, 20, 40)
    pink = (255, 170, 190)

    # background + petals
    d.rectangle((0, 0, 55, 16), fill=bg1)
    d.rectangle((0, 16, 55, 32), fill=bg2)
    d.rectangle((0, 32, 55, 47), fill=bg1)
    petals(d, 14, 21, pink, y0=0, y1=47)
    d.ellipse((14, 8, 42, 40), fill=bg2)

    # ears
    d.polygon([(12, 18), (10, 4), (23, 13)], fill=mask)
    d.polygon([(44, 18), (46, 4), (33, 13)], fill=mask)
    d.polygon([(14, 15), (13, 7), (20, 13)], fill=red)
    d.polygon([(42, 15), (43, 7), (36, 13)], fill=red)

    # mask face
    d.ellipse((13, 11, 43, 39), fill=mask)
    d.polygon([(16, 30), (28, 46), (40, 30), (40, 36), (28, 47), (16, 36)], fill=mask)
    d.ellipse((36, 14, 43, 34), fill=mask_sh)
    d.ellipse((13, 14, 20, 34), fill=mask_sh)

    # eye slits
    d.polygon([(16, 24), (25, 27), (23, 31), (16, 28)], fill=dark)
    d.polygon([(40, 24), (31, 27), (33, 31), (40, 28)], fill=dark)
    d.polygon([(17, 25), (24, 27), (22, 29), (17, 27)], fill=red)
    d.polygon([(39, 25), (32, 27), (34, 29), (39, 27)], fill=red)

    # forehead flame + cheeks + nose
    d.polygon([(28, 12), (31, 19), (28, 17), (25, 19)], fill=red)
    d.line((22, 20, 26, 22), fill=red2, width=1)
    d.line((34, 20, 30, 22), fill=red2, width=1)
    d.line((16, 32, 21, 33), fill=red, width=1)
    d.line((40, 32, 35, 33), fill=red, width=1)
    d.polygon([(26, 34), (30, 34), (28, 37)], fill=red)

    # ribbon below the mask
    d.line((28, 45, 24, 47), fill=red, width=1)
    d.line((28, 45, 33, 47), fill=red, width=1)
    return img


# ------------------------------------------------------------ swordsaint ---
def draw_swordsaint() -> Image.Image:
    """A lone swordsman beneath the full moon."""
    img, d = canvas(56, 48)
    sky1 = (18, 20, 58)
    sky2 = (30, 34, 88)
    sky3 = (52, 52, 112)
    moon = (255, 240, 200)
    moon_sh = (226, 206, 168)
    star = (240, 232, 200)
    hill = (14, 16, 38)
    figure = (12, 12, 28)
    steel = (200, 212, 232)
    pink = (255, 180, 200)

    # sky
    d.rectangle((0, 0, 55, 16), fill=sky1)
    d.rectangle((0, 16, 55, 32), fill=sky2)
    d.rectangle((0, 32, 55, 47), fill=sky3)

    # moon in the upper right, clear of the figure
    d.ellipse((34, 2, 54, 22), fill=moon_sh)
    d.ellipse((36, 4, 52, 20), fill=moon)
    d.ellipse((40, 7, 44, 11), fill=moon_sh)
    d.ellipse((45, 13, 48, 16), fill=moon_sh)

    for x, y in ((6, 6), (14, 12), (22, 4), (8, 22), (19, 18), (28, 9)):
        d.rectangle((x, y, x + 1, y + 1), fill=star)

    # hill
    d.ellipse((-14, 38, 42, 56), fill=hill)
    d.ellipse((28, 40, 74, 58), fill=hill)
    d.rectangle((0, 44, 55, 47), fill=hill)

    # swordsman silhouette, small against the sky, left of the moon
    cx = 20
    d.polygon([(cx - 7, 22), (cx, 17), (cx + 7, 22)], fill=figure)  # kasa hat
    d.ellipse((cx - 8, 21, cx + 8, 25), fill=figure)  # hat brim
    d.rectangle((cx - 3, 25, cx + 3, 29), fill=figure)  # head/neck
    d.polygon([(cx - 6, 29), (cx + 6, 29), (cx + 8, 44), (cx - 8, 44)], fill=figure)  # kimono
    d.polygon([(cx - 6, 30), (cx - 12, 38), (cx - 9, 42), (cx - 3, 34)], fill=figure)  # sleeve
    d.polygon([(cx + 6, 30), (cx + 11, 37), (cx + 9, 41), (cx + 3, 34)], fill=figure)

    # katana raised diagonally, visible against the sky
    d.line((cx + 11, 36, cx + 31, 16), fill=steel, width=1)
    d.line((cx + 10, 38, cx + 14, 34), fill=figure, width=2)  # hilt
    d.rectangle((cx + 9, 35, cx + 12, 38), fill=figure)  # guard

    petals(d, 10, 33, pink, y0=2, y1=44)
    return img


# ------------------------------------------------------------------- moon ---
def draw_moon_cat() -> Image.Image:
    img, d = canvas(56, 44)
    sky = (18, 14, 48)
    sky2 = (30, 24, 74)
    moon = (255, 214, 120)
    moon_sh = (232, 178, 82)
    star = (255, 236, 180)
    cloud = (66, 58, 120)
    cloud2 = (92, 82, 158)
    cat = (16, 12, 38)
    eye = (120, 240, 200)

    # sky
    d.rectangle((0, 0, 55, 43), fill=sky)
    d.rectangle((0, 0, 55, 18), fill=sky2)

    # moon with crescent shade
    d.ellipse((26, 6, 52, 32), fill=moon)
    d.ellipse((20, 2, 46, 28), fill=sky2)
    d.ellipse((44, 22, 50, 28), fill=moon_sh)

    # stars
    for x, y, s in ((6, 6, 3), (14, 14, 2), (22, 5, 2), (34, 16, 2), (48, 4, 3), (8, 24, 2), (52, 14, 2)):
        sparkle(d, x, y, star, s)
    for x, y in ((3, 14, ), (18, 22, ), (28, 12, ), (43, 8, ), (12, 34, ), (24, 30, )):
        d.rectangle((x, y, x + 1, y + 1), fill=star)

    # clouds
    d.ellipse((-8, 32, 30, 44), fill=cloud)
    d.ellipse((14, 34, 48, 46), fill=cloud)
    d.ellipse((30, 30, 64, 44), fill=cloud)
    d.ellipse((-4, 30, 22, 40), fill=cloud2)
    d.ellipse((24, 32, 46, 41), fill=cloud2)

    # sitting cat silhouette
    cx = 27
    d.ellipse((cx - 8, 18, cx + 8, 36), fill=cat)  # body
    d.ellipse((cx - 7, 10, cx + 7, 26), fill=cat)  # head
    d.polygon([(cx - 7, 14), (cx - 9, 4), (cx - 2, 11)], fill=cat)  # ears
    d.polygon([(cx + 7, 14), (cx + 9, 4), (cx + 2, 11)], fill=cat)
    d.ellipse((cx + 4, 28, cx + 16, 36), fill=cat)  # tail
    d.ellipse((cx + 2, 26, cx + 12, 34), fill=sky2)
    # eyes + nose
    d.ellipse((cx - 5, 16, cx - 2, 19), fill=eye)
    d.ellipse((cx + 2, 16, cx + 5, 19), fill=eye)
    d.rectangle((cx - 1, 20, cx + 1, 21), fill=(255, 120, 150))
    return img


# ------------------------------------------------------------------ torii ---
def draw_torii() -> Image.Image:
    img, d = canvas(56, 44)
    sky_hi = (255, 202, 148)
    sky = (255, 152, 110)
    sky_lo = (242, 110, 96)
    sun = (255, 228, 168)
    sun_hi = (255, 246, 214)
    gate = (128, 42, 42)
    gate2 = (96, 30, 34)
    silhouette = (52, 30, 60)
    ground = (30, 22, 48)
    petal = (255, 214, 224)

    # sky bands
    d.rectangle((0, 0, 55, 14), fill=sky_hi)
    d.rectangle((0, 14, 55, 28), fill=sky)
    d.rectangle((0, 28, 55, 43), fill=sky_lo)

    # sun behind the gate
    d.ellipse((15, 6, 41, 32), fill=sun)
    d.ellipse((19, 10, 37, 28), fill=sun_hi)

    # ground
    d.rectangle((0, 39, 55, 43), fill=ground)

    # torii: curved top beam, second beam, lower crossbeam, pillars
    d.polygon([(2, 11), (54, 11), (50, 8), (6, 8)], fill=gate2)  # kasagi tips
    d.rectangle((6, 10, 50, 13), fill=gate)  # kasagi
    d.rectangle((10, 13, 46, 15), fill=gate2)  # shimaki
    d.rectangle((8, 19, 48, 21), fill=gate)  # nuki
    d.rectangle((13, 13, 18, 41), fill=gate)  # left pillar
    d.rectangle((38, 13, 43, 41), fill=gate)  # right pillar
    d.rectangle((13, 13, 18, 16), fill=gate2)  # pillar caps
    d.rectangle((38, 13, 43, 16), fill=gate2)
    d.rectangle((13, 37, 18, 41), fill=gate2)  # pillar feet
    d.rectangle((38, 37, 43, 41), fill=gate2)

    # low bushes at the edges
    for x, y, r in ((-3, 36, 8), (4, 38, 6), (59, 35, 8), (52, 38, 6)):
        d.ellipse((x - r, y - r, x + r, y + r), fill=silhouette)
    d.rectangle((0, 38, 55, 40), fill=silhouette)
    d.rectangle((0, 40, 55, 43), fill=ground)

    # petals drifting through the sky
    rnd = random.Random(7)
    for _ in range(22):
        x, y = rnd.randrange(0, 56), rnd.randrange(2, 38)
        d.rectangle((x, y, x + 1, y), fill=petal)
    return img


# ---------------------------------------------------------------- lantern ---
def draw_lantern() -> Image.Image:
    img, d = canvas(56, 44)
    sky = (14, 18, 52)
    sky2 = (24, 30, 78)
    branch = (96, 52, 40)
    branch2 = (128, 72, 52)
    petal = (255, 170, 195)
    petal2 = (255, 208, 222)
    core = (255, 232, 120)
    lantern = (232, 66, 66)
    lantern2 = (255, 120, 110)
    glow = (255, 190, 120)

    d.rectangle((0, 0, 55, 43), fill=sky)
    d.rectangle((0, 0, 55, 14), fill=sky2)
    for x, y in ((5, 6), (16, 3), (28, 9), (40, 4), (50, 10), (12, 18), (46, 18)):
        d.rectangle((x, y, x + 1, y + 1), fill=(255, 236, 180))

    # branch
    d.line((0, 30, 22, 16), fill=branch, width=4)
    d.line((22, 16, 40, 8), fill=branch, width=3)
    d.line((40, 8, 56, 6), fill=branch, width=3)
    d.line((18, 18, 26, 24), fill=branch2, width=2)
    d.line((34, 11, 42, 16), fill=branch2, width=2)

    # blossom clusters
    for cx, cy in ((10, 24), (20, 16), (30, 12), (40, 9), (48, 7), (26, 22), (16, 28)):
        for dx, dy in ((-3, 0), (3, 0), (0, -3), (0, 3)):
            d.ellipse((cx + dx - 2, cy + dy - 2, cx + dx + 2, cy + dy + 2), fill=petal)
        d.ellipse((cx - 2, cy - 2, cx + 2, cy + 2), fill=petal2)
        d.rectangle((cx - 1, cy - 1, cx, cy), fill=core)

    # falling petals
    rnd = random.Random(11)
    for _ in range(18):
        x, y = rnd.randrange(0, 56), rnd.randrange(12, 42)
        d.rectangle((x, y, x + 1, y), fill=petal2)

    # lantern hanging from branch
    d.line((44, 7, 44, 13), fill=branch, width=1)
    d.ellipse((39, 12, 49, 15), fill=lantern2)
    d.ellipse((38, 14, 50, 28), fill=lantern)
    d.ellipse((41, 16, 47, 26), fill=lantern2)
    d.rectangle((40, 28, 48, 29), fill=lantern2)
    d.line((44, 29, 44, 33), fill=lantern2, width=1)
    d.ellipse((41, 17, 47, 25), fill=glow)
    return img


# -------------------------------------------------------------------- cat ---
def draw_cat() -> Image.Image:
    img, d = canvas(56, 44)
    bg1 = (26, 18, 52)
    fur = (240, 170, 90)
    fur3 = (200, 130, 62)
    white = (255, 246, 232)
    eye = (110, 220, 170)
    pupil = (22, 16, 52)
    pink = (255, 150, 170)

    d.rectangle((0, 0, 55, 43), fill=bg1)
    for x, y in ((4, 5), (12, 3), (22, 8), (33, 4), (44, 9), (52, 5), (7, 16), (49, 16)):
        d.rectangle((x, y, x + 1, y + 1), fill=(255, 236, 180))

    # body
    d.ellipse((10, 22, 46, 46), fill=fur)
    d.ellipse((16, 28, 40, 46), fill=white)
    # head
    d.ellipse((12, 4, 44, 32), fill=fur)
    d.polygon([(14, 12), (12, -2), (24, 7)], fill=fur)  # ears
    d.polygon([(42, 12), (44, -2), (32, 7)], fill=fur)
    d.polygon([(16, 10), (15, 2), (21, 7)], fill=pink)
    d.polygon([(40, 10), (41, 2), (35, 7)], fill=pink)
    # cheeks + muzzle
    d.ellipse((14, 18, 26, 28), fill=white)
    d.ellipse((30, 18, 42, 28), fill=white)
    d.ellipse((22, 22, 34, 30), fill=white)
    # eyes
    for cx in (20, 36):
        d.ellipse((cx - 6, 14, cx + 6, 26), fill=white)
        d.ellipse((cx - 5, 15, cx + 5, 25), fill=eye)
        d.ellipse((cx - 2, 16, cx + 2, 24), fill=pupil)
        d.ellipse((cx - 4, 16, cx - 1, 19), fill=white)
        d.rectangle((cx - 6, 13, cx + 6, 14), fill=fur3)
    # nose + mouth
    d.polygon([(27, 23), (30, 23), (28, 25)], fill=pink)
    d.arc((25, 24, 29, 27), 0, 180, fill=fur3, width=1)
    d.arc((28, 24, 32, 27), 0, 180, fill=fur3, width=1)
    # whiskers
    for y in (22, 25):
        d.line((4, y + 1, 15, y), fill=white, width=1)
        d.line((52, y + 1, 41, y), fill=white, width=1)
    # stripes
    d.line((16, 8, 19, 11), fill=fur3, width=2)
    d.line((37, 8, 40, 11), fill=fur3, width=2)
    d.line((27, 6, 28, 9), fill=fur3, width=2)
    return img


def draw_koi() -> Image.Image:
    """A bright koi circling beneath the moon in a dark garden pond."""
    img, d = canvas(56, 48)
    sky = (16, 18, 48)
    water = (18, 36, 66)
    water2 = (25, 49, 80)
    shimmer = (72, 112, 150)
    moon = (255, 232, 178)
    star = (255, 240, 198)
    koi = (246, 240, 225)
    orange = (235, 112, 54)
    orange2 = (194, 66, 42)
    fin = (226, 192, 160)
    lily = (50, 116, 76)
    lily_hi = (74, 148, 92)

    d.rectangle((0, 0, 55, 13), fill=sky)
    d.ellipse((5, 2, 17, 14), fill=moon)
    d.ellipse((8, 4, 14, 10), fill=(255, 247, 216))
    for x, y in ((25, 4), (36, 9), (49, 3), (3, 19), (51, 23)):
        d.rectangle((x, y, x + 1, y + 1), fill=star)

    d.rectangle((0, 14, 55, 31), fill=water)
    d.rectangle((0, 32, 55, 47), fill=water2)
    # moon trail on the pond
    for y, x, w in ((16, 7, 9), (19, 10, 7), (23, 6, 12), (27, 11, 8), (32, 5, 11), (37, 9, 7), (42, 4, 12)):
        d.rectangle((x, y, x + w, y + 1), fill=shimmer)

    # rings around a top-view koi
    for box in ((17, 17, 43, 43), (13, 14, 47, 46), (20, 20, 40, 40)):
        d.arc(box, 190, 345, fill=shimmer, width=1)

    # fish body, head, fins and forked tail
    d.polygon([(27, 36), (22, 42), (27, 40), (32, 42)], fill=koi)
    d.ellipse((21, 18, 33, 38), fill=koi)
    d.ellipse((20, 14, 34, 23), fill=koi)
    d.polygon([(21, 24), (15, 29), (21, 31)], fill=fin)
    d.polygon([(33, 24), (39, 29), (33, 31)], fill=fin)
    d.ellipse((22, 15, 32, 21), fill=orange)
    d.ellipse((23, 25, 31, 29), fill=orange2)
    d.ellipse((24, 33, 30, 36), fill=orange)
    d.rectangle((23, 17, 24, 18), fill=(20, 18, 30))
    d.rectangle((30, 17, 31, 18), fill=(20, 18, 30))
    d.line((24, 21, 22, 23), fill=fin, width=1)
    d.line((30, 21, 32, 23), fill=fin, width=1)

    # lily pads in the corners
    for cx, cy, rx in ((48, 39, 6), (7, 43, 5)):
        d.ellipse((cx - rx, cy - 3, cx + rx, cy + 3), fill=lily)
        d.arc((cx - rx + 1, cy - 2, cx + rx - 1, cy + 2), 190, 345, fill=lily_hi, width=1)
        d.polygon([(cx, cy), (cx + rx, cy - 2), (cx + rx, cy + 2)], fill=water2)
    return img


def draw_pagoda() -> Image.Image:
    """A tiered shrine pagoda with lit windows under a full moon."""
    img, d = canvas(56, 48)
    sky = (16, 18, 50)
    sky2 = (28, 30, 74)
    moon = (255, 232, 184)
    star = (246, 232, 190)
    roof = (38, 28, 60)
    roof_hi = (78, 42, 58)
    wall = (54, 42, 76)
    window = (255, 184, 86)
    ground = (16, 18, 34)
    trunk = (88, 54, 50)
    blossom = (238, 126, 168)
    blossom_hi = (255, 184, 206)

    d.rectangle((0, 0, 55, 20), fill=sky)
    d.rectangle((0, 20, 55, 47), fill=sky2)
    d.ellipse((36, 3, 54, 21), fill=moon)
    d.ellipse((40, 6, 45, 11), fill=(246, 214, 164))
    for x, y in ((5, 5), (14, 12), (29, 6), (49, 26), (3, 30)):
        d.rectangle((x, y, x + 1, y + 1), fill=star)

    # ground and a small sakura tree on the left
    d.rectangle((0, 43, 55, 47), fill=ground)
    d.line((7, 43, 8, 28), fill=trunk, width=2)
    d.line((8, 34, 3, 29), fill=trunk, width=1)
    d.line((8, 32, 14, 26), fill=trunk, width=1)
    for cx, cy in ((3, 28), (8, 25), (13, 27), (5, 33), (12, 32)):
        d.ellipse((cx - 4, cy - 3, cx + 4, cy + 3), fill=blossom)
        d.rectangle((cx - 1, cy - 1, cx, cy), fill=blossom_hi)

    cx = 30
    # finial
    d.line((cx, 3, cx, 10), fill=roof_hi, width=1)
    for y, half, body_bottom in ((11, 7, 17), (19, 11, 25), (27, 15, 33), (35, 19, 43)):
        # upturned eaves and roof ridge
        d.polygon([(cx - half - 3, y + 3), (cx + half + 3, y + 3), (cx + half - 2, y - 1), (cx - half + 2, y - 1)], fill=roof)
        d.polygon([(cx - half - 3, y + 3), (cx - half - 5, y), (cx - half + 2, y - 1)], fill=roof_hi)
        d.polygon([(cx + half + 3, y + 3), (cx + half + 5, y), (cx + half - 2, y - 1)], fill=roof_hi)
        left, right = cx - half + 4, cx + half - 4
        if body_bottom > y + 3 and left <= right:
            d.rectangle((left, y + 3, right, body_bottom), fill=wall)
            d.rectangle((cx - 1, y + 4, cx + 1, body_bottom - 1), fill=window)
            d.rectangle((cx - 3, body_bottom, cx + 3, body_bottom), fill=roof_hi)
    return img


def draw_toronagashi() -> Image.Image:
    """Floating remembrance lanterns on a moonlit river."""
    img, d = canvas(56, 48)
    sky = (14, 16, 44)
    sky2 = (24, 26, 62)
    water = (15, 30, 58)
    water2 = (24, 44, 74)
    water3 = (32, 56, 88)
    moon = (240, 226, 190)
    star = (236, 228, 198)
    paper = (255, 216, 148)
    paper_hi = (255, 240, 194)
    flame = (255, 188, 82)
    reflection = (190, 124, 76)
    shore = (12, 14, 32)

    d.rectangle((0, 0, 55, 13), fill=sky)
    d.rectangle((0, 13, 55, 18), fill=sky2)
    d.ellipse((40, 1, 54, 15), fill=moon)
    d.ellipse((44, 4, 49, 8), fill=(218, 204, 174))
    for x, y in ((5, 4), (16, 8), (28, 3), (34, 11), (11, 13)):
        d.rectangle((x, y, x + 1, y + 1), fill=star)
    d.rectangle((0, 15, 55, 18), fill=shore)
    d.ellipse((3, 10, 13, 18), fill=shore)
    d.ellipse((29, 11, 37, 18), fill=shore)

    d.rectangle((0, 18, 55, 29), fill=water)
    d.rectangle((0, 29, 55, 39), fill=water2)
    d.rectangle((0, 39, 55, 47), fill=water3)
    # water lines
    for x, y, w in ((2, 22, 8), (39, 20, 11), (7, 34, 9), (38, 37, 12), (4, 44, 8), (25, 45, 10)):
        d.line((x, y, x + w, y), fill=(63, 94, 132), width=1)

    def lantern(cx: int, top: int, size: int) -> None:
        bottom = top + size * 2
        d.rectangle((cx - size, top, cx + size, bottom), fill=paper)
        d.rectangle((cx - size + 1, top + 1, cx + size - 1, bottom - 1), fill=paper_hi)
        d.rectangle((cx - size - 1, top, cx + size + 1, top + 1), fill=flame)
        d.rectangle((cx - size - 1, bottom - 1, cx + size + 1, bottom), fill=flame)
        d.line((cx, top - 3, cx, top), fill=flame, width=1)
        d.rectangle((cx - 1, top - 2, cx, top - 1), fill=paper_hi)
        d.rectangle((cx - size - 2, bottom + 2, cx + size + 2, bottom + 2), fill=reflection)
        d.rectangle((cx - size, bottom + 4, cx + size, bottom + 4), fill=(128, 82, 70))
        d.line((cx - size - 3, bottom + 6, cx + size + 3, bottom + 6), fill=(75, 86, 120), width=1)

    lantern(10, 23, 3)
    lantern(27, 29, 4)
    lantern(45, 22, 3)
    return img


def draw_maneki() -> Image.Image:
    """A cheerful maneki-neko with a raised paw and gold koban."""
    img, d = canvas(56, 48)
    bg = (28, 18, 48)
    bg2 = (42, 26, 66)
    white = (248, 244, 232)
    shade = (218, 210, 202)
    red = (208, 54, 62)
    red_hi = (240, 92, 92)
    gold = (232, 176, 54)
    gold_hi = (255, 218, 112)
    ink = (46, 34, 50)
    pink = (242, 148, 158)

    d.rectangle((0, 0, 55, 47), fill=bg)
    d.rectangle((0, 30, 55, 47), fill=bg2)
    for x, y in ((5, 5), (48, 6), (8, 18), (50, 23), (7, 40), (49, 42)):
        sparkle(d, x, y, gold_hi, 1)

    # body and head
    d.ellipse((12, 26, 43, 49), fill=white)
    d.ellipse((15, 31, 40, 47), fill=shade)
    d.ellipse((11, 7, 45, 35), fill=white)
    d.polygon([(14, 15), (11, 1), (24, 10)], fill=white)
    d.polygon([(42, 15), (45, 1), (32, 10)], fill=white)
    d.polygon([(16, 11), (14, 4), (21, 10)], fill=pink)
    d.polygon([(40, 11), (42, 4), (35, 10)], fill=pink)

    # face and whiskers
    d.ellipse((18, 17, 23, 22), fill=ink)
    d.ellipse((33, 17, 38, 22), fill=ink)
    d.ellipse((19, 18, 20, 19), fill=white)
    d.ellipse((34, 18, 35, 19), fill=white)
    d.polygon([(26, 23), (30, 23), (28, 26)], fill=pink)
    d.arc((23, 24, 28, 29), 5, 170, fill=ink, width=1)
    d.arc((28, 24, 33, 29), 5, 170, fill=ink, width=1)
    for y in (21, 25):
        d.line((4, y, 15, y + 1), fill=shade, width=1)
        d.line((41, y + 1, 52, y), fill=shade, width=1)

    # red collar and bell
    d.rectangle((17, 31, 39, 34), fill=red)
    d.ellipse((25, 32, 31, 39), fill=gold)
    d.ellipse((27, 34, 29, 36), fill=ink)

    # raised paw at the right
    d.ellipse((38, 17, 49, 31), fill=white)
    d.ellipse((40, 15, 47, 23), fill=white)
    d.line((41, 23, 41, 27), fill=shade, width=1)
    d.line((45, 22, 45, 27), fill=shade, width=1)
    d.line((48, 22, 51, 20), fill=white, width=2)

    # gold koban held at the left
    d.ellipse((5, 33, 21, 43), fill=gold)
    d.ellipse((7, 35, 19, 41), fill=gold_hi)
    d.line((10, 36, 10, 40), fill=(154, 102, 42), width=1)
    d.line((13, 35, 13, 41), fill=(154, 102, 42), width=1)
    d.line((16, 36, 16, 40), fill=(154, 102, 42), width=1)
    d.ellipse((12, 30, 22, 39), fill=white)  # paw holding coin
    return img


def draw_fireflies() -> Image.Image:
    """Fireflies drift through bamboo above a red spider lily."""
    img, d = canvas(56, 48)
    sky = (10, 20, 34)
    sky2 = (17, 36, 48)
    glow_bg = (28, 54, 62)
    moon = (230, 232, 206)
    bamboo = (38, 102, 72)
    bamboo_hi = (70, 142, 92)
    node = (28, 76, 58)
    leaf = (56, 126, 82)
    firefly_glow = (84, 126, 58)
    firefly = (220, 238, 116)
    ground = (12, 28, 28)
    red = (216, 42, 48)
    red_hi = (255, 96, 82)
    green = (50, 104, 60)

    d.rectangle((0, 0, 55, 19), fill=sky)
    d.rectangle((0, 19, 55, 38), fill=sky2)
    d.ellipse((31, 1, 55, 25), fill=glow_bg)
    d.ellipse((37, 5, 51, 19), fill=moon)

    # bamboo stalks with visible joints
    for x, lean, top in ((5, 1, 0), (17, -1, 3), (40, 1, 0), (51, -1, 5)):
        for y in range(top, 44, 9):
            xx = x + (y // 9) * lean
            d.rectangle((xx, y, xx + 3, min(y + 8, 47)), fill=bamboo)
            d.rectangle((xx, y, xx + 1, min(y + 8, 47)), fill=bamboo_hi)
            d.line((xx - 1, y + 8, xx + 4, y + 8), fill=node, width=1)
        d.line((x + 2, top + 4, x - 4, top), fill=leaf, width=1)
        d.line((x + 2, top + 8, x + 8, top + 3), fill=leaf, width=1)

    # fireflies with small, restrained glow blocks
    for x, y in ((12, 13), (25, 9), (32, 24), (8, 30), (22, 35), (46, 28), (30, 16), (14, 24), (48, 12)):
        d.rectangle((x - 1, y - 1, x + 2, y + 2), fill=firefly_glow)
        d.rectangle((x, y, x + 1, y + 1), fill=firefly)

    # dark ground and a red higanbana tying back to the resurrection theme
    d.rectangle((0, 41, 55, 47), fill=ground)
    d.line((27, 46, 28, 35), fill=green, width=2)
    d.line((28, 42, 21, 39), fill=green, width=1)
    d.line((28, 43, 35, 40), fill=green, width=1)
    for dx, dy in ((-4, 0), (4, 0), (0, -4), (0, 4), (-3, -3), (3, -3)):
        d.ellipse((28 + dx - 2, 34 + dy - 2, 28 + dx + 2, 34 + dy + 2), fill=red)
    d.ellipse((26, 32, 30, 36), fill=red_hi)
    return img


ARTS = {
    "moon": draw_moon_cat(),
    "koi": draw_koi(),
    "torii": draw_torii(),
    "pagoda": draw_pagoda(),
    "lantern": draw_lantern(),
    "toronagashi": draw_toronagashi(),
    "cat": draw_cat(),
    "maneki": draw_maneki(),
    "spiderlily": draw_spiderlily(),
    "fireflies": draw_fireflies(),
    "kitsune": draw_kitsune(),
    "swordsaint": draw_swordsaint(),
}

LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


def emit_lua(path: str) -> None:
    """Write the arts as compact palette+pixel data for the Neovim dashboard."""
    lines = [
        "-- Generated pixel art for the snacks dashboard.",
        "-- Each art is a palette (letter -> hex color) plus one letter per pixel.",
        "-- The dashboard renders it with half-block characters (two pixels per row).",
        "return {",
    ]
    for name, img in ARTS.items():
        w, h = img.size
        p = img.load()
        freq: dict[tuple[int, int, int], int] = {}
        for y in range(h):
            for x in range(w):
                freq[p[x, y]] = freq.get(p[x, y], 0) + 1
        order = sorted(freq, key=lambda c: -freq[c])
        if len(order) > len(LETTERS):
            raise SystemExit(f"{name}: too many colors ({len(order)})")
        letter = {c: LETTERS[i] for i, c in enumerate(order)}
        lines.append(f"\t{{\n\t\tname = {name!r},".replace("'", '"'))
        lines.append(f"\t\twidth = {w},\n\t\theight = {h},")
        lines.append("\t\tcolors = {")
        for c in order:
            hex_color = "#{:02x}{:02x}{:02x}".format(*c)
            lines.append(f'\t\t\t["{letter[c]}"] = "{hex_color}",')
        lines.append("\t\t},")
        lines.append("\t\tpixels = {")
        for y in range(h):
            row = "".join(letter[p[x, y]] for x in range(w))
            lines.append(f'\t\t\t"{row}",')
        lines.append("\t\t},")
        lines.append("\t},")
    lines.append("}")
    with open(path, "w") as f:
        f.write("\n".join(lines) + "\n")
    print(f"lua module -> {path}")


def preview(img: Image.Image, path: str, scale: int = 8) -> None:
    w, h = img.size
    out = Image.new("RGB", (w * scale, h * scale), BG)
    d = ImageDraw.Draw(out)
    p = img.load()
    for y in range(h):
        for x in range(w):
            d.rectangle(
                (x * scale, y * scale, x * scale + scale - 1, y * scale + scale - 1),
                fill=p[x, y],
            )
    out.save(path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--preview-dir", type=Path, help="also write PNG previews into this directory")
    args = parser.parse_args()

    repo = Path(__file__).resolve().parents[1]
    output = repo / "nvim/.config/nvim/lua/config/dashboard_art.lua"
    emit_lua(str(output))
    if args.preview_dir:
        args.preview_dir.mkdir(parents=True, exist_ok=True)
        for name, img in ARTS.items():
            path = args.preview_dir / f"{name}.png"
            preview(img, str(path))
            print(f"{name}: {img.size[0]}x{img.size[1]} -> {path}")
