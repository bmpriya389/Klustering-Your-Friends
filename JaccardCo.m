function JaccardCo(Egonet_Filename,extractedfeature)

Egonet_Filename = 'Normalized_1968_ego.txt';
%extractedfeature = 'Normalized_extrctdfeature.txt';
extractedfeature = 'Allfeatures_Cell.mat';

%opening 239.egonet file
fid = fopen(Egonet_Filename);
%count number of lines
count = 0;
tline = fgets(fid);
while ischar(tline)
    tline = fgets(fid);
    count = count + 1;
end

fclose(fid);


% %opening normalized extracted_feature.txt file
% fid = fopen(extractedfeature);
% % count number of lines
% count_feature = 0;
% tline = fgets(fid);
% while ischar(tline)
%     tline = fgets(fid);
%     count_feature = count_feature +1;
% end
% fclose(fid);



% create vector from USerID.egonet
CArray = cell(1,count);
nodes = count;
edges =0;
fid = fopen(Egonet_Filename);   % this loop used for moving to next alters friend list
for j=1:count
    tline= fgets(fid);
    C = strsplit(tline,{'\t',' ',':'});
    CArray{j} = C;
    edges = edges + length(CArray{j})-1;
end
fclose(fid);

%create vector array of extracted feature file
%fid = fopen('Weighted_graph.txt','w');
%fprintf(fid,'%s\t',num2str(nodes),num2str(edges),'001');
%fprintf(fid,'\n');


load(extractedfeature,'featurevector');

% Ego features
gid = fopen('WeightedGraph_Ego_Alters.txt','w');
EgonetAlter = '1968.egonet';
A = sscanf(EgonetAlter,'%d');
indk = find(cell2mat({featurevector{:,24}})==A);
EgoFeat= featurevector(indk,[1:23 25:end]);
for m = 1:length(CArray)
    Alters = str2double(CArray{m});
  indA = find(cell2mat({featurevector{:,24}})==(Alters(1)+1968));
  EgonetFeat = {featurevector{indA,[1:23 25:end]}};
Jaccard_dist = computeJaccardDistance(EgonetFeat,EgoFeat);

%fprintf(gid,'%d %d',Alters(1),Jaccard_dist+1);  
fprintf(gid,'%d %d',1,Jaccard_dist+1);  
fprintf(gid,'\n');
end
fclose(gid);

%create vector array of extracted feature file
fid = fopen('Weighted_graph.txt','w');
fprintf(fid,'%s\t',num2str(nodes),num2str(edges),'001');
fprintf(fid,'\n');
 
  
% Alters Feature collection
for k = 1:length(CArray);
    Egonet = str2double(CArray{k});
    ind = find(cell2mat({featurevector{:,24}})==(Egonet(1)+1968));
    Egonetfeature = {featurevector{ind,[1:23 25:end]}};
    
    if(isempty(ind))
        continue;
    end
    
    if(isnan(Egonet(1)))
        fprintf(fid,'\n');
        continue;
    end
    
    for j=2:length(Egonet)
        indj = find(cell2mat({featurevector{:,24}})==(Egonet(j)+1968));
        AlterEgonetfeature = featurevector(indj,[1:23 25:end]);
        %D = pdist2(Egonetfeature,AlterEgonetfeature,'jaccard');
        
        % Similarlity computation between alters and Ego-Alters
        
        Jaccard_dist = computeJaccardDistance(Egonetfeature,AlterEgonetfeature);
        
        %Jaccard_dist = 57-D*57;
        fprintf(fid,'%d %d ', Egonet(j),Jaccard_dist+1);
    end
    fprintf(fid,'\n');
    
end
fclose(fid);










