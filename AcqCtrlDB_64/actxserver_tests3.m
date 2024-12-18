Projects = actxserver('AcqCtrlDB.Projects')
 
Projects =
 
	COM.AcqCtrlDB_Projects

Projects.DataSourceName = 'ElsaDB'
 
Projects =
 
	COM.AcqCtrlDB_Projects

Project = Projects.GetProject('AcqCtrlDB64')
 
Project =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IProject

Structure = Project.GetStructure('Str1')
 
Structure =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IStructure

Experiment = Structure.GetExperiment('Exp1')
 
Experiment =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IExperiment

PP = Experiment.GetPostProcessing('PP1')
 
PP =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IPostProcessing

folder = PP.GetDocumentFolder()
 
folder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

folder = folder.GetFolder('fold1')
 
folder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

folder.ListDocument()

ans = 

    'doc1'
    'doc2'

doc = folder.NewDocument('doc3')
 
doc =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc.Source = 'C:\Users\molina\Documents\MATLAB\test1.txt'
 
doc =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc.Save
doc.SaveToFile('C:\Users\molina\Documents\MATLAB\test2.txt')
NewFolder = DocFolder.NewFolder('fold2')
Undefined variable "DocFolder" or class "DocFolder.NewFolder".
 
 folder = PP.GetDocumentFolder()
 
folder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

NewFolder = folder.NewFolder('folder2')
 
NewFolder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

Doc2 = NewFolder.NewDocument('d1')
 
Doc2 =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc.Source = 'C:\Users\molina\Documents\MATLAB\test1.txt'
 
doc =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc.Save
