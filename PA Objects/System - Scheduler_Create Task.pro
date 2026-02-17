601,100
602,"System - Scheduler_Create Task"
562,"NULL"
586,
585,
564,
565,"eR`[JaSNcKhJJFZ3\2<IqIL3Xc;r7PB2w4[AsrJ;LzqCX6K?Qx[DThDTgF7p@7Pef78yvedXB<19BH?KpV63uw]XjCS3@\ggXlZX9SOA@YbXlLi\vHXxn2@h\E]<YwGe2VCob<e5eEYcungJ>]\AZqNTMXuDwfhfgYRSMp[qpgbt>KjeOrUKGAZD\ogU<Nct:<<AuY2m"
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
560,13
pJobName
pTaskName
pDescription
pProcessName
pSequence
pScheduleType
pRunTime
pDaysOfWeek
pDaysOfMonth
pSpecificDates
pDependsOn
pDependencyMode
pActive
561,13
2
2
2
2
1
2
2
2
2
2
2
2
2
590,13
pJobName,""
pTaskName,""
pDescription,""
pProcessName,""
pSequence,0
pScheduleType,""
pRunTime,""
pDaysOfWeek,""
pDaysOfMonth,""
pSpecificDates,""
pDependsOn,""
pDependencyMode,""
pActive,""
637,13
pJobName,"Parent job name"
pTaskName,"Task name"
pDescription,"Task description"
pProcessName,"TI process to execute"
pSequence,"Execution order within job"
pScheduleType,"Daily, Weekly, Monthly, Specific"
pRunTime,"Time to run (HH:MM in 24hr format)"
pDaysOfWeek,"For Weekly: 1=Mon, 2=Tue... 7=Sun (comma-separated)"
pDaysOfMonth,"For Monthly: day numbers (comma-separated)"
pSpecificDates,"For Specific: YYYY-MM-DD (comma-separated)"
pDependsOn,"Prerequisite tasks (comma-separated, full element names)"
pDependencyMode,"SameDay, LastRun, SameCycle"
pActive,"Y or N"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,189

#Region ############################################# HEADER #############################################
# Process: System - Scheduler_Create Task
# Purpose: Create Task under Existing Job
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Variables ---------------
sCube = 'System - Job Scheduler';
sDimJob = 'System - Scheduled Jobs';
nDateOffset = 21916;
#EndRegion

#Region --------------- Validate Required Parameters ---------------
IF(Trim(pJobName) @= '');
    ProcessError;
ENDIF;

IF(Trim(pTaskName) @= '');
    ProcessError;
ENDIF;

IF(Trim(pProcessName) @= '');
    ProcessError;
ENDIF;

IF(Trim(pScheduleType) @= '');
    ProcessError;
ENDIF;

IF(Trim(pRunTime) @= '');
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Schedule Type ---------------
sScheduleType = Trim(pScheduleType);

IF(sScheduleType @<> 'Daily' & sScheduleType @<> 'Weekly' & sScheduleType @<> 'Monthly' & sScheduleType @<> 'Specific');
    ProcessError;
ENDIF;

IF(sScheduleType @= 'Weekly' & Trim(pDaysOfWeek) @= '');
    ProcessError;
ENDIF;

IF(sScheduleType @= 'Monthly' & Trim(pDaysOfMonth) @= '');
    ProcessError;
ENDIF;

IF(sScheduleType @= 'Specific' & Trim(pSpecificDates) @= '');
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Run Time Format ---------------
sRunTime = Trim(pRunTime);

IF(Long(sRunTime) <> 5);
    ProcessError;
ENDIF;

IF(SubSt(sRunTime, 3, 1) @<> ':');
    ProcessError;
ENDIF;

sHour = SubSt(sRunTime, 1, 2);
sMinute = SubSt(sRunTime, 4, 2);

nHour = StringToNumber(sHour);
nMinute = StringToNumber(sMinute);

IF(nHour < 0 % nHour > 23);
    ProcessError;
ENDIF;

IF(nMinute < 0 % nMinute > 59);
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Process Exists ---------------
IF(ProcessExists(Trim(pProcessName)) = 0);
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Active Flag ---------------
sActive = Trim(pActive);

IF(sActive @= '');
    sActive = 'Y';
ENDIF;

IF(sActive @<> 'Y' & sActive @<> 'N');
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Dependency Mode ---------------
sDependencyMode = Trim(pDependencyMode);

IF(sDependencyMode @= '');
    sDependencyMode = 'SameDay';
ENDIF;

IF(sDependencyMode @<> 'SameDay' & sDependencyMode @<> 'LastRun' & sDependencyMode @<> 'SameCycle');
    ProcessError;
ENDIF;
#EndRegion

#Region --------------- Validate Sequence ---------------
nSequence = pSequence;

IF(nSequence <= 0);
    nSequence = 1;
ENDIF;
#EndRegion

#Region --------------- Validate Dependencies Exist ---------------
sDependsOn = Trim(pDependsOn);

IF(sDependsOn @<> '');
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
            IF(DimIx(sDimJob, sDepTask) = 0);
                ProcessError;
            ENDIF;
        ENDIF;
    END;
ENDIF;
#EndRegion

#Region --------------- Create Task ---------------
sTaskName = Trim(pTaskName);
sFullTaskName = pJobName | '|' | sTaskName;

IF(DimIx(sDimJob, sFullTaskName) > 0);
    ProcessError;
ENDIF;

DimensionElementInsertDirect(sDimJob, '', sFullTaskName, 'N');
DimensionElementComponentAddDirect(sDimJob, pJobName, sFullTaskName, 1);
#EndRegion

#Region --------------- Set Attributes ---------------
sDescription = Trim(pDescription);
IF(sDescription @= '');
    sDescription = sTaskName;
ENDIF;

AttrPutS(sDescription, sDimJob, sFullTaskName, 'Description');
AttrPutS(Trim(pProcessName), sDimJob, sFullTaskName, 'ProcessName');
AttrPutN(nSequence, sDimJob, sFullTaskName, 'Sequence');
AttrPutS('Task', sDimJob, sFullTaskName, 'ElementType');
#EndRegion

#Region --------------- Set Cube Values ---------------
CellPutS(sActive, sCube, sFullTaskName, 'Active');
CellPutS(sScheduleType, sCube, sFullTaskName, 'Schedule Type');
CellPutS(sRunTime, sCube, sFullTaskName, 'Run Time');
CellPutS(Trim(pDaysOfWeek), sCube, sFullTaskName, 'Days Of Week');
CellPutS(Trim(pDaysOfMonth), sCube, sFullTaskName, 'Days Of Month');
CellPutS(Trim(pSpecificDates), sCube, sFullTaskName, 'Specific Dates');
CellPutS(sDependsOn, sCube, sFullTaskName, 'Depends On');
CellPutS(sDependencyMode, sCube, sFullTaskName, 'Dependency Mode');
CellPutS('N', sCube, sFullTaskName, 'Execute Now');
CellPutS('N', sCube, sFullTaskName, 'Skip Dependencies');
CellPutS('⏳ Pending', sCube, sFullTaskName, 'Current Status');
#EndRegion

#Region ---------------  Calculate Next Run Date ---------------
ExecuteProcess('System - Scheduler_Calutate Next Run', 'pTask', sFullTaskName);
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
