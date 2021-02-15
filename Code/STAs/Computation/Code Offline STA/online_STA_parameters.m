classdef online_STA_parameters < handle
    %ONLINE_STA_PARAMETERS contains the parameters that are used in
    %functions for the analysis. IS is the only variable of this class in
    %the program, and only IS has to be passed as an argument to functions.
    
    properties
        savename
        
        UDPcompressed
        SkipRep
        MEAconnected
        
        Nb_seq
        length_constant_part
        length_variable_part
        
        NCheckerboard1
        NCheckerboard2
        MaxLat
        Nlatency
        StimFilePath %BitFilename
        Latencies
        
        dispReceivedPacketsContent
        dispDataToSend
        dispnTreatedStim
        dispStepContent
        
        test_value
        SendSpkUDP
        getStimFromFile
        SendStimUDP
        
        stimulus_organization
    end
    
    methods
        function obj = online_STA_parameters ()    
            obj.savename = 'test';
            
            obj.UDPcompressed=0;
            obj.SkipRep=1;
            obj.MEAconnected=0; 
            
            obj.Nb_seq=30*20;
            obj.NCheckerboard1=20;
            obj.NCheckerboard2=20;
            obj.MaxLat = 20000;
            obj.Nlatency=21;
            
            obj.dispReceivedPacketsContent=1; 
            obj.dispDataToSend=1;
            obj.dispnTreatedStim=0;
            obj.dispStepContent =0;
            
            obj.test_value=0;
            obj.SendSpkUDP = 0;
            obj.SendStimUDP=0;
            obj.getStimFromFile=0;
            
            obj.length_constant_part = 0;
            obj.length_variable_part = 0;
            
            
            obj.Latencies=(-obj.Nlatency+1):0;
            
        end
    end
    
end

