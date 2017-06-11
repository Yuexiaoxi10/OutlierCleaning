clear L K;

% These values are copied from the respective camera calibration files.

% Abbreviations
%%% World                       W
%%% Cluster                     L
%%% Camera                      C
%%% Kinect                      K
%%% World coordinate frame      WCF
%%% Cluster* coordinate frame   L*CF
%%% Camera* coordinate frame    C*CF
%%% Kinect* coordinate frame    K*CF

% Note that cluster coordinate frame is aligned with the corresponding
% reference camera in that cluster. Therefore, the transformation from
% reference camera coordinate frame to cluster coordinate frame is
% identity.

%%%%%% CLUSTER 1 (L1)
% Extrinsic parameters, i.e., rotation (R) and translation (t), of the
% reference camera (i.e., C1) in L1 (values copied from RwTw_l01.txt)
L(1).R = reshape([0.895701051 0.002872461 -0.444647521 0.050160084 -0.994248986 0.094619878 -0.441818565 -0.107054681 -0.890693903],3,3)';
L(1).t = [-654.692443848 1101.511840820 3154.582519531]';
% Homogeneous transformation matrix T = [R t; 0 0 0 1] from WCF to L1CF
L(1).T = [L(1).R L(1).t; 0 0 0 1];
% Homogeneous transformation matrix Tinv = T^-1 = [R' -R't; 0 0 0 1] from
% L1CF to WCF
L(1).Tinv = [L(1).R' -L(1).R'*L(1).t; 0 0 0 1];

%%% Camera 1 (C1)
% Intrinsic parameters K (values copied from K in camcfg_l01.yml)
L(1).C(1).K = reshape([523.62481689, 0., 351.50247192, 0., 524.78002930, 225.29899597, 0., 0., 1.],3,3)';
% Distortion parameters d (values copied from Dist in camcfg_l01.yml)
L(1).C(1).d = [-0.30726913, 0.11957706, 7.77966125e-006, -1.81283604e-003]';
% Transformation with respect to the reference camera in the cluster, which
% is itself in this case (values copied from PosRel in camcfg_l01.yml)
L(1).C(1).Rt = [0., 0., 0., 0., 0., 0.]';
% Convert Rt into a homogeneous representation, i.e., T = [R t; 0 0 0 1],
% homogeneous transformation matrix from L1CF to C1CF
L(1).C(1).t = L(1).C(1).Rt(1:3);
L(1).C(1).R = rodrigues(L(1).C(1).Rt(4:6));
L(1).C(1).T = [L(1).C(1).R L(1).C(1).t; 0 0 0 1];
% Homogeneous transformation matrix from C1CF to L1CF
L(1).C(1).Tinv = [L(1).C(1).R' -L(1).C(1).R'*L(1).C(1).t; 0 0 0 1];

%%% Camera 2 (C2)
% Intrinsic parameters K (values copied from K in camcfg_l01.yml)
L(1).C(2).K = reshape([532.78863525, 0., 320.36187744, 0., 533.49108887, 231.61149597, 0., 0., 1.],3,3)';
% Distortion parameters d (values copied from Dist in camcfg_l01.yml)
L(1).C(2).d = [-0.30525380, 0.11849667, -2.24173709e-005, -1.13707327e-003]';
% Transformation with respect to the reference camera (C1) in the cluster,
% (values copied from PosRel in camcfg_l01.yml)
L(1).C(2).Rt = [-113.23552704, -3.12581921, 5.35904837, 0.02384871, 0.10327590, 0.03027969]';
% Convert Rt into a homogeneous representation, i.e., T = [R t; 0 0 0 1],
% homogeneous transformation matrix from L1CF to C2CF
L(1).C(2).t = L(1).C(2).Rt(1:3);
L(1).C(2).R = rodrigues(L(1).C(2).Rt(4:6));
L(1).C(2).T = [L(1).C(2).R L(1).C(2).t; 0 0 0 1];
% Homogeneous transformation matrix from C2CF to L1CF
L(1).C(2).Tinv = [L(1).C(2).R' -L(1).C(2).R'*L(1).C(2).t; 0 0 0 1];

