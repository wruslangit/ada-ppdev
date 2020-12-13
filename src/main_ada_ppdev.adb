-- File	: main_ada_ppdev.adb
-- Date	: Sat 12 Dec 2020 01:32:03 PM +08
-- Env	: Linux HPEliteBook8470p-Ub2004-rt38 5.4.66-rt38 
-- #1 SMP PREEMPT_RT Sat Sep 26 16:51:59 +08 2020 x86_64 x86_64 x86_64 GNU/Linux
-- Author: WRY wruslandr@gmail.com
-- ========================================================
-- GNAT Studio Community 2020 (20200427) hosted on x86_64-pc-linux-gnu
-- GNAT 9.3.1 targetting x86_64-linux-gnu
-- SPARK Community 2020 (20200818)

-- ADA STANDARD PACKAGES
with Ada.Text_IO;
with Interfaces.C; 
use  Interfaces.C; 
with Interfaces.C.Extensions;
use  Interfaces.C.Extensions;

-- WRY CREATED PACKAGES 
with pkg_ada_dtstamp;
with pkg_ada_ppdev; 

procedure main_ada_ppdev is
   
-- RENAMING PACKAGES FOR CONVENIENCE
   package ATIO    renames Ada.Text_IO;
   package IFaceC  renames Interfaces.C;
   package IFaceCE renames Interfaces.C.Extensions;
   
   package PADTS   renames pkg_ada_dtstamp;
   package PAPPDEV renames pkg_ada_ppdev; 
   
-- IMPORTANT NOTE:   
-- ALL INITIALIZATIONS ARE SET TO 999 BECAUSE ALMOST ALL 
-- FUNCTION CALLS RETURN 0 FOR SUCCESS. SO IF FUNCTION CALLS 
-- ARE EXECUTED, THE RETURN VALUES MUST CHANGE FROM 999, WHETHER
-- RETURNS ARE SUCCESSFUL OR NOT. HA HA HA.

-- VARIABLES USED FOR PACKAGE Interfaces.C	    
   port          : IFaceC.char_array := "/dev/parport0";
   fd            : IFaceC.int := 999; -- File Descriptor just for initialization
   fd_attrib     : IFaceC.int; 
   the_interrupt : IFaceC.int;
   the_IRQ       : IFaceC.int := 5;

-- LOCAL MACHINE PARALLEL PORT HARDWARE REPORTED BY dmesg   
-- dmesg   
-- [   11.166415] lp: driver loaded but no devices found
-- [   11.173279] ppdev: user-space parallel port driver
-- [   11.265065] parport_pc 00:05: reported by Plug and Play ACPI
-- [   11.265171] parport0: PC-style at 0x378 (0x778), irq 5, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]
-- [   11.363746] lp0: using parport0 (interrupt-driven).
   
-- CONSTANTS DEFINED IN /usr/src/linux-5.4.66/include/uapi/asm-generic/fcntl.h
-- FOR FILE DESCRIPTOR ATTRIBUTES fd_attrib
   O_RDONLY  : IFaceC.int    := 0; -- HEx= 0x00  BIN= 00000000
   O_WRONLY  : IFaceC.int    := 1; -- HEx= 0x01  BIN= 00000001
   O_RDWR    : IFaceC.int    := 2; -- HEx= 0x02  BIN= 00000010
   O_ACCMODE : IFaceC.int    := 3; -- HEx= 0x03  BIN= 00000011
   
   --O_CREAT  : IFaceC.int    := 00000100;
   --O_EXCL   : IFaceC.int    := 00000200;
   --O_NOCTTY : IFaceC.int    := 00000400;
   --O_TRUNC  : IFaceC.int    := 00001000;   
   --O_APPEND : IFaceC.int    := 00002000;
   --O_NONBLOCK : IFaceC.int  := 00004000;
   --O_DSYNC  : IFaceC.int    := 00010000;
   --FASYNC	  : IFaceC.int   := 00020000;
