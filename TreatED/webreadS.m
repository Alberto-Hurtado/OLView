
%  * function localFile = webreadS(downloadIri) 
%  * Creation date: 19-Nov-2019
%  * ------------------------------------------------------------------
%  * This simple script facilitates reading files from MATLAB when
%  * untrusted by default or self-signed certificates are used.
%  *
%  * PREREQUISITES:
%  * celestinaWS must have been executed previously 
%  *
%  * USAGE:
%  * Call webreadS with these two parameters: 
%  *    - Local filename to where save the file
%  *    - URL from which retrieve the file
%  *
%  * EXAMPLE:
%  *    webreadS('.\file.txt', 'https://elsadata.jrc.it:444/files/specimen0/170712185727_file.doc');
%  *

function localFile = webreadS(downloadIri)
global celestws_options;

% fprintf('> Reading [%s] ...\n', downloadIri);
localFile = webread(downloadIri, celestws_options);

end