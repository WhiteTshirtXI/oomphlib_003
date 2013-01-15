#!MC 1000

$!VARSET |PNG|=0


#$!GETUSERINPUT |lostep| INSTRUCTIONS = "Loop. First Step??"
$!VARSET  |lostep|=0
#$!GETUSERINPUT |dlstep| INSTRUCTIONS = "Loop. Step Increment?"
$!VARSET  |dlstep|=1
$!GETUSERINPUT |nstep| INSTRUCTIONS = "Loop. Number of Steps??"

$!LOOP |nstep|
$!VarSet |nnstep| = |LOOP|
$!VarSet |nnstep| -= 1
$!VarSet |iistep| = |dlstep|
$!VarSet |iistep| *= |nnstep|
$!VarSet |iistep| += |lostep|
$!NEWLAYOUT
$!DRAWGRAPHICS FALSE
#    $!IF |iistep| < 10 
#      $!VARSET |istep|='00|iistep|'
#    $!ENDIF
#    $!IF |iistep| > 9 
#      $!VARSET |istep|='0|iistep|'
#    $!ENDIF
#    $!IF |iistep| > 99 
#      $!VARSET |istep|=|iistep|
#    $!ENDIF
$!VARSET |istep|=|iistep|
$!VARSET |istep|+=1
#$!VARSET |istep|*=10

$!VarSet |LFDSFN1| = '"RESLT/soln|istep|.dat"'
$!VarSet |LFDSVL1| = '"V1" "V2" "V3"'
$!VarSet |LFDSFN2| = '"RESLT/exact_soln|istep|.dat"'
$!VarSet |LFDSVL2| = '"V1" "V2" "V3"'
$!SETSTYLEBASE FACTORY
$!PAPER 
  BACKGROUNDCOLOR = WHITE
  ISTRANSPARENT = YES
  ORIENTPORTRAIT = NO
  SHOWGRID = YES
  SHOWRULER = YES
  SHOWPAPER = YES
  PAPERSIZE = A4
  PAPERSIZEINFO
    {
    A3
      {
      WIDTH = 11.693
      HEIGHT = 16.535
      }
    A4
      {
      WIDTH = 8.2677
      HEIGHT = 11.693
      LEFTHARDCLIPOFFSET = 0.125
      RIGHTHARDCLIPOFFSET = 0.125
      TOPHARDCLIPOFFSET = 0.125
      BOTTOMHARDCLIPOFFSET = 0.125
      }
    }
  RULERSPACING = ONECENTIMETER
  PAPERGRIDSPACING = ONETENTHCENTIMETER
  REGIONINWORKAREA
    {
    X1 = -0.05
    Y1 = -0.05
    X2 = 11.74
    Y2 = 8.318
    }
$!COLORMAP 
  CONTOURCOLORMAP = SMRAINBOW
$!COLORMAPCONTROL RESETTOFACTORY
### Frame Number 1 ###
$!READDATASET  '|LFDSFN1|' 
  READDATAOPTION = NEW
  RESETSTYLE = YES
  INITIALPLOTTYPE = CARTESIAN3D
  INCLUDETEXT = YES
  INCLUDEGEOM = YES
  INCLUDECUSTOMLABELS = NO
  VARLOADMODE = BYNAME
  VARNAMELIST = '|LFDSVL1|' 
$!REMOVEVAR |LFDSVL1|
$!REMOVEVAR |LFDSFN1|

$!VARSET |ORIG_ZONES|=|NUMZONES|
$!VARSET |START_COPY|=|NUMZONES|
$!VARSET |START_COPY|+=1
$!VARSET |END_COPY|=|NUMZONES|
$!VARSET |END_COPY|*=2


$!READDATASET  '|LFDSFN2|' 
  INITIALPLOTTYPE = CARTESIAN3D
  INCLUDETEXT = NO
  INCLUDEGEOM = NO
  READDATAOPTION = APPEND
  RESETSTYLE = NO
  VARLOADMODE = BYNAME
  VARNAMELIST = '|LFDSVL2|' 
$!REMOVEVAR |LFDSVL2|
$!REMOVEVAR |LFDSFN2|
$!FRAMELAYOUT 
  SHOWBORDER = NO
  HEADERCOLOR = RED
  XYPOS
    {
    X = 0.3937
    Y = 0.3937
    }
  WIDTH = 10.906
  HEIGHT = 7.4803
$!PLOTTYPE  = CARTESIAN3D
$!FRAMENAME  = 'Frame 001' 
$!ACTIVEFIELDZONES  =  [1-|NUMZONES|]
$!GLOBALRGB 
  RANGEMIN = 0
  RANGEMAX = 1
