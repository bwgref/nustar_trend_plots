pro update_metrology

obs = {obsid:'string', object:'string', exposure:'string', obs_start:'string', $
       type:'string', $
       mjdmean:0., $
       x0int:fltarr(3), y0int:fltarr(3), $
       x1int:fltarr(3), y1int:fltarr(3), $
       x0cent:fltarr(3), y0cent:fltarr(3), $
       x1cent:fltarr(3), y1cent:fltarr(3) $
       }


datadir = getenv('DATAHOME')+'/../../housekeeping/FltOps'
; Get top-level SOCNAMEs:
socnames = file_search(datadir+'/*', /test_directory)

outdata=getenv('TROOT')+'/data'

for s =0, n_elements(socnames) -1 do begin
   ; Second level check:
   obsid = file_search(socnames[s]+'/*', /test_directory)
   for o =0, n_elements(obsid) -1 do begin

      IF stregex(obsid[o], 'old', /boolean) THEN CONTINUE

      sname = file_basename(obsid[o])

      outfile = outdata+'/'+sname+'/'+sname+'_met.sav'
      IF file_test(outfile) THEN continue

      push, obsid_list, sname
      push, socname_list, socnames[s]

   endfor
endfor



nobs = n_elements(obsid_list)
print, 'Number of new OBSIDs for metrology: ', nobs

;all_obs = replicate(obs, nobs)

for j = 0, nobs - 1 do begin
   obs.obsid = obsid_list[j]

   outdir = outdata+'/'+obs.obsid

   file_mkdir, outdir


   if j mod 20 eq 0 then begin
      print, j, ' of ', nobs
   endif

; Get some information about the target:
;   socdir = file_search(datadir, obs.obsid, /mark_directory)
   socdir=socname_list[j]+'/'+obsid_list[j]
   metfile = file_search(socdir, '*met_summary*', count = count)
   good = 0


   if count EQ 1 then begin

      openr, lun, /get_lun, metfile


      WHILE ~eof(lun) DO BEGIN
         input = 'string'
         readf, lun, input
;         print, input

         IF stregex(input, 'X0INT', /boolean) THEN BEGIN
            fields = strsplit(input, /extract)
            obs.mjdmean = float(fields[1])

            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.x0int[i] = float(fields[2])
            ENDFOR

         endif

         IF stregex(input, 'Y0INT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.y0int[i] = float(fields[2])
            ENDFOR

         endif


         IF stregex(input, 'X0CENT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.x0cent[i] = float(fields[2])
            ENDFOR

         endif


         IF stregex(input, 'Y0CENT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.y0cent[i] = float(fields[2])
            ENDFOR

         endif

         ;;;;; Now PSD 1 ;;;;


         IF stregex(input, 'X1INT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.x1int[i] = float(fields[2])
            ENDFOR

         endif

         IF stregex(input, 'Y1INT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.y1int[i] = float(fields[2])
            ENDFOR

         endif


         IF stregex(input, 'X1CENT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.x1cent[i] = float(fields[2])
            ENDFOR

         endif


         IF stregex(input, 'Y1CENT', /boolean) THEN BEGIN
            FOR i =0, 2 DO BEGIN
               input = 'string'
               readf, lun, input

               fields = strsplit(input, /extract)

               obs.y1cent[i] = float(fields[2])
            ENDFOR

         endif

         
      ENDWHILE
      close, lun
      free_lun, lun
   ENDIF


   save, obs, file = outdir+'/'+obs.obsid+'_met.sav'
endfor




end








