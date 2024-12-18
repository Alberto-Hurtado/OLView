function st=si2st(fname)
%st=si2st(fname)
%   Reads an 'si' structure from
%   an '.si' file in the working directory.
%
% SEE ALSO:   st2si sist2db
%
% EXAMPLES:
%
%   cd('\\smnt08\users\LAB\WallU\WallUu\w21u')
%   st=si2st('w216001')
%   w=si2st({'w216002' 'w216003'})
%   w(5:6)=si2st({'w216004' 'w216005'}) 
%
%JM01

if isempty(fname);
  st={};
  return;
end;
fname=cellstr(fname);
st=cell(1,length(fname));
for j1=1:length(fname);
  fname1=[deblank(fname{j1}) '.si'];
  disp(['Structure  <- File: ' fname{j1}]);
  [fid,message] = fopen(fname1,'r','l');
  error(message);
  [sCmt,count] = fread(fid,[1 252],'char');
  CB(1:252)=setstr(sCmt);
      if CB(251)=='B';
%        disp(' (PC generated)');
      elseif CB(251)=='A';
%        disp(' (HP generated)');
        fclose(fid);
        [fid,message] = fopen(fname1,'r','b');
        error(message);
        [sCmt,count] = fread(fid,[1 252],'char');
        CB(1:252)=setstr(sCmt);
      else
        error(' File is neither HP nor PC generated!');
      end;
  domain=CB(100);                         %Javier
  [LB(1:150),count] = fread(fid,150,'float');
  [yy,count] = fread(fid,inf,'float');
  if domain=='f';
  	count=count/2;
  	yy=yy(1:count)+i*yy((count+1):(2*count));
  end;
  disp([' ' sprintf('%g',count) ' points read of ' sprintf('%g',LB(25))]);
  fclose(fid);
  LB(25)=count;
  st{j1}.FileName=fname{j1};
  st{j1}.Title=deblank(CB(21:70));
  st{j1}.Name=deblank(CB(1:12));
  st{j1}.Comment=deblank(CB(75:86));
  st{j1}.Unit=deblank(CB(13:20));
  st{j1}.Domain=domain;
  st{j1}.TimeName=deblank(CB(201:212));
  st{j1}.TimeUnit=deblank(CB(213:220));
  if domain=='t' | domain==' ';
    st{j1}.TimeName='time';
    st{j1}.TimeUnit='(s)';
  end;
  st{j1}.Coordinates=LB(2:4)';
  st{j1}.Sensitivity=LB(9);
  st{j1}.Offset=LB(26);
  st{j1}.PointsForMean=LB(30:31)';
  st{j1}.InitialTime=LB(11);
  st{j1}.TimeIncrement=LB(12);
  st{j1}.NPoints=LB(25);
  st{j1}.Value=yy;
end;
