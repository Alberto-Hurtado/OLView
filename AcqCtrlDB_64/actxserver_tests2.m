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

Signal = PP.ListSignal()

Signal = 

    's1'

Signal = PP.GetSignal('s1')
 
Signal =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IPPSignal

Signal.get
           Name: 's1'
    Description: ''
       Modified: 0
           Data: [0x1 single]
      Magnitude: 'Force'
           Unit: 'User define'
      Positions: {5x1 cell}

Signal.Data

ans =

   Empty matrix: 0-by-1

a = [1;2;3]

a =

     1
     2
     3

Signal.Data = single(a)
 
Signal =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IPPSignal

Signal.Data

ans =

     1
     2
     3

Signal.Save
Signal.SaveToFile('c:\test1.txt')
Error using Interface.AcqCtrlDB_1.0_Type_Library.IPPSignal/SaveToFile
Invoke Error, Dispatch Exception:
Source: Automation Object [PPSignal]
Description: Unable to create the file [c] : 5
 
Signal.SaveToFile('C:\Users\molina\Documents\MATLAB\test1.txt')
folder = PP.GetDocumentFolder()
 
folder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

folder.ListFolder()

ans = 

    'fold1'

folder = folder.GetFolder('fold1')
 
folder =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocumentFolder

folder.ListDocument()

ans = 

    'doc1'

folder.NewDocument('doc2')
 
ans =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc2 = ans
 
doc2 =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc2.get
           Name: 'doc2'
    Description: ''
       Modified: 0
         Source: ''
        Version: 0
           Size: 0
           Type: 'Presentation'
        Private: 0

doc2.Source = 'C:\Users\molina\Documents\MATLAB\test1.txt'
 
doc2 =
 
	Interface.AcqCtrlDB_1.0_Type_Library.IDocument

doc2.Save
Error using Interface.AcqCtrlDB_1.0_Type_Library.IDocument/Save
Invoke Error, Dispatch Exception:
Source: Automation Object [Document]
Description: SQL Error State:28000, Native Error Code: 4818, ODBC Error: [Microsoft][ODBC SQL Server Driver][SQL Server]Login failed for
user 'sa'.

 
edit putdocu
doc2.get
           Name: 'doc2'
    Description: ''
       Modified: 1
         Source: 'C:\Users\molina\Documents\MATLAB\test1.txt'
        Version: 0
           Size: 0
           Type: 'Presentation'
        Private: 0

doc2.SaveToFile('C:\Users\molina\Documents\MATLAB\test2.txt')
Error using Interface.AcqCtrlDB_1.0_Type_Library.IDocument/SaveToFile
Invoke Error, Dispatch Exception:
Source: Automation Object [Document]
Description: SQL Error State:28000, Native Error Code: 4818, ODBC Error: [Microsoft][ODBC SQL Server Driver][SQL Server]Login failed for
user 'sa'.
