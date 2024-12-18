function acq2csv(indata,inheader,outcsv,acqpath)
% function acq2csv(indata,inheader,outcsv,acqpath)
%
%         Ask also help on        acq2mat signalscsv2mat
%
% EXAMPLES:
% cd \\SMDC01\LabFolders\LAB\CALIB2014\Experiments\e02\Results_Raw
%   indata='e02con.D04';inheader='';outcsv='';acqpath='';
%  acq2csv(indata,inheader,outcsv,acqpath)

%   cd \\SMDC01\LabFolders\LAB\SLA4F4E\Experiments\f01\Results_Raw
%   acq2csv('f01ins.D03')
%

iarg=4;
if nargin<iarg; acqpath=''; end; iarg=iarg-1;
if nargin<iarg; outcsv=''; end; iarg=iarg-1;
if nargin<iarg; inheader=''; end; iarg=iarg-1;


if isempty(outcsv); outcsv=indata; end;
if ~strcmp(outcsv(length(outcsv)-3:length(outcsv)),'.csv')
    outcsv=[outcsv '.csv']
end

if isempty(inheader)
    inheader=indata;
    inheader(length(inheader)-2)='H'
end

fileheader=[acqpath inheader]
fid=fopen(fileheader,'r');
headertxt=setstr(fread(fid)');
fclose(fid);
str='[CHANNELS]';
pos1=findstr(headertxt,str);
header1txt=headertxt(pos1+length(str)+1:length(headertxt));
nchan=0; pos2=0; label=cell(0);
while ~isempty(pos2)
    str=sprintf('%d : ',nchan+1);
    pos2=findstr(header1txt,str);
    if ~isempty(pos2)
        header1txt(1:pos2-1)=[];
        pos3=min(find(header1txt==10 | header1txt==13)); 
        nchan=nchan+1;
        label{nchan}=header1txt(length(str)+1:pos3-1);
    end
end

filedata=[acqpath indata]
fid=fopen(filedata,'r')
adata=fread(fid,inf,'float');
fclose(fid);
np=length(adata)/nchan
bdata=reshape(adata,nchan,np)';

fileout=[acqpath outcsv]
fid = fopen(fileout, 'W');
for ichan=1:nchan-1
    fprintf(fid,'%s,',label{ichan});
end
fprintf(fid,'%s\n',label{nchan});
for ip=1:np
    for ichan=1:nchan-1
        fprintf(fid,'%.10g,',bdata(ip,ichan));
    end
    fprintf(fid,'%.10g\n',bdata(ip,nchan));
end
fclose(fid);


