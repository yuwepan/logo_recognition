import cv2
import sys

cascPath      = sys.argv[1]
faceCascade   = cv2.CascadeClassifier(cascPath)
video_capture = cv2.VideoCapture(0)

#img_sc        = cv.CreateMat

while True:
    # Capture frame-by-frame
    ret, frame = video_capture.read()
    #frame = cv2.imread('I:\A-D\CAD-KI\Projekte\MarkerErkennung\Marker\IMG_20180207_093213.jpg')
    gray       = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces      = faceCascade.detectMultiScale(gray, scaleFactor=1.05, minNeighbors=5 )

    # Draw a rectangle around the faces
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)

    # Display the resulting frame
    cv2.imshow('Mercedes Logo Detector', frame)

    if cv2.waitKey(33) & 0xFF == ord('q'):
        break

# When everything is done, release the capture
video_capture.release()
cv2.destroyAllWindows()