function id=createDFRel(roleLabel,roleDescription,roleParent)
% function id=createDFRel(roleLabel,roleDescription,roleParent)
% Creates a datafile relation in ELSADATA based on the name and description
% strings for the new relation and the name string of the parent relation.
%
% F.J. Molina 2020 03

% roleLabel='Testing procedure'
% roleDescription='Information on the test steps'
% roleParent='Experimental Act. data file'

roles=getAllDataFileRelations(data);
roleNames=cell(size(roles));

%% display current list for checking
display('List of existing datafile relations in ELSADATA:')
for iRole=1:size(roles)
    parent=roles(iRole).parents;
    if isempty(parent)
        parentName='';
    else
        parentName=roles(iRole).parents.name;
    end
    display(sprintf('  iRole=%2d  Name=%45s  Parent=%45s    Descr.=%s', ...
        iRole, roles(iRole).name,parentName,roles(iRole).description))
        roleNames{iRole}=roles(iRole).name;
end

%% find in the list and delete
for iRole=1:size(roles)
    roleNames{iRole}=roles(iRole).name;
end
iRole = find(strcmp(roleNames,roleLabel))
if ~isempty(iRole)   %Delete the relation if necessary
    isel = menu(['The datafile relation "' roleLabel '" exists in ED.'],...
        ['Delete the datafile relation ' roleLabel ...
        ' in ED (get sure related datafiles are deleted before!)'],...
        'Exit');
    asel={'Delete role' 'Exit' };
    sel=asel{isel}
    switch sel
        case 'Delete role'
            role = roles(iRole)
            delDataFileRelation(data,role)
        case 'Exit'
            return
    end
    
    roles=getAllDataFileRelations(data);
    roleNames=cell(size(roles));
    
    %% display current list for checking
    display('List of existing datafile relations in ELSADATA:')
    for iRole=1:size(roles)
        parent=roles(iRole).parents;
        if isempty(parent)
            parentName='';
        else
            parentName=roles(iRole).parents.name;
        end
        display(sprintf('  iRole=%2d  Name=%45s  Parent=%45s    Descr.=%s', ...
            iRole, roles(iRole).name,parentName,roles(iRole).description))
        roleNames{iRole}=roles(iRole).name;
    end
    
end

%% find in the list or create
for iRole=1:size(roles)
    roleNames{iRole}=roles(iRole).name;
end
iRole = find(strcmp(roleNames,roleLabel))
if isempty(iRole)    %Create the relation
    isel = menu(['The datafile relation "' roleLabel '" was not found in ED.'],...
        ['Create the new datafile relation ' roleLabel ' in ED'],...
        'Exit');
    asel={'Create role' 'Exit' };
    sel=asel{isel}
    switch sel
        case 'Create role'
            relation=data.getBasic;
            relation.name=roleLabel;
            relation.description=roleDescription
            iRoleParent = find(strcmp(roleNames,roleParent));
            parentRelationId=roles(iRoleParent).id
            id=createDataFileRelation(data,relation,parentRelationId)
        case 'Exit'
            return
    end
    
    roles=getAllDataFileRelations(data);
    roleNames=cell(size(roles));
    
    %% display current list for checking
    display('List of existing datafile relations in ELSADATA:')
    for iRole=1:size(roles)
        parent=roles(iRole).parents;
        if isempty(parent)
            parentName='';
        else
            parentName=roles(iRole).parents.name;
        end
        display(sprintf('  iRole=%2d  Name=%45s  Parent=%45s    Descr.=%s', ...
            iRole, roles(iRole).name,parentName,roles(iRole).description))
        roleNames{iRole}=roles(iRole).name;
    end
    
end            

            
            