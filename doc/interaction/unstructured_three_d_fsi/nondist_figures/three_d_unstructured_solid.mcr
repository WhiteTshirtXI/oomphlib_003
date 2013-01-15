#!MC 1100

$!VARSET |lostep|=1
$!VARSET |nstep|=3
$!VARSET |dstep|=1

$!VARSET |PNG|=1
$!VARSET |potential|=0


$!NEWLAYOUT 

$!IF |PNG|==0
     $!EXPORTSETUP EXPORTFORMAT = AVI
     $!EXPORTSETUP IMAGEWIDTH = 806
     $!EXPORTSETUP EXPORTFNAME = 'unstructured_solid.avi'
     $!EXPORTSTART 
       EXPORTREGION = CURRENTFRAME
$!ENDIF

$!LOOP |nstep|

$!VARSET |step|=(|lostep|+(|loop|-1)*|dstep|)

$!DRAWGRAPHICS FALSE

$!READDATASET  '"RESLT/solid_soln|step|.dat" ' 
  READDATAOPTION = NEW
  RESETSTYLE = YES
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARNAMELIST = '"V1" "V2" "V3" "V4" "V5" "V6" "V7"' 

$!VARSET |nbulk|=|NUMZONES|
$!VARSET |first_tract|=(|NUMZONES|+1)

$!FIELDMAP [1-|nbulk|]  GROUP = 2

$!READDATASET  '"RESLT/fsi_traction|step|.dat" ' 
  READDATAOPTION = APPEND
  RESETSTYLE = NO
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYPOSITION
  ASSIGNSTRANDIDS = YES
  INITIALPLOTTYPE = CARTESIAN3D
  VARPOSITIONLIST =  [1-7]

$!VARSET |last_tract|=|NUMZONES|

$!FIELDLAYERS SHOWMESH = NO
$!FIELDMAP [1-|nbulk|]  VECTOR{SHOW = NO}
$!FIELDMAP [1-|nbulk|]  EDGELAYER{COLOR = BLACK}
$!FIELDLAYERS SHOWSHADE = YES
$!FIELDMAP [1-|nbulk|]  EDGELAYER{LINETHICKNESS = 0.1}
$!GLOBALTHREEDVECTOR UVAR = 4
$!GLOBALTHREEDVECTOR VVAR = 5
$!GLOBALTHREEDVECTOR WVAR = 6
$!RESETVECTORLENGTH 
$!FIELDLAYERS SHOWVECTOR = YES
$!ACTIVEFIELDMAPS += [|first_tract|-|last_tract|]
$!FIELDMAP [|first_tract|-|last_tract|]  VECTOR{COLOR = RED}
$!FIELDMAP [|first_tract|-|last_tract|]  EDGELAYER{COLOR = BLUE}
$!FIELDMAP [|first_tract|-|last_tract|]  VECTOR{VECTORTYPE = HEADATPOINT}
$!FIELDMAP [|first_tract|-|last_tract|]  VECTOR{LINETHICKNESS = 0.1}
$!GLOBALTHREEDVECTOR HEADSIZEASFRACTION = 0.3
$!FIELDMAP [1-|last_tract|]  EDGELAYER{EDGETYPE = BORDERSANDCREASES}
$!REDRAWALL 
$!THREEDVIEW 
  PSIANGLE = 76.7491
  THETAANGLE = 197.65
  ALPHAANGLE = 0
  VIEWERPOSITION
    {
    X = 31.04679948423801
    Y = 100.4335509604116
    Z = 24.32669833038877
    }
$!VIEW PUSH
$!FIELDLAYERS USETRANSLUCENCY = YES
$!GLOBALTHREEDVECTOR RELATIVELENGTH = 1.0


$!THREEDAXIS XDETAIL{SHOWAXIS = NO}
$!THREEDAXIS YDETAIL{SHOWAXIS = NO}
$!THREEDAXIS ZDETAIL{SHOWAXIS = NO}

$!THREEDAXIS FRAMEAXIS{XYPOS{X = 11.517667845}}
$!THREEDAXIS FRAMEAXIS{XYPOS{Y = 82.276311799}}



$!THREEDVIEW 
  PSIANGLE = 171.604
  THETAANGLE = 117.909
  ALPHAANGLE = -61.9532
  VIEWERPOSITION
    {
    X = -9.659429790643696
    Y = 6.645903173045941
    Z = -75.96546766960743
    }
$!VIEW PUSH



$!IF |potential|==1

        $!CREATERECTANGULARZONE 
          IMAX = 2
          JMAX = 2
          KMAX = 2
          X1 = -1
          Y1 = -1
          Z1 = -1
          X2 = 1
          Y2 = 1
          Z2 = 2
          XVAR = 1
          YVAR = 2
          ZVAR = 3

        $!THREEDVIEW 
          PSIANGLE = 141.286
          THETAANGLE = 175.153
          ALPHAANGLE = -61.9532 
          VIEWERPOSITION
           {
           X = -2.9881471229945
           Y = 51.23433257575995
           Z = -62.99535815399609
           }
        $!VIEW PUSH

$!ELSE

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

          $!THREEDVIEW 
            PSIANGLE = 135.686
            THETAANGLE = -140.783
            ALPHAANGLE = -60.5945
            VIEWERPOSITION
              {
               X = 47.23613522862746
               Y = 57.47153351466326
               Z = -69.43548262207702
              }
          $!VIEW PUSH


$!ENDIF


$!FIELDLAYERS USETRANSLUCENCY = NO
$!REDRAWALL 
$!GLOBALTHREEDVECTOR RELATIVELENGTH = 5



$!ACTIVEFIELDMAPS += [|NUMZONES|]
$!VIEW FIT
$!FIELDMAP [|NUMZONES|]  SHADE{SHOW = NO}
$!FIELDMAP [|NUMZONES|]  EDGELAYER{COLOR = BLUE}
$!ACTIVEFIELDMAPS -= [|NUMZONES|]


$!GLOBALTHREED 
  LIGHTSOURCE
    {
    XYZDIRECTION
      {
      X = 0.365062340002
      Y = -0.718592964824
      Z = 0.591906782203
      }
    }






#$!ATTACHTEXT 
#  ANCHORPOS
#    {
#    X = 25.44169611307421
#    Y = 89.59294984029967
#    }
#  TEXTSHAPE
#    {
#    FONT = HELV
#    HEIGHT = 12
#    }
#  TEXT = 'step:  |step|' 


$!DRAWGRAPHICS TRUE
$!REDRAWALL


$!IF |PNG|==1
     $!EXPORTSETUP EXPORTFORMAT = PNG
     $!EXPORTSETUP IMAGEWIDTH = 600
     $!EXPORTSETUP EXPORTFNAME = 'unstructured_solid|loop|.png'
     $!EXPORT
       EXPORTREGION = ALLFRAMES
$!ELSE
     $!EXPORTNEXTFRAME
$!ENDIF

$!ENDLOOP

$!IF |PNG|==0
$!EXPORTFINISH
$!ENDIF
