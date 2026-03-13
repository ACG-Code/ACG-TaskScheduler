601,100
602,"System - Scheduler_Calutate Next Run"
562,"NULL"
586,
585,
564,
565,"jYxo:?Rpaja=R9C>qN3IAtamwc7\WGTGAK7R_wwP@Up746tvtIp<<P?Sn0[HcRq64WX1ADSJQfV>0f?8HZy=uCe_bvK>=4\<1]U\<3q\HdSTU13PobsVPFP4zNiYI8IfP92HeUiA0?b79r9@3A9khtxnU7PtZ[Vo4pk<PVAJ5_Yw6Gc60aM[GxT[Sfxkd;Q0bD8W7WQ0"
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
572,165

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Calutate Next Run
# Purpose: Calculate Next Run Date/Time based on Task
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

sScheduleType = CellGetS(sCube, pTask, 'Schedule Type');
sDaysOfWeek = CellGetS(sCube, pTask, 'Days Of Week');
sDaysOfMonth = CellGetS(sCube, pTask, 'Days Of Month');
sSpecificDates = CellGetS(sCube, pTask, 'Specific Dates');
sLastRunDate = CellGetS(sCube, pTask, 'Last Run Date');

nNextRunDate = 0;
#EndRegion

IF(pTask @= 'Weekly Metadata Refresh|Get Metadata files');
    c = 5;
ENDIF;

#Region --------------- Daily Schedule ---------------
IF(sScheduleType @= 'Daily');
    IF(sLastRunDate @= sToday);
        nNextRunDate = nToday + 1 + nDateOffset;
    ELSE;
        nNextRunDate = nTodayFormatted;
    ENDIF;
ENDIF;
#EndRegion

#Region --------------- Weekly Schedule ---------------

IF(sScheduleType @= 'Weekly');
    nDaysChecked = 0;
    bFound = 0;
    
    IF(sLastRunDate @= sToday);
        nDaysChecked = 1;
    ENDIF;
    
    WHILE(nDaysChecked < 14 & bFound = 0);
        nCheckDay = nToday + nDaysChecked;
        
        # Calculate day of week: 1=Mon, 2=Tue... 7=Sun
        nModResult = Mod(nCheckDay, 7);
        nDOW = Mod(nModResult + 4, 7) + 1;
        
        sDOWStr = NumberToString(nDOW);
        
        # Remove decimal if present
        nDot = Scan('.', sDOWStr);
        IF(nDot > 0);
            sDOWStr = SubSt(sDOWStr, 1, nDot - 1);
        ENDIF;
        
        IF(Scan(sDOWStr, sDaysOfWeek) > 0);
            nNextRunDate = nCheckDay + nDateOffset;
            bFound = 1;
        ENDIF;
        
        nDaysChecked = nDaysChecked + 1;
    END;
ENDIF;
#EndRegion

#Region --------------- Monthly Schedule ---------------
IF(sScheduleType @= 'Monthly');
    nDaysChecked = 0;
    bFound = 0;
    
    IF(sLastRunDate @= sToday);
        nDaysChecked = 1;
    ENDIF;
    
    WHILE(nDaysChecked < 62 & bFound = 0);
        nCheckDay = nToday + nDaysChecked;
        
        sDayOfMonthStr = TimSt(nCheckDay, '\d');
        
        IF(SubSt(sDayOfMonthStr, 1, 1) @= '0');
            sDayOfMonthStr = SubSt(sDayOfMonthStr, 2, 1);
        ENDIF;
        
        sTempDays = ',' | sDaysOfMonth | ',';
        sSearchDay = ',' | sDayOfMonthStr | ',';
        
        IF(Scan(sSearchDay, sTempDays) > 0);
            nNextRunDate = nCheckDay + nDateOffset;
            bFound = 1;
        ENDIF;
        
        nDaysChecked = nDaysChecked + 1;
    END;
ENDIF;
#EndRegion

#Region --------------- Specific Dates Schedule ---------------
IF(sScheduleType @= 'Specific');
    sRemaining = sSpecificDates;
    sEarliestDate = '';
    
    WHILE(Long(sRemaining) > 0);
        nComma = Scan(',', sRemaining);
        IF(nComma > 0);
            sCheckDate = Trim(SubSt(sRemaining, 1, nComma - 1));
            sRemaining = SubSt(sRemaining, nComma + 1, Long(sRemaining) - nComma);
        ELSE;
            sCheckDate = Trim(sRemaining);
            sRemaining = '';
        ENDIF;
        
        IF(Long(sCheckDate) = 10);
            IF(sCheckDate @= sToday);
                IF(sLastRunDate @<> sToday);
                    IF(sEarliestDate @= '' % sCheckDate @< sEarliestDate);
                        sEarliestDate = sCheckDate;
                    ENDIF;
                ENDIF;
            ELSEIF(sCheckDate @> sToday);
                IF(sEarliestDate @= '' % sCheckDate @< sEarliestDate);
                    sEarliestDate = sCheckDate;
                ENDIF;
            ENDIF;
        ENDIF;
    END;
    
    IF(sEarliestDate @<> '');
        IF(sEarliestDate @= sToday);
            nNextRunDate = nTodayFormatted;
        ELSE;
            nDaysDiff = 0;
            sTempDate = sToday;
            WHILE(sTempDate @< sEarliestDate & nDaysDiff < 400);
                nDaysDiff = nDaysDiff + 1;
                nTempDayNo = nToday + nDaysDiff;
                sTempDate = TimSt(nTempDayNo, '\Y-\m-\d');
            END;
            nNextRunDate = nTodayFormatted + nDaysDiff;
        ENDIF;
    ENDIF;
ENDIF;

#EndRegion

#Region --------------- Set Next Run Date And Status ---------------
IF(nNextRunDate > 0);
    CellPutN(nNextRunDate, sCube, pTask, 'Next Run Date');
    CellPutS('⏳ Pending', sCube, pTask, 'Current Status');
ELSE;
    CellPutN(0, sCube, pTask, 'Next Run Date');
    CellPutS('🚫 No Future Dates', sCube, pTask, 'Current Status');
ENDIF;
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
