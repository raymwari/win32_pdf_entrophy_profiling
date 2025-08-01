@echo off
if exist main.exe (del main.exe)
nasm -f win32 main.asm 
nasm -f win32 e_hd.asm
nasm -f win32 mem.asm
nasm -f win32 pdf.asm
nasm -f win32 ent.asm
nasm -f win32 ent1.asm
golink /console /entry main main.obj e_hd.obj mem.obj pdf.obj ent.obj ent1.obj kernel32.dll shannon.dll
if exist main.exe (
  del main.obj e_hd.obj mem.obj pdf.obj ent.obj ent1.obj
  main.exe
)
