@echo off

for /d %%i in (Exp*) do (
echo %%i
cd %%i
if exist 实验报告压缩.zip (del 实验报告压缩.zip)
mkdir 实验报告文件夹
copy /y task*.asm 实验报告文件夹\
copy /y task*.ASM 实验报告文件夹\
copy /y task*.exe 实验报告文件夹\
copy /y task*.EXE 实验报告文件夹\
copy /y CS1603_U201614577* 实验报告文件夹\
7z a 实验报告压缩.zip 实验报告文件夹\
rmdir /s/q 实验报告文件夹
cd ..
)