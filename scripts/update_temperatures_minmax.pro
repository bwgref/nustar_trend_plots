pro update_temperatures_minmax

obs = {obsid:'string', object:'string', exposure:'string', obs_start:'string', $
       type:'string', $
       psd0_temp_min:0., psd1_temp_min:1., $
       psd0_temp_max:0., psd1_temp_max:1., $
       laser0_temp_min:0., laser0_temp_max:0., $
       laser1_temp_min:0., laser1_temp_max:0., $
       laser0_ext_temp_min:0., laser0_ext_temp_max:0., $
       laser1_ext_temp_min:0., laser1_ext_temp_max:0.}


datadir = getenv('DATAHOME')
; Get top-level SOCNAMEs:
socnames = file_search(datadir+'/*', /test_directory)

outdata=getenv('TROOT')+'/data'


for s =0, n_elements(socnames) -1 do begin
   ; Second level check:
   obsid = file_search(socnames[s]+'/*', /test_directory)
   for o =0, n_elements(obsid) -1 do begin
      if ~file_test(obsid[o]+'/event_cl/', /directory) then CONTINUE
      IF stregex(obsid[o], 'old', /boolean) THEN CONTINUE

      sname = file_basename(obsid[o])
      IF file_test(outdata+'/'+sname+'/'+sname+'_temp_minmax.sav') THEN continue

      push, obsid_list, sname
      push, socname_list, socnames[s]

   endfor
endfor



nobs = n_elements(obsid_list)
print, 'Number of new OBSIDs for temperatures: ', nobs

;all_obs = replicate(obs, nobs)

for i = 0, nobs - 1 do begin
   obs.obsid = obsid_list[i]

   outdir = outdata+'/'+obs.obsid
   print, outdir

   file_mkdir, outdir


   if i mod 20 eq 0 then begin
      print, i, ' of ', nobs
   endif

; Get some information about the target:
;   socdir = file_search(datadir, obs.obsid, /mark_directory)
   socdir=socname_list[i]+'/'+obsid_list[i]
   clA = file_search(socdir+'/event_cl/', '*A0*_cl.evt', count = count)
   good = 0


   if count gt 0 then begin



      header = headfits(clA[0], exten=0, /silent)
      obs.object = strtrim(strupcase(fxpar(header, 'OBJECT')))
      obs.obs_start = fxpar(header, 'DATE-OBS')

                                ; See if there is an A01_cl.evt OBSID:
      clA = file_search(socdir+'/event_cl/', '*A01_cl.evt')
      f = file_info(clA)

      if f.exists then begin
      
         header = headfits(clA[0], exten=0, /silent)
         exp = round(float(fxpar(header, 'EXPOSURE')) / 1e3)
         if exp gt 5 then begin
            obs.exposure = string(exp, format = '(i0)')
; Compute the mean metrology intensities:

         

            obeb_file = file_search(socdir+'/hk/', '*obeb*')
            obeb_data = mrdfits(obeb_file, 1, /silent)

            obs.laser0_temp_min = min(obeb_data.LASER0_TEMP)
            obs.laser1_temp_min = min(obeb_data.LASER1_TEMP)
            obs.laser0_temp_max = max(obeb_data.LASER0_TEMP)
            obs.laser1_temp_max = max(obeb_data.LASER1_TEMP)


            obs.laser0_ext_temp_min = min(obeb_data.L0_EXTHTR_TEMP)
            obs.laser1_ext_temp_min = min(obeb_data.L1_EXTHTR_TEMP)
            obs.laser0_ext_temp_max = max(obeb_data.L0_EXTHTR_TEMP)
            obs.laser1_ext_temp_max = max(obeb_data.L1_EXTHTR_TEMP)



            ceb_file = file_search(socdir+'/hk/', '*ceb*')
            ceb_data = mrdfits(ceb_file, 1, /silent)
            obs.psd0_temp_min = min(ceb_data.psd0temp)
            obs.psd1_temp_min = min(ceb_data.psd1temp)

            obs.psd0_temp_max = max(ceb_data.psd0temp)
            obs.psd1_temp_max = max(ceb_data.psd1temp)


            good = 1
         endif 
      ENDIF
   ENDIF

   if good eq 0 then obs.type = 'SLEW' else obs.type = 'SCIENCE'

   save, obs, file = outdir+'/'+obs.obsid+'_temp_minmax.sav'
endfor




end








