function psdcyc(act1)
%psdcyc:     psdcyc variables at master and acq node
%Res
% ELSA OLVIEW. F. J. Molina 2022
%
global S_Step S_Time S_Times;
global S_TestName S_Path S_MenuMode;
global D_Status D_Message;
% global ALGORAV ALGOR_T ALGORUSERINPUT ALGOIREC PSD ALGORALARM MST_DI1_IN PUMPALARM;
global ALGORAV ALGOR_T ALGORUSERINPUT PSD ALGORALARM MST_DI1_IN PUMPALARM;
global STEPVAR STEPSTATUS
global Tempo_IN DATA; %2017
% global R_Param R_Active R_State R_NewTarg R_iTarg R_TargErr R_Record;  % Regulation of SACOMP 2015
% global ALGORFATIGUE ALGORFATIGUEPARAM MIXEDCONTROL;

switch act1;
case 'measure and compute';
  if strcmp(D_Status,'Not initialized');
    psdtradPONYtr('initialize',S_MenuMode);
  end;
  psdtradPONYtr('read',S_MenuMode);
case 'save MAT data';
  if ~strcmp(S_MenuMode,'Remote monitoring')
    disp('saving MAT data');
    cd(S_Path);
    save([S_TestName '_psdcycPONY' num2str(mod(S_Step,5))],...  
        'S_Step', 'S_Time', 'S_Times', 'PSD', 'ALGORALARM', ...
        'PUMPALARM', 'MST_DI1_IN', ...
    'ALGORAV', 'ALGOR_T','ALGORUSERINPUT', ...
    'STEPVAR','STEPSTATUS');  %psdtrad
%     'ALGORAV', 'ALGOR_T','ALGORUSERINPUT','ALGOIREC');
%     'ALGORFATIGUE','ALGORFATIGUEPARAM', 'MIXEDCONTROL', ...
%     'Tempo_IN', 'DATA');
    disp('MAT data saved');
  end
case 'read MAT data'
  disp(['Loading ' S_TestName '_psdcycPONY.mat']);
  dirl=dir([S_TestName '_psdcycPONY*.mat']); dates=[];  
    for il=1:length(dirl)
      dates(il)=datenum(dirl(il).date);
    end
    [datedum,imax]=max(dates);
    fname=dirl(imax).name
  if strcmp(S_MenuMode,'Remote monitoring')
    nfile=mod(str2num(fname(length(fname)-4))-1,5)
  else
    nfile=mod(str2num(fname(length(fname)-4)),5)
  end
  load([S_TestName '_psdcycPONY' num2str(mod(nfile,5))]);
  disp('MAT data was read');
end;
return;








