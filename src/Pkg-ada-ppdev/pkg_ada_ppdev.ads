with Interfaces.C;
with Interfaces.C.Extensions;

-- TO INTERFACE TO C, just create the spec ads file, not the adb file, 
-- Otherwise, we have an infinite recursion. Just spec and no body.

package pkg_ada_ppdev is
   package IFaceC renames Interfaces.C; 
   package IFaceCE renames Interfaces.C.Extensions;
   
   -- Aspect specification only (ads file) and not body (adb file).
   -- Convention used in this specification
   -- (1) For Ada to call void C-function, use "ExeC_" as prefix 
   -- (2) For Ada to call return-value C-function, use "GetC_" prefix.
 
   -- SECTION ON ADA INTERFACE TO C-PROCEDURES 
   -- ======================================================
   -- This procedure does not return anything (void). Performs something.
      
 --  procedure ExeC_ada_system_environment
 --    with Import => True, Convention => C,
 --    External_Name => "ada_system_environment";  

 -- void current_working_directory(void)  
 procedure ExeC_ada_current_working_directory
     with Import => True, Convention => C,
     External_Name => "current_working_directory";    
 
 -- void display_date_only(void)  
 procedure ExeC_ada_display_date_only
     with Import => True, Convention => C,
     External_Name => "display_date_only";    
 
 --  procedure ExeC_proc_add (a, b, result : IFaceC.int) 
 --    with Import => True, Convention => C,
 --    External_Name => "proc_add";  
    
   -- SECTION ON ADA INTERFACE TO C-FUNCTIONS
   -- =====================================================
  -- (1)  
  function GetC_ada_open_parport(the_port : in IFaceC.char_array; fd_attrib : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_open_parport";
   
  -- (2) 
  function GetC_ada_ioctl_ppclaim_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppclaim_parport";
  
   -- (3) 
  function GetC_ada_ioctl_ppgetmodes_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetmodes_parport";       
   
  -- (4)  
  function GetC_ada_ioctl_ppsetmode_parport(fd, modetoset : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetmode_parport";   
   
  -- (5)    
  function GetC_ada_ioctl_ppgetmode_current(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetmode_current";           

  -- (6)  
  function GetC_ada_ioctl_ppsetflags_parport(fd, flagstoset : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetflags_parport";       
   
  -- (7)  
  function GetC_ada_ioctl_ppgetflags_current(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetflags_current";        
   
  -- (8) 
  function GetC_ada_ioctl_ppsetphase_parport(fd, phasetoset : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetphase_parport";    
  
  -- (9)  
  function GetC_ada_ioctl_ppgetphase_current(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetphase_current";        
   
  -- (10) 
  function GetC_ada_ioctl_ppdatadir_dataport(fd, datadirection : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppdatadir_dataport";      
  
  -- (11) 
  function GetC_ada_ioctl_ppwdata_writedataregister(fd, datatowrite : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwdata_writedataregister";   
   
   -- (111.1)
   -- int ada_ioctl_streamdata_writedataregister(int fd_ada, char *stream_datatowrite)
   function GetC_ada_ioctl_streamdata_writedataregister(fd :in IFaceC.int; stream_datatowrite : in IFaceC.char_array) return IFaceC.int 
      with Import => True, Convention => C, 
      External_Name => "ada_ioctl_streamdata_writedataregister";   
      
  -- (12)  
  function GetC_ada_ioctl_pprdata_readdataregister(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprdata_readdataregister"; 
   
   -- (13) 
   function GetC_ada_ioctl_pprstatus_readstatusregister(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprstatus_readstatusregister";
   
   -- (14)
   function GetC_ada_ioctl_ppwcontrol_writecontrolregister(fd, controltowrite : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwcontrol_writecontrolregister";   
   
   -- (15) 
   function GetC_ada_ioctl_pprcontrol_readcontrolregister(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprcontrol_readcontrolregister";
   
   -- (16)
   function GetC_ada_ioctl_ppfcontrol_frob1 return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppfcontrol_frob1";   
   
   -- (17)
   function GetC_ada_ioctl_ppfcontrol_frob2 return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppfcontrol_frob2";   
   
   -- (18)
   function GetC_ada_ioctl_ppwctlonirq_controlport(fd, the_interrupt : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwctlonirq_controlport";      
      
   -- (19)
   function GetC_ada_ioctl_ppclrirq_controlport(fd, the_interrupt : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppclrirq_controlport";      
   
   -- (20)
   function GetC_ada_ioctl_ppnegot_mode(fd, modetonegot : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppnegot_mode";

   -- (21)
   function GetC_ada_ioctl_ppyield_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppyield_parport";   
   
   -- (22)
   function GetC_ada_ioctl_ppgettime_usec_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgettime_usec_parport";         

  -- (23)  
  function GetC_ada_ioctl_pprelease_parport return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprelease_parport";      
   
  -- (24)
  function GetC_ada_close_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_close_parport";
   
-- ==========================================================
-- (X1)    
function GetC_ada_ioctl_ppexcl_parport (fd : in IFaceC.int) return IFaceC.int 
    with Import => True, Convention => C, 
    External_Name => "ada_ioctl_ppexcl_parport";   
-- (X2)
function GetC_ada_ioctl_ppsettime_timeoutparport (fd, timeout : in IFaceC.int) return IFaceC.int 
    with Import => True, Convention => C, 
    External_Name => "ada_ioctl_ppsettime_timeoutparport";      

-- (X2) Not implemended SETTIME	sets device timeout (struct timeval)
   
 --* ioctl
 --*   EXCL	register device exclusively (may fail)
 --*   RELEASE	parport_release
 --*   SETMODE	set the IEEE 1284 protocol to use for read/write
 --*   SETPHASE	set the IEEE 1284 phase of a particular mode.  Not to be confused with ioctl(fd, SETPHASER, &stun). ;-)
 --*   DATADIR	data_forward / data_reverse
 --*   WDATA	write_data
 --*   RDATA	read_data
 --*   WCONTROL	write_control
 --*   RCONTROL	read_control
 --*   FCONTROL	frob_control
 --*   RSTATUS	read_status
 --*   NEGOT	parport_negotiate
 --*   YIELD	parport_yield_blocking
 --*   WCTLONIRQ	on interrupt, set control lines
 --*   CLRIRQ	clear (and return) interrupt count
 --*   SETTIME	sets device timeout (struct timeval)
 --*   GETTIME	gets device timeout (struct timeval)
 --*   GETMODES	gets hardware supported modes (unsigned int)
 --*   GETMODE	gets the current IEEE1284 mode
 --*   GETPHASE   gets the current IEEE1284 phase
 --*   GETFLAGS   gets current (user-visible) flags
 --*   SETFLAGS   sets current (user-visible) flags
 --* read/write	read or write in current IEEE 1284 protocol
 --* select	wait for interrupt (in readfds)
      
end pkg_ada_ppdev;
 
