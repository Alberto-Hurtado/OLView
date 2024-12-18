function a=evalclipb
% returns the information stored in the clipboard
% JM 01
eval('commands=GetClipBoardData;');
eval(commands);
a=ans;
