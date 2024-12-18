cd C:\Users\molina\Documents\MATLAB\2018_11_22_WS

celestinaWS


%     ____     _           _   _
%    / ___|___| | ___  ___| |_(_)_ __   __ _
%   | |   / _ \ |/ _ \/ __| __| | '_ \ / _` |
%   | |__|  __/ |  __/\__ \ |_| | | | | (_| |
%    \____\___|_|\___||___/\__|_|_| |_|\__,_|
% 
% 
% 	Web Services (and certificates) seem to have been already installed.
% If you wish to reinstall everything, just delete the files with name
% "installed_ws" and "installed_cert" in the current directory
% [*]	Listing services and object creation methods available:
% Methods for class data:
% 
% createDataFileRelation                      getAllOrganisations                         
% createDataRight                             getAllPersons                               
% createExperimentForProject                  getAllPhysicalPropertyTypes                 
% createExperimentForSpecimen                 getAllSignalMagnitudes                      
% createExperimentSpecimenRelation            getAllSpecimenComponentTypes                
% createMaterialType                          getAllUnits                                 
% createNumericalExperimentForProject         getDataFileDownloadAddress                  
% createNumericalExperimentForSpecimen        getExperiment                               
% createOrganisation                          getExperimentsIds                           
% createPerson                                getProject                                  
% createPhysicalPropertyType                  getProjectByName                            
% createProject                               getProjects                                 
% createSpecimenForExperiment                 getProjectsIds                              
% createSpecimenForProject                    getSignal                                   
% data                                        getSignalsOfExperiment                      
% delDataFileForExperimentalActivity          getSpecimen                                 
% delDataFileForProject                       getSpecimensIds                             
% delDataFileForSpecimen                      saveDataRight                               
% delDataFileRelation                         saveExperiment                              
% delDataRight                                saveOrganisation                            
% delExperiment                               savePerson                                  
% delExperimentSpecimenRelation               saveProject                                 
% delIdentityImageForExperimentalActivity     saveSpecimen                                
% delIdentityImageForOrganisation             testWS                                      
% delIdentityImageForPerson                   testWSParamException                        
% delIdentityImageForProject                  uploadDataFile                              
% delIdentityImageForSpecimen                 uploadDataFileForExperimentalActivity       
% delMaterialType                             uploadDataFileForProject                    
% delOrganisation                             uploadDataFileForSpecimen                   
% delPerson                                   uploadIdentityImageForExperimentalActivity  
% delPhysicalPropertyType                     uploadIdentityImageForOrganisation          
% delProject                                  uploadIdentityImageForPerson                
% delSignal                                   uploadIdentityImageForProject               
% delSpecimen                                 uploadIdentityImageForSpecimen              
% display                                     uploadInputSignals                          
% getAllDataFileRelations                     uploadOutputSignals                         
% getAllDataRights                            whoAmI                                      
% getAllMaterialTypes                         
% 
% Static methods:
% 
% getBasic                                    getOrganisation                             
% getCdvDate                                  getPerson                                   
% getDataFile                                 getPhysicalProperty                         
% getDataRight                                getPlan2D                                   
% getDevice                                   getPoint2D                                  
% getExperimentalActivity                     getProjectObject                            
% getLocation                                 getSignalData                               
% getMagnitude                                getSpecimenComponent                        
% getMaterial                                 getSpecimenObject                           
% getMaterialCategory                         getTypeAndUnit                              
% getMaterialType                             getUploadFile                               
% getOntologyClass                            


whoAmI(data)

% ans =
% 
%     'ADMIN INI'



help data.getProjectByName

%  getProjectByName  
%    project = getProjectByName(obj,name)  
%      Inputs:
%        obj - data object
%        name - string
%      Output:
%        project - Project object
%  
%   See also data.


% project1 = getProjectByName(data,'Spear ELSA')
project1 = getProjectByName(data,'ESECMaSE ELSA')



% project1 = 
% 
%   Project with properties:
% 
%               experimentalActs: [62×1 wsdl.data.ExperimentalActivity]
%                      specimens: [2×1 wsdl.data.Specimen]
%                     dataRights: []
%                        endDate: [1×1 wsdl.data.CdvDate]
%              identityImageIris: []
%     intellectualPropertyOwners: []
%                       keywords: {8×1 cell}
%                   participants: [1×1 wsdl.data.Organisation]
%                        purpose: []
%                      shortName: 'ESECMaSE ELSA'
%                      startDate: [1×1 wsdl.data.CdvDate]
%                      datafiles: [1×1 wsdl.data.DataFile]
%                    description: 'Enhanced Safety and Efficient Construction of Masonry Structures in Europe. COLL-CT-2003-500291.'
%                             id: 'http://elsadata.jrc.ec.europa.eu/celestina#project236'
%                           name: 'ESECMaSE ELSA'

             
             
prop_table=ed2fsProjectProp(project1,'ESECMaSE_FS')

% prop_table = 
% 
%     {'endDate'    }    {'27/03/2008'                               }
%     {'keywords'   }    {'masonry##hammer excitation##calcium sil…'}
%     {'purpose'    }    {0×0 double                                 }
%     {'shortName'  }    {'ESECMaSE ELSA'                            }
%     {'startDate'  }    {'23/08/2007'                               }
%     {'description'}    {'Enhanced Safety and Efficient Construct…'}
%     {'id'         }    {'http://elsadata.jrc.ec.europa.eu/celest…'}
%     {'name'       }    {'ESECMaSE ELSA'                            }


project1.datafiles(1)

%   DataFile with properties:
% 
%              crc: []
%     creationDate: []
%           digest: '7406ed21bbeca8ba07a132c03451639d7e6f4647'
%      downloadIRI: 'https://monica.jrc.it:444/files//project236/2uROEXXNnSs__27800Instrumentation-CS-inst_num.dwg'
%       fileFormat: []
%          roleIri: 'http://www.celestina-integrations.com/data#hasImage'
%        roleLabel: 'Image'
%        shortName: []
%             size: 200928
%     thumbnailIRI: []
%      description: 'AUTOCAD drawings for the locations and numbering of instrumentations'
%               id: 'http://elsadata.jrc.ec.europa.eu/celestina#document27800'
%             name: 'Instrumentation'             

dataf_table=ed2fsDatafiles(project1.datafiles,'ESECMaSE_FS\Datafiles')
% Error using websave (line 98)
% Could not establish a secure connection to "monica.jrc.it". The reason is "error:14090086:SSL
% routines:ssl3_get_server_certificate:certificate verify failed". Check your certificate file
% (C:\Program Files\MATLAB\R2018a\sys\certificates\ca\rootcerts.pem) for expired, missing or invalid
% certificates.
% 
% Error in ed2fsDatafiles (line 70)
%     outfile=websave([outpath '\' roleLabel1 '\' Datafiles(idf).name], ...
 
%To avoid this error, add manually a certificate in rootcerts.pem by copying
%the content in elsadata.cer.pem after it was generated for java

dataf_table=ed2fsDatafiles(project1.datafiles,'ESECMaSE_FS\Datafiles')
% dataf_table = 
% 
%   DataFile with properties:
% 
%              crc: []
%     creationDate: []
%           digest: '7406ed21bbeca8ba07a132c03451639d7e6f4647'
%      downloadIRI: 'https://monica.jrc.it:444/files//project236/2uROEXXNnSs__27800Instrumentation-CS-inst_num.dwg'
%       fileFormat: []
%          roleIri: 'http://www.celestina-integrations.com/data#hasImage'
%        roleLabel: 'Image'
%        shortName: []
%             size: 200928
%     thumbnailIRI: []
%      description: 'AUTOCAD drawings for the locations and numbering of instrumentations'
%               id: 'http://elsadata.jrc.ec.europa.eu/celestina#document27800'
%             name: 'Instrumentation'


specimensRef=project1.specimens;
specimensRef(1)
%   Specimen with properties:
% 
%               experimentalActs: []
%                      materials: []
%                   phProperties: []
%                        project: []
%             specimenComponents: []
%                     dataRights: []
%                        endDate: []
%              identityImageIris: []
%     intellectualPropertyOwners: []
%                       keywords: []
%                   participants: []
%                        purpose: []
%                      shortName: []
%                      startDate: []
%                      datafiles: []
%                    description: 'Clay Brick Units House'
%                             id: 'http://elsadata.jrc.ec.europa.eu/celestina#specimen354'
%                           name: 'Clay Brick'

[specimens,specimens_table]=ed2fsSpecimens(specimensRef, ...
    'ESECMaSE_FS\Specimens')
% specimens = 
% 
%   1×2 Specimen array with properties:
% 
%     experimentalActs
%     materials
%     phProperties
%     project
%     specimenComponents
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
% 
% 
% specimens_table =
% 
%   3×3 cell array
% 
%     {'name'              }    {'description'              }    {'experimentalActs'         }
%     {'Clay Brick'        }    {'Clay Brick Units House'   }    {'m17##e30##m16##m18##e27…'}
%     {'Calc. Silic. Brick'}    {'Calcium Silicate Brick …'}    {'e04##e03##k06##e14##e12…'}


experimentsRef=project1.experimentalActs;

% experimentsRef = 
% 
%   62×1 ExperimentalActivity array with properties:
% 
%     devices
%     inputSignals ...

Experiment=getExperiment(data,experimentsRef(1).id)

% Experiment = 
% 
%   ExperimentalActivity with properties:
% 
%                        devices: []
%                   inputSignals: []
%                         nature: [1×1 wsdl.data.OntologyClass]
%                  outputSignals: [60×1 wsdl.data.SignalData]
%                          plans: []
%                        project: [1×1 wsdl.data.Project]
%               setupDescription: []
%                        setupId: []
%                      setupName: []
%                      specimens: [1×1 wsdl.data.Specimen]
%                     dataRights: []
%                        endDate: [1×1 wsdl.data.CdvDate]
%              identityImageIris: []
%     intellectualPropertyOwners: []
%                       keywords: []
%                   participants: []
%                        purpose: []
%                      shortName: []
%                      startDate: [1×1 wsdl.data.CdvDate]
%                      datafiles: [58×1 wsdl.data.DataFile]
%                    description: 'Second small scale test, 0.01g, detection of speed of test;'
%                             id: 'http://elsadata.jrc.ec.europa.eu/celestina#exp_comp2921'
%                           name: 'k06'

% [experiments,experiments_table]=ed2fsExperiments( ...
%     experimentsRef,'ESECMaSE_FS\Experiments')
[experiments,experiments_table]=ed2fsExperiments( ...
    experimentsRef(1:1),'ESECMaSE_FS\Experiments')


% experiments = 
% 
%   ExperimentalActivity with properties:
% 
%                        devices: []
%                   inputSignals: []
%                         nature: [1×1 wsdl.data.OntologyClass]
%                  outputSignals: [60×1 wsdl.data.SignalData]
%                          plans: []
%                        project: [1×1 wsdl.data.Project]
%               setupDescription: []
%                        setupId: []
%                      setupName: []
%                      specimens: [1×1 wsdl.data.Specimen]
%                     dataRights: []
%                        endDate: [1×1 wsdl.data.CdvDate]
%              identityImageIris: []
%     intellectualPropertyOwners: []
%                       keywords: []
%                   participants: []
%                        purpose: []
%                      shortName: []
%                      startDate: [1×1 wsdl.data.CdvDate]
%                      datafiles: [58×1 wsdl.data.DataFile]
%                    description: 'Second small scale test, 0.01g, detection of speed of test;'
%                             id: 'http://elsadata.jrc.ec.europa.eu/celestina#exp_comp2921'
%                           name: 'k06'
% 
% 
% experiments_table =
% 
%   2×7 cell array
% 
%   Columns 1 through 5
% 
%     {'name'}    {'description'      }    {'startDate' }    {'endDate'   }    {'specimens'        }
%     {'k06' }    {'Second small sc…'}    {'28/11/2007'}    {'28/11/2007'}    {'Calc. Silic. Br…'}
% 
%   Columns 6 through 7
% 
%     {'setupName'}    {'nature'  }
%     {0×0 double }    {'PHYSICAL'}
    

    