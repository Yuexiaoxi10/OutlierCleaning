function poseTrack = linearRegressionPropagate(poseTrack, omega)

hor = 10;
nc = 5;
np = size(poseTrack, 1) / 2;
nFrame = size(poseTrack, 2);
for i = 1:nFrame
    if omega(i) == 1
        continue;
    end
    X = poseTrack(:, i-hor:i-1);
    prediction = zeros(2*np, 1);
    for j = 1:np
        xy = X(2*(j-1)+1:2*j, :);
        nr = 2 * (hor-nc+1);
        H = blockHankel(xy, [nr, nc]);
        a = H(:,1:end-1) \ H(:,end);
        prediction(2*(j-1)+1:2*j) = H(end-1:end, 2:end) * a;
    end
    poseTrack(:, i) = prediction;
end

end