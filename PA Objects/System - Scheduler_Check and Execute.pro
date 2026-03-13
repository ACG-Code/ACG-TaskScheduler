601,100
602,"System - Scheduler_Check and Execute"
562,"NULL"
586,
585,
564,
565,"dtLJaspcmbUSn=rq7p2G[6=LGHRqg[unz\IVRc@yFf8xfxNZ@c^KF_YqT?]jB<ZwcS1DW=^NFF\3:uJHWPem?@7wte5pwV?8KVCVP]K^0?6_Bf52=2Z>lg?kmMCx3n_D?tdB4jlMHZI=mI1jUCoLPc9qp[@CtYwOcf`AOMytV4DL;^kA>lN8Od3\SIy=TASDTyX=gRy\"
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
572,110

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Check and Execute
# Purpose: Main Task of Scheduler.  Called by Chore
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
nDateOffset = 21916;
sToday = TimSt(Now, '\Y-\m-\d');
nToday = DayNo(Today);
nTodayFormatted = nToday + nDateOffset;
sCurrentTime = TimSt(Now, '\h:\i');
sCurrentTimestamp = TimSt(Now, '\Y-\m-\d \h:\i:\s');
nJobCount = DimSiz(sDimJob);
#EndRegion

#Region --------------- Loop through Jobs/Tasks and Execute ---------------
nLoop_Outer = 1;
WHILE(nLoop_Outer <= nJobCount);
    sElement = DimNm(sDimJob, nLoop_Outer);
    sElementType = AttrS(sDimJob, sElement, 'ElementType');
    
    IF(sElementType @= 'Job');
        
        sJobActive = CellGetS(sCube, sElement, 'Active');
        
        IF(sJobActive @= 'Y');
            nChildCount = ElCompN(sDimJob, sElement);
            
            nLoop_Inner = 1;
            WHILE(nLoop_Inner <= nChildCount);
                sTask = ElComp(sDimJob, sElement, nLoop_Inner);
                sTaskActive = CellGetS(sCube, sTask, 'Active');
                
                IF(sTaskActive @= 'Y');
                    ExecuteProcess('System - Scheduler_Check Dependencies', 'pTask', sTask);
                ENDIF;
                
                nLoop_Inner = nLoop_Inner + 1;
            END;
            
            nLoop_Inner = 1;
            WHILE(nLoop_Inner <= nChildCount);
                sTask = ElComp(sDimJob, sElement, nLoop_Inner);
                sTaskActive = CellGetS(sCube, sTask, 'Active');
                
                IF(sTaskActive @= 'Y');
                    sRunTime = CellGetS(sCube, sTask, 'Run Time');
                    nNextRunDate = CellGetN(sCube, sTask, 'Next Run Date');
                    sCurrentStatus = CellGetS(sCube, sTask, 'Current Status');
                    sExecuteNow = CellGetS(sCube, sTask, 'Execute Now');
                    sDependencyStatus = CellGetS(sCube, sTask, 'Dependency Status');
                    sSkipDependencies = CellGetS(sCube, sTask, 'Skip Dependencies');
                    
                    bShouldRun = 0;
                    bTimeToRun = 0;
                    
                    IF(sExecuteNow @= 'Y');
                        bTimeToRun = 1;
                    ELSE;
                        IF(nNextRunDate = nTodayFormatted);
                            IF(sCurrentTime @>= sRunTime);
                                sLastRunDate = CellGetS(sCube, sTask, 'LastRunDate');
                                IF(sLastRunDate @<> sToday);
                                    bTimeToRun = 1;
                                ELSEIF(Scan('Pending', sCurrentStatus) > 0 % Scan('Waiting', sCurrentStatus) > 0);
                                    bTimeToRun = 1;
                                ENDIF;
                            ENDIF;
                        ENDIF;
                    ENDIF;
                    
                    IF(bTimeToRun = 1);
                        IF(sSkipDependencies @= 'Y');
                            bShouldRun = 1;
                            CellPutS('N', sCube, sTask, 'Skip Dependencies');
                        ELSEIF(sDependencyStatus @= 'Met' % sDependencyStatus @= 'No Dependencies');
                            bShouldRun = 1;
                        ELSEIF(sDependencyStatus @= 'Waiting');
                            CellPutS('⏸ Waiting', sCube, sTask, 'Current Status');
                            IF(CellGetS(sCube, sTask, 'Waiting Since') @= '');
                                CellPutS(sCurrentTimestamp, sCube, sTask, 'Waiting Since');
                            ENDIF;
                        ELSEIF(sDependencyStatus @= 'Blocked');
                            CellPutS('🚫 Blocked', sCube, sTask, 'Current Status');
                        ENDIF;
                    ENDIF;
                    
                    IF(bShouldRun = 1);
                        CellPutS('', sCube, sTask, 'Waiting Since');
                        CellPutS('', sCube, sTask, 'Blocked By');
                        ExecuteProcess('System - Scheduler_Execute Task', 'pTask', sTask);
                    ENDIF;
                    
                ENDIF;
                
                nLoop_Inner = nLoop_Inner + 1;
            END;
        ENDIF;
    ENDIF;
    
    nLoop_Outer = nLoop_Outer + 1;
END;
#EndRegion
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
