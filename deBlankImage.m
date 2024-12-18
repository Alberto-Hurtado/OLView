function deBlankImage(name)
%function deBlankImage(im1,varargin)
% Objet de deBlankImage: sauvegarde une image de la figure, en restreignant
%                        au maximum la zone de blanc peripherique
%                        
% Argument Entree      : 
% name    : nom du fichier de sauvegarde
%           
% Exemple              : 
%                        
% Remarque             : 
%                        
% Revision             : 
%                        
% Voir aussi           : 
%    

fenpos=get(gcf,'Position');
figure(gcf);
set(gcf,'Position',get(0,'ScreenSize'))
saveas(gcf,[ name '_a.fig'], 'fig')
saveas(gcf, 'buffer.tiff','tiff')
imtif=imread(['buffer.tiff']);
figure;imshow(imtif);
j1=sort(find(sum(255-imtif(:,:,1),1)));
imtif1=imtif(:,j1(1):j1(end),:);
imshow(imtif1);
j1=sort(find(sum(255-imtif(:,:,1),2)));
imtif1=imtif1(j1(1):j1(end),:,:);
imshow(imtif1);
imwrite(imtif1,[ name '_a.tif'],'Compression','none');
imwrite(imtif1,[ name '_a.bmp']);
pause(2);
close;
set(gcf,'Position',fenpos);
