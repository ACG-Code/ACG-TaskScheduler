601,100
602,"System - Scheduler_Check Circular Dependencies"
562,"NULL"
586,
585,
564,
565,"w^\H4\\afl:\v?[vtH0x]uqaK1d15a7]iVXGvnGxYf7T[>PidKCo0R?2ZirOkshNN[z<Bm^6z<J:WRi5T3Z6dIH4SPPn?yp2kY;`kJCtOJY1b5n4`IvJOE`4=Segm=vykIe9v<zg7O_U7NPEeHbpuE08LP;\ALv]k<Flrk7HN0wJ`bQdI]LScO1wfAg@=nDbWgSJdzYE"
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
560,2
pTask
pVisited
561,2
2
2
590,2
pTask,""
pVisited,""
637,2
pTask,""
pVisited,""
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,56

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Check Circular Dependencies
# Purpose: Check for Circular Dependencies
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
sDependsOn = CellGetS(sCube, pTask, 'Depends On');
#EndRegion

IF(Trim(sDependsOn) @= '');
    ProcessBreak;
ENDIF;

sRemaining = sDependsOn;

WHILE(Long(sRemaining) > 0);
    nComma = Scan(',', sRemaining);
    IF(nComma > 0);
        sDepTask = Trim(SubSt(sRemaining, 1, nComma - 1));
        sRemaining = SubSt(sRemaining, nComma + 1, Long(sRemaining) - nComma);
    ELSE;
        sDepTask = Trim(sRemaining);
        sRemaining = '';
    ENDIF;
    
    IF(sDepTask @<> '');
        sVisitedCheck = ',' | pVisited | ',';
        sDepCheck = ',' | sDepTask | ',';
        
        IF(Scan(sDepCheck, sVisitedCheck) > 0);
            nFirstComma = Scan(',', pVisited);
            IF(nFirstComma > 0);
                sOriginalTask = SubSt(pVisited, 1, nFirstComma - 1);
            ELSE;
                sOriginalTask = pVisited;
            ENDIF;
            
            CellPutS('Circular Dependency', sCube, sOriginalTask, 'Dependency Status');
            CellPutS('Cycle: ' | pVisited | ' -> ' | sDepTask, sCube, sOriginalTask, 'Blocked By');
            ProcessBreak;
        ENDIF;
        
        IF(DimIx(sDimJob, sDepTask) > 0);
            sNewVisited = pVisited | ',' | sDepTask;
            ExecuteProcess('System - Scheduler_Check Circular Dependencies', 'pTask', sDepTask, 'pVisited', sNewVisited);
        ENDIF;
    ENDIF;
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
