)ATTR DEFAULT(%+_)
  | AREA(DYNAMIC) SCROLL(ON) EXTEND(ON)
  @ TYPE(OUTPUT) INTENS(HIGH) CAPS(OFF) JUST(ASIS)
  # TYPE(OUTPUT) INTENS(LOW) CAPS(OFF) JUST(ASIS)
  _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(PINK) HILITE(USCORE)
  ] TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(PINK) HILITE(USCORE)
  [ TYPE(INPUT) INTENS(HIGH) CAPS(OFF) JUST(LEFT) COLOR(PINK) HILITE(USCORE)
  { TYPE(OUTPUT) INTENS(HIGH) CAPS(ON) JUST(ASIS) COLOR(BLUE)
  } TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(PINK)
)BODY WIDTH(80)
+                   %ADD TASK TO ASSIGNMENT &IPROJNO   +
%COMMAND ===>}ZCMD

@IDESC                                            +
+Type       ]NTYP    +  (See list of valid types below)
+Name       [Z                                                 +
+Action     _Z       +  (C-Compile, D-Delete, F-Fallback, H-History)
+Application_Z       +  (Default=&IA)      +SubAppl_Z       +(Default=&ISA)
+Stream     _Z       +  (Default=&IS)
+Path       _Z   +      &patha
+                       &pathb
+Filter     _Z   +      &filtera
+                       &filterb
+Release    _IMPLNO    +(Default=&IR )
+Import     _Z+         (Import From External Source Y/N)
@typesa
@typesb




+&usertip
+Press%ENTER+to add entry,%END+to terminate
)INIT
  .ZVARS = '(NTMNAME NEWACT NTAPPLID NTSUBAPL NTSTREAM NTSLVL NTBLVL NTIMPORT)'
  &usertip = 'Place cursor in Type, Path or Filter and press PF1 for the +
    complete list'
  /* Add Support for NOTE member name generation */
  &x        = ')'
  &TEMP     = TRUNC(&IPROJNO,4)
  &NOTESUF  = .TRAIL
  &TEMP1    = TRUNC(&IPROJNO,6)
  &NOTESUF  = .TRAIL
  &NOTEMEM = '&TEMP.&NOTESUF.'
  /* Add Support for NOTE member name generation */
  If (&WZZWCAPS = N)
    .ATTRCHAR([) = 'CAPS(OFF)'
  Else
    .ATTRCHAR([) = 'CAPS(ON)'

  If (&INHARLSE = Y)
    .ATTR(IMPLNO) = 'TYPE(OUTPUT) COLOR(BLUE)'
  Else
    .ATTR(IMPLNO) = 'TYPE(INPUT) COLOR(PINK)'

  &NEWACT = &NACTION
  IF (&NTIMPORT NE 'Y')
    &NTIMPORT = 'N'
  if (&IA = &Z)
    &IA = &NTAPPLID
  if (&ISA = &Z)
    &ISA = &NTSUBAPL
  if (&IS = &Z)
    &IS = &NTSTREAM
  if (&IR = &Z)
    &IR = &IMPLNO
  &NTYP = &NTMTYPE
  .HELP = WZHPSA#
/*.CURSOR = NTYP   */
  IF (&deferver = 'Y')
    &deferver = &Z
    IF (&ZAPPLID NE 'ISP','ISR')
      .RESP = ENTER

  &dohelp = '0'

*REXX(*,path,filtera,filterb,taplvls,tahlvls,taslvls,TAMTYPES,
    typesa,typesb,patha,pathb,dohelp,(WZZTA#1))

)REINIT
  REFRESH(*)

  &dohelp = '0'

*REXX(*,taplvls,tahlvls,taslvls,TAMTYPES,NTYP,NTSLVL,NTBLVL,
    section,dohelp,SAREA0L,(WZZTA#1))
)PROC
  /* Repository Add Support - APPL and STREAM can be blank */
  VER (&NTIMPORT,NB,LIST,'Y','N')
  &DSNM01 = TRUNC (&NWORKPDS,1)
  IF (&DSNM01 = '''')
    &DSNM02 = .TRAIL
    &DSNM03 = TRUNC (&DSNM02,'''')
    IF (&DSNM02 = &DSNM03)
      &NWORKPDS = '&NWORKPDS.'''
  VER (&NWORKPDS,DSNAME)
  IF (&NTAPPLID = &WTAPPLID AND &NTSTREAM = &WTSTRM AND &NTSUBAPL = &WTSUBAPL)
    &NTYPPRE = &Z
    &NMEMPRE = &Z
    IF (&NTYP = NOTE)
      &NTMNAME = &NOTEMEM
    IF (&NTYP = DATA)
      &NEWACT = TRANS (&NEWACT *,' ')
      &A3PATT = &NTMNAME
      &NTMNAME = TRANS (&NTMNAME *,' ')
      &NTIMPORT = 'Y'
    ELSE
      IF (&NTAPPLID NE &Z AND &NTSUBAPL NE &Z)
        IF (&NTYP NE '*')
          &NTYPPRE = TRUNC(&NTYP,'*')
          IF (&NTYPPRE = &NTYP)
            VER (&NTYP,NB)
      IF (&NTIMPORT = 'Y')
        VER (&NTYP,NB)
    IF (&NTMNAME NE '*')
      &NMEMPRE = TRUNC(&NTMNAME,'*')
    IF (&NTMNAME NE &Z)
      VER (&NTIMPORT,NB,LIST,'N',MSG=WZZI015N)
    IF (&NTMNAME = &Z)                 /*.. allow pattern ... ??     */
      &WZZFORGN = 1                    /* ... allow pattern ... ??   */
    ELSE                               /* ... allow pattern ... ??   */
      &WZZFORGN = 0                    /* ... allow pattern ... ??   */
    VER (&NEWACT,LIST,'H','D','C','L','F')
    IF (&NEWACT = &Z)
      &NACTION = &Z
    ELSE
      &NACTION = &NEWACT
    IF (&deferflg NE 0,1)                                /*GJA ??? */
      IF (&NACTION = 'F')
        &NTBLVL = &taplvls
      VER (&NTSLVL,NB)                       /* (?)                */
  ELSE
    VER (&NEWACT,LIST,'H','D','C','L','F')
    IF (&NEWACT = &Z)
      &NACTION = &Z
    ELSE
      &NACTION = &NEWACT
    IF (&NTYP NE &Z)
      &deferver = 'Y'
  &NTMTYPE  = &NTYP
  IF (&NTYP EQ 'DML')
     &WZDMLADD = 'CMD'
     VPUT (WZDMLADD) SHARED

  &dohelp = '0'

*REXX(*,taplvls,tahlvls,taslvls,TAMTYPES,SAREA01,NTYP,NTSLVL,NTBLVL,
    dohelp,SAREA0L,(WZZTA#1))
)HELP
FIELD(NTSLVL) PANEL(WZHPSA#L)
FIELD(NTBLVL) PANEL(WZHPSA#L)
FIELD(NTYP) PANEL(WZHPSA#L)
)END
/*===================================================================*/
/* Code Pipeline (TM)                                                */
/* THESE MATERIALS CONTAIN CONFIDENTIAL INFORMATION AND TRADE SECRETS*/
/* OF BMC SOFTWARE, INC. YOU SHALL MAINTAIN THE MATERIALS AS         */
/* CONFIDENTIAL AND SHALL NOT DISCLOSE ITS CONTENTS TO ANY THIRD     */
/* PARTY EXCEPT AS MAY BE REQUIRED BY LAW OR REGULATION. USE,        */
/* DISCLOSURE, OR REPRODUCTION IS PROHIBITED WITHOUT THE PRIOR       */
/* EXPRESS WRITTEN PERMISSION OF BMC SOFTWARE, INC.                  */
/*                                                                   */
/* ALL BMC SOFTWARE PRODUCTS LISTED WITHIN THE MATERIALS ARE         */
/* TRADEMARKS OF BMC SOFTWARE, INC. ALL OTHER COMPANY PRODUCT NAMES  */
/* ARE TRADEMARKS OF THEIR RESPECTIVE OWNERS.                        */
/*                                                                   */
/* © Copyright 1986-2020, 2020-2023 BMC Software, Inc.               */
/*===================================================================*/
/*  MODIFICATION LOG                                                 */
/*                                                                   */
/*  DATE       NAME  JIRA    DESCRIPTION                             */
/*  ========== ====  ======  ========================================*/
/*  2023/11/02 BMC   320200  Disable release for INHARLSE            */
/*  2022/03/17 BMC           Update panel to support Sub-application.*/
/*  2021/10/06 BMC           Update panel removed VER doing then in  */
/*                           code                                    */
/*                           and cleaned up commented out code       */
/*  2021/03/22 BMC           update for large number of types        */
/*  2007/07/25 BMC           added WZDMLADD                          */
/*             ISPW 2.0                                              */
/*                                                                   */
/*===================================================================*/