$!GLOBALCONTOUR  1
  VAR = 3
  DEFNUMLEVELS = 10
  LEGEND
    {
    XYPOS
      {
      X = 95
      }
    }
  COLORCUTOFF
    {
    RANGEMIN = 0.236137379892
    RANGEMAX = 0.749779141508
    }
  COLORMAPFILTER
    {
    CONTINUOUSCOLOR
      {
      CMIN = -0.0206835009158
      CMAX = 1.00660002232
      }
    }
$!CONTOURLEVELS NEW
  CONTOURGROUP = 1
  RAWDATA
10
0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
$!GLOBALCONTOUR  2
  LEGEND
    {
    XYPOS
      {
      X = 95
      }
    }
  COLORMAPFILTER
    {
    CONTINUOUSCOLOR
      {
      CMIN = 0
      CMAX = 1
      }
    }
$!GLOBALCONTOUR  3
  LEGEND
    {
    XYPOS
      {
      X = 95
      }
    }
  COLORMAPFILTER
    {
    CONTINUOUSCOLOR
      {
      CMIN = 0
      CMAX = 1
      }
    }
$!GLOBALCONTOUR  4
  LEGEND
    {
    XYPOS
      {
      X = 95
      }
    }
  COLORMAPFILTER
    {
    CONTINUOUSCOLOR
      {
      CMIN = 0
      CMAX = 1
      }
    }
$!GLOBALSCATTER 
  LEGEND
    {
    XYPOS
      {
      X = 95
      }
    }
  REFSCATSYMBOL
    {
    COLOR = RED
    FILLCOLOR = RED
    }

$!FIELD  [1-|ORIG_ZONES|]
  MESH
    {
    COLOR = RED
    }
  CONTOUR
    {
    CONTOURTYPE = FLOOD
    COLOR = RED
    USELIGHTINGEFFECT = YES
    }
  VECTOR
    {
    COLOR = RED
    }
  SCATTER
    {
    COLOR = RED
    }
  SHADE
    {
    COLOR = CUSTOM35
    }
  BOUNDARY
    {
    SHOW = YES
    COLOR = CUSTOM36
    LINETHICKNESS = 0.02
    }
  POINTS
    {
    POINTSTOPLOT = SURFACENODES
    }
  SURFACES
    {
    SURFACESTOPLOT = KPLANES
    }
  VOLUMEMODE
    {
    VOLUMEOBJECTSTOPLOT
      {
      SHOWISOSURFACES = NO
      SHOWSLICES = NO
      SHOWSTREAMTRACES = NO
      }
    }



$!FIELD  [|START_COPY|-|NUMZONES|]
  MESH
    {
    COLOR = CYAN
    }
  CONTOUR
    {
    CONTOURTYPE = FLOOD
    COLOR = CYAN
    USELIGHTINGEFFECT = YES
    }
  VECTOR
    {
    COLOR = CYAN
    }
  SCATTER
    {
    COLOR = CYAN
    }
  SHADE
    {
    COLOR = CUSTOM50
    }
  BOUNDARY
    {
    SHOW = YES
    COLOR = RED
    LINETHICKNESS = 0.02
    }
  POINTS
    {
    POINTSTOPLOT = SURFACENODES
    }
  SURFACES
    {
    SURFACESTOPLOT = KPLANES
    }
  VOLUMEMODE
    {
    VOLUMEOBJECTSTOPLOT
      {
      SHOWISOSURFACES = NO
      SHOWSLICES = NO
      SHOWSTREAMTRACES = NO
      }
    }
  GROUP = 2




$!THREEDAXIS 
  XDETAIL
    {
    VARNUM = 1
    }
  YDETAIL
    {
    VARNUM = 2
    }
  ZDETAIL
    {
    VARNUM = 3
    }
$!VIEW FIT
$!THREEDAXIS 
  AXISMODE = INDEPENDENT
  XYDEPXTOYRATIO = 1
  DEPXTOYRATIO = 1
  DEPXTOZRATIO = 1
  GRIDAREA
    {
    ISFILLED = NO
    }
$!THREEDAXIS 
  XDETAIL
    {
    RANGEMIN = -0.05
    RANGEMAX = 1.15
    GRSPACING = 0.2
    TITLE
      {
      TITLEMODE = USETEXT
      TEXT = 'x' 
      }
    AXISLINE
      {
      EDGE = 2
      }
    }
$!THREEDAXIS 
  YDETAIL
    {
    RANGEMIN = -0.05
    RANGEMAX = 1.15
    GRSPACING = 0.5
    TITLE
      {
      TITLEMODE = USETEXT
      TEXT = 'y' 
      }
    AXISLINE
      {
      EDGE = 3
      }
    }
