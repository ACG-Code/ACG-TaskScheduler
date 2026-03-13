601,100
602,"System - Scheduler_Initialize Schedule"
562,"NULL"
586,
585,
564,
565,"uiWsuxX0>M;FCT@Sh<=t]asDQg8c<vQLYJ0oGUQIl68l33o\Gw@x`obUQgFEh00;gFjWBzM=Qy9pCymYH:L4FwvRe3Qo>?wmyI;]gR<0LiOZ^H5rk\ln0wTVkaF\7v]INMB0R@YEVPXNv?0Ruabzt4\Ja9wrvHOheu@y5=k@B9^L3sWA_i?3lr[k8eS;x14iG4lwmcLu"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,","
568,""""
570,
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,39

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Initialize Schedule
# Purpose: Initialize Schedule after:
#     Initial Setup
#     Changing Schedule Type
#     Changing Run Time
#     Changing Days of Week
#     Changing Days of Month
#     Changing Specific Dates
#     After adding tasks manually (not with "System - Scheduler_Create Task)
#     After Clearing Next Run Date
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
nCount = DimSiz(sDimJob);
#EndRegion

nLoop = 1;
WHILE(nLoop <= nCount);
    sElement = DimNm(sDimJob, nLoop);
    sElementType = AttrS(sDimJob, sElement, 'ElementType');
    
    IF(sElementType @= 'Task');
        sActive = CellGetS(sCube, sElement, 'Active');
        IF(sActive @= 'Y');
            ExecuteProcess('System - Scheduler_Calculate Next Run', 'pTask', sElement);
        ENDIF;
    ENDIF;
    
    nLoop = nLoop + 1;
END;
 
573,1

574,1

575,1

576,
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
