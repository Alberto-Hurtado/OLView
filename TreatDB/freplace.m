function freplace(filemask,stringold,stringnew,check)
%freplace:      String replace in file.
%      freplace(filemask,stringold,stringnew,check)
%          Replaces stringold by stringnew in all the files
%          matching the specified MASK at the current
%          directory.
%          If check=0 no check is done before replacing.
%
%          FILEMASK =  mask filename with possible wildchars * ?
%                  (no file extension is presumed)
%
%      Ask also help on      strrep ffind
%
%   EXAMPLE:
%     freplace('*.m','belocity','velocity',1)
%
%   13/10/97 J. Molina  
if nargin<4;check=1;end

if check~=0
    ffind(filemask,stringold);
    drawnow;
    repl=input('\nDo you confirm the replace operation?\n  1=Yes\n  2=No\n')==1;
else
    repl=1;
end
if repl==1;
    ll1=dir(filemask);
    for i=1:length(ll1);
        fn=ll1(i).name;
        fid=fopen(fn,'r');
        s1=fscanf(fid,'%c');
        fclose(fid);
        s1=strrep(s1,stringold,stringnew);
        fid=fopen(fn,'w');
        fprintf(fid,'%c',s1);
        fclose(fid);
    end;
end;