$!THREEDAXIS 
  ZDETAIL
    {
    RANGEMIN = -1.1
    RANGEMAX = 1.1
    GRSPACING = 0.2
    TITLE
      {
      TITLEMODE = USETEXT
      TEXT = 'u' 
      }
    AXISLINE
      {
      EDGE = 3
      }
    }
$!GLOBALISOSURFACE 
  ISOVALUE1 = 0.236137379892
  ISOVALUE2 = 0.4929582607
  ISOVALUE3 = 0.749779141508
  MARCHINGCUBEALGORITHM = CLASSICPLUS
$!GLOBALSLICE 
  BOUNDARY
    {
    SHOW = NO
    }
$!GLOBALTHREED 
  AXISSCALEFACT
    {
    X = 0.916666666667
    Y = 0.916666666667
    Z = 1
    }
  ROTATEORIGIN
    {
    X = 0.5
    Y = 0.55
    Z = 0.000974953174591
    }
  LIGHTSOURCE
    {
    INTENSITY = 75
    BACKGROUNDLIGHT = 30
    }
  LINELIFTFRACTION = 0.2
  SYMBOLLIFTFRACTION = 0.6
  VECTORLIFTFRACTION = 0.7
$!THREEDVIEW 
  PSIANGLE = 62.1074
  THETAANGLE = 296.654
  VIEWERPOSITION
    {
    X = 14.5331185947
    Y = -6.51875509948
    Z = 7.59560389637
    }
  VIEWWIDTH = 4.59558
$!FIELDLAYERS 
  SHOWMESH = NO
  SHOWSHADE = YES
  USETRANSLUCENCY = YES
$!ATTACHTEXT 
  ANCHORPOS
    {
    X = 76.4579329366
    Y = 9.88721246507
    }
  COLOR = CUSTOM36
  TEXTSHAPE
    {
    FONT = HELV
    }
  BOX
    {
    MARGIN = 10
    LINETHICKNESS = 0.4
    }
  SCOPE = GLOBAL
  TEXT = 'Calculated Solution' 
$!ATTACHTEXT 
  ANCHORPOS
    {
    X = 76.3278419259
    Y = 6.3259747871
    }
  COLOR = RED
  TEXTSHAPE
    {
    FONT = HELV
    }
  BOX
    {
    MARGIN = 10
    LINETHICKNESS = 0.4
    }
  SCOPE = GLOBAL
  TEXT = 'Exact Solution' 

$!SETSTYLEBASE CONFIG


$!THREEDAXIS AXISMODE = XYZDEPENDENT
$!THREEDAXIS DEPXTOZRATIO = 3


$!VIEW FIT


#------------------------
# don't show dummy zones
#------------------------
$!VARSET |LAST_BUT_ONE|=(|NUMZONES|-1)
$!ACTIVEFIELDZONES -= [|LAST_BUT_ONE|-|NUMZONES|]
$!VARSET |LAST_OF_FIRST|=(|NUMZONES|/2)
$!VARSET |LAST_BUT_ONE_OF_FIRST|=(|LAST_OF_FIRST|-1)
$!ACTIVEFIELDZONES -= [|LAST_BUT_ONE_OF_FIRST|-|LAST_OF_FIRST|]

############################


$!REDRAWALL


$!IF |PNG|==1


        $!EXPORTSETUP EXPORTFORMAT = PNG
        $!EXPORTSETUP IMAGEWIDTH = 600
        $!EXPORTSETUP EXPORTFNAME = 'un_heat_step_soln|istep|.png'
        $!EXPORT
          EXPORTREGION = CURRENTFRAME

        $!EXPORTSETUP EXPORTFORMAT = EPS
        $!EXPORTSETUP IMAGEWIDTH = 1423
        $!EXPORTSETUP EXPORTFNAME = 'un_heat_step_soln|istep|.eps'

        $!EXPORTSETUP PRINTRENDERTYPE = IMAGE
        $!EXPORTSETUP EXPORTFNAME = 'un_heat_step_soln|istep|.img.eps'
        $!EXPORT
          EXPORTREGION = CURRENTFRAME

$!ELSE

        $!IF |LOOP|>1
                $!EXPORTNEXTFRAME
        $!ELSE

                $!EXPORTSETUP
                 EXPORTFORMAT = AVI
                 EXPORTFNAME = "un_heat_step_soln.avi"
                $!EXPORTSETUP IMAGEWIDTH = 829
                $!EXPORTSTART
        $!ENDIF

$!ENDIF


$!VARSET |LAST_STEP|=|istep|

$!EndLoop


$!IF |PNG|==0
        $!EXPORTFINISH
$!ENDIF


#$!QUIT
