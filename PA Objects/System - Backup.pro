601,100
602,"System - Backup"
562,"NULL"
586,
585,
564,
565,"u>TrC[nsAdhorkhH1=VU=aLl6?uwZ=E4UQK1NbDQtNMmzsV6=GJaosToC:ghZ1c3a=o55r?I:nMHs0fMpgETq7cc[P?f9wW0yx]Oy1eos8wH>VB6iK=imKyyLUhNO>Rf1kw_7bf[=sMBj<ahwcqK1o4wF73J;X8K=[lQ=EJoE<aV:u1=oEDi<pWS5Wnb3DUQS=Y\mz[Y"
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
572,26

#Region ############################################# HEADER #############################################
# Process: System - Backup
# Purpose: Backup Data Directory
# Date Created: 2026.02.17 (ACGI)
# Last Update: 2026.02.17
# Notes: 
#     2026.02.17 (ACGI) - Initial Process Creation
#EndRegion

#Region --------------- Constants ---------------
cType = CellGetS('System - Admin Parameters', 'Environment Type', 'String');
cName = CellGetS('System - Admin Parameters', 'Environment Name', 'String');
cServer = cName | '_' | cType;
cData = CellGetS('System - Admin Parameters', 'Data Directory', 'String');
cLogs = CellGetS('System - Admin Parameters', 'Logging Directory', 'String');
cBackups = CellGetS('System - Admin Parameters', 'Backup Directory', 'String');
cScript = CellGetS('System - Admin Parameters', 'Scripts Directory', 'String') | 'TM1Backup.exe';
cBackup_Retention = CellGetS('System - Admin Parameters', 'Backup Retention', 'String');
cLog_Retention = CellGetS('System - Admin Parameters', 'Log Retention', 'String');
#EndRegion

SaveDataAll;
sCMD = EXPAND('%cScript% %cServer% %cData% %cBackups% %cLogs% -k %cBackup_Retention% -l %cLog_Retention% -z');
ExecuteCommand(sCMD, 1);

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
