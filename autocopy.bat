@echo off

for /d %%i in (Exp*) do (
echo %%i
cd %%i
if not exist *.zip (
mkdir 实验报告文件夹
copy /y *.asm 实验报告文件夹\
copy /y *.ASM 实验报告文件夹\
copy /y *.exe 实验报告文件夹\
copy /y *.EXE 实验报告文件夹\
copy /y CS1603_U201614577* 实验报告文件夹\
7z a 实验报告压缩.zip 实验报告文件夹\
rmdir /s/q 实验报告文件夹
) 
cd ..
)