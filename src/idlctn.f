
      SUBROUTINE IDLCTN(NDP, XD, YD, NT, IPT, NL, IPL, XII, YII, ITI,   IDL   10
     *  IWK, WK)
C THIS SUBROUTINE LOCATES A POINT, I.E., DETERMINES TO WHAT TRI-
C ANGLE A GIVEN POINT (XII,YII) BELONGS.  WHEN THE GIVEN POINT
C DOES NOT LIE INSIDE THE DATA AREA, THIS SUBROUTINE DETERMINES
C THE BORDER LINE SEGMENT WHEN THE POINT LIES IN AN OUTSIDE
C RECTANGULAR AREA, AND TWO BORDER LINE SEGMENTS WHEN THE POINT
C LIES IN AN OUTSIDE TRIANGULAR AREA.
C THE INPUT PARAMETERS ARE
C     NDP = NUMBER OF DATA POINTS,
C     XD,YD = ARRAYS OF DIMENSION NDP CONTAINING THE X AND Y
C           COORDINATES OF THE DATA POINTS,
C     NT  = NUMBER OF TRIANGLES,
C     IPT = INTEGER ARRAY OF DIMENSION 3*NT CONTAINING THE
C           POINT NUMBERS OF THE VERTEXES OF THE TRIANGLES,
C     NL  = NUMBER OF BORDER LINE SEGMENTS,
C     IPL = INTEGER ARRAY OF DIMENSION 3*NL CONTAINING THE
C           POINT NUMBERS OF THE END POINTS OF THE BORDER
C           LINE SEGMENTS AND THEIR RESPECTIVE TRIANGLE
C           NUMBERS,
C     XII,YII = X AND Y COORDINATES OF THE POINT TO BE
C           LOCATED.
C THE OUTPUT PARAMETER IS
C     ITI = TRIANGLE NUMBER, WHEN THE POINT IS INSIDE THE
C           DATA AREA, OR
C           TWO BORDER LINE SEGMENT NUMBERS, IL1 AND IL2,
C           CODED TO IL1*(NT+NL)+IL2, WHEN THE POINT IS
C           OUTSIDE THE DATA AREA.
C THE OTHER PARAMETERS ARE
C     IWK = INTEGER ARRAY OF DIMENSION 18*NDP USED INTER-
C           NALLY AS A WORK AREA,
C     WK  = ARRAY OF DIMENSION 8*NDP USED INTERNALLY AS A
C           WORK AREA.
C DECLARATION STATEMENTS
      IMPLICIT DOUBLE PRECISION (A-D,P-Z)
      DIMENSION XD(NDP), YD(NDP), IPT(3*NT), IPL(3*NL), IWK(18*NDP),
     *  WK(8*NDP)
      DIMENSION NTSC(9), IDSC(9)
      COMMON /IDLC/ NIT, ITIPV
C STATEMENT FUNCTIONS
      SIDE(U1,V1,U2,V2,U3,V3) = (U1-U3)*(V2-V3) - (V1-V3)*(U2-U3)
      SPDT(U1,V1,U2,V2,U3,V3) = (U1-U2)*(U3-U2) + (V1-V2)*(V3-V2)
C PRELIMINARY PROCESSING
      NDP0 = NDP
      NT0 = NT
      NL0 = NL
      NTL = NT0 + NL0
      X0 = XII
      Y0 = YII
C PROCESSING FOR A NEW SET OF DATA POINTS
      IF (NIT.NE.0) GO TO 80
      NIT = 1
C - DIVIDES THE X-Y PLANE INTO NINE RECTANGULAR SECTIONS.
      XMN = XD(1)
      XMX = XMN
      YMN = YD(1)
      YMX = YMN
      DO 10 IDP=2,NDP0
        XI = XD(IDP)
        YI = YD(IDP)
        XMN = DMIN1(XI,XMN)
        XMX = DMAX1(XI,XMX)
        YMN = DMIN1(YI,YMN)
        YMX = DMAX1(YI,YMX)
   10 CONTINUE
      XS1 = (XMN+XMN+XMX)/3.0
      XS2 = (XMN+XMX+XMX)/3.0
      YS1 = (YMN+YMN+YMX)/3.0
      YS2 = (YMN+YMX+YMX)/3.0
