#!MC 1120

$!VARSET |lostep|=0
$!VARSET |nstep|=12
$!VARSET |dstep|=1

$!VARSET |PNG|=1


$!IF |PNG|==0
     $!EXPORTSETUP EXPORTFORMAT = AVI
     $!EXPORTSETUP IMAGEWIDTH = 806
     $!EXPORTSETUP EXPORTFNAME = 'boundary_test.avi'
     $!EXPORTSTART 
       EXPORTREGION = CURRENTFRAME
$!ENDIF

$!LOOP |nstep|

$!VARSET |step|=(|lostep|+(|loop|-1)*|dstep|)

$!DRAWGRAPHICS FALSE


$!NEWLAYOUT 


$!READDATASET  '"RESLT/fluid_boundary_coordinates|step|.dat" '
  READDATAOPTION = NEW
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"V1" "V2" "V3" "V4" "V5"'



$!VARSET |last_boundary|=|NUMZONES|
$!VARSET |first_mesh|=(|NUMZONES|+1)


$!FIELDLAYERS SHOWMESH = NO
$!GLOBALCONTOUR 1  VAR = 5
$!CONTOURLEVELS RESETTONICE
  CONTOURGROUP = 1
  APPROXNUMVALUES = 15
$!FIELDLAYERS SHOWCONTOUR = YES
$!FIELDMAP [1-|last_boundary|]  EDGELAYER{COLOR = BLACK}
$!FIELDMAP [1-|last_boundary|]  EDGELAYER{LINETHICKNESS = 0.100000000000000006}
$!FIELDMAP [1-|last_boundary|]  GROUP = 2

$!READDATASET  '"RESLT/fluid_soln0.dat" '
  READDATAOPTION = APPEND
  RESETSTYLE = NO
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"V1" "V2" "V3" "V4" "V5"'

$!VARSET |last_mesh|=|NUMZONES|

$!FIELDMAP [1-|last_mesh|]  EDGELAYER{COLOR = BLACK}
$!ACTIVEFIELDMAPS += [1-|last_mesh|]
$!FIELDMAP [|first_mesh|-|last_mesh|]  CONTOUR{SHOW = NO}
$!FIELDMAP [|first_mesh|-|last_mesh|]  EDGELAYER{EDGETYPE = CREASES}
$!FIELDMAP [|first_mesh|-|last_mesh|]  EDGELAYER{LINETHICKNESS = 0.10}

$!VIEW PUSH
$!THREEDVIEW 
  PSIANGLE = 127.956
  THETAANGLE = -45.0942
  ALPHAANGLE = 59.3464
  VIEWERPOSITION
    {
    X = 30.62733949599254
    Y = -32.00591615836889
    Z = -27.88421407503599
    }
$!VIEW PUSH


        $!CREATERECTANGULARZONE 
          IMAX = 2
          JMAX = 2
          KMAX = 2
          X1 = -1.5
          Y1 = -3
          Z1 = -1
          X2 = 1.5
          Y2 = 5
          Z2 = 12
          XVAR = 1
          YVAR = 2
          ZVAR = 3
$!ACTIVEFIELDMAPS += [|NUMZONES|]

$!VIEW FIT
$!VIEW PUSH

$!ACTIVEFIELDMAPS -= [|NUMZONES|]

$!DRAWGRAPHICS TRUE
$!REDRAWALL


$!IF |PNG|==1
     $!EXPORTSETUP EXPORTFORMAT = PNG
     $!EXPORTSETUP IMAGEWIDTH = 600
     $!EXPORTSETUP EXPORTFNAME = 'boundary_test|loop|.png'
     $!EXPORT
       EXPORTREGION = ALLFRAMES
$!ELSE
     $!EXPORTNEXTFRAME
$!ENDIF

$!ENDLOOP

$!IF |PNG|==0
$!EXPORTFINISH
$!ENDIF
