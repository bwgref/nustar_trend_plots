PRO get_max_optics_temp

restore, 'aft.sav'
datdir='/home/nustar1/nustarops/fltops/'

outfile = 'max_temps_vs_saa.txt'
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
;   socdir = file_search(datdir+'/*/'+seqid)

   socn = strmid(seqid, 0, 8)

   socdir = file_search(datdir+socn+'*', /test_dir)
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


   tagbase = 'CHU4_TEMP'
   this_tag = where(tags EQ tagbase, found)
   outstring += string(max(obeb.(this_tag)), format = '(20f)')
   




   FOR opt = 0, 3 DO BEGIN
      IF opt EQ 1 THEN CONTINUE

      tagbase = 'OPT_B'+string(opt, format = '(i0)')+'_TEMP'

      this_tag = where(tags EQ tagbase, found)
         
      outstring += string(max(obeb.(this_tag)), format = '(20f)')
      
   ENDFOR

;   Addition of PA - get this from the event file header
   evfile = socdir+'/'+seqid+'/event_cl/nu'+seqid+'A01_cl.evt'

   f = file_info(evfile)
   IF f.exists THEN BEGIN
      ev = mrdfits(evfile, 1, /silent, evhdr)
      ev_inf = size(ev, /structure)

      IF ev_inf.type_name EQ 'STRUCT' THEN BEGIN

         pa_pnt = fxpar(evhdr, 'PA_PNT')
         outstring += string(pa_pnt, format = '(20f)')

         ;   Addition of Yaw Offset - get this using pa_times for when we have a valid PA
         ;   PA for this code is 180 - Sky PA
         plan_pa = 180 - pa_pnt
         params = aft[i].starttime+' '+aft[i].endtime+' '+string(aft[i].ra)+' '+string(aft[i].dec)+' '+string(plan_pa, format = '(20f)')

         openw, 2,'run_patimes.csh'
         printf, 2, 'cd /users/nuops/mps/orbit_engine'
         printf, 2, './pa_times '+params
         close, 2
         spawn, 'csh ./run_patimes.csh', output

         yaw_offset = FLTARR(size(output, /N_ELEMENTS)-3)
         jds = DBLARR(size(output, /N_ELEMENTS)-3)
         FOR n = 3, size(output, /N_ELEMENTS)-1 DO BEGIN
            linebits = strsplit(output[n],/extract)
            timestring = linebits[0]
            jds[n-3] = JULDAY(1,STRMID(timestring,5,3),STRMID(timestring,0,4),STRMID(timestring,9,2),STRMID(timestring,12,2),STRMID(timestring,15,2))
            yaw_offset[n-3] = linebits[4]
         ENDFOR

         ; Linearly interpolate to find value of yaw offset in the middle of the observation
         midtime = (jds[0] + jds[n_elements(jds)-1]) / 2

         if n_elements(jds) gt 2 then begin
            std = stdev(jds[1:*]-jds,dx)
            if abs(std/dx) lt 1.e-5 then begin    ; Check for linearity in X0
               new_yo = yaw_offset                  ; No new interpolation necessary
            endif else begin
               new_jds = jds[0] + findgen((jds[n_elements(jds)-1]-jds[0])/dx + 2 ) * dx
               new_yo = interpol(yaw_offset,jds,new_jds)
            endelse
            x2 = ( midtime - jds[0] ) / dx
            yaw_offset_int = interpolate(new_yo,x2)
         endif else begin
            yaw_offset_int = interpolate(yaw_offset,0.5)
         endelse

         outstring += string(yaw_offset_int, format = '(20f)')

      ENDIF

   ENDIF



   printf, lun, outstring
   





   

ENDFOR

close, lun
free_lun, lun



END
