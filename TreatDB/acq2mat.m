function [bdata,channelnames]=acq2mat(indataname,indataext,acqpath,fmt)
% [bdata,channelnames]=acq2mat(indataname,indataext,acqpath,fmt)
%
%         Ask also help on        acq2csv signalscsv2mat
%
% EXAMPLES:
% cd \\SMDC01\LabFolders\LAB\CALIB2014\Experiments\e02\Results_Raw
%   indataname='e02con';indataext='D04';acqpath='';
%  acq2mat(indataname,indataext,acqpath)
%
%   cd C:\Users\admin\Desktop\LabFolders_sm59\LAB_sm59\SLABSTRESS-CAL\Experiments\a08\Datafiles\Unprocessed_data
%   [bdata,channelnames]=acq2mat('a08inc','D02');
%   [bdata,channelnames]=acq2mat('a08inc',{  'D02' 'D03' 'D04' 'D05'  });
%   [bdata,channelnames]=acq2mat('a08inc','D02','','ascii');  %2023
%

iarg=4;
if nargin<iarg; fmt=''; end; iarg=iarg-1;
if nargin<iarg; acqpath=''; end; iarg=iarg-1;

switch fmt
    case ''
        fmt = 'float'
end

if ~iscell(indataext)
    indataext={indataext}
end
indata1=[indataname '.' indataext{1}]
inheader=indata1;
inheader(length(inheader)-2)='H';

fileheader=[acqpath inheader]
fid=fopen(fileheader,'r');
headertxt=setstr(fread(fid)');
fclose(fid);
str='[CHANNELS]';
pos1=findstr(headertxt,str);
header1txt=headertxt(pos1+length(str)+1:length(headertxt));
nchan=0; pos2=0; channelnames=cell(0);
while ~isempty(pos2)
    str=sprintf('%d : ',nchan+1);
    pos2=findstr(header1txt,str);
    if ~isempty(pos2)
        header1txt(1:pos2-1)=[];
        pos3=min(find(header1txt==10 | header1txt==13));
        nchan=nchan+1;
        channelnames{nchan}=header1txt(length(str)+1:pos3-1);
    end
end

filedata=[acqpath indata1]

np=0; bdata=[];
for ifile=1:length(indataext)
    filedata=[acqpath indataname '.' indataext{ifile}]
    switch fmt
        case 'ascii'
            bdata1 = load(filedata,'-ascii');
            np1 = size(bdata1,1);
        otherwise
            fid=fopen(filedata,'r');
            adata=fread(fid,inf,fmt);
            fclose(fid);
            np1=length(adata)/nchan
            if rem(np1,nchan)==0
                bdata1=reshape(adata,nchan,np1)';
            else
                warning('This file is not complete!')
                np1=floor(np1)
                bdata1=reshape(adata(1:nchan*floor(np1)),nchan,floor(np1))';
            end
    end
    np=np+np1
    bdata=[bdata; bdata1];
end

