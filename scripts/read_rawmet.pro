PRO read_rawmet, infile = infile, rawdat = rawdat, basedat = basedat


rawdat_temp = {x0A:-1., x0B:-1., y0A:-1., y0B:-1, $
               x1A:-1., x1B:-1., y1A:-1., y1B:-1, $
               intense0:-1., intense1:-1.}


; Read in the data from the first extension. Also read in the header.
; Make sure that unsigned ints are read in as unsigned.

data = mrdfits(infile, 1, header, /unsigned, status = status, /silent)
;print, 'Done reading metrology...'

baselines = where(data.las_on EQ 0, nbaselines)
sources = where(data.las_on eq 1, nsources)

rawdat = replicate(rawdat_temp, n_elements(sources)) 
basedat = replicate(rawdat_temp, n_elements(baselines)) 

basedat.intense0 = data[baselines].(2) + data[baselines].(3) + data[baselines].(4) + data[baselines].(5)
basedat.intense1 = data[baselines].(6) + data[baselines].(7) + data[baselines].(8) + data[baselines].(9)
basedat.x0A = data[baselines].(2)
basedat.x0B = data[baselines].(3)
basedat.y0A = data[baselines].(4)
basedat.y0B = data[baselines].(5)
basedat.x1A = data[baselines].(6)
basedat.x1B = data[baselines].(7)
basedat.y1A = data[baselines].(8)
basedat.y1B = data[baselines].(9)

FOR i = 2, 9 DO BEGIN
   IF data[sources[0]].(i) GT 0 THEN data[sources].(i) = abs(data[sources].(i) - 2000) ELSE $
      data[sources].(i) += 2000
ENDFOR


rawdat.intense0 = data[sources].(2) + data[sources].(3) + data[sources].(4) + data[sources].(5)
rawdat.intense1 = data[sources].(6) + data[sources].(7) + data[sources].(8) + data[sources].(9)
rawdat.x0A = data[sources].(2)
rawdat.x0B = data[sources].(3)
rawdat.y0A = data[sources].(4)
rawdat.y0B = data[sources].(5)
rawdat.x1A = data[sources].(6)
rawdat.x1B = data[sources].(7)
rawdat.y1A = data[sources].(8)
rawdat.y1B = data[sources].(9)


return

x0 = x0[*, sources]
x1 = x1[*, sources]
y0 = y0[*, sources]
y1 = y1[*,sources]

; Only care about differences from the baseline, not the direction...
x0 = abs(x0)
y0 = abs(y0)
x1 = abs(x1)
y1 = abs(y1)

rawdat.intense0 = total(x0, 1) + total(y0, 1)
rawdat.intense1 = total(x1, 1) + total(y1, 1)

rawdat.x0 = reform(x0[1, *] - x0[0, *]) / total(x0, 1)
rawdat.y0 = reform(y0[1, *] - y0[0, *]) / total(y0, 1)

; Note the swap here!!!
rawdat.x1 = reform(x1[1, *] - x1[0, *]) / total(x1, 1)
rawdat.y1 = reform(y1[1, *] - y1[0, *]) / total(y1, 1)

END
