import cv2
import sys
import os

indir  = r'.\Input'
outdir = r'.\Output'
fileext = '.tif'

cascPath = sys.argv[1]
markerCascade = cv2.CascadeClassifier(cascPath)
def img_Resize ( imgSrc, scale ):
    return cv2.resize( imgSrc, None, fx=scale, fy=scale, interpolation=cv2.INTER_AREA )
    
    
for root, dirs, filenames in os.walk(indir):
    for fn in filenames:
        if fn.endswith(fileext):
            fullname = os.path.join(root, fn)
    
            frame    = cv2.imread(fullname) 
            bf,hf,tf = frame.shape
            gray     = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

            markers = markerCascade.detectMultiScale(gray, scaleFactor = 1.2, minNeighbors = 3)
            anz=0
            for (x, y, w, h) in markers:
                #cv2.drawMarker(frame, (x+w/2,y+h/2), (0, 0, 255), cv2.MARKER_CROSS, 100, 3, cv2.LINE_AA)
                cv2.rectangle(frame, (x-2, y-2), (x+w+2, y+h+2), (0, 255, 0), 2)
            #outfile = '%s_marked.png' % (os.path.join(outdir, fn))  
            #cv2.imwrite(outfile, frame)
                print x, y, w, h
                if x+w < bf and y+h < hf: 
                  detail = frame [ y-2:y+h+2,x-2:x+w+2]
                  sx = 1.05*(32.0/float(w))
                  print "Anz:", anz, frame.shape, sx
                  detail32x32 = img_Resize ( detail, sx )
                  #-----------------------------
                  #print detail.shape
                  #cv2.imshow('Mercedes Logo Detector', detail)
                  #cv2.waitKey(1)
                  outfile = fullname + str(anz)+'_Negativ.png' 
                  cv2.imwrite(outfile, detail32x32)
                anz += 1
            # Display the resulting frame
            
            
            sx = 1200.0/float(bf)
            print "Anz:", anz, frame.shape, sx
            img = img_Resize ( frame, sx )
            #cv2.imshow('Mercedes Logo Detector', img)
            outfile = '%s_marked.png' % (os.path.join(outdir, fn))  
            cv2.imwrite(outfile, frame)
            #while (1):
            #cv2.waitKey(3000)
                #if cv2.waitKey(33) & 0xFF == ord('q'):
            #        break   
                
            

                




