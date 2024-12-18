function st2si(st)
%st2si(st)
%   Writes an 'si' structure in
%   an '.si' file in the working directory.
%
% SEE ALSO:   si2st sist2db
%
% EXAMPLES:
%
%   cd('\\smnt08\users\lab')
%   st1.FileName='dum9999';
%   st2.FileName='du19999';
%   st2si({st1 st2})
%
%JM01

for j1=1:length(st)
  v=st{j1};
  CB=blanks(252);
  LB=zeros(150,1);
  CB(21:70)=adjust(deblank(v.Title),50);
  CB(1:12)=adjust(deblank(v.Name),12);
  CB(75:86)=adjust(deblank(v.Comment),12);
  CB(13:20)=adjust(deblank(v.Unit),8);
  domain=adjust(deblank(v.Domain),1);     
  CB(100)=domain;                           %Javier
  CB(201:212)=adjust(deblank(v.TimeName),12);
  CB(213:220)=adjust(deblank(v.TimeUnit),8);
  %         fla='A';            % HP generated
  fla='B';            % PC generated
  CB(251)=fla;
  CB(252)=setstr(0);
  LB(2:4)=v.Coordinates';
  LB(9)=v.Sensitivity;
  LB(26)=v.Offset;
  LB(30:31)=v.PointsForMean';
  LB(11)=v.InitialTime;
  LB(12)=v.TimeIncrement;
  LB(25)=v.NPoints;
  yy=v.Value;
  fname1=[v.FileName '.si'];
  disp(['Vector -> File: ' fname1]);
  if fla=='A';
    [fid,message] = fopen(fname1,'w','b');     % HP generated
    error(message);
  elseif fla=='B';
    [fid,message] = fopen(fname1,'w','l');     % PC generated
    error(message);
  end;
  count = fwrite(fid,CB,'char');
  count = fwrite(fid,LB,'float');
  count = fwrite(fid,real(yy),'float');
  if domain=='f';
    count1 = fwrite(fid,imag(yy),'float');
    count = min([count count1]);
  end;
  fclose(fid);
  disp([' ' sprintf('%g',count) ' points written of ' sprintf('%g',v.NPoints)]);
end;
return;



function str2=adjust(str1,n)
%ADJUST
%       STR2=ADJUST(STR1,N)  Adds the required trailing
%         blanks to string matrix STR1 till its columns are N.
%         If size(STR1,2)>N, a warning window is generated.
%
%       EXAMPLE:
%                        adjust('abc',10)
%                        adjust(str2mat('abc','lmncd'),10)
%
%   9/6/95 J. Molina  

nn=n-size(str1,2);
if nn<0;
  str2=str1(:,1:n);
  warndlg(['The string ''' str1(1,:) ...
      ''' will be cut to ''' str2(1,:) ''''],...
    'Warning at adjust.m');
elseif nn>0;
  if isempty(str1);
    str1=' ';
  end;
  bla=blanks(nn);
  str2=[str1 bla(ones(size(str1,1),1),:)];
else;
  str2=str1;
end;
str2=str2(:,1:n);
return;

