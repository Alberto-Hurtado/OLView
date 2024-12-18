cd C:\Users\molina\Documents\MATLAB\CDV_Web_Services_R2018a

celestinaWS

projects = getProjects(data)

% projects = 
% 
%   59×1 Project array with properties:
% 
%     experimentalActs
%     specimens
%     dataRights
%     endDate
%     identityImageIris
%     intellectualPropertyOwners
%     keywords
%     participants
%     purpose
%     shortName
%     startDate
%     datafiles
%     description
%     id
%     name
    
    
projects(1)

project_names=cell(length(projects),1);
for ipr=1:length(projects)
    project_names{ipr}=projects(ipr).name;
    disp(sprintf('%d    %s',ipr,project_names{ipr}));
end

project1 = getProjectByName(data,'Dual Frame')
[Projects,tab]=ed2fsProjects(project1,'ELSADATA_FS1')













ed2fsProjects(projects(1:3),'ELSADATA_FS2')

ed2fsProjects(projects(4),'ELSADATA_FS4')

ed2fsProjects(projects(5:10),'ELSADATA_FS5')

ed2fsProjects(projects(1),'E:\ELSADATA_FS0')


ed2fsProjects(projects,'E:\2018_04_24_ELSADATA_FS')


ed2fsProjects(projects(18:19),'E:\2018_04_24_ELSADATA_FS')

ed2fsProjects(projects,'E:\2018_05_01_ELSADATA_FS')


% 1    ASR Bare Frame
% 2    ASR Infilled Frame
% 3    ASSO ELSA
% 4    Acc_Pavia
% 5    Arco ELSA
% 6    BabyFrame_ELSA
% 7    CALIB2013 ELSA
% 8    CaSCo ELSA
% 9    ConcretePrec8 ELSA
% 10    DUAREM ELSA
% 11    DamDet_Pavia
% 12    Dispass ELSA
% 13    Dual Frame
% 14    ESECMaSE ELSA
% 15    FlatRib ELSA
% 16    FlatSlab
% 17    IERP Isol ELSA
% 18    IMAC1 ELSA
% 19    IMAC2 ELSA
% 20    IRIS ELSA
% 21    ISTECH TASK 9 ELSA
% 22    MISS ELSA
% 23    NECSO Bridge ELSA
% 24    NEFDIS ELSA
% 25    NEFOREEE1 ELSA
% 26    Neforeee ELSA
% 27    New Control
% 28    PrecastEC8 ELSA
% 29    Precon
% 30    Prometeo ELSA
% 31    PsChar
% 32    RETRO ELSA
% 33    Reeds_ELSA
% 34    SACOMP ELSA
% 35    SAFE
% 36    SAFE ELSA
% 37    SAFECAST ELSA
% 38    SAFECLADDING ELSA
% 39    SAFEFLOOR ELSA
% 40    SERFIN ELSA
% 41    SILER ELSA
% 42    SLA4F4E ELSA
% 43    SeisLines
% 44    SeisProtec Shear
% 45    SeisRacks ELSA
% 46    Sika
% 47    Spear ELSA
% 48    StableShape ELSA
% 49    SteelQuake
% 50    StruDaMo_ELSA
% 51    SwayComp ELSA
% 52    TAV ELSA
% 53    Tascb ELSA
% 54    Tensacciai Dynamic ELSA
% 55    Tensacciai ELSA
% 56    Vab
% 57    uWalls

