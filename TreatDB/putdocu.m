function putdocu(doclist,exten,descrlist, docpath, DBfolder, ...
    Projname, Strucname, Expername, PPname)
% putdocu(doclist,exten,descrlist, docpath, DBfolder, ...
%             Projname, Strucname, Expername, PPname)
% Puts document(s) in the DBfolder assigned in the ELSA Data Base.
%
% doclist: List containing the names of the documents wanted to be inserted in the DB
% exten: Extension of each document.
% descrlist: list containing the description of the documents
% docpath: Directory where the documents are saved/ stored,
%     usually, it is the physic unit test file
% DBfolder: The name of the ELSA DB folder in which the document is going to be saved
% Projname: name of the project used in ELSA the DB
% Strucname: name of the structure related to the project used in ELSA the DB
% Expername: name of the experiment in which we want the document to be saved
% PPname: name of the postprocessing in which we want the document to be saved
%
% SEE ALSO:  putpp
%
% EXAMPLE:
% patroot=[labpath 'PsChar\PsChar'];
% cd([patroot 'p\Dyn_Burst_SB\treat']);
% Projname='PsChar';
% Strucname='P50t Long';
% Expername='r151';
% patsiu=[patroot 'u\' Expername 'u\'];
% docpath=patsiu;
% DBfolder='graphics';
% doclist={'r151db80g01' 'r151db82g02'};
% exten='jpg'; PPname=[];
% descrlist={'Time histories' 'Open and Closed Loop from Heidenhain'};
% putdocu(doclist,exten,descrlist, docpath, DBfolder, Projname, Strucname, Expername, PPname)
%
%JM 2012 MATLAB 7.14.0.739 R2012a 64-bit

global AUTOMATIC_SEL_TREAT  %4-April-2008
AUTOMATIC_SEL_TREAT

iarg=9;
if nargin<iarg; PPname=[]; end; iarg=iarg-1;
if nargin<iarg; Expername=[]; end; iarg=iarg-1;
if nargin<iarg; Strucname=[]; end; iarg=iarg-1;
if nargin<iarg; Projname=[]; end; iarg=iarg-1;
if nargin<iarg; DBfolder=[]; end; iarg=iarg-1;
if nargin<iarg; docpath=[]; end; iarg=iarg-1;
if nargin<iarg; descrlist=[]; end; iarg=iarg-1;
if nargin<iarg; exten=[]; end; iarg=iarg-1;
if nargin<iarg; doclist=[]; end; iarg=iarg-1;
if isempty(descrlist); descrlist=doclist; end;


for ii=1:length(doclist)
    doclist{ii}=[doclist{ii} exten];
end

% Open database
%
Projects =  actxserver('AcqCtrlDb.Projects')
Projects.DataSourceName = 'ElsaDB';

%
% Open project
%
Project = Projects.GetProject(Projname);

if isempty(Strucname)
    rootf= Project.GetDocumentFolder;
    lf=rootf.ListFolder;
    fexist=0;
    for jj=1:length(lf)
        fexist=fexist|strcmp(lf{jj},DBfolder);
    end
    if fexist
        Folder = rootf.GetFolder(DBfolder);
        sa=0;
        for jj=1:length(doclist)
            if Folder.DocumentExist(doclist{jj});
                if sa~=2;
                    if AUTOMATIC_SEL_TREAT>0
                        sa=AUTOMATIC_SEL_TREAT
                    else
                        sa = menu(['The document ' doclist{jj} ' already exists within DBfolder ' DBfolder ...
                            '. Do you want to replace that old document?'],'Ok','Ok to all', ...
                            'Cancel (documents will not be saved)');
                    end
                end
                switch sa;
                    case {1 2};
                        OldDoc = Folder.GetDocument(doclist{jj});
                        OldDoc.Delete;
                        OldDoc.release;
                    case 3
                        return;
                end
            end
            TS = Folder.NewDocument(doclist{jj});
            TS.Source=[docpath doclist{jj} ];
            TS.Description=descrlist{jj};
            TS.Version=1;
            TS.Save;
            TS.release;
        end;
    else
        Folder = rootf.NewFolder(DBfolder);
        for jj=1:length(doclist)
            TS = Folder.NewDocument(doclist{jj});
            TS.Source=[docpath doclist{jj} ];
            TS.Description=descrlist{jj};
            TS.Version=1;
            TS.Save;
            TS.release;
        end
    end
    
else
    %
    % Open structure
    %
    Structure = Project.GetStructure(Strucname);
    if isempty(Expername)
        rootf= Structure.GetDocumentFolder;
        lf=rootf.ListFolder;
        fexist=0;
        for jj=1:length(lf)
            fexist=fexist|strcmp(lf{jj},DBfolder);
        end
        if fexist
            Folder = rootf.GetFolder(DBfolder);
            sa=0;
            for jj=1:length(doclist)
                if Folder.DocumentExist(doclist{jj});
                    if sa~=2;
                        if AUTOMATIC_SEL_TREAT>0
                            sa=AUTOMATIC_SEL_TREAT
                        else
                            sa = menu(['The document ' doclist{jj} ' already exists within DBfolder ' DBfolder ...
                                '. Do you want to replace that old document?'],'Ok','Ok to all', ...
                                'Cancel (documents will not be saved)');
                        end
                    end
                    switch sa;
                        case {1 2};
                            OldDoc = Folder.GetDocument(doclist{jj});
                            OldDoc.Delete;
                            OldDoc.release;
                        case 3
                            return;
                    end
                end
                TS = Folder.NewDocument(doclist{jj});
                TS.Source=[docpath doclist{jj} ];
                TS.Description=descrlist{jj};
                TS.Version=1;
                TS.Save;
                TS.release;
            end;
        else
            Folder = rootf.NewFolder(DBfolder);
            for jj=1:length(doclist)
                TS = Folder.NewDocument(doclist{jj});
                TS.Source=[docpath doclist{jj} ];
                TS.Description=descrlist{jj};
                TS.Version=1;
                TS.Save;
                TS.release;
            end
        end
        
    else
        %
        % Open experiment
        %
        Experiment = Structure.GetExperiment(Expername);
        if isempty(PPname)
            rootf= Experiment.GetDocumentFolder;
            lf=rootf.ListFolder;
            fexist=0;
            for jj=1:length(lf)
                fexist=fexist|strcmp(lf{jj},DBfolder);
            end
            if fexist
                Folder = rootf.GetFolder(DBfolder);
                sa=0;
                for jj=1:length(doclist)
                    if Folder.DocumentExist(doclist{jj});
                        if sa~=2;
                            if AUTOMATIC_SEL_TREAT>0
                                sa=AUTOMATIC_SEL_TREAT
                            else
                                sa = menu(['The document ' doclist{jj} ' already exists within DBfolder ' DBfolder ...
                                    '. Do you want to replace that old document?'],'Ok','Ok to all', ...
                                    'Cancel (documents will not be saved)');
                            end
                        end
                        switch sa;
                            case {1 2};
                                OldDoc = Folder.GetDocument(doclist{jj});
                                OldDoc.Delete;
                                OldDoc.release;
                            case 3
                                return;
                        end
                    end
                    TS = Folder.NewDocument(doclist{jj});
                    TS.Source=[docpath doclist{jj} ];
                    TS.Description=descrlist{jj};
                    TS.Version=1;
                    TS.Save;
                    TS.release;
                end;
            else
                Folder = rootf.NewFolder(DBfolder);
                for jj=1:length(doclist)
                    TS = Folder.NewDocument(doclist{jj});
                    TS.Source=[docpath doclist{jj} ];
                    TS.Description=descrlist{jj};
                    TS.Version=1;
                    TS.Save;
                    TS.release;
                end
            end
        
        else
            %
            % Open PostProcessing
            %
            PP1 = Experiment.GetPostProcessing(PPname);
            rootf= PP1.GetDocumentFolder;
            lf=ObjectInvoke(rootf,'ListFolder');
            fexist=0;
            for jj=1:length(lf)
                fexist=fexist|strcmp(lf{jj},DBfolder);
            end
            if fexist
                Folder = rootf.GetFolder(DBfolder);
                sa=0;
                for jj=1:length(doclist)
                    if Folder.DocumentExist(doclist{jj});
                        if sa~=2;
                            if AUTOMATIC_SEL_TREAT>0
                                sa=AUTOMATIC_SEL_TREAT
                            else
                                sa = menu(['The document ' doclist{jj} ' already exists within DBfolder ' DBfolder ...
                                    '. Do you want to replace that old document?'],'Ok','Ok to all', ...
                                    'Cancel (documents will not be saved)');
                            end
                        end
                        switch sa;
                            case {1 2};
                                OldDoc = Folder.GetDocument(doclist{jj});
                                OldDoc.Delete;
                                OldDoc.release;
                            case 3
                                return;
                        end
                    end
                    TS = Folder.NewDocument(doclist{jj});
                    TS.Source=[docpath doclist{jj} ];
                    TS.Description=descrlist{jj};
                    TS.Version=1;
                    TS.Save;
                    TS.release;
                end;
            else
                Folder = rootf.NewFolder(DBfolder);
                for jj=1:length(doclist)
                    TS = Folder.NewDocument(doclist{jj});
                    TS.Source=[docpath doclist{jj} ];
                    TS.Description=descrlist{jj};
                    TS.Version=1;
                    TS.Save;
                    TS.release;
                end
            end
            
        end
        %
        
        Experiment.release;
        
    end
    Structure.release;
end


saveddocs=doclist
ndocs=length(doclist);

Project.release;
Projects.release;

return