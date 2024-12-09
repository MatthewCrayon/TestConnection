/* REXX
 |
 | Copyright Notice:
 |
 | ISPW (TM)
 | COPYRIGHT (C) 1986-2023 BMC Software
 | Unpublished rights reserved under the copyright laws of the United States.
 |
 | Purpose:
 |
 | This REXX processes the add task panel by the same name.
 |
*/

REXX_name_long = "Add Task Panel Processing"
Update_date = "26 Nov 2024 09:42" /* See Change Log */

SIGNAL ON NOVALUE                       /* Enable the conditions and  */
SIGNAL ON SYNTAX                        /* point at reasonable        */
SIGNAL ON FAILURE                       /* condition handling         */
SIGNAL ON HALT

/* Determine the execution environment                                */

PARSE SOURCE,
   TSO_STRING,
   CALL_TYPE,
   EXEC_NAME,
   EXEC_DD,
   EXEC_DSN,
   EXEC_CALL_NAME,
   INITIAL_ENV,
   ADDRESS_SPACE

SELECT
   WHEN INITIAL_ENV = "TSO" THEN, /* TSO (IKJEFT01) */
      user_interface = SYSVAR("SYSENV") /* FORE or BACK */
   WHEN INITIAL_ENV = "MVS" THEN, /* Batch (expected) */
      user_interface = "BACK"
   OTHERWISE nop
END

/* Initialize stems for numeric fields and logical switches */
ctr. = 0; sw. = 0
xrc=0 /* REXX return code */

type_list = TAMTYPES 'DATA' /* Add "DATA" to the list of types*/

IF dohelp THEN DO
   CALL populate_WZHPSA#L
   SIGNAL QUIT
END

CALL Split_string 80 type_list
typesa = string1
typesb = string2

CALL Split_string 55 taslvls
patha = string1
pathb = string2

filters = taplvls tahlvls
CALL Split_string 55 filters
filtera = string1
filterb = string2

/* ------------------------------------------------------------------------ */
/* Wrap it up                                                               */
/* ------------------------------------------------------------------------ */

QUIT:
zrxrc=xrc
RETURN

/*----------------------------------------------------------------------------*/
/* INTERNAL SUBROUTINES                                                       */
/*----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
   Function to split an input string into two strings on word boundaries
-----------------------------------------------------------------------------*/
Split_string:
parse arg maxLength input

/* Initialize output strings */
string1 =
string2 =

/* Iterate over the words in the input string */
DO WHILE input \= ''
   word = WORD(input, 1)        /* Extract the first word */
   input = SUBWORD(input, 2)   /* Remove the first word from input */
/* Check if the current word fits in the first string */
   IF LENGTH(string1) + LENGTH(word) + 1 <= maxLength THEN DO
      IF string1 = '' THEN
         string1 = word
      ELSE
         string1 = string1 word
   END
/* If it doesn't fit in the first string, process for the second string */
   ELSE DO
/* Append remaining input to the second string with truncation if needed */
      endword =
      IF input \= '' THEN endword = input
      string2 = word endword
      /* Check if string2 exceeds maxLength */
      IF length(string2) > maxLength THEN DO
          /* Truncate string2 on a word boundary */
          truncated =
          DO i = 1 to WORDS(string2)
              temp = truncated WORD(string2, i)
              IF LENGTH(STRIP(temp)) + 3 > maxLength THEN LEAVE
              truncated = temp
          END
          string2 = STRIP(truncated) || "..."
          LEAVE
      END
      LEAVE
    END
END

/*
   If the entire input fits in the first string, ensure the second string is
   blank

*/
IF input = '' THEN string2 =

RETURN

populate_WZHPSA#L:

dop='01'x /* Ouptut low */
doh='02'x /* Ouptut Highlight */

/* Do the Types */
SAREA0L =
label = ' 'doh'Valid Types:'
linelength = 80-LENGTH(label)
line =
i = 1 /* word index */
x = 0 /* line number */

DO WHILE i <= WORDS(type_list)

   aword = WORD(type_list,i)

/* Append the next word to the line and bump the index */
   IF LENGTH(line) + length(aword) + 1 <= linelength THEN DO
      line = line||dop||aword
      i = i + 1 /* next word */
      ITERATE
   END

   x = x + 1 /* next line number */

/* Do the first line */
   IF x = 1 THEN DO
      line = label||line
      linelength = 80
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L||line
      line = ' '
      ITERATE
   END

/* Do the other lines */
   llength = length(line)
   line = line||COPIES(' ',linelength-llength)
   SAREA0L = SAREA0L||line
   line = ' '

END

