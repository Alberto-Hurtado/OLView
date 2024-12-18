function DBst=sist2db(SIst)
%DBst=sist2db(SIst)
%   Converts signals form 'si' structure to ELSA Data Base structure.
%
% SEE ALSO:   si2st repsig putpp
%
% EXAMPLES:
%   cd('\\smnt08\users\LAB\WallU\WallUu\w21u')
%   SIst=si2st({'w216002' 'w216003'})
%   DBst=sist2db(SIst)
%   repsig(DBst);
%
%JM01

DBst=cell(size(SIst));
for j1=1:length(SIst)
  v=SIst{j1};
%  DBst{j1}.Name=sprintf('%03d',j1);
  DBst{j1}.Name='';
  DBst{j1}.Description=v.Name;
  DBst{j1}.Magnitude='';
  switch v.Unit
  case '(mm)'
    DBst{j1}.Unit='mm';
  case '(kN)'
    DBst{j1}.Unit='kN';
  case '(m/s/s)'
    DBst{j1}.Unit='m/s/s';
  case '(J)'
    DBst{j1}.Unit='J';
  case '(Hz)'
    DBst{j1}.Unit='Hz';
  case '(%)'
    DBst{j1}.Unit='%';
  otherwise
    DBst{j1}.Unit='-';
  end
  DBst{j1}.Positions={v.Comment '' '' '' ''};
  DBst{j1}.Data=v.Value;
end