%%% Camera 3 (C3)
% Intrinsic parameters K (values copied from K in camcfg_l01.yml)
L(1).C(3).K = reshape([535.76379395, 0., 351.78421021, 0., 536.48388672, 258.91003418, 0., 0., 1.],3,3)';
% Distortion parameters d (values copied from Dist in camcfg_l01.yml)
L(1).C(3).d = [-0.30206695, 0.10986967, 2.87068815e-005, -5.85383852e-004]';
% Transformation with respect to the reference camera (C1) in the cluster,
% (values copied from PosRel in camcfg_l01.yml)
L(1).C(3).Rt = [-225.57591248, -8.37060165, 10.44907475, 0.06187005, 0.10036616, 0.03608300]';
% Convert Rt into a homogeneous representation, i.e., T = [R t; 0 0 0 1],
% homogeneous transformation matrix from L1CF to C3CF
L(1).C(3).t = L(1).C(3).Rt(1:3);
L(1).C(3).R = rodrigues(L(1).C(3).Rt(4:6));
L(1).C(3).T = [L(1).C(3).R L(1).C(3).t; 0 0 0 1];
% Homogeneous transformation matrix from C3CF to L1CF
L(1).C(3).Tinv = [L(1).C(3).R' -L(1).C(3).R'*L(1).C(3).t; 0 0 0 1];

%%% Camera 4 (C4)
% Intrinsic parameters K (values copied from K in camcfg_l01.yml)
L(1).C(4).K = reshape([541.68511963, 0., 334.84011841, 0., 542.19091797, 229.06407166, 0., 0., 1.],3,3)';
% Distortion parameters d (values copied from Dist in camcfg_l01.yml)
L(1).C(4).d = [-0.30782333, 0.12185945, -6.21398794e-004, -6.72762864e-004]';
% Transformation with respect to the reference camera (C1) in the cluster,
% (values copied from PosRel in camcfg_l01.yml)
L(1).C(4).Rt = [-331.18945313, -5.80678654, 43.41628647, 0.01283832, 0.17892610, 0.01941607]';
% Convert Rt into a homogeneous representation, i.e., T = [R t; 0 0 0 1],
% homogeneous transformation matrix from L1CF to C4CF
L(1).C(4).t = L(1).C(4).Rt(1:3);
L(1).C(4).R = rodrigues(L(1).C(4).Rt(4:6));
L(1).C(4).T = [L(1).C(4).R L(1).C(4).t; 0 0 0 1];
% Homogeneous transformation matrix from C4CF to L1CF
L(1).C(4).Tinv = [L(1).C(4).R' -L(1).C(4).R'*L(1).C(4).t; 0 0 0 1];


%%%%%% CLUSTER 2 (L2)
L(2).R = reshape([-0.788662493 -0.041136641 0.613448620 -0.070219174 -0.985203922 -0.156341061 0.610803366 -0.166376188 0.774104774],3,3)';
L(2).t = [425.134826660 958.274047852 2533.748535156]';
L(2).T = [L(2).R L(2).t; 0 0 0 1];
L(2).Tinv = [L(2).R' -L(2).R'*L(2).t; 0 0 0 1];

%%% Camera 1 (C1)
L(2).C(1).K = reshape([536.22784424, 0., 330.95697021, 0., 537.43035889, 255.47770691, 0., 0., 1.],3,3)';
L(2).C(1).d = [-0.30754250, 0.12662455, 1.29046195e-004, -5.86564071e-004]';
L(2).C(1).Rt = [0., 0., 0., 0., 0., 0.]';
L(2).C(1).t = L(2).C(1).Rt(1:3);
L(2).C(1).R = rodrigues(L(2).C(1).Rt(4:6));
L(2).C(1).T = [L(2).C(1).R L(2).C(1).t; 0 0 0 1];
L(2).C(1).Tinv = [L(2).C(1).R' -L(2).C(1).R'*L(2).C(1).t; 0 0 0 1];

%%% Camera 2 (C2)
L(2).C(2).K = reshape([530.17150879, 0., 348.21569824, 0., 531.24768066, 221.58586121, 0., 0., 1.],3,3)';
L(2).C(2).d = [-0.31191686, 0.13442637, -1.74640474e-004, -1.52578956e-004]';
L(2).C(2).Rt = [-112.65316010, 1.45886219, 7.63488483, -0.05266878, 0.02991591, 0.01637690]';
L(2).C(2).t = L(2).C(2).Rt(1:3);
L(2).C(2).R = rodrigues(L(2).C(2).Rt(4:6));
L(2).C(2).T = [L(2).C(2).R L(2).C(2).t; 0 0 0 1];
L(2).C(2).Tinv = [L(2).C(2).R' -L(2).C(2).R'*L(2).C(2).t; 0 0 0 1];

