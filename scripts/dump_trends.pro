PRO dump_trends

outdata=getenv('ROOT')+'/bwgref/update_trends/data'
dirs = file_search(outdata+'/*', /test_directory)

FOR d = 0, n_elements(dirs) -1 DO BEGIN
   ; See if the metrology data exists:

   sname = file_basename(dirs[d])
   metfile = outdata+'/'+sname+'/'+sname+'_met.sav'
   IF ~file_test(metfile) THEN continue

   restore, metfile
   push, all_obs, obs


ENDFOR



science = where(all_obs.type EQ 'SCIENCE', goodn)

all_obs = all_obs[science]

times = convert_nustar_time(all_obs.obs_start, /from_ut)

t0 = min(times)
print, 'Time start for trend plots: ',convert_nustar_time(t0, /ut)
print, 'Time end for trend plots: ', convert_nustar_time(max(times), /ut)

times = (times - t0) / 86400.

openw, lun, /get_lun, 'noise_psd0_on_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].noisex0A, all_obs[i].noisex0B, all_obs[i].noisey0A, all_obs[i].noisey0B
ENDFOR
close, lun
free_lun, lun


openw, lun, /get_lun, 'noise_psd1_on_vs_time.txt'
FOR i =1, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].noisex1A, all_obs[i].noisex1B, all_obs[i].noisey1A, all_obs[i].noisey1B
ENDFOR
close, lun
free_lun, lun


openw, lun, /get_lun, 'noise_psd0_off_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].dark_noisex0A, all_obs[i].dark_noisex0B, all_obs[i].dark_noisey0A, all_obs[i].dark_noisey0B
ENDFOR
close, lun
free_lun, lun


openw, lun, /get_lun, 'noise_psd1_off_vs_time.txt'
FOR i =1, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].dark_noisex1A, all_obs[i].dark_noisex1B, all_obs[i].dark_noisey1A, all_obs[i].dark_noisey1B
ENDFOR
close, lun
free_lun, lun





openw, lun, /get_lun, 'metrology_on_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].intense0, all_obs[i].intense_noise0, all_obs[i].intense1, all_obs[i].intense_noise1
ENDFOR
close, lun
free_lun, lun


openw, lun, /get_lun, 'metrology_dark_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].dark0, all_obs[i].noise0, all_obs[i].dark1, all_obs[i].noise1
ENDFOR
close, lun
free_lun, lun


openw, lun, /get_lun, 'psd0_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].x0A, all_obs[i].x0B, all_obs[i].y0A, all_obs[i].y0B
ENDFOR
close, lun
free_lun, lun

openw, lun, /get_lun, 'psd1_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].x1A, all_obs[i].x1B, all_obs[i].y1A, all_obs[i].y1B
ENDFOR
close, lun
free_lun, lun

openw, lun, /get_lun, 'psd0_dark_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].dark_x0A, all_obs[i].dark_x0B, all_obs[i].dark_y0A, all_obs[i].dark_y0B
ENDFOR
close, lun
free_lun, lun

openw, lun, /get_lun, 'psd1_dark_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].dark_x1A, all_obs[i].dark_x1B, all_obs[i].dark_y1A, all_obs[i].dark_y1B
ENDFOR
close, lun
free_lun, lun



END
