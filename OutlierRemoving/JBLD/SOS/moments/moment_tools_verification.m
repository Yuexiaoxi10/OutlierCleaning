% AUTHOR: Jose Lopez NEU 2014
% LICENSE:This code is licensed under the BSD License.
%
% This script runs the examples I've coded to check if the answers are what
% we expect them to be. This is the closest thing I have to verification
% testing. It is meant to be run in the debugger, manually...
%
clear;clc;
close all;
addpath('./examples/');

%%
example_1 %-0.492635

%%
example_1_dual %-0.492635

%%
example_1_yalmip %-0.49263

%%
example_2 %-11.4581

%%
example_2_dual %-11.4581

%%
example_3 %-0.037037

%%
example_3_dual

%%
example_5 %8

%%
example_2_2 %-213.492

%%
example_2_6 %-39

%%
example_2_9 %0.375

%%
example_3_3 %-310

%%
example_3_4 %-4

%%
example_4_6 %-5.50801

%%
example_4_7 %-16.7389

%%
zero_one_knapsack %8.6626

%%
zero_one_knapsack_large %25.4513
