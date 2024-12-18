function [mfound,foundchannelnames]=findsigname(channelnames,fmt1,fmt2,error_flag)
%   [mfound,foundchannelnames]=findsigname(channelnames,fmt1,fmt2)
%               Based on the list of channel names produced by acq2mat,
%               this function finds the positions of the channels that
%               match format fmt1 (for scalars) or fmt1 and fmt2 together (for
%               vectors).
%
% SEE ALSO:    acq2mat
%
% EXAMPLES:
%
% [bdata1,channelnames]=acq2mat('b05avrs','D01','L:\LAB\SLABSTRESS-CAL\Experiments\b05\Datafiles\Unprocessed_data\');
% mComputerTime80=findsigname(channelnames,'TIME')
% [mLCell,foundchannelnames]=findsigname(channelnames,'ALGORAV.LCellAv','%d')
% mTemp=findsigname(channam,'C%d',' - ALGO.Tempo2Net');


iarg=4;
if nargin<iarg; error_flag=''; end; iarg=iarg-1;
if nargin<iarg; fmt2=''; end; iarg=iarg-1;
if isempty(error_flag); error_flag=0; end;


Nsig=length(channelnames);
% indcell=strfind(channelnames,fmt1);
mfound=[];
foundchannelnames={};
for m=1:Nsig
    if isempty(fmt2)  % scalar variable
        if strfind(channelnames{m},fmt1)
            mfound=[mfound(:); m];
            foundchannelnames={foundchannelnames{:} channelnames{m}};
        end
    else        % vector variable
        if strfind(fmt1,'%')
            [i,COUNT,ERRMSG,NEXTINDEX] = sscanf(channelnames{m},fmt1);
            if ~isempty(i)
                if strfind(channelnames{m}(NEXTINDEX:length(channelnames{m})),fmt2)
                    mfound=[mfound(:); m];
                    foundchannelnames={foundchannelnames{:} channelnames{m}};
                end
            end
        else
            i=sscanf(channelnames{m},[fmt1 fmt2]);
            if ~isempty(i)
                mfound=[mfound(:); m];
                foundchannelnames={foundchannelnames{:} channelnames{m}};
            end
        end
    end
end

if isempty(mfound)
    if error_flag
        disp([fmt1 fmt2 ' was not found as channel name!'])
        disp('(Answer will be 0)')
        mfound=0;
    else
        error([fmt1 fmt2 ' was not found as channel name!'])
    end
end

