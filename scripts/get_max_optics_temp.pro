PRO get_max_optics_temp

restore, 'aft.sav'
datdir='~/fltops/'

outfile = 'max_temps_vs_saa.txt'
openw, lun, /get_lun, outfile

ctr = 0
FOR i = 0, n_elements(aft) -1 DO BEGIN
   seqid = aft[i].seqid

   outstring = string(aft[i].saa, format = '(20f)')
;   socdir = file_search(datdir+'/*/'+seqid)

   socn = strmid(seqid, 0, 8)
   socdir = file_search(datdir+'/'+socn+'*', /test_dir)
   IF n_elements(socdir) GT 1 THEN BEGIN
;;      print, 'Weird duplicate...'
;;     print, socdir
      socdir = socdir[0]
   ENDIF

   hkfile = socdir+'/'+seqid+'/hk/nu'+seqid+'_obeb.hk'

   f = file_info(hkfile)
   IF ~f.exists THEN continue
   

   obeb = mrdfits(hkfile, 1, /silent, hkhdr)
   obeb_inf = size(obeb, /structure)
   IF obeb_inf.type_name NE 'STRUCT' THEN continue

   
   tags = tag_names(obeb)

   outstring+=string(fxpar(hkhdr, 'TSTART')) 


   FOR opt = 0, 1 DO BEGIN
      tagbase = 'OPT'+string(opt, format = '(i0)')
      FOR therm = 0, 5 DO BEGIN
         tagstr = tagbase+'_'+string(therm, format = '(i0)')+'TEMP'
         this_tag = where(tags EQ tagstr, found)
         
         outstring += string(max(obeb.(this_tag)), format = '(20f)')

      ENDFOR


   Endfor

   FOR opt = 0, 1 DO begin
      tagbase = 'LASER'+string(opt, format = '(i0)')+'_TEMP'
      this_tag = where(tags EQ tagbase, found)
      outstring += string(max(obeb.(this_tag)), format = '(20f)')


      tagbase = 'L'+string(opt, format = '(i0)')+'_EXTHTR_TEMP'
      this_tag = where(tags EQ tagbase, found)
      outstring += string(max(obeb.(this_tag)), format = '(20f)')

   ENDFOR



   printf, lun, outstring

   

ENDFOR

close, lun
free_lun, lun



END
