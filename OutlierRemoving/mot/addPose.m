function poseTracklet1 = addPose(poseTracklet1, person)

poseTracklet1.frame = [poseTracklet1.frame, person];
poseTracklet1.traj = [poseTracklet1.traj, cat(1,person.joint.xy)];
poseTracklet1.tEnd = poseTracklet1.tEnd + 1;
poseTracklet1.length = poseTracklet1.length + 1;

end