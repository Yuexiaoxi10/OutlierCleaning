 
function NewTraj = getNewTraj(videoPrediction,order,lambda)

njt = size(videoPrediction{1,1},1); % number of joints
Joint_Frm = cell(1, njt);
frame = length(videoPrediction);
dtTemp = cell2mat(videoPrediction);
for j = 1:njt
    Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);
end
Trajec_new = cell(1, njt);
Omega = cell(1, njt);
for j = 1 : njt
    [omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,j}(1,:), order+1);
    [omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,j}(2,:), order+1);
    omega = double(omegaX & omegaY);
    Trajec_new{j} = l2_fastalm_mo(Joint_Frm{1,j},lambda,'omega',omega);
    Omega{j} = omega;
end


NewTraj = cell(1,frame);
pose = zeros(njt,2);
for i = 1 : frame
    
    
    for j = 1 : njt
        joint = Trajec_new{1,j}(:,i);
        pose(j,:) = joint';
        
        
    end
    
    NewTraj{1,i} = pose;
    
end
