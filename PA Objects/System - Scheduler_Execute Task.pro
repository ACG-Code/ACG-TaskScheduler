601,100
602,"System - Scheduler_Execute Task"
562,"NULL"
586,
585,
564,
565,"tMCF@?r]Ks3NqwKGsaymajUf938j6<NAo`_pSGcSFSx<[]Y`ICbQZbex1PuqjQ]9DDq_Yec2eL]TGPIbVZ85HvmWUHAGY[s`kV3VB09V:w=r;@H6GqW?9Hr_Z]<oU4bZ6o]V;Hj9vVRz:3ScXs\H4CKpC@?X6hyfF554v>fScFCJZr0Qed9gX6>c`HkSmshHAru:<jVG"
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
572,53

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Execute Task
# Purpose: Execute task once pre-flight checks are complete
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
sToday = TimSt(Now, '\Y-\m-\d');
sCurrentTime = TimSt(Now, '\h:\i:\s');
sProcessName = AttrS(sDimJob, pTask, 'ProcessName');
#EndRegion

#Region --------------- Validate Process ---------------
IF(sProcessName @= '');
    CellPutS('❌ Failed', sCube, pTask, 'Last Run Status');
    CellPutS('❌ Failed', sCube, pTask, 'Current Status');
    CellPutS(sToday, sCube, pTask, 'Last Run Date');
    CellPutS(sCurrentTime, sCube, pTask, 'Last Run Time');
    CellPutS('No ProcessName defined in attribute', sCube, pTask, 'Last Run Message');
    CellPutS('N', sCube, pTask, 'Execute Now');
    ExecuteProcess('System - Scheduler_Calculate Next Run', 'pTask', pTask);
    ProcessBreak;
ENDIF;

IF(ProcessExists(sProcessName) = 0);
    CellPutS('❌ Failed', sCube, pTask, 'Last Run Status');
    CellPutS('❌ Failed', sCube, pTask, 'Current`Status');
    CellPutS(sToday, sCube, pTask, 'Last Run Date');
    CellPutS(sCurrentTime, sCube, pTask, 'Last Run Time');
    CellPutS('Process does not exist: ' | sProcessName, sCube, pTask, 'Last Run Message');
    CellPutS('N', sCube, pTask, 'Execute Now');
    ExecuteProcess('System - Scheduler_Calculate Next Run', 'pTask', pTask);
    ProcessBreak;
ENDIF;
#EndRegion

#Region --------------- Set Pre-Execution Status ---------------
CellPutS('🔄 Running', sCube, pTask, 'Current Status');
CellPutS(sToday, sCube, pTask, 'Last Run Date');
CellPutS(sCurrentTime, sCube, pTask, 'Last Run Time');
CellPutS('', sCube, pTask, 'Last Run Message');
CellPutS('N', sCube, pTask, 'Execute Now');
#EndRegion

#Region --------------- Execute Target Process ---------------
nResult = ExecuteProcess(sProcessName);
#EndRegion
573,1

574,1

575,17

#Region --------------- Set Post-Execution Status  ---------------
sCube = 'System - Job Scheduler';

IF(nResult = ProcessExitNormal);
    CellPutS('✅ Success', sCube, pTask, 'Last Run Status');
    CellPutS('', sCube, pTask, 'Last Run Message');
ELSE;
    CellPutS('❌ Failed', sCube, pTask, 'Last Run Status');
    CellPutS('Process returned error code: ' | NumberToString(nResult), sCube, pTask, 'Last Run Message');
ENDIF;

# Always set CurrentStatus here - don't rely on CalculateNextRun
CellPutS('⏳ Pending', sCube, pTask, 'Current Status');

ExecuteProcess('System - Scheduler_Calculate Next Run', 'pTask', pTask );
#EndRegion
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
