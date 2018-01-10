PRO dump_met

restore, 'aft.sav'
datdir='../data/'

outfile = 'met_vs_saa.txt'
openw, lun, /get_lun, outfile

ctr = 0

aftind = findgen(n_elements(aft))


r = RANDOMU(seed, n_elements(aft) )            
sortr = sort(r)

FOR ctr = 0, n_elements(aft) -1 DO BEGIN
;   thisind = floor(n_elements(aftind) * randomu(seed))
   i = sortr[ctr]

   seqid = aft[i].seqid

   outstring = string(aft[i].saa, format = '(20f)')

   metfile = datdir+'/'+seqid+'/'+seqid+'_met.sav'

   f = file_info(metfile)
   IF ~f.exists THEN CONTINUE
   
   restore, metfile
   outstring += string(obs.x0cent[1], format = '(20f)')
   outstring += string(obs.y0cent[1], format = '(20f)')
   outstring += string(obs.x1cent[1], format = '(20f)')
   outstring += string(obs.y1cent[1], format = '(20f)')

   outstring += string(obs.x0int[1], format = '(20f)')
   outstring += string(obs.y0int[1], format = '(20f)')
   outstring += string(obs.x1int[1], format = '(20f)')
   outstring += string(obs.y1int[1], format = '(20f)')
   
   printf, lun, outstring

   

ENDFOR

close, lun
free_lun, lun



END
