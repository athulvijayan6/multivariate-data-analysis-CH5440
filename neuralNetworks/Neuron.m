% @Author: Athul Vijayan
% @Date:   2014-05-07 14:23:48
% @Last Modified by:   Athul Vijayan
% @Last Modified time: 2014-05-08 00:24:21

classdef Neuron < handle
    % Class defines the class for a neuron in a Artificial Neural Network
    % Instances of this class can be used to create Input, Hiddden or output neurons
    % Documentation for variables and methods in the class follows
    properties(Hidden)
	    initEpsilon = 50;
	end

    properties(SetAccess = private)
	    objFun = 'Sigmoid';
	    layer = 'Input';
	    inputCount = 0;
	    theta
    end

    properties
	    input;
    end

    methods
	    %% Neuron: Initiates a neuron by taking in the inputs.
	    % Number of inputs is the size of matrix input
	    function neuron = Neuron(Input, Layer, objFun)
	    	neuron.inputCount = size(Input, 1);
	    	neuron.layer = Layer;
	    	if nargin > 2
	    		neuron.objFun = objFun;
	    	end
	    	neuron.input = Input;
	    	% Initiating theta to zeroes is pointless since no learning will occur. So we initialize to random
		    % initially theta will be initialized to numbers ranging from (-initEpsilon , initEpsilon).
	    	neuron.theta= rand(neuron.inputCount,1)*(2*neuron.initEpsilon) - neuron.initEpsilon;
	    end

	    %% setInput: change input vector
	    function [] = setInput(neuron, Input)
	    	neuron.input = Input;
	    end

	    %% setWeights: change weights
	    function [] = setWeights(neuron, theta)
	    	neuron.theta = theta;
	    end 

	    %% getWeights: function description
	    function [output] = getWeights(neuron)
	    	output = neuron.theta;
	    	return
	    end
	    

	    %% output: Finds the objective function with current value of theta and input
	    function output = output(neuron)
	    	output = 1./(1 + exp(-neuron.theta'*neuron.input));
	    	return;
    	end 
    end
end

