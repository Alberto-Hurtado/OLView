function treat2fs(pplist,sppsave,patDatafiles,patSignals,descrl,experiment)
% treat2fs(pplist,sppsave,patExp,patTreated,patGraphics,patSignals,descrl,project,specimen,experiment)
%
%     Saves into file system in folder LAB a list of postprocessings,
%     graphs and other files treted after a test. The stored files have a
%     format compatible with ELSADATA
%
% SEE ALSO:  save_pp2csv ed2fsSignals
%
% 2018 Javier Molina

global AUTOMATIC_SEL_TREAT 
if isempty(AUTOMATIC_SEL_TREAT) %4-April-2008
    AUTOMATIC_SEL_TREAT=0;
end

    
if isempty(dir(patSignals));
    if AUTOMATIC_SEL_TREAT>0
        isel=AUTOMATIC_SEL_TREAT;
    else
        isel = menu('The data have been treated. Please, choose an option:',...
            ['Create the directory ' patSignals ' and save the data there'],...
            'Exit');
    end
    asel={ 'create and save' 'exit'};
else
    if AUTOMATIC_SEL_TREAT>0
        isel=AUTOMATIC_SEL_TREAT;
    else
        isel = menu('The data have been treated. Please, choose an option:',...
            ['Save the data in the existing directory ' patSignals],...
            'Exit');
    end
    asel={'save' 'exit'};
