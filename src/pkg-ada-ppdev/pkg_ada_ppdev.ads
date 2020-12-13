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
   
 --  procedure ExeC_proc_add (a, b, result : IFaceC.int) 
 --    with Import => True, Convention => C,
 --    External_Name => "proc_add";  
    
   -- SECTION ON ADA INTERFACE TO C-FUNCTIONS
   -- =====================================================
   
  -- (1) int ada_open_parport(const char *the_port, int fd_attrib);
  function GetC_ada_open_parport(the_port : in IFaceC.char_array; fd_attrib : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_open_parport";
   
  -- (2) int ada_ioctl_ppclaim_parport(void);
  function GetC_ada_ioctl_ppclaim_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppclaim_parport";
    
 -- (3) int ada_ioctl_ppnegot_mode(int fd_ada, int mode_ada);
 function GetC_ada_ioctl_ppnegot_mode(fd : in IFaceC.int; mode_ada : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppnegot_mode";
   
 -- (4) int ada_ioctl_ppfcontrol_frob1(void); 
 function GetC_ada_ioctl_ppfcontrol_frob1 return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppfcontrol_frob1";   

-- (5) int ada_ioctl_ppwdata_writedataregister(int fd, int datatowrite); 
function GetC_ada_ioctl_ppwdata_writedataregister(fd : in IFaceC.int; datatowrite : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwdata_writedataregister";   
  
-- (6) int ada_ioctl_ppfcontrol_frob2(void);
function GetC_ada_ioctl_ppfcontrol_frob2 return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppfcontrol_frob2";   
  
-- (7) int ada_ioctl_pprdata_readdataregister(int fd);
function GetC_ada_ioctl_pprdata_readdataregister(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprdata_readdataregister";

-- (8) int ada_ioctl_pprstatus_readstatusregister(int fd_ada); 
function GetC_ada_ioctl_pprstatus_readstatusregister(fd : in IFaceC.int; statustoread : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprstatus_readstatusregister";
   
-- (9) int ada_ioctl_pprcontrol_readcontrolregister(int fd);
function GetC_ada_ioctl_pprcontrol_readcontrolregister(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprcontrol_readcontrolregister";
   
-- (10) int ada_ioctl_ppwcontrol_writecontrolregister(int fd_ada, int controltowrite);
function GetC_ada_ioctl_ppwcontrol_writecontrolregister(fd : in IFaceC.int; controltowrite : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwcontrol_writecontrolregister";   
   
-- (11) int ada_ioctl_ppsetmode_parport(int fd_ada, int modetoset);   
function GetC_ada_ioctl_ppsetmode_parport(fd : in IFaceC.int; modetoset : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetmode_parport";   
     
-- (12) int ada_ioctl_ppyield_parport(int fd_ada);   
function GetC_ada_ioctl_ppyield_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppyield_parport";   

-- (13) int ada_ioctl_ppexcl_parport(int fd_ada)   
function GetC_ada_ioctl_ppexcl_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppexcl_parport";   
      
-- (14) int ada_ioctl_ppdatadir_dataport(int fd_ada, int datadirection)   
function GetC_ada_ioctl_ppdatadir_dataport(fd : in IFaceC.int; datadirection : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppdatadir_dataport";      

-- (15) int ada_ioctl_ppwctlonirq_controlport(int fd_ada, int the_interrupt)   
function GetC_ada_ioctl_ppwctlonirq_controlport(fd : in IFaceC.int; the_interrupt : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppwctlonirq_controlport";      
   
-- (16) int ada_ioctl_ppclrirq_controlport(int fd_ada, int the_interrupt);   
function GetC_ada_ioctl_ppclrirq_controlport(fd : in IFaceC.int; the_interrupt : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppclrirq_controlport";      
   
-- (17) int ada_ioctl_ppsetphase_parport(int fd_ada, int the_phase)   
function GetC_ada_ioctl_ppsetphase_parport(fd : in IFaceC.int; the_phase : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetphase_parport";      

-- (18) int ada_ioctl_ppgettime_usec_parport(int fd); 
function GetC_ada_ioctl_ppgettime_usec_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgettime_usec_parport";         
   
-- (19) ppsettime_usec_parport(fd) is not allowed   
-- (20) int ada_ioctl_ppgetmodes_parport(int fd_ada, int the_ppmodes);   
function GetC_ada_ioctl_ppgetmodes_parport(fd : in IFaceC.int; the_ppmodes : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetmodes_parport";            
   
-- (21) int ada_ioctl_ppgetmode_current(int fd_ada, int curr_ppmode);   
function GetC_ada_ioctl_ppgetmode_current(fd : in IFaceC.int; curr_ppmode : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetmode_current";            
   
-- (22) int ada_ioctl_ppgetphase_current(int fd_ada, int curr_ppphase);   
function GetC_ada_ioctl_ppgetphase_current(fd : in IFaceC.int; curr_ppphase : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetphase_current";       
   
-- (23) int ada_ioctl_ppsetflags_parport(int fd_ada, int the_flags);
function GetC_ada_ioctl_ppsetflags_parport(fd : in IFaceC.int; the_flags : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppsetflags_parport";       
  
-- (24) int ada_ioctl_ppgetflags_parport(int fd_ada, int the_flags);   
function GetC_ada_ioctl_ppgetflags_parport(fd : in IFaceC.int; the_flags : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_ppgetflags_parport";       
   
-- int ada_ioctl_pprelease_parport(void);  
function GetC_ada_ioctl_pprelease_parport return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_ioctl_pprelease_parport";      
   
-- int ada_close_parport(int fd);
function GetC_ada_close_parport(fd : in IFaceC.int) return IFaceC.int 
     with Import => True, Convention => C, 
     External_Name => "ada_close_parport";
  
   
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
 
