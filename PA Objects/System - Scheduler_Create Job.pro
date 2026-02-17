601,100
602,"System - Scheduler_Create Job"
562,"NULL"
586,
585,
564,
565,"u<_d`XNFpXpOyVVehpSN6aqGDt:K7nkt[xUaT_^@>^zk]V>Hi:ui2L9VudC1YUrkXj;;EdqqzXs@yLkf52TB5@[bfyaY_4wCiO<rwdl\a:OZyJ:WdJ[]djs^_qX6J_RpZi9nbA`PPS6meh;7?<GQm_Sujg<;R_`egoz?y[L=rx>PJ`MHT;R4TcBQ5W@q1YAK3z0MiI36"
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
pJobName
561,1
2
590,1
pJobName,""
637,1
pJobName,"Enter new job name"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,28

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Create Job
# Purpose: Create new job
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Error Handling ---------------
nError = 0;

IF(pJobName @= '');
    nError = 1;
    LogOutput( 'FATAL', 'pJobName not supplied');
ELSEIF(DimensionElementExists('System - Scheduled Jobs', pJobName) > 0);
    nError = 1;
    LogOutput( 'FATAL', 'pJobName: "' | pJobName | '" already existrs');
ENDIF;

IF(nError = 1);
    ProcessError;
ENDIF;
#EndRegion

DimensionElementInsertDirect('System - Scheduled Jobs', '', pJobName, 'C');

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
