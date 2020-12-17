with Ada.Text_IO;
with Interfaces.C; use  Interfaces.C;
with Interfaces.C.Extensions; use  Interfaces.C.Extensions;

with pkg_ada_ppdev;  -- THIS IS C-CODE INTERFACED/TRANSFERRED TO ADA SPECIFICATIONS

package pkg_aada_ppdev is
-- ========================================================

   package AATIO    renames Ada.Text_IO;
   package AIFaceC  renames Interfaces.C;
   package AIFaceCE renames Interfaces.C.Extensions;

   package PAPPDEV renames pkg_ada_ppdev;

   -- port unconstrained subtype not allowed (need initialization)
   -- provide initial value or explicit array bounds
   port          : AIFaceC.char_array := "/dev/parport0";
   fd            : AIFaceC.int;
   fd_attrib     : AIFaceC.int;

   -- CONSTANTS DEFINED IN /usr/src/linux-5.4.66/include/uapi/asm-generic/fcntl.h
   -- FOR FILE DESCRIPTOR ATTRIBUTES fd_attrib
   -- The open() function shall establish the connection between a file and a file descriptor.
   -- It shall create an open file description that refers to a file and a file descriptor that refers to that open file description.
   O_RDONLY  : AIFaceC.int    := 0; -- HEx= 0x00  BIN= 00000000
   O_WRONLY  : AIFaceC.int    := 1; -- HEx= 0x01  BIN= 00000001
   O_RDWR    : AIFaceC.int    := 2; -- HEx= 0x02  BIN= 00000010
   O_ACCMODE : AIFaceC.int    := 3; -- HEx= 0x03  BIN= 00000011
   -- fd_attrib : AIFaceC.int := O_RDWR;

   --O_CREAT  : AIFaceC.int    := 00000100;   -- BIN= 00000000 00000100
   --O_EXCL   : AIFaceC.int    := 00000200;   -- BIN= 00000000 00000101
   --O_NOCTTY : AIFaceC.int    := 00000400;   -- BIN= 00000000 00000110
   --O_TRUNC  : AIFaceC.int    := 00001000;   -- BIN= 00000000 00000111
   --O_APPEND : AIFaceC.int    := 00002000;   -- BIN= 00000000 00001000
   --O_NONBLOCK : AIFaceC.int  := 00004000;   -- BIN= 00000010 00000000
   --O_DSYNC  : AIFaceC.int    := 00010000;   -- BIN= 00000100 00000000
   --FASYNC   : AIFaceC.int    := 00020000;   -- BIN= 00001000 00000000
--   O_DIRECT : AIFaceC.int    := 00040000;   -- BIN= 00010000 00000000
--   O_LARGEFILE : AIFaceC.int := 00100000;   -- BIN= 00100000 00000000
--   O_DIRECTORY :AIFaceC.int  := 00200000;   -- BIN= 01000000 00000000
--   O_NOFOLLOW	: AIFaceC.int   := 00400000; -- BIN= 01000000 00000000
--   O_NOATIME	: AIFaceC.int   := 01000000; -- BIN= 01000000 00000000
--   O_CLOEXEC	: AIFaceC.int   := 02000000; -- BIN= 01000000 00000000


   -- CONSTANTS DEFINED IN /usr/include/linux/ppdev.h
   PPSETMODE   : AIFaceC.int := 128; -- HEX 0x80
   PPRSTATUS   : AIFaceC.int := 129; -- HEX 0x81 Read status
   PPRCONTROL  : AIFaceC.int := 131; -- HEX 0x83 Read control
   PPWCONTROL  : AIFaceC.int := 132; -- HEX 0x84 Write control
   PPFCONTROL  : AIFaceC.int := 142; -- HEX 0x8e Frob control
   PPRDATA     : AIFaceC.int := 133; -- HEX 0x85 Read data port
   PPWDATA     : AIFaceC.int := 134; -- HEX 0x86 Write data port
   PPCLAIM     : AIFaceC.int := 139; -- HEX 0x8b Claims access to the port
   PPRELEASE   : AIFaceC.int := 140; -- HEX 0x8c
   PPYIELD     : AIFaceC.int := 141; -- HEX 0x8d
   PPEXCL      : AIFaceC.int := 143; -- HEX 0x8f
   PPDATADIR   : AIFaceC.int := 144; -- HEX 0x90 Data line direction
   PPNEGOT     : AIFaceC.int := 145; -- HEX 0x91 Negotiate a particular IEEE 1284 mode
   PPWCTLONIRQ : AIFaceC.int := 146; -- HEX 0x92 Set control lines when an interrupt occurs
   PPCLRIRQ    : AIFaceC.int := 147; -- HEX 0x93 Clear (and return) interrupt count
   PPSETPHASE  : AIFaceC.int := 148; -- HEX 0x94
   PPGETTIME   : AIFaceC.int := 149; -- HEX 0x95
   PPSETTIME   : AIFaceC.int := 150; -- HEX 0x96 DO NOT USE DANGEROUS
   PPGETMODES  : AIFaceC.int := 151; -- HEX 0x97 Hardware capabilities of parport
   PPGETMODE   : AIFaceC.int := 152; -- HEX 0x98
   PPGETPHASE  : AIFaceC.int := 153; -- HEX 0x99
   PPGETFLAGS  : AIFaceC.int := 154; -- HEX 0x9a
   PPSETFLAGS  : AIFaceC.int := 155; -- HEX 0x9b

