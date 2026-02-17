601,100
602,"System - Scheduler_Calutate Next Run"
562,"NULL"
586,
585,
564,
565,"lwE63Ym>RwJwatXD5XQ1DWF:1X97UFw_f0MdnIaA`2ow8VpRPUccKXzd0my7^=9kkMBe0UgK5DvnwgpC>Sgn\tT6E=n^PI`EfDf\d6fesl7iA?8^V[@59pbwBg<q^4<AipCikkPq]P;xlYx6y>GQocooIzza[yG_2eJLvoW>_@gjt;RFugloMyqIElmDjM57[LKar^cH"
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
572,170

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

#Region --------------- Daily Schedule ---------------
IF(sScheduleType @= 'Daily');
    IF(sLastRunDate @= sToday);
        nNextDay = nToday + 1;
        nNextRunDate = nNextDay + nDateOffset;
    ELSE;
        nNextRunDate = nTodayFormatted;
    ENDIF;
ENDIF;
#EndRegion

#Region --------------- Weekly Schedule ---------------
IF(sScheduleType @= 'Weekly');
    nDaysChecked = 0;
    bFound = 0;
    
    WHILE(nDaysChecked < 8 & bFound = 0);
        nCheckDay = nToday + nDaysChecked;
        dCheckDate = nCheckDay;
        sCheckDateStr = TimSt(dCheckDate, '\Y-\m-\d');
        
        nDOW = Mod(nCheckDay, 7);
        IF(nDOW = 0);
            nDOW = 7;
        ENDIF;
        
        sDOWStr = NumberToString(nDOW);
        
        IF(Scan(sDOWStr, sDaysOfWeek) > 0);
            IF(sCheckDateStr @= sToday);
                IF(sLastRunDate @<> sToday);
                    nNextRunDate = nCheckDay + nDateOffset;
                    bFound = 1;
                ENDIF;
            ELSE;
                nNextRunDate = nCheckDay + nDateOffset;
                bFound = 1;
            ENDIF;
        ENDIF;
        
        nDaysChecked = nDaysChecked + 1;
    END;
ENDIF;
#EndRegion

#Region --------------- Monthly Schedule ---------------
IF(sScheduleType @= 'Monthly');
    nDaysChecked = 0;
    bFound = 0;
    
    WHILE(nDaysChecked < 62 & bFound = 0);
        nCheckDay = nToday + nDaysChecked;
        dCheckDate = nCheckDay;
        sCheckDateStr = TimSt(dCheckDate, '\Y-\m-\d');
        
        sDayOfMonthStr = TimSt(dCheckDate, '\d');
        
        IF(SubSt(sDayOfMonthStr, 1, 1) @= '0');
            sDayOfMonthStr = SubSt(sDayOfMonthStr, 2, 1);
        ENDIF;
        
        sTempDays = ',' | sDaysOfMonth | ',';
        sSearchDay = ',' | sDayOfMonthStr | ',';
        
        IF(Scan(sSearchDay, sTempDays) > 0);
            IF(sCheckDateStr @= sToday);
                IF(sLastRunDate @<> sToday);
                    nNextRunDate = nCheckDay + nDateOffset;
                    bFound = 1;
                ENDIF;
            ELSE;
                nNextRunDate = nCheckDay + nDateOffset;
                bFound = 1;
            ENDIF;
        ENDIF;
        
        nDaysChecked = nDaysChecked + 1;
    END;
ENDIF;
#EndRegion

#Region --------------- Specific Dates Schedule ---------------
IF(sScheduleType @= 'Specific');
    sRemaining = sSpecificDates;
    sEarliestDate = '';
    
    # Find the earliest future date from the list
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
            # Check if date is today and hasn't run yet
            IF(sCheckDate @= sToday);
                IF(sLastRunDate @<> sToday);
                    IF(sEarliestDate @= '' % sCheckDate @< sEarliestDate);
                        sEarliestDate = sCheckDate;
                    ENDIF;
                ENDIF;
            # Check if date is in the future
            ELSEIF(sCheckDate @> sToday);
                IF(sEarliestDate @= '' % sCheckDate @< sEarliestDate);
                    sEarliestDate = sCheckDate;
                ENDIF;
            ENDIF;
        ENDIF;
    END;
    
    # Convert earliest date to day number
    IF(sEarliestDate @<> '');
        IF(sEarliestDate @= sToday);
            nNextRunDate = nTodayFormatted;
        ELSE;
            # Calculate days between today and target by iterating
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
