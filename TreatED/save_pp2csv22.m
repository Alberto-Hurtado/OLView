function tab=save_pp2csv22(sDB,outpath,fileName)
% function tab=save_pp2csv22(sDB,outpath,fileName)
% Saves signals of a postprocessing in csv files
% New csv format 2022
% F.J. Molina 2022 03

% iarg=3;
% if nargin<iarg; fileName=''; end; iarg=iarg-1;
% if nargin<iarg; outpath=''; end; iarg=iarg-1;
% % if isempty(outpath); outpath='Signals'; end;


% maps for the description of the postprocessing types
[desSourceMap,desElaborationMap,desSamplingMap]=postp_type_maps();

%% converts to SI basic units
for iSig=1:length(sDB)
    sDB{iSig}=sigDB2SIbasic(sDB{iSig}); 
end

%% New csv format 2022:

% Number of notes is variable but common within the csv file
notesGroupLength = 1;  %Necessary number of notes in the file
% Number of values is variable but common within the csv file
valuesLength = 0;  %Minimum number of values (samplings) in the file
for iSig=1:length(sDB)
    sigDB=sDB{iSig};
    len1 = length(sigDB.Positions);
    while len1 > 0
        if isempty(sigDB.Positions{len1}) %empty notes are ignored
            len1 = len1 - 1;
        else
            break
        end
    end
    notesGroupLength = max(notesGroupLength,len1);
    valuesLength = max(valuesLength,length(sigDB.Data));
end
fixedFieldsLength = 13;
tab=cell(fixedFieldsLength + notesGroupLength,1 + length(sDB));

%% First column contains always the names of the fields

% Initial fixed fields rows
tab{1,1} = 'groupName';
tab{2,1} = 'source';
tab{3,1} = 'sourceDescr';
tab{4,1} = 'elaboration';
tab{5,1} = 'elaborationDescr';
tab{6,1} = 'sampling';
tab{7,1} = 'samplingDescr';
tab{8,1} = 'version';
tab{9,1} = 'versionDescr';
tab{10,1} = 'name';
tab{11,1} = 'description';
tab{12,1} = 'magnitude';
tab{13,1} = 'unit';

% Notes rows
for iNote = 1:notesGroupLength
    tab{fixedFieldsLength + iNote,1}=sprintf('note%d',iNote);
end


%% Successive columns contain the signals

% Values rows
tabValues=zeros(valuesLength,length(sDB)); %numeric values

for iSig=1:length(sDB)
    sigDB=sDB{iSig};
    tab{1,1+iSig} = sigDB.PostProcessing;
    tab{2,1+iSig} = sigDB.ppSource;
    tab{3,1+iSig} = desSourceMap(sigDB.ppSource);
    tab{4,1+iSig} = sigDB.ppElaboration;
    tab{5,1+iSig} = desElaborationMap(sigDB.ppElaboration);
    tab{6,1+iSig} = sigDB.ppSampling;
    tab{7,1+iSig} = desSamplingMap(sigDB.ppSampling);
    tab{8,1+iSig} = sigDB.ppVersion;
    tab{9,1+iSig} = sigDB.ppVersionDescr;
    tab{10,1+iSig} = sprintf('%03d',iSig); %name is created here 
    tab{11,1+iSig} = sigDB.Description;
    tab{12,1+iSig} = sigDB.Magnitude;
    tab{13,1+iSig} = sigDB.Unit;
    
    notes=sigDB.Positions;
    for iNote = 1:min(length(notes),notesGroupLength)
        tab{fixedFieldsLength + iNote,1+iSig}=notes{iNote};
    end
    
    values=sigDB.Data;
    tabValues(1:length(values),iSig)=values;
end

fid = fopen([outpath '\' fileName], 'W');

[nrows,ncols]=size(tab);
for irow=1:nrows
    for icol=1:ncols
        str1=tab{irow,icol};
        if isempty(find(str1==','))
            strOKcoma = str1;
        else
            strOKcoma=['"' str1 '"'];
        end
        fprintf(fid,'%s',strOKcoma);
        if icol<ncols
            fprintf(fid,',');
        else
            fprintf(fid,'\n');
        end
    end
end

[nrows,ncols]=size(tabValues);
for irow=1:nrows
    fprintf(fid,'value'); % First column is the names of the field
    for icol=1:ncols
        fprintf(fid,',%.10g',tabValues(irow,icol));
    end
    fprintf(fid,'\n');
end
% for irow=1:nrows
%     fprintf(fid,'value'); % First column is the names of the field
%     if ncols > 0; fprintf(fid,','); else; fprintf(fid,'\n'); end
%     for icol=1:ncols
%         fprintf(fid,'%.10g',tabValues(irow,icol));
%         if icol < ncols; fprintf(fid,','); else; fprintf(fid,'\n'); end
%     end
% end

fclose(fid);

end


function s1=sigDB2SIbasic(s)
%converts to SI basic units for ED

s1 = s;
switch s.Unit
    case 'mm'
        s1.Unit = 'm';
        s1.Data = s.Data * 0.001;
    case 'kN'
        s1.Unit = 'N';
        s1.Data = s.Data * 1000;
    case 'kNm'
        s1.Unit = 'Nm';
        s1.Data = s.Data * 1000;
    case 'm/s/s'
        s1.Unit = 'm/s²';
        s1.Data = s.Data;
    case 'mm/s'
        s1.Unit = 'm/s';
        s1.Data = s.Data * 0.001;
    case 'ms'
        s1.Unit = 's';
        s1.Data = s.Data * 0.001;
    case '-'
        s1.Unit = 'Dimensionless';
        s1.Data = s.Data;
    case {'Bar' 'bar'}
        s1.Unit = 'Pa';
        s1.Data = s.Data * 1e5;
    case '%'
        s1.Unit = 'Dimensionless';
        s1.Data = s.Data * 0.01;
    case 'Rad'
        s1.Unit = 'rad';
        s1.Data = s.Data;
    case {'mrad' 'mRad'}
        s1.Unit = 'rad';
        s1.Data = s.Data * 0.001;
    case {'kg?¹' 'A' 'ºC' 'Dimensionless' 'Hz' 'J' 'kg' 'm' 'm/s' 'm/s²' 'N' ...
            'Nm' 'N/m' 'Ns/m' 'Pa' 'rad' 'rad/s' 'rad/s²' 's' '?' 'V'}
        % these are already eccepted as basic units
    otherwise
        error(['Unit ' s.Unit ' is not recognised!!!'])
end

switch s.Magnitude
    case 'Damping Ratio'
        s1.Magnitude = 'Ratio';
        s1.Description = [s.Description 'Damping'];
    case {'Rotation acceleration' 'Mass' 'Rotation velocity' 'Temperature' ...
            'Energy' 'Number' 'Displacement' 'Stiffness' 'Stress' 'Strain' ...
            'Cycle' 'Phase' 'Time' 'Counter' 'Voltage' 'Accelerance' 'Moment' ...
            'Angle' 'Acceleration' 'Current' 'Pressure' 'Velocity' 'Force' ...
            'Period' 'Ratio' 'Frequency' 'Rotation' 'Damping'}
        % these are already eccepted magnitudes
    otherwise
        error(['Magnitude ' s.Magnitude ' is not recognised!!!'])
end

end