-- CONSTANTS DEFINED IN /usr/src/linux-5.4.66/include/linux/parport.h
-- FOUND IN ENUMERATION enum ieee1284_phase {
   IEEE1284_PH_FWD_DATA         : AIFaceC.int := 0;  -- Starts at 0 by default
   IEEE1284_PH_FWD_IDLE         : AIFaceC.int := 1;
   IEEE1284_PH_TERMINATE        : AIFaceC.int := 2;
   IEEE1284_PH_NEGOTIATION      : AIFaceC.int := 3;
   IEEE1284_PH_HBUSY_DNA        : AIFaceC.int := 4;
   IEEE1284_PH_REV_IDLE         : AIFaceC.int := 5;
   IEEE1284_PH_HBUSY_DAVAIL     : AIFaceC.int := 6;
   IEEE1284_PH_REV_DATA         : AIFaceC.int := 7;
   IEEE1284_PH_ECP_SETUP        : AIFaceC.int := 8;
   IEEE1284_PH_ECP_FWD_TO_REV   : AIFaceC.int := 9;
   IEEE1284_PH_ECP_REV_TO_FWD   : AIFaceC.int := 10;
   IEEE1284_PH_ECP_DIR_UNKNOWN  : AIFaceC.int := 11;
   the_phase    : AIFaceC.int    := 999;  -- JUST INITIIALIZATION
   curr_ppphase : AIFaceC.int    := 999;  -- JUST INITIALIZATION

-- CONSTANTS DEFINED IN /usr/include/uapi/linux/parport.h
-- NO SHIFT OPERATORS IN ADA UNLIKE C, SO WE USE INTEGERS FOR PARPORT MODE
   PARPORT_MODE_PCSPP     : AIFaceC.int := 1;  -- (1<<0) = BIN= 00001 INT= 1
   PARPORT_MODE_TRISTATE  : AIFaceC.int := 2;  -- (1<<1) = BIN= 00010 INT= 2
   PARPORT_MODE_EPP       : AIFaceC.int := 4;  -- (1<<2) = BIN= 00100 INT= 3
   PARPORT_MODE_ECP       : AIFaceC.int := 8;  -- (1<<3) = BIN= 01000 INT= 8
   PARPORT_MODE_COMPAT	  : AIFaceC.int := 16; -- (1<<4) = BIN= 10000 INT= 16
   modetoset              : AIFaceC.int := 999; -- JUST INITIALIZATION
   curr_ppmode            : AIFaceC.int := 999; -- JUST INITIALIZATION
   the_ppmodes            : AIFaceC.int := 999; -- HARDWARE CAPABLE MODES LIST

-- FOR PARPORT DATA REGISTER (BOTH READ AND WRITE)
   PPDATADIR_IN  : AIFaceC.int := 1;   -- (Non-zero) SET DATA PORT FOR INPUT
   PPDATADIR_OUT : AIFaceC.int := 0;   -- (Zero) SET DATA PORT FOR OUTPUT
   datadirection : AIFaceC.int := 999; -- Initialize direction of data in/out
   datatowrite   : AIFaceC.int := 999; -- Initialize write to data port
   dataread      : AIFaceC.int := 999; -- Results of data port read initialized

-- FOR PARPORT STATUS REGISTER (READ ONLY. NO WRITE)
   PARPORT_STATUS_ERROR    : AIFaceC.int := 8;   -- HEX 0x8
   PARPORT_STATUS_SELECT   : AIFaceC.int := 16;  -- HEX 0x10
   PARPORT_STATUS_PAPEROUT : AIFaceC.int := 32;  -- HEX 0x20
   PARPORT_STATUS_ACK      : AIFaceC.int := 64;  -- HEX 0x40
   PARPORT_STATUS_BUSY     : AIFaceC.int := 128; -- HEX 0x80
   statusread              : AIFaceC.int := 999; -- JUST INITIALIZATION

-- FOR PARPORT CONTROL REGISTER (BOTH READ AND WRITE)
   PARPORT_CONTROL_STROBE  : AIFaceC.int := 1; -- HEX 0x1
   PARPORT_CONTROL_AUTOFD  : AIFaceC.int := 2; -- HEX 0x2
   PARPORT_CONTROL_INIT    : AIFaceC.int := 4; -- HEX 0x4
   PARPORT_CONTROL_SELECT  : AIFaceC.int := 8; -- HEX 0x8
   controltowrite          : AIFaceC.int := 999; -- JUST INITIALIZATION
   controlread             : AIFaceC.int := 999; -- JUST INITIALIZATION

-- FOR PARPORT FLAGS
   PP_FASTWRITE : AIFaceC.int := 4;    --	(1<<2)  BIN= 00000100  INT= 4
   PP_FASTREAD  :	 AIFaceC.int := 8;    --(1<<3)  BIN= 00001000  INT= 8
   PP_W91284PIC :	 AIFaceC.int := 16;   --(1<<4)  BIN= 00010000  INT= 16
   the_flags    : AIFaceC.int := 999;  --  JUST INITIALIZATION

   -- INTEGER RETURN VALUES FOR ADA_PPDEV (IOCTL) FUNCTION CALLS
   ret01, ret02, ret03, ret04, ret05, ret06, ret07, ret08 : AIFaceC.int;
   ret09, ret10, ret11, ret12, ret13, ret14, ret15, ret16 : AIFaceC.int;
   ret17, ret18, ret19, ret20, ret21, ret22, ret23, ret24 : AIFaceC.int;
   ret25, ret26, retX1, retX2 : AIFaceC.int;


-- LIST OF FUNCTIONS FOR ADA_PPDEV
-- ========================================================
   -- (1) to (2)
   function GetA_open_parport (port : in AIFaceC.char_array; fd_attrib : in AIFaceC.int) return AIFaceC.int;
   function GetA_ppclaim_parport (fd : in AIFaceC.int) return AIFaceC.int;

   -- (3) to (5)
   function GetA_ppgetmodes_parport (fd : AIFaceC.int) return AIFaceC.int;
   function GetA_ppsetmode_parport(fd, modetoset : in AIFaceC.int) return AIFaceC.int;
   function GetA_ppgetmode_current (fd : AIFaceC.int) return AIFaceC.int;

   -- (6) to (7)
   function GetA_ppsetflags_parport (fd, flagstoset : AIFaceC.int) return AIFaceC.int;
   function GetA_ppgetflags_current (fd : AIFaceC.int) return AIFaceC.int;

   -- (8) to (9)
   function GetA_ppsetphase_parport (fd, phasetoset : AIFaceC.int) return AIFaceC.int;
   function GetA_ppgetphase_current (fd : AIFaceC.int) return AIFaceC.int;

   function GetA_streamdata_writedataregister (fd : in AIFaceC.int; stream_datatowrite : in AIFaceC.char_array) return AIFaceC.int;

   -- (10) to (12)
   function GetA_ppdatadir_dataport (fd, datadirection : in AIFaceC.int) return AIFaceC.int;
   function GetA_ppwdata_writedataregister (fd, datatowrite : in AIFaceC.int) return AIFaceC.int;
   function GetA_pprdata_readdataregister (fd : AIFaceC.int) return AIFaceC.int;

   -- (13)
   function GetA_pprstatus_readstatusregister (fd : AIFaceC.int) return AIFaceC.int;

   -- (14) to (15)
   function GetA_ppwcontrol_writecontrolregister (fd, controltowrite : AIFaceC.int) return AIFaceC.int;
   function GetA_pprcontrol_readcontrolregister (fd : AIFaceC.int) return AIFaceC.int;

   -- (16) to (19)
   function GetA_ppfcontrol_frob1 return AIFaceC.int;
   function GetA_ppfcontrol_frob2 return AIFaceC.int;
   function GetA_ppwctlonirq_controlport (fd, the_interrupt : AIFaceC.int) return AIFaceC.int;
   function GetA_ppclrirq_controlport (fd, the_interrupt : AIFaceC.int) return AIFaceC.int;

   -- (20) to (22)
   function GetA_ppnegot_mode (fd_ada, modetoset : in AIFaceC.int) return AIFaceC.int;
   function GetA_ppyield_parport (fd : AIFaceC.int) return AIFaceC.int;
   function GetA_ppgettime_usec_parport (fd : AIFaceC.int) return AIFaceC.int;

   -- (23) to (24)
   function GetA_pprelease_parport return AIFaceC.int;
   function GetA_close_parport (fd : in AIFaceC.int) return AIFaceC.int;

   -- (X1)
   function GetA_ppexcl_parport (fd : in AIFaceC.int) return AIFaceC.int;
   -- (X2)
   function GetA_ppsettime_timeoutparport (fd, timeout : in AIFaceC.int) return AIFaceC.int;

-- ========================================================
end pkg_aada_ppdev;

