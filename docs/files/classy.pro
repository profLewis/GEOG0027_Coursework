
;
; NAME:
;   real_classy
;
; PURPOSE:
;   Automate classifications over set of files
;   File_Search(dir, '*/????_Shenzhen')
;   
; INPUTS:
;   dir - directory where to look for datasets
;   fixfile - class translation file
;            If this is set, infer number of classes
;            assuming you have unclassified and 
;            Masked Pixels
; OUTPUTS:
;    input_file + '_class'     - classification ENVI file
;    input_file + "_class.gif" - annotated gif
;    class_movie.gif           - movie file
;
; AUTHOR:
;   P.Lewis, UCL 26 Jan 2019 (p.lewis@ucl.ac.uk)
;

Pro real_classy,fixfile,BANDS
  compile_opt idl2, hidden
  on_error, 2
  
  ; legacy variable
  dir = '.'
  ; we *need* convert or magick
  ; in the path, so test for that
  if get_magick() eq '0' then begin
    print, 'Warning: cannot make gifs'
    print,'unless you install ImageMagick'
    print,'see: https://imagemagick.org/'
  endif

  if ( N_params() LT 1 ) then begin
    fixfile = 'classy_lut4.dat'
    BANDS = [5,6]
  endif else if ( N_params() LT 2 ) then begin
    BANDS = [5,6]
  endif 

  ; class dfinitions from file
  template=create_struct('VERSION',1.00000,'DATASTART',0,'DELIMITER',44,'MISSINGVALUE',255, $
              'COMMENTSYMBOL','#','FIELDCOUNT',4,'FIELDTYPES',[7,7,7,7], 'FIELDNAMES',['class_name','R','G','B'], $
              'FIELDLOCATIONS',[0,13,16,21], 'FIELDGROUPS',[0,1,1,1])  ; [0,1,2,3])
  print,'defining default classes with ',fixfile  
  fix = read_ascii(fixfile,DELIMITER=',',TEMPLATE=template)
  classNames = fix.class_name
  classLookup = fix.r
  classN = size(fix.class_name)
  classN = classN[-1] 
  print,'setting ',classN,' classes'
  ;spawn,'./runMe'
  ; clean out gif files for movies
  cmd = 'rm -f */*class*.gif'
  spawn,cmd

  inputs = File_Search(dir, '????/????_Shenzhen')
  N = N_Elements(inputs)
  print,'Found ',N,' datasets'
  For i=0, N-1 DO BEGIN
    print,i,' ',N
    raster = inputs[i]
    classy,raster,classN-2,BANDS
    fix_class,raster,fixfile
  Endfor
  getStats,fixfile
  make_movie
end

;
; NAME:
;   getStats
;
; PURPOSE:
;   Get statistics (pixel count) of classified images 
;   ????/????_Shenzhen_class and save to file
;   results.dat
;
; INPUTS:
;    results  : results filename
;   
; OUTPUTS:
;    writes results to resulkts file
;
; AUTHOR:
;   P.Lewis, UCL 26 Jan 2019 (p.lewis@ucl.ac.uk)
;
pro getStats,fixfile,results
  compile_opt idl2, hidden
  on_error, 2
  
  y0 = 1986
  y1 = 2018
  r0 = 'results-'+string(y1+1)+'.csv'
  r0 = strcompress(r0, /REMOVE_ALL)
  
  if ( N_params() LT 1 ) then begin
    results = r0
    fixfile = 'classy_lut3.dat'
  endif else if ( N_params() LT 2 ) then begin
    results = r0
  endif
   
  ; class dfinitions from file
  template=create_struct('VERSION',1.00000,'DATASTART',0,'DELIMITER',44,'MISSINGVALUE',255, $
    'COMMENTSYMBOL','#','FIELDCOUNT',4,'FIELDTYPES',[7,7,7,7], 'FIELDNAMES',['class_name','R','G','B'], $
    'FIELDLOCATIONS',[0,13,16,21], 'FIELDGROUPS',[0,1,1,1])  ; [0,1,2,3])
  print,'defining default classes with ',fixfile
  fix = read_ascii(fixfile,DELIMITER=',',TEMPLATE=template)
  classNames = fix.class_name
  classLookup = fix.r
  classN = size(fix.class_name)
  classN = classN[-1] - 1
  
  print,'writing to ',results,' using ',fixfile

  
  result = []   

  ny = y1-y0+1
  FOR y=y0,y1 DO result = [result,HISTOGRAM(READ_BINARY((String(y)+'/'+String(y)+'_Shenzhen_class').compress()),locations=locations,min=0,max=classN)]
  result = reform(result,classN+1,ny)
  close,1
  openw,1,results
  ; header line
  printf,1,'Year,',FORMAT='(A,$)'
  for i=0,classN do printf,1,classNames[i],',',FORMAT='(A,A,$)'
  printf,1
  for y=y0,y1 do begin
    j = y - y0
    printf,1,y,',',FORMAT='(I,A2,$)'
    for i=0,classN do printf,1,result[i,j],',',FORMAT='(A,A2,$)'
    printf,1
  endfor

  ;result[i,*]
  close,1
