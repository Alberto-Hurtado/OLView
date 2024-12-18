%This are example lines to delete an object from the data base.
return



%To delete a project:
%Projname='SeisProject Shear'
% Projname='SeisRacks ELSA'
% Projname='prueba'
Projname='dummy 5'
%Projname='ESECMaSE ELSA dummy'

Projects = CreateObject ('AcqCtrlDb.Projects')
PutObjectProp(Projects,'DataSourceName','ElsaDB');
if ObjectInvoke(Projects,'ProjectExist',Projname);
  sa = MENU(['The project ' Projname ' does exist' ...
      '. Do you want to delete that project?'],'Ok','Cancel');
  switch sa;
  case 1;
    Project = ObjectInvoke(Projects,'GetProject',Projname)
    ObjectInvoke(Project,'Delete')
    ReleaseObject(Project)
  case 2
    return;
  end
else
  sa = MENU(['The project ' Projname ' does not exist'],'Ok');
end;

ReleaseObject(Projects)




%To delete a structure:
Projname='Dispass'
Strucname='Frame+SPD 1st'
Projects = CreateObject ('AcqCtrlDb.Projects')
PutObjectProp(Projects,'DataSourceName','ElsaDB');
if ObjectInvoke(Projects,'ProjectExist',Projname);
  Project = ObjectInvoke(Projects,'GetProject',Projname)
  if ObjectInvoke(Project,'StructureExist',Strucname);
    sa = MENU(['Structure ' Strucname ' exists within project ' Projname ...
        '. Do you want to delete that structure?'],'Ok','Cancel');
    switch sa;
    case 1;
      Structure = ObjectInvoke(Project,'GetStructure',Strucname)
      ObjectInvoke(Structure,'Delete')
      ReleaseObject(Structure)
    case 2
      return;
    end
  else
    sa = MENU(['Structure ' Strucname ' does not exist'],'Ok');
  end;
  ReleaseObject(Project)
else
  sa = MENU(['The project ' Projname ' does not exist'],'Ok');
end;
ReleaseObject(Projects)