%%% Camera 3 (C3)
L(2).C(3).K = reshape([546.88293457, 0., 322.02459717, 0., 548.02545166, 234.25865173, 0., 0., 1.],3,3)';
L(2).C(3).d = [-0.31121001, 0.13268919, -9.13340948e-004, 8.80855805e-005]';
L(2).C(3).Rt = [-225.22500610, 1.80177021, 25.86536598, -0.03129913, 0.10528020, 5.36032300e-003]';
L(2).C(3).t = L(2).C(3).Rt(1:3);
L(2).C(3).R = rodrigues(L(2).C(3).Rt(4:6));
L(2).C(3).T = [L(2).C(3).R L(2).C(3).t; 0 0 0 1];
L(2).C(3).Tinv = [L(2).C(3).R' -L(2).C(3).R'*L(2).C(3).t; 0 0 0 1];

%%% Camera 4 (C4)
L(2).C(4).K = reshape([545.57482910, 0., 323.34945679, 0., 546.70520020, 239.74145508, 0., 0., 1.],3,3)';
L(2).C(4).d = [-0.30886060, 0.12867413, -6.22767955e-004, -6.69802466e-005]';
L(2).C(4).Rt = [-334.29324341, -0.42288470, 47.23010635, -0.02231921, 0.13328844, 7.67685520e-003]';
L(2).C(4).t = L(2).C(4).Rt(1:3);
L(2).C(4).R = rodrigues(L(2).C(4).Rt(4:6));
L(2).C(4).T = [L(2).C(4).R L(2).C(4).t; 0 0 0 1];
L(2).C(4).Tinv = [L(2).C(4).R' -L(2).C(4).R'*L(2).C(4).t; 0 0 0 1];


%%%%%% CLUSTER 3 (L3)
L(3).R = reshape([-0.870248973 0.022778150 -0.492085218 0.040615544 -0.992211521 -0.117756799 -0.490934908 -0.122464038 0.862545907],3,3)';
L(3).t = [642.973693848 1091.080078125 2696.827392578]';
L(3).T = [L(3).R L(3).t; 0 0 0 1];
L(3).Tinv = [L(3).R' -L(3).R'*L(3).t; 0 0 0 1];

%%% Camera 1 (C1)
L(3).C(1).K = reshape([547.57348633, 0., 313.34936523, 0., 548.31109619, 241.95222473, 0., 0., 1.],3,3)';
L(3).C(1).d = [-0.30918822, 0.12642565, -6.04151399e-004, 3.46956745e-004]';
L(3).C(1).Rt = [0., 0., 0., 0., 0., 0.]';
L(3).C(1).t = L(3).C(1).Rt(1:3);
L(3).C(1).R = rodrigues(L(3).C(1).Rt(4:6));
L(3).C(1).T = [L(3).C(1).R L(3).C(1).t; 0 0 0 1];
L(3).C(1).Tinv = [L(3).C(1).R' -L(3).C(1).R'*L(3).C(1).t; 0 0 0 1];

%%% Camera 2 (C2)
L(3).C(2).K = reshape([536.85382080, 0., 339.61489868, 0., 537.53009033, 235.44552612, 0., 0., 1.],3,3)';
L(3).C(2).d = [-0.30596223, 0.12021901, -8.36337393e-004, 8.00849695e-004]';
L(3).C(2).Rt = [-152.58418274, -1.01097679, -7.04021549, -2.47665215e-003, 7.28918705e-003, -1.07275601e-003]';
L(3).C(2).t = L(3).C(2).Rt(1:3);
L(3).C(2).R = rodrigues(L(3).C(2).Rt(4:6));
L(3).C(2).T = [L(3).C(2).R L(3).C(2).t; 0 0 0 1];
L(3).C(2).Tinv = [L(3).C(2).R' -L(3).C(2).R'*L(3).C(2).t; 0 0 0 1];


%%%%%% CLUSTER 4 (L4)
L(4).R = reshape([0.708072186 0.018875621 0.705887735 -0.163710788 -0.968018532 0.190102473 0.686900675 -0.250167727 -0.682336807],3,3)';
L(4).t = [-424.038238525 897.219055176 2837.927246094]';
L(4).T = [L(4).R L(4).t; 0 0 0 1];
L(4).Tinv = [L(4).R' -L(4).R'*L(4).t; 0 0 0 1];

%%% Camera 1 (C1)
L(4).C(1).K = reshape([522.80261230, 0., 345.56921387, 0., 523.47979736, 241.90707397, 0., 0., 1.],3,3)';
L(4).C(1).d = [-0.30581141, 0.11963996, -1.08503085e-003, -1.31329332e-004]';
L(4).C(1).Rt = [0., 0., 0., 0., 0., 0.]';
L(4).C(1).t = L(4).C(1).Rt(1:3);
L(4).C(1).R = rodrigues(L(4).C(1).Rt(4:6));
L(4).C(1).T = [L(4).C(1).R L(4).C(1).t; 0 0 0 1];
L(4).C(1).Tinv = [L(4).C(1).R' -L(4).C(1).R'*L(4).C(1).t; 0 0 0 1];

