601,100
602,"System - Scheduler_Check Dependencies"
562,"NULL"
586,
585,
564,
565,"orSgjZ?GG<Aa;5BaDC^tb^iShvwetl4TPf]oeYi_s`GWoLuf:4t0@KYZkzldhD;DB7wE;vJ\^kbaaVj;rGEYv<B>xbzOzHyj^wNM9RM\H^A4P<7Y[Rsg<[Ivmn@raVb`cS1[^XXQNQjz]AXL4makZ7oVH`io_HbPBL_4\HPTLwl\ttcC\V7eZn79T]iL_H^3z9>=VJfc"
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
572,137

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Check Dependencies
# Purpose: Check to Ensure dependencies have been met and there are no circular dependencies
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
sToday = TimSt(Now, '\Y-\m-\d');
sDependsOn = CellGetS(sCube, pTask, 'Depends On');
sDependencyMode = CellGetS(sCube, pTask, 'Dependency Mode');
#EndRegion

IF(sDependencyMode @= '');
    sDependencyMode = 'SameDay';
ENDIF;

IF(Trim(sDependsOn) @= '');
    CellPutS('No Dependencies', sCube, pTask, 'Dependency Status');
    CellPutS('', sCube, pTask, 'Blocked By');
    ProcessBreak;
ENDIF;

ExecuteProcess('System - Scheduler_Check Circular Dependencies', 'pTask', pTask, 'pVisited', pTask);

sCircularCheck = CellGetS(sCube, pTask, 'Dependency Status');
IF(sCircularCheck @= 'Circular Dependency');
    ProcessBreak;
ENDIF;

sRemaining = sDependsOn;
bAllMet = 1;
bAnyFailed = 0;
sFirstBlocker = '';

WHILE(Long(sRemaining) > 0 & bAnyFailed = 0);
    nComma = Scan(',', sRemaining);
    IF(nComma > 0);
        sDepTask = Trim(SubSt(sRemaining, 1, nComma - 1));
        sRemaining = SubSt(sRemaining, nComma + 1, Long(sRemaining) - nComma);
    ELSE;
        sDepTask = Trim(sRemaining);
        sRemaining = '';
    ENDIF;
    
    IF(sDepTask @<> '');
        
        IF(DimIx(sDimJob, sDepTask) = 0);
            bAnyFailed = 1;
            sFirstBlocker = sDepTask | ' (not found)';
        ELSE;
            sDepActive = CellGetS(sCube, sDepTask, 'Active');
            
            IF(sDepActive @<> 'Y');
                # Inactive dependency - skip it
            ELSE;
                sDepLastRunDate = CellGetS(sCube, sDepTask, 'Last Run Date');
                sDepLastRunStatus = CellGetS(sCube, sDepTask, 'Last Run Status');
                sDepCurrentStatus = CellGetS(sCube, sDepTask, 'Current Status');
                
                IF(sDependencyMode @= 'SameDay');
                    IF(sDepLastRunDate @= sToday);
                        IF(Scan('Success', sDepLastRunStatus) > 0);
                            # Met
                        ELSEIF(Scan('Failed', sDepLastRunStatus) > 0);
                            bAnyFailed = 1;
                            sFirstBlocker = sDepTask | ' (failed today)';
                        ELSEIF(Scan('Running', sDepCurrentStatus) > 0);
                            bAllMet = 0;
                            IF(sFirstBlocker @= '');
                                sFirstBlocker = sDepTask | ' (running)';
                            ENDIF;
                        ELSE;
                            bAllMet = 0;
                            IF(sFirstBlocker @= '');
                                sFirstBlocker = sDepTask | ' (not yet run)';
                            ENDIF;
                        ENDIF;
                    ELSE;
                        bAllMet = 0;
                        IF(sFirstBlocker @= '');
                            sFirstBlocker = sDepTask | ' (not yet run today)';
                        ENDIF;
                    ENDIF;
                    
                ELSEIF(sDependencyMode @= 'LastRun');
                    IF(Scan('Success', sDepLastRunStatus) > 0);
                        # Met
                    ELSEIF(Scan('Failed', sDepLastRunStatus) > 0);
                        bAnyFailed = 1;
                        sFirstBlocker = sDepTask | ' (last run failed)';
                    ELSEIF(Scan('Running', sDepCurrentStatus) > 0);
                        bAllMet = 0;
                        IF(sFirstBlocker @= '');
                            sFirstBlocker = sDepTask | ' (running)';
                        ENDIF;
                    ELSE;
                        bAllMet = 0;
                        IF(sFirstBlocker @= '');
                            sFirstBlocker = sDepTask | ' (never run)';
                        ENDIF;
                    ENDIF;
                    
                ELSEIF(sDependencyMode @= 'SameCycle');
                    IF(sDepLastRunDate @= sToday & Scan('Success', sDepLastRunStatus) > 0);
                        # Met
                    ELSEIF(Scan('Failed', sDepLastRunStatus) > 0);
                        bAnyFailed = 1;
                        sFirstBlocker = sDepTask | ' (failed)';
                    ELSE;
                        bAllMet = 0;
                        IF(sFirstBlocker @= '');
                            sFirstBlocker = sDepTask | ' (waiting)';
                        ENDIF;
                    ENDIF;
                    
                ENDIF;
            ENDIF;
        ENDIF;
    ENDIF;
END;

IF(bAnyFailed = 1);
    CellPutS('Blocked', sCube, pTask, 'Dependency Status');
    CellPutS(sFirstBlocker, sCube, pTask, 'Blocked By');
ELSEIF(bAllMet = 1);
    CellPutS('Met', sCube, pTask, 'Dependency Status');
    CellPutS('', sCube, pTask, 'Blocked By');
ELSE;
    CellPutS('Waiting', sCube, pTask, 'Dependency Status');
    CellPutS(sFirstBlocker, sCube, pTask, 'Blocked By');
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
