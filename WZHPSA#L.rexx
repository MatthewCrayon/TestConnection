)ATTR DEFAULT(%+~)
 _ TYPE(INPUT)  INTENS(LOW) CAPS(ON) COLOR(PINK) JUST(LEFT)
 { TYPE(TEXT)  INTENS(LOW) CAPS(OFF) COLOR(PINK)
 [ TYPE(TEXT)  INTENS(LOW) CAPS(OFF) COLOR(TURQ)
 ] TYPE(TEXT)  INTENS(LOW) CAPS(OFF) COLOR(GREEN)
 | AREA(DYNAMIC) SCROLL(ON) EXTEND(ON)
 01 TYPE(DATAOUT) INTENS(LOW)
 02 TYPE(DATAOUT) INTENS(HIGH)
)BODY WIDTH(80)
+                      %ADD TASK TO ASSIGNMENT+
%Command  ===>_ZCMD                                              +
|SAREA0L                                                                       |
)INIT
 &ZUP = WZHPSA#
 &ZCONT = WZHPSA#L
 &DOHELP = '1'
*REXX(*,DOHELP,path,taplvls,tahlvls,taslvls,TAMTYPES,SAREA0L,(WZZTA#1))
)PROC
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
/*  2024/10/21 BMC           Initial deployment
/*