function id=deleteDFRel(roleLabel)
% function id=deleteDFRel(roleLabel,roleDescription,roleParent)
% Deletes a datafile relation in ELSADATA based on the name.
%
% F.J. Molina 2019 04

% roleLabel='Testing procedure'

roles=getAllDataFileRelations(data);
roleNames=cell(size(roles));
for iRole=1:size(roles)
    roleNames{iRole}=roles(iRole).name;
end
iRole = find(strcmp(roleNames,roleLabel))
if ~isempty(iRole)   %Delete the relation 
    isel = menu(['The datafile relation "' roleLabel '" exists in ED.'],...
        ['Delete the datafile relation ' roleLabel ...
        ' in ED (get sure related datafiles are deleted before!)'],...
        'Exit');
    asel={'Delete role' 'Exit' };
    sel=asel{isel}
    switch sel
        case 'Delete role'
            role = roles(iRole)
            id=delDataFileRelation(data,role)
        case 'Exit'
            return
    end
end
