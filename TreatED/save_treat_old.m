function save_treat(pplist,sppsave,patExp,patTreated,patGraphics,descrl,folders2save,project,structure,experiment)
% put_treat(pplist,sppsave,patExp,patTreated,patGraphics,descrl,folders2save,project,structure,experiment)
%
%     Saves into the experiment folder a list of postprocessings, csv
%     signals,
%     graphs and other files treted after a test.
%
% SEE ALSO:  putpp   putdocu
%
% csv files compatible with ELSADATA 2018

global AUTOMATIC_SEL_TREAT  %4-April-2008


iarg=9;
if nargin<iarg; postprocessing=[]; end; iarg=iarg-1;

if isempty(AUTOMATIC_SEL_TREAT) %4-April-2008
    AUTOMATIC_SEL_TREAT=0;
end
AUTOMATIC_SEL_TREAT;



    
if isempty(dir(patTreated));
    if AUTOMATIC_SEL_TREAT>0
        isel=AUTOMATIC_SEL_TREAT;
    else
        isel = menu('The data have been treated. Please, choose an option:',...
            ['Create the directory ' patTreated ' and save the data there'],...
            'Exit');
    end
    asel={'create and save' 'exit'};
else
    if AUTOMATIC_SEL_TREAT>0
        isel=AUTOMATIC_SEL_TREAT;
    else
        isel = menu('The data have been treated. Please, choose an option:',...
            ['Save the data in the existing directory ' patTreated],...
            'Exit');
    end
    asel={'save' 'exit'};
end;
sel=asel{isel};
switch sel;
    case {'create and save'};
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patTreated]);  cd(pwd1);
end;
switch sel;
case {'create and save' 'save'};
    for ipp=1:length(pplist)  %save postprocessing in LAB folder
        pp=pplist{ipp};
        s=sppsave{ipp};
        save([patTreated experiment 'db' pp],'s'); %MATLAB format
        filelst=[patTreated experiment 'db' pp 'lst.txt']; % TXT header file
        fid=fopen(filelst,'w');
        fprintf(fid,'  %s\n\n',date);
        fprintf(fid,'  %s\n\n',patTreated);  fclose(fid);
        repsig(s,filelst,'a');  type(filelst);
        sdata=gm(s);                                                               %2012-02-08
        save(sprintf('%s.txt',[patTreated experiment 'db' pp]), ...
            'sdata','-ASCII');  % TXT body file
        
        
        %here save in csv format!
        
        
        
    end
    if isempty(dir(patGraphics));
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patGraphics]);  cd(pwd1);
    end;   
    pwd1=pwd;    cd(patGraphics);
    graphlist={};
    for ii=1:length(descrl)
        if isempty(pplist)
            pplist1='';
        else
            pplist1=pplist{1};
        end
        graphlist={graphlist{:},[experiment 'dbg' pplist1 sprintf('%02d',ii)]};
%         print(ii,'-djpeg',graphlist{ii}); %create graph file
        print(ii,'-djpeg','-loose',graphlist{ii}); %create graph file
        saveas(ii,graphlist{ii},'fig'); %MATLAB figure file
    end
    cd(pwd1);
    
    
case 'exit';
    return
end;
