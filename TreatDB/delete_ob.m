%This are example lines to delete an object from the data base.
return





%
% Open database
%
Projects =  actxserver('AcqCtrlDb.Projects')
Projects.DataSourceName = 'ElsaDB';


%To delete a structure:
Projname='RETRO ELSA'
Strucname='TALL PIER+TALL ISOL'
if ~Projects.ProjectExist(Projname)
    error(['The project ' Projname ' does not exist' ]);
end
Project = Projects.GetProject(Projname)
if ~Project.StructureExist(Strucname)
        error(['The structure ' Strucname ' does not exist']);
end
Structure = Project.GetStructure(Strucname)
Structure.Delete
Structure.release


