/* USER SPACE PARALLEL PORT USING PPDEV
 * File: ada_ppdev.h
 *
 *  Created on: Dec 4, 2020
 *      Author: wruslan
=========================================================== 
*/

#ifndef _ADA_PPDEV_H_
#define _ADA_PPDEV_H_

// ADDED BY WRY
#include <time.h> 		   // For high-res timer clock_gettime with (nanoseconds)
#include <sys/time.h>	 // For local date-time with (microseconds)
#include <unistd.h>     // getcwd(), close(0
#include <limits.h>     // perror()

// ========================================================
//-- (1) to (2)
int ada_open_parport(const char *the_port, int fd_attrib);
int ada_ioctl_ppclaim_parport(int fd_ada);
//-- (3) to (5)
int ada_ioctl_ppgetmodes_parport(int fd_ada);
int ada_ioctl_ppsetmode_parport(int fd_ada, int modetoset);
int ada_ioctl_ppgetmode_current(int fd_ada);
//-- (6) to (7)
int ada_ioctl_ppsetflags_parport(int fd_ada, int flagstoset);
int ada_ioctl_ppgetflags_current(int fd_ada);
//-- (8) to (9)
int ada_ioctl_ppsetphase_parport(int fd_ada, int phasetoset);
int ada_ioctl_ppgetphase_current(int fd_ada);
// -- (10) to (12)
int ada_ioctl_ppdatadir_dataport(int fd_ada, int datadirection);
int ada_ioctl_ppwdata_writedataregister(int fd_ada, int datatowrite);
int ada_ioctl_pprdata_readdataregister(int fd_ada);
// -- (13) 
int ada_ioctl_pprstatus_readstatusregister(int fd_ada);
// -- (14) to (15)
int ada_ioctl_ppwcontrol_writecontrolregister(int fd_ada, int controltowrite);
int ada_ioctl_pprcontrol_readcontrolregister(int fd_ada);
// -- (16) to (19)
int ada_ioctl_ppfcontrol_frob1(void);
int ada_ioctl_ppfcontrol_frob2(void);
int ada_ioctl_ppwctlonirq_controlport(int fd_ada, int the_interrupt);
int ada_ioctl_ppclrirq_controlport(int fd_ada, int the_interrupt);
// -- (20) to (22)
int ada_ioctl_ppnegot_mode(int fd_ada, int modetoset);
int ada_ioctl_ppyield_parport(int fd_ada);
int ada_ioctl_ppgettime_usec_parport(int fd); 
// -- (23) to (24)
int ada_ioctl_pprelease_parport(void);
int ada_close_parport(int fd);

// -- (X1)
int ada_ioctl_ppexcl_parport(int fd_ada);
// -- (X2)
int ada_ioctl_ppsettime_timeoutparport(int fd_ada, int timeout);

// ========================================================

#endif /* _ADA_PPDEV_H_ */