end;
sel=asel{isel};
switch sel;
case {'create and save' 'save'};
    switch sel;
    case {'create and save'};
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patSignals]);  cd(pwd1);
    end;
    
    for ipp=1:length(pplist)            
        s=sppsave{ipp};
        tab_csv=save_pp2csv(s,patSignals,experiment);  %save postprocessing in csv
    end

    % tab for excel sheet with datafile props    
    tabfields={'name' 'roleLabel' 'description' 'subfolder' 'fileName'};   %2020 01 30
    tab(1,1:length(tabfields))=tabfields;
    if ~exist(patDatafiles,'dir')
        dos(['mkdir ' patDatafiles]);
    end
    PropFileName='DatafilesProps.xlsx';
    propFile=[patDatafiles '\' PropFileName]
    if ~exist(propFile,'file')
        xlswrite(propFile,tab);
    end
    [num,tab0,raw] = xlsread(propFile);
    [row,iColName] = find(strcmp(tabfields,'name'));
    [row,iColDescription] = find(strcmp(tabfields,'description'));
    [row,iColRoleLabel] = find(strcmp(tabfields,'roleLabel'));
    [row,iColSubfolder] = find(strcmp(tabfields,'subfolder'));
    [row,iColFileName] = find(strcmp(tabfields,'fileName'));
    if size(tab0,1)>1
        [row,iColName0] = find(strcmp(tab0(1,:),'name'));
        [row,iColRoleLabel0] = find(strcmp(tab0(1,:),'roleLabel'));
        [row,iColDescription0] = find(strcmp(tab0(1,:),'description'));
        [row,iColSubfolder0] = find(strcmp(tab0(1,:),'subfolder'));
        [row,iColFileName0] = find(strcmp(tab0(1,:),'fileName'));
        if isempty(iColSubfolder0)    % 2020-01-29
            newCol=cell(size(tab0,1),1);
            newCol{1}='subfolder';
            tab0(:,size(tab0,2)+1)=newCol;
            [row,iColSubfolder0] = find(strcmp(tab0(1,:),'subfolder'));
        end
        if isempty(iColFileName0)    % 2020-01-29
            newCol=cell(size(tab0,1),1);
            newCol{1}='fileName';
            tab0(:,size(tab0,2)+1)=newCol;
            [row,iColFileName0] = find(strcmp(tab0(1,:),'fileName'));
        end
        tab = tab0;
        tab(:,[iColName iColRoleLabel iColDescription iColSubfolder]) = ...
            tab0(:,[iColName0 iColRoleLabel0 iColDescription0 iColSubfolder0]);
    end

    if isempty(pplist)
        pplist1='';
    else
        pplist1=pplist{1};
    end
    roleLabelFolder='Processed_data'
    roleLabel=strrep(roleLabelFolder,'_',' ');
    for ipp=1:length(pplist)
        pp=pplist{ipp};
        s=sppsave{ipp};
        
        name=[experiment 'db' pp];
        save([patDatafiles roleLabelFolder '\' name],'s');
        fileName=[name '.mat'];
        irow=row4name(tab,iColName,fileName); %find existing row or assigns new one
        tab{irow,iColName}=fileName;
        tab{irow,iColDescription}='Signals in MATLAB format';
        tab{irow,iColRoleLabel}=roleLabel;
        tab{irow,iColSubfolder}='';
        tab{irow,iColFileName}=fileName;
        
        name=[experiment 'db' pp 'lst'];
        fileName=[name '.txt'];
        filelst=[patDatafiles roleLabelFolder '\' fileName];
        fid=fopen(filelst,'w');
        fprintf(fid,'  %s\n\n',date);
        fprintf(fid,'  %s\n\n',[patDatafiles roleLabelFolder '\']);  fclose(fid);
        repsig(s,filelst,'a');  type(filelst);
        irow=row4name(tab,iColName,fileName); %find existing row or assigns new one
        tab{irow,iColName}=fileName;
        tab{irow,iColDescription}='Signals in txt format (header)';
        tab{irow,iColSubfolder}='';
        tab{irow,iColFileName}=fileName;
        tab{irow,iColRoleLabel}=roleLabel;
        
        name=[experiment 'db' pp];
        fileName=[name '.txt'];
        sdata=gm(s);                                                            
        save(sprintf('%s.txt',[patDatafiles roleLabelFolder '\' name]),'sdata','-ASCII'); 
        irow=row4name(tab,iColName,fileName); %find existing row or assigns new one
        tab{irow,iColName}=fileName;
        tab{irow,iColDescription}='Signals in txt format (body)';
        tab{irow,iColRoleLabel}=roleLabel;
        tab{irow,iColSubfolder}='';
        tab{irow,iColFileName}=fileName;
    end
    
    roleLabelFolder='Graph'
    roleLabel=strrep(roleLabelFolder,'_',' ');
    if isempty(dir([patDatafiles roleLabelFolder '\']));
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patDatafiles roleLabelFolder '\']);  cd(pwd1);
    end;   
    pwd1=pwd;    cd([patDatafiles roleLabelFolder '\']);
    for iGr=1:length(descrl)
        name=[experiment 'dbg' pplist1 sprintf('%02d',iGr)];
        saveas(iGr,name,'fig'); %create graph file 2014
        
        fileName=[name '.jpg'];
        set(iGr,'PaperOrientation','portrait') %avoids rotated jpg file 2020_02
        print(iGr,'-djpeg',name); %create graph file
        irow=row4name(tab,iColName,fileName); %find existing row or assigns new one
        tab{irow,iColName}=fileName;
        tab{irow,iColDescription}=descrl{iGr};
        tab{irow,iColRoleLabel}=roleLabel;
        tab{irow,iColSubfolder}='';
        tab{irow,iColFileName}=fileName;
        
        fileName=[name '.fig'];
        irow=row4name(tab,iColName,fileName); %find existing row or assigns new one
        tab{irow,iColName}=fileName;
        tab{irow,iColDescription}=[descrl{iGr} ' (MATLAB fig)'];
        tab{irow,iColRoleLabel}=roleLabel;
        tab{irow,iColSubfolder}='';
        tab{irow,iColFileName}=fileName;
    end
    
    [B,I]=sort(tab(2:size(tab,1),iColRoleLabel)); %orders by roleLabel
    tab(2:size(tab,1),:)=tab(1+I,:); %reordered tab
    if exist(propFile,'file')
        dos(['del ' propFile]);
    end
    xlswrite(propFile,tab)
    
    cd(pwd1);
        
case 'exit';
    return
end;

function row=row4name(tab,col,name)
if size(tab,1)==1
    row=2;
else
    i1 = find(strcmp(tab(2:size(tab,1),col),name));
    if ~isempty(i1) % name already in the list
        row=i1+1;
    else
        row=size(tab,1)+1;
    end
end
