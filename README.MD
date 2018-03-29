实验说明见doc文档

masm60目录下批处理脚本autoexec.bat内容如下：
@echo off
set PATH=%%PATH%;C:\
set
mount d e:\Desktop\Workspace\Assembly
d:

用途：
该脚本将masm60添加到环境变量path，
目的是可以将工作目录和编译环境目录分离。

注意事项：
1，若开始masm60目录挂在到其他盘，比如mount e c:\masm60；
则set PATH=%%PATH%;C:\中的C:\应相应地换为E:\
2，e:\Desktop\Workspace\Assembly为汇编工作目录。
使用时需要进行相应替换。