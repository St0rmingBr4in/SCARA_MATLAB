function DessinerSCARAVR=Dessiner_SCARA_VR(T1)
 
Angle=T1*(pi/180);

SCARAVR=vrworld('oneddl.wrl');
open(SCARAVR);
SCARAVR.joint1.rotation=[0, 1, 0, Angle];