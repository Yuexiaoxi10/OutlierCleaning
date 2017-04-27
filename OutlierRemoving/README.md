# OutlierCleaning----Designed a Framework

This code is for a designed framework which combines JBLD distance with Data Intepretation.
This is joint-wise, cleaning outliers for each joint over total length of sequence

To run the whole UYDP data set, run Main.m

To visualize the results, run Visualize.m

Main.m:
     1. UYDP dataset: 20 videos in total, 100 frames for each
     2. VideoPrediction_UYDP: 1)Input data from pose estimator 
                              2)1x2000 cell, 20x100
                              
     3. label: Ground truth
     4. You can play with your own data, the data size input for "step 3" is a 1xnp cell, where np is number of joints;
        In each cell, 2x100 vector 
     5. Please note the order of joints of a pose in the step of evaluating APK results: 
        Since the order from detection and the order from ground truth are different, we did a process to match them together; you need
        to do your own match accordingly; 



