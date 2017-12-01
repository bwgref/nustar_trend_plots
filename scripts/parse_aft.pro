PRO parse_aft


aft_file = '/home/nustar1/Web/NuSTAROperationSite/Operations/observing_schedule.txt'
openr, lun, /get_lun, aft_file

stub = {seqid:'', saa:-1.0}
 

WHILE ~eof(lun) DO BEGIN
   input = 'string'
   readf, lun, input
   IF (stregex(input, ';') EQ 0 ) THEN continue

   fields = strsplit(input, ' ',  /extract)

   stub.seqid=fields[2]

;   test_inf = size(fields[8], /structure)

   IF fields[8] EQ 'na' THEN continue
   stub.saa=float(fields[8])
;   print, fields[2],'  ', fields[8]
;   print, stub

   push, aft, stub


ENDWHILE
close, lun
free_lun, lun

save, aft, file = 'aft.sav'

END