end

;
; NAME:
;   classy
;
; PURPOSE:
;   Performs classification (clustering) on image
;
; INPUTS:
;   input_file - name of envi image to read
;   nclasses - how many classesa (default 5)
;   BANDS: default [5,6]
;
; OUTPUTS:
;    input_file + '_class'     - classification ENVI file
;
; AUTHOR:
;   P.Lewis, UCL 26 Jan 2019 (p.lewis@ucl.ac.uk)
;

Pro classy, input_file, nclasses, BANDS
  compile_opt idl2, hidden

  on_error, 2
  
  ; open a dialog if the filename isnt given
  ;

  if ( N_params() LT 1 ) then begin
    e = ENVI(/CURRENT)
    input_file = DIALOG_PICKFILE(DIALOG_PARENT = e.WIDGET_ID, $
    TITLE='Please select input file', $
    /MUST_EXIST)
    nclasses = 5
    BANDS = [5,6]
  endif else if ( N_params() LT 2 ) then begin
    e = ENVI(/HEADLESS)
    nclasses = 5
    BANDS = [5,6]
  endif else if ( N_params() LT 3 ) then begin
    e = ENVI(/HEADLESS)
    BANDS = [5,6]
  endif else begin 
    e = ENVI(/HEADLESS)
  endelse

  ; we assume the directory name is the year
  year = strsplit(input_file, /EXTRACT, '\/')
  print,'the year is classy',year
  year = year[-2]
  ; get the year
  print,'year ',year

  print,'loading input file ',input_file
  raster_1 = ENVI.OpenRaster(input_file)
  metadata = raster_1.METADATA
  bnames = metadata['BAND NAMES']
  Subset = ENVISubsetRaster(raster_1,BANDS=BANDS)
  
  ; ----------------------
  ; ISODATA Classification
  ; ----------------------
  class = input_file+"_class"
  task_1 = ENVITask('ISODATAClassification')
  task_1.NUMBER_OF_CLASSES = nclasses
  ;print,task_1.NUMBER_OF_CLASSES
  ;task_1.input_raster = task_0.output_raster
  task_1.input_raster = Subset
  task_1.output_raster_uri = class
  FILE_DELETE,class,/RECYCLE,/ALLOW_NONEXISTENT
  print,'classiying to file ',class
  task_1.Execute

  Subset.Close
  raster_1.Close
  task_1.output_raster.Close

end

pro fix_class2,input_file,fixfile
  compile_opt idl2, hidden

  on_error, 2

  e = ENVI(/HEADLESS)
  version = e.VERSION
  print,'ENVI version ',version

  if ( N_params() LT 2 ) then begin
    fixfile = 'classy_lut1.dat'
  endif 

  print,'fixing classes in ',input_file,' with ',fixfile
  template=create_struct('VERSION',1.00000,'DATASTART',0,'DELIMITER',44,'MISSINGVALUE',255, $
              'COMMENTSYMBOL','#','FIELDCOUNT',4,'FIELDTYPES',[7,7,7,7], 'FIELDNAMES',['class_name','R','G','B'], $
              'FIELDLOCATIONS',[0,13,16,21], 'FIELDGROUPS',[0,1,1,1])  ; [0,1,2,3])
 
  ;template=ascii_template(fixfile)
  ;print,'template is',tag_names(template)

  fix = read_ascii(fixfile,DELIMITER=',',TEMPLATE=template)
  ; how many classes
  classN = size(fix.class_name)
  classN = classN[-1]
  
  if ( e.VERSION lt 5.5) then begin
    r = fix.R[*,-1]
    name = fix.class_name[-1]
    for i=1,classN-1 do begin
      fix.R[*,-i] = fix.R[*,-(i+1)]
      fix.class_name[-i] = fix.class_name[-(i+1)]
    endfor
    fix.R[*,1] = r
    fix.class_name[1] = name
  endif
  
  ; add a class if envi version < 5.3

  if ( e.VERSION lt 5.3) then classN = classN + 1
  classN = "classes = " + string(classN)
  print,classN
  ; class names
  classNames = "class names = {" +strjoin(fix.class_name,',') +"}"

  ; colour lut
  lookupStr = strjoin(strjoin(fix.r,','),',')
  classLookup = 'class lookup = {'+lookupStr+'}'
  
  ;-------------
  ; edit the lookup
  ;-------------
  hdrFile = input_file+'_class.hdr'

  openw, 1, hdrFile, /APPEND
  printf, 1, classN
  printf, 1, classNames
  printf, 1, classLookup
  close, 1