%%% Camera 2 (C2)
L(4).C(2).K = reshape([531.64221191, 0., 329.00204468, 0., 532.30084229, 241.58192444, 0., 0., 1.],3,3)';
L(4).C(2).d = [-0.30320752, 0.11169375, -1.41603034e-003, -6.89732333e-005]';
L(4).C(2).Rt = [-151.09100342, -0.85118026, 9.14525700, 5.00013644e-004, 0.08078900, 2.56788498e-003]';
L(4).C(2).t = L(4).C(2).Rt(1:3);
L(4).C(2).R = rodrigues(L(4).C(2).Rt(4:6));
L(4).C(2).T = [L(4).C(2).R L(4).C(2).t; 0 0 0 1];
L(4).C(2).Tinv = [L(4).C(2).R' -L(4).C(2).R'*L(4).C(2).t; 0 0 0 1];


%%%%%% KINECT 1 (K1)
% Extrinsic parameters, i.e., rotation (R) and translation (t), of the
% Kinect camera (i.e., K1) (values copied from RwTw_k01.txt)
K(1).R = reshape([0.869593024 0.005134047 -0.493742496 0.083783410 -0.986979902 0.137298822 -0.486609042 -0.160761520 -0.858700991],3,3)';
K(1).t = [-844.523864746 763.838439941 3232.193359375]';
% Homogeneous transformation matrix T = [R t; 0 0 0 1] from WCF to K1CF
K(1).T = [K(1).R K(1).t; 0 0 0 1];
% Homogeneous transformation matrix Tinv = T^-1 = [R' -R't; 0 0 0 1] from
% K1CF to WCF
K(1).Tinv = [K(1).R' -K(1).R'*K(1).t; 0 0 0 1];

K(1).K = reshape([531.49230957, 0., 314.63775635, 0., 532.39190674, 252.53335571, 0., 0., 1.],3,3)';
K(1).d = [0.19607373, -0.36734107, -2.47962005e-003, -1.89774996e-003]';
K(1).Rt = [0., 0., 0., 0., 0., 0.]';
K(1).t = K(1).Rt(1:3);
K(1).R = rodrigues(K(1).Rt(4:6));


%%%%%% KINECT 2 (K2)
K(2).R = reshape([-0.798016667 -0.041981064 0.601171315 -0.059102636 -0.987309396 -0.147400886 0.599730134 -0.153159171 0.785408199],3,3)';
K(2).t = [26.147224426 853.124328613 2533.297607422]';
K(2).T = [K(2).R K(2).t; 0 0 0 1];
K(2).Tinv = [K(2).R' -K(2).R'*K(2).t; 0 0 0 1];

K(2).K = reshape([532.33691406, 0., 323.22338867, 0., 532.80218506, 265.27493286, 0., 0., 1.],3,3)';
K(2).d = [0.18276334, -0.35502717, -6.75550546e-004, -9.90863307e-004]';
K(2).Rt = [0., 0., 0., 0., 0., 0.]';
K(2).t = K(2).Rt(1:3);
K(2).R = rodrigues(K(2).Rt(4:6));


%%% Compute camera positions in the the world coordinate frame

% camera is located at the origin of the camera coordinate frame
z = [0 0 0 1]';

% Transform the camera position in the camera coordinate frame first into
% cluster coordinate frame and next into world coordinate frame
L(1).C(1).p = L(1).Tinv*L(1).C(1).Tinv*z;
L(1).C(2).p = L(1).Tinv*L(1).C(2).Tinv*z;
L(1).C(3).p = L(1).Tinv*L(1).C(3).Tinv*z;
L(1).C(4).p = L(1).Tinv*L(1).C(4).Tinv*z;

L(2).C(1).p = L(2).Tinv*L(2).C(1).Tinv*z;
L(2).C(2).p = L(2).Tinv*L(2).C(2).Tinv*z;
L(2).C(3).p = L(2).Tinv*L(2).C(3).Tinv*z;
L(2).C(4).p = L(2).Tinv*L(2).C(4).Tinv*z;

L(3).C(1).p = L(3).Tinv*L(3).C(1).Tinv*z;
L(3).C(2).p = L(3).Tinv*L(3).C(2).Tinv*z;

L(4).C(1).p = L(4).Tinv*L(4).C(1).Tinv*z;
L(4).C(2).p = L(4).Tinv*L(4).C(2).Tinv*z;

K(1).p = K(1).Tinv*z;
K(2).p = K(2).Tinv*z;