--   O_DIRECT : IFaceC.int    := 00040000;
--   O_LARGEFILE : IFaceC.int := 00100000;
--   O_DIRECTORY :IFaceC.int  := 00200000;
--   O_NOFOLLOW	: IFaceC.int   := 00400000;
--   O_NOATIME	: IFaceC.int   := 01000000;
--   O_CLOEXEC	: IFaceC.int   := 02000000;

-- CONSTANTS DEFINED IN /usr/include/linux/ppdev.h
   PPSETMODE   : IFaceC.int := 128; -- HEX 0x80
   PPRSTATUS   : IFaceC.int := 129; -- HEX 0x81 Read status
   PPRCONTROL  : IFaceC.int := 131; -- HEX 0x83 Read control
   PPWCONTROL  : IFaceC.int := 132; -- HEX 0x84 Write control
   PPFCONTROL  : IFaceC.int := 142; -- HEX 0x8e Frob control
   PPRDATA     : IFaceC.int := 133; -- HEX 0x85 Read data port
   PPWDATA     : IFaceC.int := 134; -- HEX 0x86 Write data port
   PPCLAIM     : IFaceC.int := 139; -- HEX 0x8b Claims access to the port
   PPRELEASE   : IFaceC.int := 140; -- HEX 0x8c
   PPYIELD     : IFaceC.int := 141; -- HEX 0x8d
   PPEXCL      : IFaceC.int := 143; -- HEX 0x8f
   PPDATADIR   : IFaceC.int := 144; -- HEX 0x90 Data line direction
   PPNEGOT     : IFaceC.int := 145; -- HEX 0x91 Negotiate a particular IEEE 1284 mode
   PPWCTLONIRQ : IFaceC.int := 146; -- HEX 0x92 Set control lines when an interrupt occurs
   PPCLRIRQ    : IFaceC.int := 147; -- HEX 0x93 Clear (and return) interrupt count
   PPSETPHASE  : IFaceC.int := 148; -- HEX 0x94
   PPGETTIME   : IFaceC.int := 149; -- HEX 0x95
   PPSETTIME   : IFaceC.int := 150; -- HEX 0x96 DO NOT USE DANGEROUS
   PPGETMODES  : IFaceC.int := 151; -- HEX 0x97 Hardware capabilities of parport
   PPGETMODE   : IFaceC.int := 152; -- HEX 0x98
   PPGETPHASE  : IFaceC.int := 153; -- HEX 0x99
   PPGETFLAGS  : IFaceC.int := 154; -- HEX 0x9a
   PPSETFLAGS  : IFaceC.int := 155; -- HEX 0x9b
   
