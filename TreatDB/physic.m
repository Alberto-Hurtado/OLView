function datau=physic(datav,sensitivity,pointsmean,offset)
%datau=physic(datav,sensitivity,pointsmean,offset)
%   Converts the data from Volts
%   to physical units by using the formula:
%
%      datau=sensitivity*(datav-mean(datav(pointsmean))+offset
%
%   or, if pointsmean==[],
%
%      datau=sensitivity*datav+offset
%
% SEE ALSO:  dericen work
%
% EXAMPLES:
% physic(rand(10,3),100,2:5)
% physic(rand(10,3),[100 200 300],[],[10000 20000 30000])
% physic({rand(10,1) rand(12,1)},100,[]) 
% physic({rand(10,1) rand(12,1)},{100 200},2:5,{10000 20000}) 
%
%JM01

iarg=1;
if nargin<iarg; datav=[]; end; iarg=iarg+1;
if nargin<iarg; sensitivity=[]; end; iarg=iarg+1;
if nargin<iarg; pointsmean=[]; end; iarg=iarg+1;
if nargin<iarg; offset=[]; end; iarg=iarg+1;

if iscell(datav);
  ncol=length(datav);
else
  ncol=size(datav,2);
end;
sensitivity=cell2mat(sensitivity);
if isempty(sensitivity); sensitivity=1; end;
if length(sensitivity)==1; sensitivity=sensitivity(ones(1,ncol)); end;
offset=cell2mat(offset);
if isempty(offset); offset=0; end;
if length(offset)==1; offset=offset(ones(1,ncol)); end;

if isempty(pointsmean)
  if iscell(datav);
    datau=cell(1,ncol);
    for i=1:ncol
      datau{i}=sensitivity(i)*datav{i}+offset(i);
    end
  else
    datau=zeros(size(datav));
    for i=1:ncol
      datau(:,i)=sensitivity(i)*datav(:,i)+offset(i);
    end
  end
else
  if iscell(datav);
    datau=cell(1,ncol);
    for i=1:ncol
      datau{i}=sensitivity(i)*(datav{i}-mean(datav{i}(pointsmean)))+offset(i);
    end
  else
    datau=zeros(size(datav));
    for i=1:ncol
      datau(:,i)=sensitivity(i)*(datav(:,i)-mean(datav(pointsmean,i)))+offset(i);
    end
  end
end

