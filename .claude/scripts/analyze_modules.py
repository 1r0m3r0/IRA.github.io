import os, re, json

BASE = r"D:\poryectosPulidos\PAGINA\cursos\programa-datos-fundamentos"
courses = [d for d in os.listdir(BASE) if os.path.isdir(os.path.join(BASE, d)) and d.startswith("curso-")]

color_map = {
    "curso-1-python-data-science": "#00e0ff",
    "curso-2-estadistica": "#ffb347",
    "curso-3-probabilidad": "#2b9eff",
    "curso-4-visualizacion": "#9c64ff",
    "curso-5-sql-data-science": "#ff5050",
    "curso-6-intro-machine-learning": "#ffd700"
}
color_names = {
    "curso-1-python-data-science": "cyan",
    "curso-2-estadistica": "orange",
    "curso-3-probabilidad": "blue",
    "curso-4-visualizacion": "purple",
    "curso-5-sql-data-science": "red",
    "curso-6-intro-machine-learning": "gold"
}

metadata = {}

for course in sorted(courses):
    cpath = os.path.join(BASE, course)
    color = color_map.get(course, "#00e0ff")
    cname = color_names.get(course, "cyan")
    # Determine pattern type
    pattern_type = "A" if course in ["curso-1-python-data-science", "curso-2-estadistica", "curso-3-probabilidad"] else "B"
    files = sorted([f for f in os.listdir(cpath) if f.endswith(".html") and f != "index.html"])
    for fname in files:
        fpath = os.path.join(cpath, fname)
        with open(fpath, "r", encoding="utf-8", errors="replace") as f:
            content = f.read()
        
        # Extract title
        title_match = re.search(r'<h1[^>]*>(.*?)</h1>', content, re.DOTALL)
        title = title_match.group(1).strip() if title_match else fname
        
        # Extract subtitle/description
        subtitle = ""
        if pattern_type == "A":
            st_match = re.search(r'<p[^>]*>(.*?)</p>', content.split('<div class="badge-area">')[0], re.DOTALL) if '<div class="badge-area">' in content else None
            if st_match:
                subtitle = st_match.group(1).strip()
        else:
            st_match = re.search(r'<p[^>]*>(.*?)</p>', content.split('<div class="progress-text')[0], re.DOTALL)
            if st_match:
                subtitle = st_match.group(1).strip()
        
        # Extract module number
        mod_num = 1
        mn_match = re.search(r'Módulo (\d+)', content)
        if mn_match:
            mod_num = int(mn_match.group(1))
        elif fname.startswith("0"):
            mn_match2 = re.match(r'0?(\d+)', fname)
            if mn_match2:
                mod_num = int(mn_match2.group(1))
        
        # Extract localStorage keys
        lsk = {}
        if pattern_type == "A":
            lk_match = re.search(r"const\s+(?:MODULE_KEY|M)\s*=\s*'([^']+)'", content)
            if lk_match:
                lsk["MODULE_KEY"] = lk_match.group(1)
            ck_match = re.search(r"const\s+(?:COURSE_KEY|CK)\s*=\s*'([^']+)'", content)
            if ck_match:
                lsk["COURSE_KEY"] = ck_match.group(1)
            pk_match = re.search(r"const\s+(?:PROGRAM_KEY|PK)\s*=\s*'([^']+)'", content)
            if pk_match:
                lsk["PROGRAM_KEY"] = pk_match.group(1)
        else:
            mid_match = re.search(r"const\s+MODULE_ID\s*=\s*'([^']+)'", content)
            if mid_match:
                lsk["MODULE_ID"] = mid_match.group(1)
            cpk_match = re.search(r"const\s+COURSE_PROGRESS_KEY\s*=\s*'([^']+)'", content)
            if cpk_match:
                lsk["COURSE_PROGRESS_KEY"] = cpk_match.group(1)
            bk_match = re.search(r"const\s+BADGE_KEY\s*=\s*'([^']+)'", content)
            if bk_match:
                lsk["BADGE_KEY"] = bk_match.group(1)
        
        # Extract quiz questions
        questions = []
        if pattern_type == "A":
            # Pattern A: questions stored in array ['text', 'options', 'correct']
            qs_match = re.search(r'(?:const\s+questions|const\s+qs)\s*=\s*\[(.*?)\];', content, re.DOTALL)
            if qs_match:
                qs_text = qs_match.group(1)
                q_blocks = re.findall(r'\{(.*?)\}', qs_text, re.DOTALL)
                for qb in q_blocks:
                    text_m = re.search(r'(?:text|q)\s*[=:]\s*"([^"]*)"', qb)
                    opts_m = re.search(r'(?:options|opts)\s*[=:]\s*\[([^\]]*)\]', qb)
                    ans_m = re.search(r'(?:correct|a)\s*[=:]\s*(\d+)', qb)
                    if text_m:
                        q_obj = {"text": text_m.group(1)}
                        if opts_m:
                            q_obj["options"] = re.findall(r'"([^"]*)"', opts_m.group(1))
                        if ans_m:
                            q_obj["correct"] = int(ans_m.group(1))
                        questions.append(q_obj)
        else:
            # Pattern B: questions stored as array of objects with q, opts, ans
            qs_match = re.search(r"const\s+questions\s*=\s*\[(.*?)\];", content, re.DOTALL)
            if qs_match:
                qs_text = qs_match.group(1)
                q_blocks = re.findall(r'\{(.*?)\}', qs_text, re.DOTALL)
                for qb in q_blocks:
                    text_m = re.search(r'[qa]\s*[=:]\s*"([^"]*)"', qb)
                    opts_m = re.search(r'opts\s*[=:]\s*\[([^\]]*)\]', qb)
                    ans_m = re.search(r'ans\s*[=:]\s*(\d+)', qb)
                    if text_m:
                        q_obj = {"text": text_m.group(1)}
                        if opts_m:
                            q_obj["options"] = re.findall(r'"([^"]*)"', opts_m.group(1))
                        if ans_m:
                            q_obj["correct"] = int(ans_m.group(1))
                        questions.append(q_obj)
        
        # Extract badge/insignia name
        badge_name = ""
        if pattern_type == "A":
            bn_match = re.search(r'<h3[^>]*>(.*?)</h3>', content.split('<div id="insigniaArea"')[1] if '<div id="insigniaArea"' in content else content)
            if bn_match:
                badge_name = bn_match.group(1).strip()
        else:
            bn_match = re.search(r'<h3[^>]*>(.*?)</h3>', content.split('<div id="insignia"')[1] if '<div id="insignia"' in content else content)
            if bn_match:
                badge_name = bn_match.group(1).strip()
        
        # Extract total modules
        total = 12
        total_match = re.search(r'(?:TOTAL|total)\s*=\s*(\d+)', content)
        if total_match:
            total = int(total_match.group(1))
        elif '/ 12' in content or 'de 12' in content:
            total = 12
        
        metadata[f"{course}/{fname}"] = {
            "title": title,
            "subtitle": subtitle,
            "mod_num": mod_num,
            "total": total,
            "pattern": pattern_type,
            "color": color,
            "color_name": cname,
            "ls_keys": lsk,
            "questions": questions,
            "badge": badge_name,
            "course_slug": course
        }

print(json.dumps(metadata, ensure_ascii=False, indent=2))
print(f"\n\nTotal files analyzed: {len(metadata)}")