end
pro fix_class, input_file,fixfile
  compile_opt idl2, hidden

  on_error, 2

  if ( N_params() LT 2 ) then begin
    fixfile = 'classy_lut1.dat'
  endif 

  print,'fixing classes in ',input_file,' with ',fixfile
  template=create_struct('VERSION',1.00000,'DATASTART',0,'DELIMITER',44,'MISSINGVALUE',255, $
              'COMMENTSYMBOL','#','FIELDCOUNT',4,'FIELDTYPES',[7,7,7,7], 'FIELDNAMES',['class_name','R','G','B'], $
              'FIELDLOCATIONS',[0,13,16,21], 'FIELDGROUPS',[0,1,1,1])  ; [0,1,2,3])
 
  ;template=ascii_template(fixfile)
  ;print,'template is',tag_names(template)

  fix = read_ascii(fixfile,DELIMITER=',',TEMPLATE=template)

  ; how many classes
  classN = size(fix.class_name)
  classN = classN[-1] 
  classN = "classes = " + string(classN)

  ; class names
  classNames = "class names = {" +strjoin(fix.class_name,',') +"}"

  ; colour lut
  lookupStr = strjoin(strjoin(fix.r,','),',')
  classLookup = 'class lookup = {'+lookupStr+'}'
  
  ;-------------
  ; edit the lookup
  ;-------------
  hdrFile = input_file+'_class.hdr'

  openw, 1, hdrFile, /APPEND
  printf, 1, classN
  printf, 1, classNames
  printf, 1, classLookup
  close, 1

end

function get_magick
  ; need to test to see if we have ImageMagick in any form
  ; leave out convert.exe as this is a file in windows 10
  ; C:\Windows\system32\convert.exe
  possible = ['convert','magick','magick.exe']
  
  ; return just the name part (not extension)
  foreach i, possible do begin
    path = file_which(getenv('PATH'),i,/INCLUDE_CURRENT_DIR)
    if strlen(path) gt 0 then return, (strsplit(i,'.',/EXTRACT))[0]
  endforeach
  print,'You need to install ImageMagick: check your path, and/or get from https://imagemagick.org/'
  return,'0'
end

function make_gif, input_file
  class = input_file+"_class"
  compile_opt idl2, hidden
  on_error, 2

  ; we *need* convert or magick 
  ; in the path, so test for that
  if get_magick() eq '0' then begin
    print, 'cannot run make_gif(input_file)'
    print,'You need to install ImageMagick'
    return,''
    
  endif


  ; we assume the directory name is the year
  year = strsplit(input_file, /EXTRACT, '\/')
  year = year[-2]
  
  
  ; get the year
  print,'year ',year
  ; first, check that input exists
  if file_test(class) then begin
    class_1 = ENVI.OpenRaster(class)
  endif else return,''

  ; -------------
  ; Export to PNG
  ; -------------  
  
  
  task_2 = ENVITask('ExportRasterToPNG')
  task_2.input_raster = class_1
  png = input_file+"_class.png"
  gif = input_file+"_class.gif"
  print,'saving picture'
  task_2.output_uri = png
  FILE_DELETE,png,/ALLOW_NONEXISTENT
  task_2.Execute

  task_2.output_raster.Close
  class_1.Close

  user =  getenv('USER')
  print,'annotating picture in ',gif
  cmd ='magick convert -font Verdana -pointsize 100 -fill black -gravity Northeast -annotate +20+20 '+string(year)+'  '+png+' '+gif
  print,cmd
  ; spawn
  spawn,cmd
  print, 'tidy up'
  FILE_DELETE,png,/ALLOW_NONEXISTENT
  return,gif
end


pro make_movie
  ; make movie
  compile_opt idl2, hidden
  on_error, 2

 ; we *need* convert or magick
  ; in the path, so test for that
  if get_magick() eq '0' then begin
    print, 'Error: cannot make gifs'
    print,'unless you install ImageMagick'
    print,'see: https://imagemagick.org/'
    return
  endif

  cd, CURRENT=dir
  inputs = File_Search(dir, '????/????_Shenzhen')
  N = N_Elements(inputs)
  print,'Found ',N,' datasets'
  gstring = ''
  
  For i=0, N-1 DO BEGIN
    print,i,' ',N
    raster = inputs[i]
    gif = make_gif(raster)
    gstring = gstring + ' ' + gif
  Endfor

  movie = 'class_movie.gif'
  print,'making movie of files so far to ',movie
  ; whilst wildcards work for most sensible 
  ; operating systems, this bums out for windows
  ; so need to do explicitly,
  cmd = 'magick convert -delay 100 -loop 0 '+gstring+' '+movie
  spawn,cmd
end
