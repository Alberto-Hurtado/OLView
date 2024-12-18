function tab=save_pp2csv(sDB,outpath,experimentName)
% function tab=save_pp2csv(sDB,outpath,experimentName)
% Saves signals of a postprocessing in csv files
% F.J. Molina 2018 06

iarg=3;
if nargin<iarg; experimentName=''; end; iarg=iarg-1;
if nargin<iarg; outpath=''; end; iarg=iarg-1;
if isempty(outpath); outpath='Signals'; end;


sDBfields={'PostProcessing';'Name';'Description'; ...
    'Magnitude';'Unit';'Positions'};
tabfields={'groupName';'name';'description'; ...
    'magnitude.type.name';'unit';'additionalNotes'};
tab=cell(length(tabfields),length(sDB));

for isig=1:length(sDB)
    sDB{isig}=sigDB2SIbasic(sDB{isig}); %converts to SI basic units
    sigDB=sDB{isig};
    for ifield=1:length(tabfields)
        fieldname=tabfields{ifield};
        switch fieldname
            case 'groupName'
                ppName=sigDB.PostProcessing;
                switch ppName
                    case '80'
                        groupName= ...
                            'CTRLav0 - Source: controller acq | Sampling: record average | Elaboration: measured';
                    case '82'
                        groupName= ...
                            'CTRLav1 - Source: CTRLav0 | Sampling: record average | Elaboration: derived';
                    case '60'
                        groupName= ...
                            'PHYSav0 - Source: physical DoFs | Sampling: record average | Elaboration: equation';
                    case '62'
                        groupName= ...
                            'PHYSav1 - Source: PHYSav0 | Sampling: record average | Elaboration: derived';
                    case '63'
                        groupName= ...
                            'IDENre - Source: hybrid system | Sampling: resampled | Elaboration: identified';
                    case '70'
                        groupName= ...
                            'STDav0 - Source: standard acq | Sampling: record average | Elaboration: measured';
                    case '72'
                        groupName= ...
                            'STDav1 - Source: STDav0 | Sampling: record average | Elaboration: derived';
                end
                tab{ifield,isig}=groupName;
            case 'name'
                tab{ifield,isig}=sprintf('%03d',isig);
            case 'additionalNotes'
                list=eval(['sigDB.' sDBfields{ifield,1}]);
                string='';
                for iElement=1:length(list)
                    if iElement<length(list)
                        string=[string list{iElement} '##'];
                    else
                        string=[string list{iElement}];
                    end
                end
                tab{ifield,isig}=string;
            otherwise
                tab{ifield,isig}=eval(['sigDB.' sDBfields{ifield,1}]);
        end
    end
    %     tab(find(strcmp(tabfields,'name')),isig)=sprintf('%03d',isig);
end

[B,I]=sort(tab(1,:)); %orders by group name
groupName1=tab{1,I(1)};
Igroup=1;
for iI=1:length(I)
    if ~strcmp(groupName1,tab{1,I(iI)})
        Igroup=[Igroup; iI];
        groupName1=tab{1,I(iI)};
    end
end
ngroups=length(Igroup);
Igroup1=[Igroup; length(I)+1];
for igroup=1:ngroups
    grouplength=Igroup1(igroup+1)-Igroup1(igroup);
    group_tabcell=cell(length(tabfields),grouplength);
    group_tabcell= ...
        tab(:,I(Igroup1(igroup):Igroup1(igroup+1)-1));
    for ii=1:grouplength
        isig=I(Igroup1(igroup)+ii-1);
        sigDB=sDB{isig};
        values=sigDB.Data;
        if ii==1
            group_tabmatrix=zeros(length(values),grouplength);
        end
        group_tabmatrix(1:length(values),ii)=values;
    end
    groupName_split=strsplit(group_tabcell{1,1});
    groupNam=groupName_split{1};
    fileName=[outpath '\' experimentName '_' groupNam '.csv'];
    fid = fopen(fileName, 'W');
    [nrows,ncols]=size(group_tabcell);
    for irow=1:nrows
        for icol=1:ncols
            strOKcoma=group_tabcell{irow,icol};
            %             if ~isempty(strOKcoma)
            %                 strOKcoma=strrep(group_tabcell{irow,icol},',',';');
            %             end
            if ~isempty(find(strOKcoma==','))
                strOKcoma=['"' strOKcoma '"'];
            end
            fprintf(fid,'%s',strOKcoma);
            if icol<ncols; fprintf(fid,','); else; fprintf(fid,'\n'); end
        end
    end
    [nrows,ncols]=size(group_tabmatrix);
    for irow=1:nrows
        for icol=1:ncols
            fprintf(fid,'%.10g',group_tabmatrix(irow,icol));
            if icol<ncols; fprintf(fid,','); else; fprintf(fid,'\n'); end
        end
    end
    fclose(fid);
end

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
        s1.Description = [s.Description ' Damping'];
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





