function sig=pp2csv(sig)
%sig=pp2csv(sig)
% Puts all the signals (cell of structures) of a postprocesing
% in a CSV file compatible with ELSADATA.
% Ordered names are assigned to the signals in the form:
%     sig{i}.Name=sprintf('%03d',i-1)
%
% SEE ALSO:  acq2csv
%
% EXAMPLES:
%
%JM 2018

if isempty(sig); return; end;

%
% Write the signals
%

experiment=sig{1}.Experiment;
PPname=sig{1}.PostProcessing;

fileout=[experiment PPname]
fid = fopen(fileout, 'W');
nsig=length(sig);
for i=1:nsig
    fprintf(fid,'%s - %s',sig{i}.PostProcessing,sig{i}.PostP_Descr);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end
for i=1:nsig
    sig{i}.Name=sprintf('%03d',i-1);
    fprintf(fid,'%s',sig{1}.Name);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end
for i=1:nsig
    fprintf(fid,'%s',sig{1}.Description);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end
for i=1:nsig
    fprintf(fid,'%s',sig{1}.Magnitude);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end
for i=1:nsig
    fprintf(fid,'%s',sig{1}.Unit);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end



for i=1:nsig
    fprintf(fid,'%s',sig{1}.Positions);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end
for i=1:nsig
    fprintf(fid,'%s',sig{1}.Data);
    if i<nsig; fprintf(fid,','); else; fprintf(fid,'\n'); end
end



for ip=1:np
    for ichan=1:nchan-1
        fprintf(fid,'%.10g,',bdata(ip,ichan));
    end
    fprintf(fid,'%.10g\n',bdata(ip,nchan));
end
fclose(fid);


