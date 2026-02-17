601,100
602,"System - Scheduler_Skip Dependencies"
562,"NULL"
586,
585,
564,
565,"ePERPa6u4e>ilbNtC^nw:Dz:t2Wbr\H@5nQ_5NH@m5F67LNC@mhSuq];LbYs^MmJ7uM:o:H5z[8P?ceRihBERQ;LQ0nDTA26xZsA]wl6wz;fO78=0skgSQ]Lhq7eo@^jVlB_A2mTnN8Gmb5V9iLX8fe<ojKo>`RO@=i]o_o<IMFV[2qEcgvP=tiUjKu2V0\uX2Ngb^::"
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
560,1
pTask
561,1
2
590,1
pTask,""
637,1
pTask,""
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,34

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Skip Dependencies
# Purpose: Manual Process.  Call when:
#     A task is stuck in Waiting status
#     A task is blocked but need to be run anyway
#     You want to bypass the dependencies for a one-time execution
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
#EndRegion

IF(pTask @= '');
    ProcessError;
ENDIF;

IF(DimIx(sDimJob, pTask) = 0);
    ProcessError;
ENDIF;

CellPutS('Y', sCube, pTask, 'Skip Dependencies');

sCurrentStatus = CellGetS(sCube, pTask, 'CurrentStatus');
IF(Scan('Blocked', sCurrentStatus) > 0 % Scan('Waiting', sCurrentStatus) > 0);
    CellPutS('⏳ Pending', sCube, pTask, 'Current Status');
ENDIF;
 

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