-- CONSTANTS DEFINED IN /usr/src/linux-5.4.66/include/linux/parport.h
-- FOUND IN ENUMERATION enum ieee1284_phase {
   IEEE1284_PH_FWD_DATA         : IFaceC.int := 0;  -- Starts at 0 by default
   IEEE1284_PH_FWD_IDLE         : IFaceC.int := 1;  
   IEEE1284_PH_TERMINATE        : IFaceC.int := 2;
   IEEE1284_PH_NEGOTIATION      : IFaceC.int := 3;
   IEEE1284_PH_HBUSY_DNA        : IFaceC.int := 4;
   IEEE1284_PH_REV_IDLE         : IFaceC.int := 5;
   IEEE1284_PH_HBUSY_DAVAIL     : IFaceC.int := 6;
   IEEE1284_PH_REV_DATA         : IFaceC.int := 7;
   IEEE1284_PH_ECP_SETUP        : IFaceC.int := 8;
   IEEE1284_PH_ECP_FWD_TO_REV   : IFaceC.int := 9;
   IEEE1284_PH_ECP_REV_TO_FWD   : IFaceC.int := 10;
   IEEE1284_PH_ECP_DIR_UNKNOWN  : IFaceC.int := 11;  
   the_phase    : IFaceC.int    := 999;  -- JUST INITIIALIZATION 
   curr_ppphase : IFaceC.int    := 999;  -- JUST INITIALIZATION
   
-- CONSTANTS DEFINED IN /usr/include/uapi/linux/parport.h
-- NO SHIFT OPERATORS IN ADA UNLIKE C, SO WE USE INTEGERS FOR PARPORT MODE
   PARPORT_MODE_PCSPP     : IFaceC.int := 1;  -- (1<<0) = BIN= 00001 INT= 1
   PARPORT_MODE_TRISTATE  : IFaceC.int := 2;  -- (1<<1) = BIN= 00010 INT= 2
   PARPORT_MODE_EPP       : IFaceC.int := 4;  -- (1<<2) = BIN= 00100 INT= 3    
   PARPORT_MODE_ECP       : IFaceC.int := 8;  -- (1<<3) = BIN= 01000 INT= 8
   PARPORT_MODE_COMPAT	  : IFaceC.int := 16; -- (1<<4) = BIN= 10000 INT= 16
   modetoset              : IFaceC.int := 999; -- JUST INITIALIZATION
   curr_ppmode            : IFaceC.int := 999; -- JUST INITIALIZATION
   the_ppmodes            : IFaceC.int := 999; -- HARDWARE CAPABLE MODES LIST
   
-- FOR PARPORT DATA REGISTER (BOTH READ AND WRITE)  
   PPDATADIR_IN  : IFaceC.int := 1;   -- (Non-zero) SET DATA PORT FOR INPUT
   PPDATADIR_OUT : IFaceC.int := 0;   -- (Zero) SET DATA PORT FOR OUTPUT
   datadirection : IFaceC.int := 999; -- Initialize direction of data in/out
   datatowrite   : IFaceC.int := 999; -- Initialize write to data port 
   dataread      : IFaceC.int := 999; -- Results of data port read initialized

-- FOR PARPORT STATUS REGISTER (READ ONLY. NO WRITE)   
   PARPORT_STATUS_ERROR    : IFaceC.int := 8;   -- HEX 0x8
   PARPORT_STATUS_SELECT   : IFaceC.int := 16;  -- HEX 0x10
   PARPORT_STATUS_PAPEROUT : IFaceC.int := 32;  -- HEX 0x20
   PARPORT_STATUS_ACK      : IFaceC.int := 64;  -- HEX 0x40
   PARPORT_STATUS_BUSY     : IFaceC.int := 128; -- HEX 0x80 
   statusread              : IFaceC.int := 999; -- JUST INITIALIZATION

-- FOR PARPORT CONTROL REGISTER (BOTH READ AND WRITE)   
   PARPORT_CONTROL_STROBE  : IFaceC.int := 1; -- HEX 0x1
   PARPORT_CONTROL_AUTOFD  : IFaceC.int := 2; -- HEX 0x2
   PARPORT_CONTROL_INIT    : IFaceC.int := 4; -- HEX 0x4
   PARPORT_CONTROL_SELECT  : IFaceC.int := 8; -- HEX 0x8
   controltowrite          : IFaceC.int := 999; -- JUST INITIALIZATION
   controlread             : IFaceC.int := 999; -- JUST INITIALIZATION
   
-- FOR PARPORT FLAGS
   PP_FASTWRITE : IFaceC.int := 4;    --	(1<<2)  BIN= 00000100  INT= 4
   PP_FASTREAD  :	 IFaceC.int := 8;    --	(1<<3)  BIN= 00001000  INT= 8
   PP_W91284PIC :	 IFaceC.int := 16;   -- (1<<4)  BIN= 00010000  INT= 16 
   the_flags    : IFaceC.int := 999;  --  JUST INITIALIZATION
   
-- INTEGER RETURN VALUES FOR ADA_PPDEV (IOCTL) FUNCTION CALLS   
   ret01, ret02, ret03, ret04, ret05, ret06, ret07, ret08 : IFaceC.int; 
   ret09, ret10, ret11, ret12, ret13, ret14, ret15, ret16 : IFaceC.int;
   ret17, ret18, ret19, ret20, ret21, ret22, ret23, ret24 : IFaceC.int;
   ret25, ret26 : IFaceC.int;
     
begin
   
-- INITIALIZE INTEGER RETURN VALUES FOR ADA_PPDEV (IOCTL) FUNCTION CALLS   
   ret01 := 999; ret02 := 999; ret03 := 999; ret04 := 999; ret05 := 999; 
   ret06 := 999; ret07 := 999; ret08 := 999; ret09 := 999; ret10 := 999; 
   ret11 := 999; ret12 := 999; ret13 := 999; ret14 := 999; ret15 := 999; 
   ret16 := 999; ret17 := 999; ret18 := 999; ret19 := 999; ret20 := 999;
   ret21 := 999; ret22 := 999; ret23 := 999; ret24 := 999; ret25 := 999; 
   ret26 := 999;
        
   PADTS.dtstamp; ATIO.Put_Line ("Bismillah 3 times WRY");
   PADTS.dtstamp; ATIO.Put_Line ("Running inside GNAT Studio Community (20200427)");
   -- ========================================================   
   
   -- DISPLAY COMPUTING ENVIRONMENT USE dtstamp.h
   
   ATIO.New_Line;
   ATIO.Put_Line ("USING INTERFACE API ada_ppdev.c AND ada_ppdev.h "); 
   ATIO.Put_Line ("=================================================");     
   
   -- port : IFaceC.char_array := "/dev/parport0"; -- ALREADY DEFINED GLOBALLY
   fd_attrib := O_RDWR; -- SET FILE DESCRIPTOR ATTRIBUTES INT= 2
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_open_parport(port, fd_attrib) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret01 := PAPPDEV.GetC_ada_open_parport(port, fd_attrib);
   PADTS.dtstamp; 
   if (ret01 /= 0) then    -- fd must be nonzero to be a success
      ATIO.Put ("PASSED. GET_FILE_DESCRIPTOR: fd = "); 
      ATIO.Put (IFaceC.int'Image(ret01));
   else 
      ATIO.Put ("FAILED. GET_FILE_DESCRIPTOR: fd = ");
      ATIO.Put (IFaceC.int'Image(ret01));
   end if;
   ATIO.New_Line;
      
   -- CREATED fd becomes the file descriptior for all ensuing function calls 
   fd := ret01;   
   
   modetoset := PARPORT_MODE_ECP;
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppsetmode_parport(fd, modetoset) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret11 := PAPPDEV.GetC_ada_ioctl_ppsetmode_parport(fd, modetoset);
   PADTS.dtstamp;
   if (ret11 = 0) then    
      ATIO.Put ("PASSED. PP_SET_MODE. ");       
    else 
      ATIO.Put ("FAILED. PP_SET_MODE: ret11 = "); 
      ATIO.Put (IFaceC.int'Image(ret11));
   end if;
   ATIO.New_Line;   
    
   -- Note: This is exclusive access, not a shared parport (data, status, control and IRQ)
   -- ret13 := PAPPDEV.GetC_ada_ioctl_ppexcl_parport(fd);
   -- PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppexcl_parport(fd) : ret13 = ");
   -- ATIO.Put (IFaceC.int'Image(ret13));
   -- ATIO.New_Line;    
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppclaim_parport(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret02 := PAPPDEV.GetC_ada_ioctl_ppclaim_parport(fd);
   PADTS.dtstamp;
   if (ret02 = 0) then    
      ATIO.Put ("PASSED. PP_CLAIM.");       
   else 
      ATIO.Put ("FAILED. PP_CLAIM: ret02 = "); 
      ATIO.Put (IFaceC.int'Image(ret02));
   end if;
   ATIO.New_Line;   
  
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppnegot_mode(fd, modetoset) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret03 := PAPPDEV.GetC_ada_ioctl_ppnegot_mode(fd, modetoset);
   PADTS.dtstamp;
   if (ret03 = 0) then    
      ATIO.Put ("PASSED. PP_NEGOT.");       
   else 
      ATIO.Put ("FAILED. PP_NEGOT: ret03 = "); 
      ATIO.Put (IFaceC.int'Image(ret03));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppfcontrol_frob1.");
   ATIO.New_Line;
   PADTS.dtstamp; ret04 := PAPPDEV.GetC_ada_ioctl_ppfcontrol_frob1;
   PADTS.dtstamp;
   if (ret04 = 0) then    
      ATIO.Put ("PASSED. PP_FROB_CONTROL.");       
   else 
      ATIO.Put ("FAILED. PP_FROB_CONTROL: ret04 = "); 
      ATIO.Put (IFaceC.int'Image(ret04));
   end if;
   ATIO.New_Line;
   
   datadirection := PPDATADIR_OUT;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppdatadir_dataport(fd, datadirection) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret14 := PAPPDEV.GetC_ada_ioctl_ppdatadir_dataport(fd, datadirection);
   PADTS.dtstamp;
   if (ret14 = 0) then    
      ATIO.Put ("PASSED. PP_DATA_DIRECTION.");       
   else 
      ATIO.Put ("FAILED. PP_DATA_DIRECTION: ret14 = "); 
      ATIO.Put (IFaceC.int'Image(ret14));
   end if;
   ATIO.New_Line;
      
   -- WRITE PROPER POSSIBLE INTEGER CODES (RANGE [0..255] ONLY)
   datatowrite := 215; -- AS AN EXAMPLE
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppwdata_writedataregister(fd, datatowrite)");
   ATIO.New_Line;
   PADTS.dtstamp; ret05 := PAPPDEV.GetC_ada_ioctl_ppwdata_writedataregister(fd, datatowrite); 
   PADTS.dtstamp;
   if (ret05 = 0) then    
      ATIO.Put ("PASSED. PP_WRITE_DATA.");       
   else 
      ATIO.Put ("FAILED. PP_WRITE_DATA: ret05 = "); 
      ATIO.Put (IFaceC.int'Image(ret05));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppfcontrol_frob2.");
   ATIO.New_Line;
   PADTS.dtstamp; ret06 := PAPPDEV.GetC_ada_ioctl_ppfcontrol_frob2;
   PADTS.dtstamp;
   if (ret06 = 0) then    
      ATIO.Put ("PASSED. PP_FROB_CONTROL.");       
   else 
      ATIO.Put ("FAILED. PP_FROB_CONTROL: ret06 = "); 
      ATIO.Put (IFaceC.int'Image(ret06));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_pprdata_readdataregister(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret07 := PAPPDEV.GetC_ada_ioctl_pprdata_readdataregister(fd);
   PADTS.dtstamp;
   if (ret07 = 0) then    
      ATIO.Put ("PASSED. PP_READ_DATA.");       
   else 
      ATIO.Put ("FAILED. PP_READ_DATA: ret07 = "); 
      ATIO.Put (IFaceC.int'Image(ret07));
   end if;
   ATIO.New_Line;
     
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_pprstatus_readstatusregister(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret08 := PAPPDEV.GetC_ada_ioctl_pprstatus_readstatusregister(fd, statusread);
   PADTS.dtstamp;
   if (ret08 = 0) then    
      ATIO.Put ("PASSED. PP_READ_STATUS.");       
   else 
      ATIO.Put ("FAILED. PP_READ_STATUS: ret08 = "); 
      ATIO.Put (IFaceC.int'Image(ret08));
   end if;
   ATIO.New_Line;
   
   -- WRITE PROPER POSSIBLE CODES TO CONTROL PORT 
   controltowrite := PARPORT_CONTROL_INIT; 
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppwcontrol_writecontrolregister(fd, controltowrite) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret10 := PAPPDEV.GetC_ada_ioctl_ppwcontrol_writecontrolregister(fd, controltowrite); 
   PADTS.dtstamp;
   if (ret10 = 0) then    
      ATIO.Put ("PASSED. PP_WRITE_CONTROL.");       
   else 
      ATIO.Put ("FAILED. PP_WRITE_CONTROL: ret10 = "); 
      ATIO.Put (IFaceC.int'Image(ret10));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_pprcontrol_readcontrolregister(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret09 := PAPPDEV.GetC_ada_ioctl_pprcontrol_readcontrolregister(fd);
   PADTS.dtstamp;
   if (ret09 = 0) then    
      ATIO.Put ("PASSED. PP_READ_CONTROL.");       
   else 
      ATIO.Put ("FAILED. PP_READ_CONTROL: ret09 = "); 
      ATIO.Put (IFaceC.int'Image(ret09));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppyield_parport(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret12 := PAPPDEV.GetC_ada_ioctl_ppyield_parport(fd); 
   PADTS.dtstamp;
   if (ret12 = 0) then    
      ATIO.Put ("PASSED. PP_YIELD.");       
   else 
      ATIO.Put ("FAILED. PP_YIELD: ret12 = "); 
      ATIO.Put (IFaceC.int'Image(ret12));
   end if;
   ATIO.New_Line;
   
   the_interrupt := the_IRQ;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppwctlonirq_controlport(fd, the_interrupt) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret15 := PAPPDEV.GetC_ada_ioctl_ppwctlonirq_controlport(fd, the_interrupt); 
   PADTS.dtstamp;
   if (ret15 = 0) then    
      ATIO.Put ("PASSED. PP_WRITE_CONTROL_ON_IRQ.");       
   else 
      ATIO.Put ("FAILED. PP_WRITE_CONTROL_ON_IRQ: ret15 = "); 
      ATIO.Put (IFaceC.int'Image(ret15));
   end if;
   ATIO.New_Line;
      
   the_interrupt := the_IRQ;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppclrirq_controlport(fd, the_interrupt) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret16 := PAPPDEV.GetC_ada_ioctl_ppclrirq_controlport(fd, the_interrupt); 
   PADTS.dtstamp;
   if (ret16 = 0) then    
      ATIO.Put ("PASSED. PP_CLEAR_IRQ.");       
   else 
      ATIO.Put ("FAILED. PP_CLEAR_IRQ: ret16 = "); 
      ATIO.Put (IFaceC.int'Image(ret16));
   end if;
   ATIO.New_Line;
   
   the_phase := IEEE1284_PH_FWD_IDLE;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppsetphase_parport(fd, the_phase) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret17 := PAPPDEV.GetC_ada_ioctl_ppsetphase_parport(fd, the_phase);
   PADTS.dtstamp;
   if (ret17 = 0) then    
      ATIO.Put ("PASSED. PP_SET_PHASE.");       
   else 
      ATIO.Put ("FAILED. PP_SET_PHASE: ret17 = "); 
      ATIO.Put (IFaceC.int'Image(ret17));
   end if;
   ATIO.New_Line;
   
   the_phase := IEEE1284_PH_ECP_FWD_TO_REV;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppsetphase_parport(fd, the_phase) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret17 := PAPPDEV.GetC_ada_ioctl_ppsetphase_parport(fd, the_phase);
   PADTS.dtstamp;
   if (ret17 = 0) then    
      ATIO.Put ("PASSED. PP_SET_PHASE.");       
   else 
      ATIO.Put ("FAILED. PP_SET_PHASE: ret17 = "); 
      ATIO.Put (IFaceC.int'Image(ret17));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppgettime_usec_parport(fd) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret18 := PAPPDEV.GetC_ada_ioctl_ppgettime_usec_parport(fd);
   PADTS.dtstamp;
   if (ret18 = 0) then    
      ATIO.Put ("PASSED. PP_GET_TIME.");       
   else 
      ATIO.Put ("FAILED. PP_GET_TIME: ret18 = "); 
      ATIO.Put (IFaceC.int'Image(ret18));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put ("GetC_ada_ioctl_ppgetmodes_parport(fd, the_ppmodes) ");
   ATIO.New_Line;
   PADTS.dtstamp; ret20 := PAPPDEV.GetC_ada_ioctl_ppgetmodes_parport(fd, the_ppmodes); 
   PADTS.dtstamp;
   if (ret20 = 0) then    
      ATIO.Put ("PASSED. PP_GET_HARDWARE_MODES.");       
   else 
      ATIO.Put ("FAILED. PP_GET_HARDWARE_MODES: ret20 = "); 
      ATIO.Put (IFaceC.int'Image(ret20));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_ioctl_ppgetmode_current(fd, curr_ppmode) ");
   PADTS.dtstamp; ret21 := PAPPDEV.GetC_ada_ioctl_ppgetmode_current(fd, curr_ppmode);
   PADTS.dtstamp;
   if (ret21 = 0) then    
      ATIO.Put ("PASSED. PP_GET_MODE.");       
   else 
      ATIO.Put ("FAILED. PP_GET_MODE: ret21 = "); 
      ATIO.Put (IFaceC.int'Image(ret21));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_ioctl_ppgetphase_current(fd, curr_ppphase) ");
   PADTS.dtstamp; ret22 := PAPPDEV.GetC_ada_ioctl_ppgetphase_current(fd, curr_ppphase);
   PADTS.dtstamp;
   if (ret22 = 0) then    
      ATIO.Put ("PASSED. PP_GET_PHASE.");       
   else 
      ATIO.Put ("FAILED. PP_GET_PHASE: ret22 = "); 
      ATIO.Put (IFaceC.int'Image(ret22));
   end if;
   ATIO.New_Line;
   
   the_flags := PP_FASTREAD;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_ioctl_ppsetflags_parport(fd, the_flags) ");
   PADTS.dtstamp; ret23 := PAPPDEV.GetC_ada_ioctl_ppsetflags_parport(fd, the_flags);
   PADTS.dtstamp;
   if (ret23 = 0) then    
      ATIO.Put ("PASSED. PP_SET_FLAGS.");       
   else 
      ATIO.Put ("FAILED. PP_SET_FLAGS: ret23 = "); 
      ATIO.Put (IFaceC.int'Image(ret23));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_ioctl_ppgetflags_parport(fd, the_flags) ");
   PADTS.dtstamp; ret24 := PAPPDEV.GetC_ada_ioctl_ppgetflags_parport(fd, the_flags);
   PADTS.dtstamp;
   if (ret24 = 0) then    
      ATIO.Put ("PASSED. PP_GET_FLAGS.");       
   else 
      ATIO.Put ("FAILED. PP_GET_FLAGS: ret24 = "); 
      ATIO.Put (IFaceC.int'Image(ret23));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_ioctl_pprelease_parport. ");
   PADTS.dtstamp; ret25 := PAPPDEV.GetC_ada_ioctl_pprelease_parport;
   PADTS.dtstamp;
   if (ret25 = 0) then    
      ATIO.Put ("PASSED. PP_RELEASE.");       
   else 
      ATIO.Put ("FAILED. PP_RELEASE: ret25 = "); 
      ATIO.Put (IFaceC.int'Image(ret25));
   end if;
   ATIO.New_Line;
   
   PADTS.dtstamp; ATIO.Put_Line ("GetC_ada_close_parport(fd) ");
   PADTS.dtstamp; ret26 := PAPPDEV.GetC_ada_close_parport(fd);
   PADTS.dtstamp;
   if (ret26 = 0) then    
      ATIO.Put ("PASSED. PP_CLOSE_PARPORT.");       
   else 
      ATIO.Put ("FAILED. PP_CLOSE_PARPORT: ret26 = "); 
      ATIO.Put (IFaceC.int'Image(ret26));
   end if;
   ATIO.New_Line;
   
-- ========================================================      
   ATIO.New_Line;
   PADTS.dtstamp; ATiO.Put_Line ("Alhamdulillah 3 times WRY");
   
-- Catch every possible error using built-in package Ada.Standard
exception
	when Constraint_Error =>
		ATIO.Put_Line("Constraint_Error raised.");
	when Program_Error =>
		ATIO.Put_Line("Program_Error raised.");
	when Storage_Error =>
		ATIO.Put_Line("Storage_Error raised.");
	when Tasking_Error =>
		ATIO.Put_Line("Task_Error raised.");
	when Others =>
       ATIO.Put_Line("Others raised. Unknown error.");
      
  -- null;
end main_ada_ppdev;