C - DETERMINES AND STORES IN THE IWK ARRAY TRIANGLE NUMBERS OF
C - THE TRIANGLES ASSOCIATED WITH EACH OF THE NINE SECTIONS.
      DO 20 ISC=1,9
        NTSC(ISC) = 0
        IDSC(ISC) = 0
   20 CONTINUE
      IT0T3 = 0
      JWK = 0
      DO 70 IT0=1,NT0
        IT0T3 = IT0T3 + 3
        I1 = IPT(IT0T3-2)
        I2 = IPT(IT0T3-1)
        I3 = IPT(IT0T3)
        XMN = DMIN1(XD(I1),XD(I2),XD(I3))
        XMX = DMAX1(XD(I1),XD(I2),XD(I3))
        YMN = DMIN1(YD(I1),YD(I2),YD(I3))
        YMX = DMAX1(YD(I1),YD(I2),YD(I3))
        IF (YMN.GT.YS1) GO TO 30
        IF (XMN.LE.XS1) IDSC(1) = 1
        IF (XMX.GE.XS1 .AND. XMN.LE.XS2) IDSC(2) = 1
        IF (XMX.GE.XS2) IDSC(3) = 1
   30   IF (YMX.LT.YS1 .OR. YMN.GT.YS2) GO TO 40
        IF (XMN.LE.XS1) IDSC(4) = 1
        IF (XMX.GE.XS1 .AND. XMN.LE.XS2) IDSC(5) = 1
        IF (XMX.GE.XS2) IDSC(6) = 1
   40   IF (YMX.LT.YS2) GO TO 50
        IF (XMN.LE.XS1) IDSC(7) = 1
        IF (XMX.GE.XS1 .AND. XMN.LE.XS2) IDSC(8) = 1
        IF (XMX.GE.XS2) IDSC(9) = 1
   50   DO 60 ISC=1,9
          IF (IDSC(ISC).EQ.0) GO TO 60
          JIWK = 9*NTSC(ISC) + ISC
          IWK(JIWK) = IT0
          NTSC(ISC) = NTSC(ISC) + 1
          IDSC(ISC) = 0
   60   CONTINUE
C - STORES IN THE WK ARRAY THE MINIMUM AND MAXIMUM OF THE X AND
C - Y COORDINATE VALUES FOR EACH OF THE TRIANGLE.
        JWK = JWK + 4
        WK(JWK-3) = XMN
        WK(JWK-2) = XMX
        WK(JWK-1) = YMN
        WK(JWK) = YMX
   70 CONTINUE
      GO TO 110
C CHECKS IF IN THE SAME TRIANGLE AS PREVIOUS.
   80 IT0 = ITIPV
      IF (IT0.GT.NT0) GO TO 90
      IT0T3 = IT0*3
      IP1 = IPT(IT0T3-2)
      X1 = XD(IP1)
      Y1 = YD(IP1)
      IP2 = IPT(IT0T3-1)
      X2 = XD(IP2)
      Y2 = YD(IP2)
      IF (SIDE(X1,Y1,X2,Y2,X0,Y0).LT.0.0) GO TO 110
      IP3 = IPT(IT0T3)
      X3 = XD(IP3)
      Y3 = YD(IP3)
      IF (SIDE(X2,Y2,X3,Y3,X0,Y0).LT.0.0) GO TO 110
      IF (SIDE(X3,Y3,X1,Y1,X0,Y0).LT.0.0) GO TO 110
      GO TO 170
