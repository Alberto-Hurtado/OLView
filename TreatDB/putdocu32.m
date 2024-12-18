function putdocu(doclist,exten,descrlist, docpath, DBfolder, ...
    project, structure, experiment, postprocessing)
% putdocu(doclist,exten,descrlist, docpath, DBfolder, ...
%             project, structure, experiment, postprocessing)
% Puts document(s) in the DBfolder assigned in the ELSA Data Base.
%
% doclist: List containing the names of the documents wanted to be inserted in the DB
% exten: Extension of each document. By defect the extension will be '.jpg'
% descrlist: list containing the description of the documents
% docpath: Directory where the documents are saved/ storaged,
%     usually, it is the physic unit test file  
% DBfolder: The name of the ELSA DB folder in which the document is going to be saved  
% project: name of the project used in ELSA the DB
% structure: name of the structure related to the project used in ELSA the DB
% experiment: name of the experiment in which we want the document to be saved
% postprocessing: name of the postprocessing in which we want the document to be saved
%
% SEE ALSO:  putpp   insertfile
%
% EXAMPLE:
% patroot=[labpath 'PsChar\PsChar'];
% cd([patroot 'p\Dyn_Burst_SB\treat']);
% project='PsChar';
% structure='P50t Long';
% experiment='r151';
% patsiu=[patroot 'u\' experiment 'u\'];
% docpath=patsiu;
% DBfolder='graphics';
% doclist={'r151db80g01' 'r151db82g02'};
% exten=[]; postprocessing=[];
% descrlist={'Time histories' 'Open and Closed Loop from Heidenhain'};
% putdocu(doclist,exten,descrlist, docpath, DBfolder, project, structure, experiment, postprocessing)
%
%  VV '04

global AUTOMATIC_SEL_TREAT  %4-April-2008
AUTOMATIC_SEL_TREAT

iarg=9;
if nargin<iarg; postprocessing=[]; end; iarg=iarg-1;
if nargin<iarg; experiment=[]; end; iarg=iarg-1;
if nargin<iarg; structure=[]; end; iarg=iarg-1;
if nargin<iarg; project=[]; end; iarg=iarg-1;
if nargin<iarg; DBfolder=[]; end; iarg=iarg-1;
if nargin<iarg; docpath=[]; end; iarg=iarg-1;
if nargin<iarg; descrlist=[]; end; iarg=iarg-1;
if nargin<iarg; exten=[]; end; iarg=iarg-1;
if nargin<iarg; doclist=[]; end; iarg=iarg-1;
if isempty(descrlist); descrlist=doclist; end;

% if isempty(exten); exten='.jpg' ; end

for ii=1:length(doclist)
    doclist{ii}=[doclist{ii} exten];
end

% Open database
%
Projects = CreateObject ('AcqCtrlDb.Projects')
PutObjectProp(Projects,'DataSourceName','ElsaDB');
%ObjectInfo(Projects)

%
% Open project
%
% Projname=s{1}.Project
Projname=project;
Project = ObjectInvoke(Projects,'GetProject',Projname);

% rootf= ObjectInvoke(Project,'GetDocumentFolder');
% lf=ObjectInvoke(rootf,'ListFolder');
% fexist=0;
if isempty(structure) 
    rootf= ObjectInvoke(Project,'GetDocumentFolder');
    lf=ObjectInvoke(rootf,'ListFolder');
    fexist=0;
   for jj=1:length(lf)
        fexist=fexist|strcmp(lf{jj},DBfolder);
    end   
    if fexist
        % get
        Folder = ObjectInvoke(rootf,'GetFolder',DBfolder);
        sa=0;
        for jj=1:length(doclist)
            if ObjectInvoke(Folder,'DocumentExist',doclist{jj});
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
                    OldDoc = ObjectInvoke(Folder,'GetDocument',doclist{jj});
                    ObjectInvoke(OldDoc,'Delete')
                    ReleaseObject(OldDoc)
                case 3
                    return;
                end
                TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                PutObjectProp(TS,'Description',descrlist{jj});
                PutObjectProp(TS,'Version',1);
                ObjectInvoke(TS,'Save');
                ReleaseObject(TS) 
            else
                TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                PutObjectProp(TS,'Description',descrlist{jj});
                PutObjectProp(TS,'Version',1);
                ObjectInvoke(TS,'Save');
                ReleaseObject(TS) 
            end
        end;
        
    else
        Folder = ObjectInvoke(rootf,'NewFolder',DBfolder);
        for jj=1:length(doclist)
            TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
            PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
            PutObjectProp(TS,'Description',descrlist{jj});
            PutObjectProp(TS,'Version',1);
            ObjectInvoke(TS,'Save');
            ReleaseObject(TS)
        end
    end
else
    %
    % Open structure
    %
    Strucname=structure;
    Structure = ObjectInvoke(Project,'GetStructure',Strucname);
    
    rootf= ObjectInvoke(Structure,'GetDocumentFolder');
    lf=ObjectInvoke(rootf,'ListFolder');
    fexist=0;
    if isempty(experiment) 
        for jj=1:length(lf)
            fexist=fexist|strcmp(lf{jj},DBfolder);
        end   
        if fexist
            % get
            Folder = ObjectInvoke(rootf,'GetFolder',DBfolder);
            sa=0;
            for jj=1:length(doclist)
                if ObjectInvoke(Folder,'DocumentExist',doclist{jj});
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
                        OldDoc = ObjectInvoke(Folder,'GetDocument',doclist{jj});
                        ObjectInvoke(OldDoc,'Delete')
                        ReleaseObject(OldDoc)
                    case 3
                        return;
                    end
                    TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                    PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                    PutObjectProp(TS,'Description',descrlist{jj});
                    PutObjectProp(TS,'Version',1);
                    ObjectInvoke(TS,'Save');
                    ReleaseObject(TS) 
                else
                    TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                    PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                    PutObjectProp(TS,'Description',descrlist{jj});
                    PutObjectProp(TS,'Version',1);
                    ObjectInvoke(TS,'Save');
                    ReleaseObject(TS) 
                end
            end;
            
        else
            Folder = ObjectInvoke(rootf,'NewFolder',DBfolder)
            for jj=1:length(doclist)
                TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                PutObjectProp(TS,'Description',descrlist{jj});
                PutObjectProp(TS,'Version',1);
                ObjectInvoke(TS,'Save');
                ReleaseObject(TS)
            end
        end
        
    else
        %
        % Open experiment
        %
        Expername=experiment;
        Experiment = ObjectInvoke(Structure,'GetExperiment',Expername);
        rootf= ObjectInvoke(Experiment,'GetDocumentFolder');
        lf=ObjectInvoke(rootf,'ListFolder');
        fexist=0;
        if isempty(postprocessing)
            for jj=1:length(lf)
                fexist=fexist|strcmp(lf{jj},DBfolder);
            end
            if fexist
                if AUTOMATIC_SEL_TREAT>0
                  sa=AUTOMATIC_SEL_TREAT
                else
                  sa = menu(['The folder ' DBfolder ' already exists' ...
                        '. Do you want to add these documents to the existing ones in that folder?'], ...
                    'Yes, add these documents and keep the old ones','No, clean up the folder and then add these documents');
                end
                if sa==2
                    Folder = ObjectInvoke(rootf,'GetFolder',DBfolder)
                    ObjectInvoke(Folder,'Delete')
                    ReleaseObject(Folder)
                    fexist=0;
                end
            end
            if fexist
                % get
                Folder = ObjectInvoke(rootf,'GetFolder',DBfolder)
                sa=0;
                for jj=1:length(doclist)
                    if ObjectInvoke(Folder,'DocumentExist',doclist{jj});
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
                            OldDoc = ObjectInvoke(Folder,'GetDocument',doclist{jj});
                            ObjectInvoke(OldDoc,'Delete')
                            ReleaseObject(OldDoc)
                        case 3
                            return;
                        end
                        TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                        PutObjectProp(TS,'Source',[docpath  doclist{jj} ]);
                        PutObjectProp(TS,'Description',descrlist{jj});
                        PutObjectProp(TS,'Version',1);
                        ObjectInvoke(TS,'Save')
                        ReleaseObject(TS) 
                    else
                        TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                        PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                        PutObjectProp(TS,'Description',descrlist{jj});
                        PutObjectProp(TS,'Version',1);
                        ObjectInvoke(TS,'Save')
                        ReleaseObject(TS) 
                    end
                end;
                
            else
                if ~isempty(doclist)
                   Folder = ObjectInvoke(rootf,'NewFolder',DBfolder);
                end
                for jj=1:length(doclist)
                    TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                    PutObjectProp(TS,'Source',[docpath  doclist{jj} ]);
                    PutObjectProp(TS,'Description',descrlist{jj});
                    PutObjectProp(TS,'Version',1);
                    ObjectInvoke(TS,'Save')
                    ReleaseObject(TS)
                end
            end
            
        else    
            %
            % Open PostProcessing
            %
            PPname=postprocessing;
            PP1 = ObjectInvoke(Experiment,'GetPostProcessing',PPname);
            rootf= ObjectInvoke(PP1,'GetDocumentFolder');
            lf=ObjectInvoke(rootf,'ListFolder');
            fexist=0;
            for jj=1:length(lf)
                fexist=fexist|strcmp(lf{jj},DBfolder);
            end
            if fexist
                % get
                Folder = ObjectInvoke(rootf,'GetFolder',DBfolder)
                sa=0;
                for jj=1:length(doclist)
                    if ObjectInvoke(Folder,'DocumentExist',doclist{jj});
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
                            OldDoc = ObjectInvoke(Folder,'GetDocument',doclist{jj})
                            ObjectInvoke(OldDoc,'Delete')
                            ReleaseObject(OldDoc)
                        case 3
                            return;
                        end
                        TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                        PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                        PutObjectProp(TS,'Description',descrlist{jj});
                        PutObjectProp(TS,'Version',1);
                        ObjectInvoke(TS,'Save')
                        ReleaseObject(TS) 
                    else
                        TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                        PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                        PutObjectProp(TS,'Description',descrlist{jj});
                        PutObjectProp(TS,'Version',1);
                        ObjectInvoke(TS,'Save')
                        ReleaseObject(TS) 
                        ReleaseObject(PP1)
                    end
                end;
                
            else
                Folder = ObjectInvoke(rootf,'NewFolder',DBfolder);
                for jj=1:length(doclist)
                    TS = ObjectInvoke(Folder,'NewDocument',doclist{jj});
                    PutObjectProp(TS,'Source',[docpath doclist{jj} ]);
                    PutObjectProp(TS,'Description',descrlist{jj});
                    PutObjectProp(TS,'Version',1);
                    ObjectInvoke(TS,'Save')
                    ReleaseObject(TS)
                    
                end
                ReleaseObject(PP1)
            end
            
            
            
        end
        %             
        
        ReleaseObject(Experiment)
        
    end
    ReleaseObject(Structure)
end


saveddocs=doclist
ndocs=length(doclist);

ReleaseObject(Project)
ReleaseObject(Projects)