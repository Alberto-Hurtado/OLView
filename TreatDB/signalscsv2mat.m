function [Mnum,channelnames]=signalscsv2mat(csvfilename,signalspath)
%  function [Mnum,channelnames]=signalscsv2mat(csvfilename,signalspath)
%  Reads the muneric matrix of processed signals with their channel names
%
%         Ask also help on        acq2mat acq2csv
%
% EXAMPLES:
% cd L:\LAB\IRESIST\Experiments\e10\Datafiles\Processed_data
%   csvfilename='e10-STD-ORIG-av.csv'; 
%   [Mnum,channelnames]=signalscsv2mat(csvfilename)
%

iarg=2;
if nargin<iarg; signalspath=''; end; iarg=iarg-1;

filefull=[signalspath csvfilename]
[num,txt,raw] = xlsread(filefull);

i = 1;
while ~strcmp(txt{i,1},'note1');
    i = i + 1;
end
channelnames = txt(i,2:size(txt,2));

i = 1;
while ~strcmp(txt{i,1},'value');
    i = i + 1;
end
Mraw = raw(i:size(raw,1),2:size(raw,2));
[nrows,ncols] = size(Mraw);
Mnum = zeros(nrows,ncols);
for i = 1:nrows
    for j = 1:ncols
        Mnum(i,j) = Mraw{i,j};
    end
end
