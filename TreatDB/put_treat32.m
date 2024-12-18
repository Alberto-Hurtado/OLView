

function put_treat(pplist,sppsave,patExp,patTreated,patGraphics,descrl,folders2save,project,structure,experiment)
% put_treat(pplist,sppsave,patExp,patTreated,patGraphics,descrl,folders2save,project,structure,experiment)
%
%     Saves into folder LAB and into the database a list of postprocessings,
%     graphs and other files treted after a test.
%
% SEE ALSO:  putpp   putdocu
%
% Dec/2006 Javier Molina

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
            ['Create the directory ' patTreated ' and save the data there and in DB'],...
            ['Create the directory ' patTreated ' and save the data there BUT NOT in DB'],...
            'Exit');
    end
    asel={'create and save + DB' 'create and save' 'exit'};
else
    if AUTOMATIC_SEL_TREAT>0
        isel=AUTOMATIC_SEL_TREAT;
    else
        isel = menu('The data have been treated. Please, choose an option:',...
            ['Save the data in the existing directory ' patTreated ' and in DB'],...
            ['Save the data in the existing directory ' patTreated ' BUT NOT in DB'],...
            'Exit');
    end
    asel={'save + DB' 'save' 'exit'};
end;
sel=asel{isel};
switch sel;
case {'create and save + DB' 'create and save' 'save + DB' 'save'};
    switch sel;
    case {'create and save + DB' 'create and save'};
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patTreated]);  cd(pwd1);
    end;
    for ipp=1:length(pplist)
        pp=pplist{ipp};
        s=sppsave{ipp};
        switch sel;
        case {'create and save + DB' 'save + DB'};
            s=putpp(sppsave{ipp}); %save postprocessing in DB
        end
        save([patTreated experiment 'db' pp],'s'); %save postprocessing in LAB folder
        filelst=[patTreated experiment 'db' pp 'lst.txt'];
        fid=fopen(filelst,'w');
        fprintf(fid,'  %s\n\n',date);
        fprintf(fid,'  %s\n\n',patTreated);  fclose(fid);
        repsig(s,filelst,'a');  type(filelst);
        
        sdata=gm(s);                                                               %2012-02-08
        save(sprintf('%s.txt',[patTreated experiment 'db' pp]),'sdata','-ASCII');  %2012-02-08

    end
    if isempty(dir(patGraphics));
        pwd1=pwd;  cd('c:');  eval(['! mkdir ' patGraphics]);  cd(pwd1);
    end;   
    pwd1=pwd;    cd(patGraphics);
    graphlist={};
    for ii=1:length(descrl)
        graphlist={graphlist{:},[experiment 'dbg' pplist{1} sprintf('%02d',ii)]};
        print(ii,'-djpeg',graphlist{ii}); %create graph file
    end
    cd(pwd1);
    
    switch sel;
    case {'create and save + DB' 'save + DB'};
        
        putdocu(graphlist,'.jpg',descrl,patGraphics,'Graphics', ...
            project, structure, experiment); %save graphs in DB
        for ifol=1:length(folders2save) %save folders in DB
            fol=folders2save{ifol};
            patfol=[patExp fol '\'];
            dirfol=dir(patfol);
            if ~isempty(dirfol)
                filelist={};descrl={};
                for ifile=1:length(dirfol)
                    if ~isdir([patfol dirfol(ifile).name])
                        filelist={filelist{:} dirfol(ifile).name};
                        descrl={descrl{:} dirfol(ifile).date};
                    end
                end
                putdocu(filelist,'',descrl,patfol,fol, ...
                    project, structure, experiment);
            end
        end
        
    end
    
case 'exit';
    return
end;
