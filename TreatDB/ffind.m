function [sline_list,sline_list_long]=ffind(filemask,string)
%ffind:      String find in file.
%      [sline_list]=ffind(filemask,string)
%          Finds string in all the files
%          matching the specified MASK at the current
%          directory.
%
%          FILEMASK =  mask filename with possible wildchars * ?
%                  (no file extension is presumed)
%
%      Ask also help on      strrep freplace
%
%   EXAMPLE:
%     ffind('*.m','belocity')
%
%   13/10/97 J. Molina  

ll1=dir(filemask);
sline_list=cell(1,length(ll1));   %2014
sline_list_long=cell(0,0);   %2019
for i=1:length(ll1);
  fn=ll1(i).name;
  fid=fopen(fn,'r');
  s1=fscanf(fid,'%c');
  fclose(fid);
  eol=[findstr(s1,setstr(13)) length(s1)];
  bol=1;
  for e=eol;
    sline=s1(bol:(e-1));
    if (length(sline)>=length(string)) & ~isempty(findstr(sline,string));
      disp([fn '::' sline]);
      sline_list{1,i}=[fn '::' sline];    %2014
      sline_list_long={sline_list_long{:} [fn '::' sline]};   %2019
    end;
    bol=e+2;
  end;
end;