IF 0 < LENGTH(line) THEN DO
   x = x + 1 /* next line number */
   IF x = 1 THEN DO
      llength = length(line)
      line = line||copies(' ',linelength-llength)
      SAREA0L = SAREA0L' 'doh'Valid Types:'line
   END
   ELSE DO
      llength = length(line)
      line = line||copies(' ',linelength-llength)
      SAREA0L = SAREA0L||line
   END
END

/* Do the Paths */
label = ' 'doh'Allowable Paths:'
linelength = 80-LENGTH(label)
line =
i = 1 /* word index */
x = 0 /* line number */

DO WHILE i <= WORDS(taslvls)

   aword = WORD(taslvls,i)

/* Append the next word to the line and bump the index */
   IF LENGTH(line) + length(aword) + 1 <= linelength THEN DO
      line = line||dop||aword
      i = i + 1 /* next word */
      ITERATE
   END

   x = x + 1 /* next line number */

/* Do the first line */
   IF x = 1 THEN DO
      line = label||line
      linelength = 80
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L||line
      line = ' '
      ITERATE
   END

/* Do the other lines */
   llength = length(line)
   line = line||COPIES(' ',linelength-llength)
   SAREA0L = SAREA0L||line
   line = ' '

END

IF 0 < LENGTH(line) THEN DO
   x = x + 1 /* next line number */
   IF x = 1 THEN DO
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L' 'doh'Allowable Paths:'line
   END
   ELSE DO
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L||line
   END
END

/* Do the Filters */
label = ' 'doh'Allowable Filters:'
linelength = 80-LENGTH(label)
line =
i = 1 /* word index */
x = 0 /* line number */
filters = taplvls tahlvls

DO WHILE i <= WORDS(filters)

   aword = WORD(filters,i)

/* Append the next word to the line and bump the index */
   IF LENGTH(line) + length(aword) + 1 <= linelength THEN DO
      line = line||dop||aword
      i = i + 1 /* next word */
      ITERATE
   END

   x = x + 1 /* next line number */

/* Do the first line */
   IF x = 1 THEN DO
      line = label||line
      linelength = 80
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L||line
      line = ' '
      ITERATE
   END

/* Do the other lines */
   llength = length(line)
   line = line||COPIES(' ',linelength-llength)
   SAREA0L = SAREA0L||line
   line = ' '

END

IF 0 < LENGTH(line) THEN DO
   x = x + 1 /* next line number */
   IF x = 1 THEN DO
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L' 'doh'Allowable Filters:'line
   END
   ELSE DO
      llength = length(line)
      line = line||COPIES(' ',linelength-llength)
      SAREA0L = SAREA0L||line
   END
END

RETURN

/*
   Condition handling

   Taken from "What's wrong with Rexx?" by Walter Pachl, IBM Retiree
   Downloaded from www.rexxla.org/events/2004/walterp.pdf

*/
NOVALUE:
SAY 'Novalue raised in line' SIGL   /* line in error number       */
SAY SOURCELINE(SIGL)                /* and text                   */
SAY 'Variable' CONDITION('D')       /* the bad variable reference */
SIGNAL Lookaround                   /* common interactive code    */

SYNTAX:
syntax_rc = rc                      /* Save the rc                */
SAY 'Syntax raised in line' SIGL    /* line in error number       */
SAY SOURCELINE(SIGL)                /* and text                   */
                                    /* the error code and message */
SAY 'rc='syntax_rc '('errortext(syntax_rc)')'

HALT:
Lookaround:                         /* common interactive code    */
IF user_interface = 'FORE' THEN DO  /* when running in foreground */
   SAY 'You can look around now.'   /* tell user what he can do   */
   TRACE ?R                         /* start interactive trace    */
   NOP                              /* and cause the first prompt */
   END

/* Change Log

26 Nov 2024
Revised based on user feedback

21 Oct 2024
Initial development

*/

/*

Hide the testing variables here:

/* testing */
  &TAMTYPES = 'ADR ASM BMS C CLST CMAP CNTL COB COPY DCLG DSCT EZT H ICOP LKED +
    MAC MAP MSGS PANL PARM PLAN PROC RMOT RUNB SAS SCL SKEL TABL'

  &taslvls = 'DEVL DEV2 DEV3 DEV4 DEV5 DEV6 DEV7 DEV8 DSHD DV10 +
      DV15 DV31 DV35 DV37'

  &taplvls = 'PROD'
  &tahlvls = 'SHAD STGE TEST TSHD TST2 TST3 TST4 TST5 TST6 TST7 TST8 TST10 +
      TST15 TST31 TST35 TST37 UAT6 UAT7 USHD UT15 UT31 UT35 UT37'

*/

/*
TRACE ?I /* testing - Display intermediate results */
TRACE ?A /* testing - Display all clauses before execution */
TRACE ?R /* testing - Display final results */
TRACE O /* testing - turn off trace */
*/
 /* testing */