C CHECKS IF ON THE SAME BORDER LINE SEGMENT.
   90 IL1 = IT0/NTL
      IL2 = IT0 - IL1*NTL
      IL1T3 = IL1*3
      IP1 = IPL(IL1T3-2)
      X1 = XD(IP1)
      Y1 = YD(IP1)
      IP2 = IPL(IL1T3-1)
      X2 = XD(IP2)
      Y2 = YD(IP2)
      IF (IL2.NE.IL1) GO TO 100
      IF (SPDT(X1,Y1,X2,Y2,X0,Y0).LT.0.0) GO TO 110
      IF (SPDT(X2,Y2,X1,Y1,X0,Y0).LT.0.0) GO TO 110
      IF (SIDE(X1,Y1,X2,Y2,X0,Y0).GT.0.0) GO TO 110
      GO TO 170
C CHECKS IF BETWEEN THE SAME TWO BORDER LINE SEGMENTS.
  100 IF (SPDT(X1,Y1,X2,Y2,X0,Y0).GT.0.0) GO TO 110
      IP3 = IPL(3*IL2-1)
      X3 = XD(IP3)
      Y3 = YD(IP3)
      IF (SPDT(X3,Y3,X2,Y2,X0,Y0).LE.0.0) GO TO 170
C LOCATES INSIDE THE DATA AREA.
C - DETERMINES THE SECTION IN WHICH THE POINT IN QUESTION LIES.
 110  ISC = 1
      IF (X0.GE.XS1) ISC = ISC + 1
      IF (X0.GE.XS2) ISC = ISC + 1
      IF (Y0.GE.YS1) ISC = ISC + 3
      IF (Y0.GE.YS2) ISC = ISC + 3
C - SEARCHES THROUGH THE TRIANGLES ASSOCIATED WITH THE SECTION.
      NTSCI = NTSC(ISC)
      IF (NTSCI.LE.0) GO TO 130
      JIWK = -9 + ISC
      DO 120 ITSC=1,NTSCI
        JIWK = JIWK + 9
        IT0 = IWK(JIWK)
        JWK = IT0*4
        IF (X0.LT.WK(JWK-3)) GO TO 120
        IF (X0.GT.WK(JWK-2)) GO TO 120
        IF (Y0.LT.WK(JWK-1)) GO TO 120
        IF (Y0.GT.WK(JWK)) GO TO 120
        IT0T3 = IT0*3
        IP1 = IPT(IT0T3-2)
        X1 = XD(IP1)
        Y1 = YD(IP1)
        IP2 = IPT(IT0T3-1)
        X2 = XD(IP2)
        Y2 = YD(IP2)
        IF (SIDE(X1,Y1,X2,Y2,X0,Y0).LT.0.0) GO TO 120
        IP3 = IPT(IT0T3)
        X3 = XD(IP3)
        Y3 = YD(IP3)
        IF (SIDE(X2,Y2,X3,Y3,X0,Y0).LT.0.0) GO TO 120
        IF (SIDE(X3,Y3,X1,Y1,X0,Y0).LT.0.0) GO TO 120
        GO TO 170
  120 CONTINUE
C LOCATES OUTSIDE THE DATA AREA.
  130 DO 150 IL1=1,NL0
        IL1T3 = IL1*3
        IP1 = IPL(IL1T3-2)
        X1 = XD(IP1)
        Y1 = YD(IP1)
        IP2 = IPL(IL1T3-1)
        X2 = XD(IP2)
        Y2 = YD(IP2)
        IF (SPDT(X2,Y2,X1,Y1,X0,Y0).LT.0.0) GO TO 150
        IF (SPDT(X1,Y1,X2,Y2,X0,Y0).LT.0.0) GO TO 140
        IF (SIDE(X1,Y1,X2,Y2,X0,Y0).GT.0.0) GO TO 150
        IL2 = IL1
        GO TO 160
  140   IL2 = MOD(IL1,NL0) + 1
        IP3 = IPL(3*IL2-1)
        X3 = XD(IP3)
        Y3 = YD(IP3)
        IF (SPDT(X3,Y3,X2,Y2,X0,Y0).LE.0.0) GO TO 160
  150 CONTINUE
      IT0 = 1
      GO TO 170
  160 IT0 = IL1*NTL + IL2
C NORMAL EXIT
  170 ITI = IT0
      ITIPV = IT0
      RETURN
      END