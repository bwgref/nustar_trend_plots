PRO update_trends

forward_function read_rawmet

obs = {obsid:'string', object:'string', exposure:'string', obs_start:'string', $
       type:'string', $
       dark0:0., noise0:0., dark1:0., noise1:0., $
       intense0:0., intense_noise0:0., intense1:0., intense_noise1:0., $
       intense0X:0., intense0Y:0., intense1X:0., intense1Y:0., $
       noiseX0A:0., noiseX0B:0., noiseX1A:0., noiseX1B:0., $
       noiseY0A:0., noiseY0B:0., noiseY1A:0., noiseY1B:0., $       
       x0A:-1., x0B:-1., y0A:-1., y0B:-1., $
       x1A:-1., x1B:-1., y1A:-1., y1B:-1., $
       dark_x0A:-1., dark_x0B:-1., dark_y0A:-1., dark_y0B:-1., $
       dark_x1A:-1., dark_x1B:-1., dark_y1A:-1., dark_y1B:-1., $
       dark_noiseX0A:0., dark_noiseX0B:0., dark_noiseX1A:0., dark_noiseX1B:0., $
       dark_noiseY0A:0., dark_noiseY0B:0., dark_noiseY1A:0.,$
       dark_noiseY1B:0.}

datadir = getenv('DATAHOME')
; Get top-level SOCNAMEs:
socnames = file_search(datadir+'/*', /test_directory)


; Storage directory for info:
outdata=getenv('TROOT')+'/data'

for s =0, n_elements(socnames) -1 do begin
   ; Second level check:
   obsid = file_search(socnames[s]+'/*', /test_directory)
   for o =0, n_elements(obsid) -1 do begin
      if ~file_test(obsid[o]+'/event_cl/', /directory) then CONTINUE

      IF stregex(obsid[o], 'old', /boolean) THEN CONTINUE



     ; Truncate to just obsid
      sname = file_basename(obsid[o])

      outfile = outdata+'/'+sname+'/'+sname+'_trends.sav'
      IF file_test(outfile) THEN continue

      push, obsid_list, sname
      push, socname_list, socnames[s]

   endfor
endfor

nobs = n_elements(obsid_list)
print, 'Number of new OBSIDs: ', nobs

for i = 0, nobs - 1 do begin
   obs.obsid = obsid_list[i]

   outdir = outdata+'/'+obs.obsid
   print, outdir

   file_mkdir, outdir

   if i mod 20 eq 0 then begin
      print, i, ' of ', nobs
   endif

; Get some information about the target:
   ;ocdir = file_search(datadir, obs.obsid, /mark_directory)
   socdir=socname_list[i]+'/'+obsid_list[i]


   clA = file_search(socdir, '*A0*_cl.evt', count = count)
   good = 0
   if count GT 0 then begin



      header = headfits(clA[0], exten=0, /silent)
      obs.object = strtrim(strupcase(fxpar(header, 'OBJECT')))
      obs.obs_start = fxpar(header, 'DATE-OBS')

   ; See if there is an A01_cl.evt OBSID:
      clA = file_search(socdir, '*A01_cl.evt')
      f = file_info(clA)

      if f.exists then begin
         
         header = headfits(clA[0], exten=0, /silent)
         exp = round(float(fxpar(header, 'EXPOSURE')) / 1e3)
         if exp gt 5 then begin
            obs.exposure = string(exp, format = '(i0)')
; Compute the mean metrology intensities:

            rawmet_file = file_search(socdir+'/hk/', '*met*')
            read_rawmet, infile = rawmet_file, rawdat = rawdat, basedat = basedat
            obs.dark0 = mean(basedat.intense0)
            obs.noise0 = stddev(basedat.intense0)
            
            obs.dark1 = mean(basedat.intense1)
            obs.noise1 = stddev(basedat.intense1)

            obs.intense0 = mean(rawdat.intense0)
            obs.intense_noise0 = stddev(rawdat.intense0)



      
            obs.intense1 = mean(rawdat.intense1)
            obs.intense_noise1 = stddev(rawdat.intense1)
         
        
            obs.x0A = mean(rawdat.x0A)
            obs.x0B = mean(rawdat.x0B)
            obs.x1A = mean(rawdat.x1A)
            obs.x1B = mean(rawdat.x1B)



            obs.noisex0A = stddev(rawdat.x0A)
            obs.noisex0B = stddev(rawdat.x0B)
            obs.noisex1A = stddev(rawdat.x1A)
            obs.noisex1B = stddev(rawdat.x1B)



            obs.y0A = mean(rawdat.y0A)
            obs.y0B = mean(rawdat.y0B)
            obs.y1A = mean(rawdat.y1A)
            obs.y1B = mean(rawdat.y1B)
            
            obs.noisey0A = stddev(rawdat.y0A)
            obs.noisey0B = stddev(rawdat.y0B)
            obs.noisey1A = stddev(rawdat.y1A)
            obs.noisey1B = stddev(rawdat.y1B)



            

            obs.dark_x0A = mean(basedat.x0A)
            obs.dark_x0B = mean(basedat.x0B)
            obs.dark_x1A = mean(basedat.x1A)
            obs.dark_x1B = mean(basedat.x1B)

            obs.dark_y0A = mean(basedat.y0A)
            obs.dark_y0B = mean(basedat.y0B)
            obs.dark_y1A = mean(basedat.y1A)
            obs.dark_y1B = mean(basedat.y1B)

            obs.dark_noisex0A = stddev(basedat.x0A)
            obs.dark_noisex0B = stddev(basedat.x0B)
            obs.dark_noisex1A = stddev(basedat.x1A)
            obs.dark_noisex1B = stddev(basedat.x1B)

            obs.dark_noisey0A = stddev(basedat.y0A)
            obs.dark_noisey0B = stddev(basedat.y0B)
            obs.dark_noisey1A = stddev(basedat.y1A)
            obs.dark_noisey1B = stddev(basedat.y1B)

        
;         obs.oa = compute_ave_oa(obs)
            good = 1
         endif 
      ENDIF
   ENDIF

   if good eq 0 then obs.type = 'SLEW' else obs.type = 'SCIENCE'

   save, obs, file = outdir+'/'+obs.obsid+'_trends.sav'


ENDFOR





end








