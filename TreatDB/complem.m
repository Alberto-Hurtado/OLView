function s1_=complem(s1,s2)
%s1_=complem(s1,s2)
%  Complement of s2 within s1.
%
% SEE ALSO:  common
%
% EXAMPLES:
% s1={'first' 'second' 'third'}; s2={'' 'second' 'third' 'fourth'};
% s1_=complem(s1,s2)
%
%JM01

if ~iscell(s1); s1=cellstr(s1); end   %2008
if ~iscell(s2); s2=cellstr(s2); end

empty={''}; siz1=size(s1); siz2=size(s2);
s=empty(ones(max(siz1,siz2)));
ss1=s; ss1(1:siz1(1),1:siz1(2))=s1;
ss2=s; ss2(1:siz2(1),1:siz2(2))=s2;
intersec=strcmp(ss1,ss2);
s(~intersec)=ss1(~intersec);
s1_=s(1:siz1(1),1:siz1(2));