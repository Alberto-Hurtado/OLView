function str=simplestr(str)
% Replaces extrange characters in a string


    str=strrep(str,' ','_');
    str=strrep(str,',','-');
    str=strrep(str,'&','-');
    str=strrep(str,'%','-');
    str=strrep(str,'\','-');
    str=strrep(str,'{','-');
    str=strrep(str,'}','-');
    str=strrep(str,'<','-');
    str=strrep(str,'>','-');
    str=strrep(str,'*','-');
    str=strrep(str,'?','-');
    str=strrep(str,'/','-');
    str=strrep(str,'!','-');
    str=strrep(str,'''','-');
    str=strrep(str,'"','-');
    str=strrep(str,':','-');
    str=strrep(str,'|','-');
    str=strrep(str,'#','-');
    str=strrep(str,'@','-');
    str=strrep(str,'^','-');