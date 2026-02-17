601,100
602,"System - Scheduler_Reset Blocked Tasks"
562,"NULL"
586,
585,
564,
565,"ySol[s3K6F;cdy=\X2lEz^beBa>TEPxeboA[=yILJeR>gSmxb?zx\4sQc_0HcuZVbcKhR;ktaGB1`S?ChFVJsD64Hoym]`^<WQq>?`GxY?ENK0tWDT075Z2ov=5AsI7]=sRz4nYIbJIqT<yUMJd5F><Wq]k3nGF3>t4T4xCL^lYm\`V]GA6y_B1hbj592SQ<<7>Ck?fe"
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
572,52

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Reset Blocked Tasks
# Purpose: Manual Process.  Use when:
#     A task shows failed and you've fixed the underlying issue
#     A taks shows blocked and you've fixed the dependency
#     A task is stuck in the Running status
#     You want to clear error messages and try again
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
 sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
#EndRegion

IF(pTask @<> '');
    IF(DimIx(sDimJob, pTask) > 0);
        sCurrentStatus = CellGetS(sCube, pTask, 'Current Status');
        sLastRunStatus = CellGetS(sCube, pTask, 'Last Run Status');
        IF(Scan('Blocked', sCurrentStatus) > 0 % Scan('Failed', sLastRunStatus) > 0);
            CellPutS('⏳ Pending', sCube, pTask, 'Current Status');
            CellPutS('', sCube, pTask, 'Dependency Status');
            CellPutS('', sCube, pTask, 'Blocked By');
            CellPutS('', sCube, pTask, 'Waiting Since');
            CellPutS('', sCube, pTask, 'Last Run Message');
        ENDIF;
    ENDIF;
ELSE;
    nCount = DimSiz(sDimJob);
    nLoop = 1;
    WHILE(nLoop <= nCount);
        sElement = DimNm(sDimJob, nLoop);
        sElementType = AttrS(sDimJob, sElement, 'ElementType');
        
        IF(sElementType @= 'Task');
            sCurrentStatus = CellGetS(sCube, sElement, 'Current Status');
            IF(Scan('Blocked', sCurrentStatus) > 0);
                CellPutS('⏳ Pending', sCube, sElement, 'Current Status');
                CellPutS('', sCube, sElement, 'Dependency Status');
                CellPutS('', sCube, sElement, 'Blocked By');
                CellPutS('', sCube, sElement, 'Waiting Since');
            ENDIF;
        ENDIF;
        
        nLoop = nLoop + 1;
    END;
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
