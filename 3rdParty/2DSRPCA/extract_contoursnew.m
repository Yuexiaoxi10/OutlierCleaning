%This function is used for feature extraction and rank minimization
%input: is binary iamge which after canny edge detector
%output: is cell which contain the information of each trajectory in image
%In the cell r, each cell represent one trajectory.
%%
function contour_clean=extract_contoursnew(BW)

 con=double(BW); 
 
hankelsize = 8;
% build one 'filter' s which the center is zero
s=[1 1 1;1 0 1;1 1 1];
% using the input image make a convolution with s
BW= conv2(con,s,'same');
% make sure after the convolutin each pixel will not being effected, 
% bcz sometime after convolution some pixel will become 1 although 
% the original value is 0
BW = BW.*con;
% we find out the value biger than three or not, here we accept bifurcate
% contour but we not accept crossing contour.
while ~isempty(find(BW>3))
    
    [row, col]= find(BW>3);
    
    con(row(1),col(1))=0;
     BW= conv2(con,s,'same');
     BW = BW.*con;
end
% find the beginning point of each trajectory
[row, col]=find(BW==1);
k=1;
endpoint=[row';col']';

[row,column]=find(BW > 1);
all_p=[row';column']';
% % duan=0;
% % duan1=0;
while (~isempty(all_p))
    if isempty(endpoint)
% all_p store all the begining point  
        i = all_p(1,:);
        contourz = bwtraceboundary(BW, i, 'W', 8, 2000,'counterclockwise');
% sepatate the contourz for two parts, and use both of them as the same 
% trajectory from different direction
% contourz_half is the first half and contourz_half1 is the seconde half
% if there is an wheel in the image there is no beginning point we directly
% set contourz_half information to contourz
        contourz_half=contourz;
         contourz_half1=[];
    else
        i=endpoint(1,:);
        contourz = bwtraceboundary(BW, i, 'W', 8, 2000,'counterclockwise');
        contourz_half=contourz(1:floor(length(contourz)/2),:);
          contourz_half1=contourz(floor(length(contourz)/2)+1:length(contourz),:);
                contourz = [contourz_half;
                     contourz_half1;
                    endpoint(1,:)];

    end   
    
%     estimate the contour is empty or not, if not the point in each
%     trajectory should longer than 15
    if(~isempty(contourz))
        if(size(contourz_half,1)>=15)
%            duan=floor((size(contourz_half,1)/15));
%                for i=0:duan-1 
%                    j=i*15+1;
%                    jj=(i+1)*15;
%              
%             contour{k}=contourz_half(j:jj,:);
% %                
                 contour{k}=contourz_half;       
%              contourz=[contourz_half;
%                        endpoint(1,:)];
            k=k+1;
%                 end
          end
          if(size(contourz_half1,1)>=15)
%              duan1=floor((size(contourz_half1,1)/15));
%                for i=0:duan1-1 
%                    j=i*15+1;
%                    jj=(i+1)*15;
%             contour{k}=contourz_half1(j:jj,:);
                  contour{k}=contourz_half1;
              k=k+1;  
%                end
%         figure,plot(all_p(:,2),all_p(:,1),'r*');
%         hold on;
%         plot(contour{k-1}(:,2),contour{k-1}(:,1));
%         hold off;
%         all_p=setdiff(all_p,contourz,'rows');
%         pause();
        end
    
    
        for n = 1:length(contourz)
            BW(contourz(n,1),contourz(n,2)) = 0;
        end
        [row1,col1]=find(BW==1);
        endpoint=[row1,col1];
    else
        all_p(1,:)=[];
    end
    
end

% toc;

%  imagesc(con)
%  figure
%  con1=edge(test_image,'canny',[],0.5);
%  imagesc(con1);
%  figure
%  con2=edge(test_image,'canny',[],2)
%  imagesc(con2)
%  rng(101);
% %  figure;
% %  imshow(BW,'border','tight');
% % drawnow;
% 
% % fullscreen;
% % Z=getframe(gcf);
% % imwrite(Z.cdata,'plane_binary.jpg','Quality',100);  %%%here plane_binary.jpg can be changed with any name you want for saving


% %  figure;
% %  imshow(0*BW,'border','tight');
% % hold on;
colorz=rand(3,length(contour));
% %  for(k=1:length(contour))
% %    cc=contour{k};
% %      plot(cc(:,2),cc(:,1),'Color',colorz(:,k),'LineWidth',2);
% % %      pause();
% %   end
% %  hold off;
% %  drawnow;
% %  fullscreen;
% % Z=getframe(gcf);
% % imwrite(Z.cdata,'plane_contours.jpg','Quality',100);

lambda=5;
xx=round(size(BW,1)/2);
yy=round(size(BW,2)/2);

%%%all of the above was to obtain the contours
%%%this for loop is the main processing part
%%%for each contour vector we construct the 
%%%required hankel matrices and call the SRPCA code
%%%as appeared in CVPR 2012 paper
%%%means the input is structure hankel data matrix
%%%a cleaner version of this can be written
%%%accepting vectors for more information refer to 
%%%Mustafa Ayazoglu's PhD thesis and ALM algorithm
for(k=1:length(contour))
    contourz=contour{k};
    trjx=contourz(:,1)';
    trjy=contourz(:,2)';
    
    trjx=trjx-xx;
    trjy=trjy-yy;
    
    trjx=trjx/xx;
    trjy=trjy/yy;
    
    trj=[trjx;trjy];
    trj=trj(:);
    
    cc=find(~isnan(trjx));
    horizon=cc(end)-cc(1)+1;
    
    datacomx=trjx(cc(1):cc(end));
    datacomy=trjy(cc(1):cc(end));
if horizon>2*hankelsize
    Hcomx=hankelConstruction(datacomx,hankelsize);
    Hcomy=hankelConstruction(datacomy,hankelsize);
else
    Hcomx=hankel(datacomx(1:round(horizon/2)),datacomx(round(horizon/2):horizon));
    Hcomy=hankel(datacomy(1:round(horizon/2)),datacomy(round(horizon/2):horizon));
end    
    Hcom=[Hcomx; Hcomy];
    size(Hcom)
    
     tic;
     [~,~,val,rnk,a,e]=rHPCA_weight_reweighted_simpler_2D(Hcom,lambda,ones(1,size(datacomx,2)));
     toc;
    
    datacomx_clean=a(1:end/2);
    datacomy_clean=a(end/2+1:end);
    
    datacomx_clean=(datacomx_clean*xx)+xx;
    datacomy_clean=(datacomy_clean*yy)+yy;
    
    contourz_clean(:,1)=datacomx_clean;
    contourz_clean(:,2)=datacomy_clean;
    
    contour_clean{k}=contourz_clean;
    contourz_clean=[];
end

%  figure;
%  imshow(0*BW,'border','tight');
%  hold on;
% % % 
%  for(k=1:length(contour))
%       cc=contour_clean{k};
%       %plot(round(cc(:,2)),round(cc(:,1)),'Color',colorz(:,k),'LineWidth',2);
%       plot((cc(:,2)),(cc(:,1)),'Color',colorz(:,k),'LineWidth',2);
%   end
%  hold off;
%  drawnow;
%  fullscreen;

