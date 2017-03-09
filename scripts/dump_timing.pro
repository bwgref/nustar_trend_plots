PRO dump_timing


outdata=getenv('ROOT')+'/bwgref/update_trends/data'
dirs = file_search(outdata+'/*', /test_directory)

FOR d = 0, n_elements(dirs) -1 DO BEGIN
   ; See if the metrology data exists:

   sname = file_basename(dirs[d])
   metfile = outdata+'/'+sname+'/'+sname+'_timing.sav'
   IF ~file_test(metfile) THEN continue

   restore, metfile
   push, all_obs, obs


ENDFOR



science = where(all_obs.type EQ 'SCIENCE', goodn)
print, goodn
all_obs = all_obs[science]

times = convert_nustar_time(all_obs.obs_start, /from_ut)

t0 = min(times)
times = (times - t0) / 86400.

;; !p.multi = [0, 1, 2]
;; !p.charsize = 2
;; plot, times, all_obs.dark0, psym =4, ytitle = 'Dark Current (analog)', $
;;       xtitle = 'Days since '+convert_nustar_time(t0, /fits), xrange = [20, max(times)+2]

;; plot, times, all_obs.noise0, psym =4, ytitle = 'Noise on Dark Current (analog)', $
;;       xtitle = 'Days since '+convert_nustar_time(t0, /fits), xrange = [20, max(times)+2]

;; plot, times, all_obs.dark1, psym =4, ytitle = 'Dark Current (analog)', $
;;       xtitle = 'Days since '+convert_nustar_time(t0, /fits), xrange = [20, max(times)+2]

;; plot, times, all_obs.noise1, psym =4, ytitle = 'Noise on Dark Current (analog)', $
;;       xtitle = 'Days since '+convert_nustar_time(t0, /fits), xrange = [20, max(times)+2]

;; !p.multi = 0

openw, lun, /get_lun, 'timing_vs_time.txt'
FOR i =0, n_elements(times) -1 DO BEGIN
   printf, lun, times[i], all_obs[i].min_offset, all_obs[i].mean_offset, all_obs[i].max_offset,$
           format = '(4f25)'
ENDFOR
close, lun
free_lun, lun


END
