function Plotdb(action)
% Plotdb(action) plots the signals chosen by the user.
% For DATABASE:  The user choses at the database the signal(s), copy them in the clipboard with the right button of the mouse
% and after press the button "Copy DB  signal to x". 
% Repeats the same for the Y signal.
%
% For DESKTOP signals: The user choses the signals, after getting signal information (getsig),
% check that information is ok, call s2plot with the signals and finally clicks on the button
% "Copy s2plot() Signal to Y".
% The same procedure is for x.
%
% Election of figure number with the indicated for it and Finally, press button "Plot"
%
% JM & VV 02
% 
% s=struct('Project','Dispass ELSA','Structure','Steel Frame BC1BN', ...
%     'Experiment','d24','PostProcessing','60');
% s.Signal={'002' '003'};
% s=getsig(s);
% s2plot(s);
% Note: If doesn't work try to clean signals before.

global nam ysigdb xsigdb ysignal xsignal s SelX SelY loadpp plotting fplo;
global s2plotlist;
if nargin<1; action=[]; end;
if isempty(action); action='initialize'; end;

switch action
case 'initialize'
    nam='empty';
    f=figure;
    set(1,'position',[360 264 829 670])
    Ydb = uicontrol(f,'Style','Pushbutton', 'Tag','Select Y','String', 'Copy DB signals to Y',...
        'Position',[527 400 135 50],'callb','Plotdb(''Ydb'')');
    Xdb = uicontrol(f,'Style','Pushbutton', 'Tag','Select X','String', 'Copy DB signals to X',...
        'Position',[50 400 135 50],'callb','Plotdb(''Xdb'')');
    Yans = uicontrol(f,'Style','Pushbutton', 'Tag','Select Y','String', 'Copy ans signals to Y',...
        'Position',[680 400 135 50],'callb','Plotdb(''Yans'')');
    Xans = uicontrol(f,'Style','Pushbutton', 'Tag','Select X','String', 'Copy ans signals to X',...
        'Position',[200 400 135 50],'callb','Plotdb(''Xans'')'); 
    plotting = uicontrol(f,'Style','pushbutton', 'Tag','Plotting','String','Plot',...
        'Position',[500 50 100 40],'callb','Plotdb(''plotting'')');
    ClearX = uicontrol(f,'Style','Pushbutton', 'Tag','Clear X','String', 'Clear X Signals',...
        'Position',[135 475 100 40],'callb','Plotdb(''ClearX'')');
    ClearY = uicontrol(f,'Style','Pushbutton', 'Tag','Clear X','String', 'Clear Y Signals',...
        'Position',[620 475 100 40],'callb','Plotdb(''ClearY'')');
    num={'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20'};
    TextFig = uicontrol(f,'Style','text', 'Tag','Fig','String','Figure Number',...
        'Position',[630 65 100 30]);
    Fignum = uicontrol(f,'Style','popupmenu', 'Tag','Figures','String',num,...
        'Position',[630 25 100 40],'callb','Plotdb(''FigNum'')');
    xsignal={};
    ysignal={};
    
case 'Ydb'
    dbsig=getsig(evalclipb);
    ysignal={ysignal{:} dbsig{:}};   
    ReportY= uicontrol('Style','Listbox', 'Tag','Repy','String',repsig(ysignal),...
        'Position',[525 200 280 150]);
    
case 'Xdb' 
    dbsig=getsig(evalclipb);
    xsignal={xsignal{:} dbsig{:}};
    ReportX= uicontrol('Style','Listbox', 'Tag','Repx','String',repsig(xsignal),...
        'Position',[50 200 280 150]); 
    
case 'Yans'
    ysignal = {ysignal{:} s2plotlist{:}};
    ReportY= uicontrol('Style','text', 'Tag','Repy','String',repsig(ysignal),...
        'Position',[525 200 280 150]);
    
case 'Xans'
    xsignal={xsignal{:} s2plotlist{:}};
    ReportX= uicontrol('Style','text', 'Tag','Repx','String',repsig(xsignal),...
        'Position',[50 200 280 150]); 
    
case 'ClearX'
    xsignal={};
    ReportX= uicontrol('Style','text', 'Tag','Repx','String',repsig(xsignal),...
        'Position',[50 200 280 150]); 
    
case 'ClearY'  
    ysignal={};
    ReportY= uicontrol('Style','text', 'Tag','Repy','String',repsig(ysignal),...
        'Position',[525 200 280 150]); 
    
case 'FigNum'
    fplo = get(gcbo,'Value');
    
case 'plotting'
    g1=[];	g1.pl{1}.ysig=ysignal;	g1.pl{1}.xsig=xsignal;
    g1=grdef(g1);
    gra(g1,'l',fplo)   
end

