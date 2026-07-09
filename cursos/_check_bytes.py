fpath = r'D:\poryectosPulidos\PAGINA\cursos\programa-sql-medio\curso-1-window-functions\12-mini-proyecto.html'
with open(fpath, 'rb') as f:
    raw = f.read()
# Show bytes around position 6531
start = max(0, 6525)
end = min(len(raw), 6540)
print(f"Bytes {start}-{end}:")
for i in range(start, end):
    print(f"  {i}: {raw[i]:02x} ({chr(raw[i]) if 32 <= raw[i] < 127 else '?'})")
print()
print(f"Total file size: {len(raw)}")
print(f"First 3 bytes: {raw[:3]}")
