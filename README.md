# Turning back AR: See AR object when turning to your back

### Usage
1. Turn your body when holding the phone, when the yaw value is larger than 160 a cube will appear on the floor
2. The cube will spin for a few seconds and disappear when you are close enough to the cube. Otherwise, it will remain at the location where it appeared
3. After the cube disappears, go back to step 1 to make it appear again

### Features
- Shows 3D object with ARView
- Utilizes CoreMotion to get the turning angle
- Implements triggers to start a motion when the user is close enough to the cube and inform the code when the motion ends to remove the cube

### Caution!!
- This app requires Xcode 14 to run since it is using the "Experience" Reality File
