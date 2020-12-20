/* USER SPACE PARALLEL PORT USING PPDEV
 * File: Cada_ppdev.c
 *
 *  Created on: Dec 4, 2020
 *      Author: wruslan
=========================================================== 
wruslan@HPEliteBook8470p-Ub2004-rt38:~/temp4$ date
Fri 04 Dec 2020 10:36:46 AM +08

wruslan@HPEliteBook8470p-Ub2004-rt38:~/temp4$ uname -a
Linux HPEliteBook8470p-Ub2004-rt38 5.4.66-rt38 
#1 SMP PREEMPT_RT Sat Sep 26 16:51:59 +08 2020 x86_64 x86_64 x86_64 GNU/Linux

wruslan@HPEliteBook8470p-Ub2004-rt38:~/temp4$ lsb_release -a
LSB Version:	core-11.1.0ubuntu2-noarch:security-11.1.0ubuntu2-noarch
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.1 LTS
Release:	20.04
Codename:	focal
wruslan@HPEliteBook8470p-Ub2004-rt38:~/temp4$ 

===========================================================
An Undefined Reference error occurs when we have a reference to 
object name (class, function, variable, etc.) in our program and 
the linker cannot find its definition when it tries to search for 
it in all the linked object files and libraries.

*/
// ========================================================
// ADDED BY WRY
#include <time.h> 		   // For high-res timer clock_gettime with (nanoseconds)
#include <sys/time.h>	 // For local date-time with (microseconds)
#include <unistd.h>     // getcwd(), close(0
#include <limits.h>     // perror()

// C-HEADERS
#include <fcntl.h>
#include <sys/fcntl.h> 	// for open(), close(), O_RDWR, and so on
#include <sys/types.h>
#include <sys/stat.h>		// for stat(), lstat(), and stat()
#include <sys/ioctl.h>		// for ioctl()       
#include <stdio.h>			  // for printf()
#include <stdlib.h>			// for exit()
#include <stdbool.h>		  // for bool type

#include <linux/parport.h>
#include <linux/ppdev.h>
#include "Cada_ppdev.h"   // ADDED BY WRY Calls the C-MODULE HEADER

// ========================================================
// GLOBAL DEFINITIONS FOR (18) ada_ioctl_ppgettime_usec_parport(fd)
// ========================================================
time_t   	the_time;
char     the_strbuffer1[26];
char     the_strbuffer2[60];
struct tm*      the_tminfo;
struct timeval  current_time;
struct timeval  thetime_sec_now;
struct timeval  thetime_usec_now;
struct timespec thetime_nsec_now;

// ========================================================
// https://www.rapidtables.com/convert/number/hex-to-binary.html

#define SPPDATAPORT    0x378
#define SPPSTATUSPORT  (SPPDATAPORT + 1)
#define SPPCONTROLPORT (SPPDATAPORT + 2)

#define OUTPUTENABLE 0x02     // BIN= 00000010  INT= 2 
#define OUTPUTLATCH  0x04     // BIN= 00000100  INT= 4
// value (OUTPUTENABLE|OUTPUTLATCH) HEX= 0x06 BIN= 00000110 INT= 6

// PARPORT FLAGS
#define PP_FASTWRITE	 (1<<2)   // BIN= 00000100  HEX= 0x04  INT= 4
#define PP_FASTREAD	 (1<<3)   // BIN= 00001000  HEX= 0x08  INT= 8
#define PP_W91284PIC	 (1<<4)   // BIN= 00010000  HEX= 0x10  INT= 16
#define PP_FLAGMASK	(PP_FASTWRITE | PP_FASTREAD | PP_W91284PIC)  // HEX= 0x1C  BIN= 00011100 INT= 28

#define PPDATADIR_IN  1   // (Non-zero) SET DATA PORT FOR INPUT
#define PPDATADIR_OUT 0   // (Zero) SET DATA PORT FOR OUTPUT


struct ppdev_frob_struct frob;
// struct ppdev_frob_struct {
//     unsigned char mask;
//     unsigned char val;
// };

// ========================================================
// GLOBAL VARIABLES
// ========================================================
int fd_ada; 
unsigned char status_ada, data_ada;
const char *port_ada = "/dev/parport0";
int fd_attrib_ada;
int mode_ada;

// ========================================================
void convert_int2bin8(int input_int, char *output_bin8) {
// ========================================================
    unsigned int mask8;
    mask8  = 0b10000000; 
    // printf("INTEGER INPUT = %d \n", input_int);
	
    int bitposition = 0;    
    while (mask8)          		     // Loop until MASK is empty
    {
        bitposition++;
        if (input_int & mask8)    	// Bitwise AND => test the masked bit
        {
            *output_bin8 = '1';   // if true, binary value 1 is appended to output array

        } else {
            *output_bin8 = '0';   // if false, binary value 0 is appended to output array
        } // END if..else

	      output_bin8++;            // next character
        mask8 >>= 1;              // shift the mask variable 1 bit to the right
    } // END while
  
    *output_bin8 = 0;             // add the trailing null 
}
// ===================================================
void current_working_directory(void) {
// ===================================================
   char cwd[255];
   if (getcwd(cwd, sizeof(cwd)) != NULL) {
	   printf("Current directory: %s\n", cwd);
   } else {
	   perror("getcwd() error");
   }

}
// ========================================================
void display_date_only(void) {
// ========================================================
  time(&the_time);
  the_tminfo = localtime(&the_time);
  strftime(the_strbuffer1, 26, "%Y-%m-%d %H:%M:%S", the_tminfo);
  strftime(the_strbuffer2, 60, "%a %b %d, %Y %H:%M:%S", the_tminfo);
  
  //printf("%s \n", the_strbuffer1);
  printf("%s \n", the_strbuffer2);
  
}
// NO. 01
// ========================================================
int ada_open_parport(const char *port_ada, int fd_attrib_ada) {
// ========================================================
  fd_ada = open(port_ada, fd_attrib_ada);
  if (fd_ada == -1) {
    perror("open");
    printf("Call FAILED. Open parallel port %s , fd_attrib = %d , fd = %d \n", port_ada, fd_attrib_ada, fd_ada);
    exit(1);
  } else {
  
     /*
   O_RDONLY  : IFaceC.int    := 0; -- HEx= 0x00  BIN= 00000000
   O_WRONLY  : IFaceC.int    := 1; -- HEx= 0x01  BIN= 00000001
   O_RDWR    : IFaceC.int    := 2; -- HEx= 0x02  BIN= 00000010
   O_ACCMODE : IFaceC.int    := 3; -- HEx= 0x03  BIN= 00000011
     */
    printf("Success. OPEN parallel port = %s, fd_ada = %d, fd_attrib_ada = ", port_ada, fd_ada);
    switch (fd_attrib_ada) {
          case 0 :
               printf("0 = O_RDONLY \n");
               break;
          case 1 :
               printf("1 = O_WRONLY \n");
               break;
          case 2 :
               printf("2 = O_RDWR \n");
               break;
          case 3 :
               printf("3 = O_ACCMODE \n");
               break;
          default:
               printf("ERROR: Unknown file descriptor attribute. \n");
       } // END switch..case
      
  }
int result01 = fd_ada;
return (result01);
}
// NO. 02
// ========================================================
int ada_ioctl_ppclaim_parport(int fd_ada) {
// ========================================================
/* Claim the port to start using it */
// DONE (2) #define PPCLAIM		_IO(PP_IOCTL, 0x8b)

  int result02 = ioctl(fd_ada, PPCLAIM);
  if (result02 != 0) {
      printf("Call FAILED. Request PPCLAIM access to the_port %s , fd_ada = %d , result02 = %d \n", port_ada, fd_ada, result02);
      close(fd_ada);
      exit(1);
  } else {
      printf("Success. PPCLAIM access to parport: the_port %s , fd_ada = %d \n", port_ada, fd_ada);
  }  
return(result02);
}
// NO. 03 
// ========================================================
int ada_ioctl_ppgetmodes_parport(int fd_ada) {
// ========================================================
/* Get available modes (what the hardware can do) */
// (20) #define PPGETMODES	_IOR(PP_IOCTL, 0x97, unsigned int)

int the_ppmodes;
char the_ppmodes_bin8[9];  

int result03 = ioctl(fd_ada, PPGETMODES, &the_ppmodes);
  if (result03 != 0)
  {
    perror ("PPGETMODES");
    close (fd_ada);
    printf("Call FAILED.  Get available modes (hardware capabilities). fd_ada = %d , result03 = %d \n", fd_ada, result03);
    exit(1); 
  } else {
    printf("Get PPGETMODES parport capability modes: fd_ada = %d port %s \n", fd_ada, port_ada);
    convert_int2bin8(the_ppmodes, the_ppmodes_bin8);
    printf("\tPARALLEL PORT HARDWARE MODES: INT= %d BIN= %s\n", the_ppmodes, the_ppmodes_bin8);
    
    // #define PARPORT_MODE_PCSPP	(1<<0)      00000001     /* IBM PC registers available. */
    // #define PARPORT_MODE_TRISTATE	(1<<1)    00000010     /* Can tristate. */
    // #define PARPORT_MODE_EPP	(1<<2)        00000100      /* Hardware EPP. */
    // #define PARPORT_MODE_ECP	(1<<3)        00001000      /* Hardware ECP. */
    // #define PARPORT_MODE_COMPAT	(1<<4)      00010000      /* Hardware 'printer protocol'. */
    // #define PARPORT_MODE_DMA	(1<<5)        00100000      /* Hardware can DMA. */
    // #define PARPORT_MODE_SAFEININT (1<<6)  01000000      /* SPP registers accessible in IRQ. */
      
      if (the_ppmodes_bin8[7] == '1') { printf("\tPARPORT_MODE_PCSPP     00000001 \n"); } 
      if (the_ppmodes_bin8[6] == '1') { printf("\tPARPORT_MODE_TRISTATE  00000010 \n"); } 
      if (the_ppmodes_bin8[5] == '1') { printf("\tPARPORT_MODE_EPP       00000100 \n"); } 
      if (the_ppmodes_bin8[4] == '1') { printf("\tPARPORT_MODE_ECP       00001000 \n"); } 
      if (the_ppmodes_bin8[3] == '1') { printf("\tPARPORT_MODE_COMPAT    00010000 \n"); } 
      if (the_ppmodes_bin8[2] == '1') { printf("\tPARPORT_MODE_DMA	       00100000 \n"); } 
      if (the_ppmodes_bin8[1] == '1') { printf("\tPARPORT_MODE_SAFEININT 01000000 \n"); } 
  }

return (result03);
}
// NO. 4
// ========================================================
int ada_ioctl_ppsetmode_parport(int fd_ada, int modetoset) {
// ========================================================
/* Set mode for read/write (e.g. IEEE1284_MODE_EPP) */
// (11) #define PPSETMODE	_IOW(PP_IOCTL, 0x80, int)
// PPSETMODE	: IFaceC.int := 128; -- HEX 0x80
  
// FROM /usr/include/uapi/linux/parport.h
// Magic numbers 
// #define PARPORT_IRQ_NONE  -1
// #define PARPORT_DMA_NONE  -1
// #define PARPORT_IRQ_AUTO  -2
// #define PARPORT_DMA_AUTO  -2
// #define PARPORT_DMA_NOFIFO -3
// #define PARPORT_DISABLE   -2
// #define PARPORT_IRQ_PROBEONLY -3
// #define PARPORT_IOHI_AUTO -1

// #define PARPORT_CONTROL_STROBE    0x1
// #define PARPORT_CONTROL_AUTOFD    0x2
// #define PARPORT_CONTROL_INIT      0x4
// #define PARPORT_CONTROL_SELECT    0x8

// #define PARPORT_STATUS_ERROR      0x8
// #define PARPORT_STATUS_SELECT     0x10
// #define PARPORT_STATUS_PAPEROUT   0x20
// #define PARPORT_STATUS_ACK        0x40
// #define PARPORT_STATUS_BUSY       0x80 
  
// Mode (1 << 8) means:  shifting bits 8 steps to the left from 
// 00000000 00000001 to become 00000001 00000000

// The "modes" entry in parport is a bit field representing the capabilities of the hardware.
// #define PARPORT_MODE_PCSPP	(1<<0)      /* IBM PC registers available. */
// #define PARPORT_MODE_TRISTATE	(1<<1)  /* Can tristate. */
// #define PARPORT_MODE_EPP	(1<<2)       /* Hardware EPP. */
// #define PARPORT_MODE_ECP	(1<<3)       /* Hardware ECP. */
// #define PARPORT_MODE_COMPAT	(1<<4)     /* Hardware 'printer protocol'. */
// #define PARPORT_MODE_DMA	(1<<5)       /* Hardware can DMA. */
// #define PARPORT_MODE_SAFEININT	(1<<6)   /* SPP registers accessible in IRQ. */

 /*
[    8.563950] lp: driver loaded but no devices found
[    8.621481] systemd[1]: Started Journal Service.
[    8.642951] ppdev: user-space parallel port driver
[    8.662919] parport_pc 00:05: reported by Plug and Play ACPI
[    8.663322] systemd-journald[415]: Received client request to flush runtime journal.
[    8.663086] parport0: PC-style at 0x378 (0x778), irq 5, using FIFO [PCSPP,TRISTATE,COMPAT,EPP,ECP]
[    8.759758] lp0: using parport0 (interrupt-driven).
*/

  int result04;
  char modetoset_bin8[9];
  // modetoset = PARPORT_MODE_ECP;  // (1<<3) = 00000000 00001000
  
  result04 = ioctl(fd_ada, PPSETMODE, &modetoset); 
  if (result04 != 0)
  {
      perror("fd_ada");
      printf("Call FAILED.  Set PPSETMODE for fd_ada = %d, modetoset = %d result04 = %d \n", fd_ada, modetoset, result04);
      exit(1);
  } else {
     printf("Set PPSETMODE for parport mode: fd_ada = %d, modetoset = %d => ", fd_ada, modetoset);
     convert_int2bin8(modetoset, modetoset_bin8);
    
      if (modetoset_bin8[7] == '1') { printf("PARPORT_MODE_PCSPP \n"); } 
      if (modetoset_bin8[6] == '1') { printf("PARPORT_MODE_TRISTATE \n"); } 
      if (modetoset_bin8[5] == '1') { printf("PARPORT_MODE_EPP \n"); } 
      if (modetoset_bin8[4] == '1') { printf("PARPORT_MODE_ECP \n"); } 
      if (modetoset_bin8[3] == '1') { printf("PARPORT_MODE_COMPAT \n"); } 
      if (modetoset_bin8[2] == '1') { printf("PARPORT_MODE_DMA	 \n"); } 
      if (modetoset_bin8[1] == '1') { printf("PARPORT_MODE_SAFEININT \n"); } 
   
  }
  
return(result04); 
}  
// NO. 05
// ========================================================
int ada_ioctl_ppgetmode_current(int fd_ada) {
// ========================================================
int  the_mode;  
char the_mode_bin8[9];    

int result05 = ioctl(fd_ada, PPGETMODE, &the_mode);
  if (result05 != 0)
  {
    perror ("PPGETMODE");
    close (fd_ada);
    printf("Call FAILED. Get the current mode PPGETMODE. fd_ada = %d , result05 = %d \n", fd_ada, result05);
    exit(1); 
  } else {
    printf("Get PPGETMODE current parport mode: fd_ada = %d, ", fd_ada);
    convert_int2bin8(the_mode, the_mode_bin8);
    printf("the_mode: INT= %d BIN= %s = ", the_mode, the_mode_bin8);
    
      if (the_mode_bin8[7] == '1') { printf("PARPORT_MODE_PCSPP \n"); } 
      if (the_mode_bin8[6] == '1') { printf("PARPORT_MODE_TRISTATE \n"); } 
      if (the_mode_bin8[5] == '1') { printf("PARPORT_MODE_EPP \n"); } 
      if (the_mode_bin8[4] == '1') { printf("PARPORT_MODE_ECP \n"); } 
      if (the_mode_bin8[3] == '1') { printf("PARPORT_MODE_COMPAT \n"); } 
      if (the_mode_bin8[2] == '1') { printf("PARPORT_MODE_DMA	 \n"); } 
      if (the_mode_bin8[1] == '1') { printf("PARPORT_MODE_SAFEININT \n"); } 
  }  

return (result05);  
}  
// NO. 06
// ========================================================
int ada_ioctl_ppsetflags_parport(int fd_ada, int flagstoset) {
// ========================================================
  
// #define PP_FASTWRITE	(1<<2)  BIN= 00000100  INT= 4
// #define PP_FASTREAD		(1<<3)  BIN= 00001000  INT= 8
// #define PP_W91284PIC	(1<<4)  BIN= 00010000  INT= 16 
// #define PP_FLAGMASK	(PP_FASTWRITE | PP_FASTREAD | PP_W91284PIC)  
  char flagstoset_bin8[9];
  
  int the_mask = PP_FLAGMASK;
  char the_mask_bin8[9];
  convert_int2bin8(the_mask, the_mask_bin8);
  // printf("(23) the_mask INT= %d BIN= %s\n", the_mask, the_mask_bin8);

  int result06 = ioctl(fd_ada, PPSETFLAGS, &flagstoset);
  if (result06 != 0)
  {
    perror ("PPSETFLAGS");
    close (fd_ada);
    printf("Call FAILED. Set parport flag PPSETFLAGS. fd_ada = %d , flagstoset = %d, result06 = %d \n", fd_ada, flagstoset, result06);
    exit(1); 
  } else {
    printf("Set PPSETFLAGS for parport flags: fd_ada = %d, flagstoset = %d => ", fd_ada, flagstoset);
    
    convert_int2bin8(flagstoset, flagstoset_bin8);
        
    if (flagstoset == 4) { printf(" PP_FASTWRITE "); }
    if (flagstoset == 8) { printf(" PP_FASTREAD "); }
    if (flagstoset == 12) { printf(" PP_FASTWRITE | PP_FASTREAD "); }
    if (flagstoset == 16) { printf(" PP_W91284PIC ");} 
    if (flagstoset == 20) { printf(" PP_FASTWRITE | PP_W91284PIC "); }
    if (flagstoset == 24) { printf(" PP_FASTREAD | PP_W91284PIC  "); }
    if (flagstoset == 28) { printf(" PP_FLAGMASK "); }
  }
  printf("\n");
return (result06);  
}
// NO. 07
// ========================================================
int ada_ioctl_ppgetflags_current(int fd_ada) {
// ========================================================
  int the_flags;
  char the_flags_bin8[9];
  
  int result07 = ioctl(fd_ada, PPGETFLAGS, &the_flags);
  if (result07 != 0)
  {
    perror ("PPGETFLAGS");
    close (fd_ada);
    printf("Call FAILED. Get parport flag PPGETFLAGS. fd_ada = %d , the_flags = %d , result07 = %d \n", fd_ada, the_flags, result07);
    exit(1); 
  } else {
    printf("Get PPGETFLAGS current parport flags: fd_ada = %d, the_flags: ", fd_ada);
  
    convert_int2bin8(the_flags, the_flags_bin8);
    printf("INT= %d BIN= %s = ", the_flags, the_flags_bin8);
    
    switch (the_flags) {
          case 4 :
               printf(" PP_FASTWRITE  \n");
               break;
          case 8 :
               printf(" PP_FASTREAD	\n");
               break;
          case 12 :
               printf(" PP_FASTWRITE | PP_FASTREAD 	\n");
               break;
          case 20:
               printf(" PP_FASTWRITE | PP_W91284PIC 	\n");
               break;
          case 16 :
               printf(" PP_W91284PIC  \n");
               break;
          case 24 :
               printf(" PP_FASTREAD | PP_W91284PIC  \n");
               break;
          case 28 :
               printf(" PP_FLAGMASK \n");
               break;
          default:
               printf(" ERROR: Unknown flags for PARPORT \n");
     } // END switch..case  
        
  } // END if..else
  
return (result07);  
}
// No. 08
// ========================================================
int ada_ioctl_ppsetphase_parport(int fd_ada, int phasetoset) {
// ========================================================
/* Set the IEEE 1284 phase that we're in (e.g. IEEE1284_PH_FWD_IDLE) */
// (17) #define PPSETPHASE	_IOW(PP_IOCTL, 0x94, int)

// PPSETPHASE : IFaceC.int := 148; -- HEX 0x94

  
  int result08 = ioctl(fd_ada, PPSETPHASE, &phasetoset);
  if (result08 != 0)
  {
    perror ("PPSETPHASE");
    close (fd_ada);
    printf("Call FAILED. Set IEEE 1284 phase PPSETPHASE. fd_ada = %d , ieee1284_phase = %d, result08 = %d \n", fd_ada, phasetoset, result08);
    exit(1); 
  } else {
    printf("Set PPSETPHASE for parport phase: fd_ada = %d, phasetoset = %d => ", fd_ada, phasetoset);
    
    switch (phasetoset) {
          case 0 :
               printf("IEEE1284_PH_FWD_DATA \n");
               break;
          case 1 :
               printf("IEEE1284_PH_FWD_IDLE \n");
               break;
          case 2 :
               printf("IEEE1284_PH_TERMINATE \n");
               break;
          case 3 :
               printf("IEEE1284_PH_NEGOTIATION \n");
               break;
          case 4 :
               printf("IEEE1284_PH_HBUSY_DNA \n");
               break;
          case 5 :
               printf("IEEE1284_PH_REV_IDLE \n");
               break;
          case 6 :
               printf("IEEE1284_PH_HBUSY_DAVAIL \n");
               break;
          case 7 :
               printf("IEEE1284_PH_REV_DATA \n");
               break;
          case 8 :
               printf("IEEE1284_PH_ECP_SETUP \n");
               break;
          case 9 :
               printf("IEEE1284_PH_ECP_FWD_TO_REV \n");
               break;
          case 10 :
               printf("IEEE1284_PH_ECP_REV_TO_FWD \n");
               break;
          case 11 :
               printf("IEEE1284_PH_ECP_DIR_UNKNOWN \n");
               break;       
          default:
               printf("ERROR: Unknown IEEE1284_PHASE \n");
     } // END switch..case
    
  } // END if..else

return (result08);
}
// No. 09
// ========================================================
int ada_ioctl_ppgetphase_current(int fd_ada) {
// ========================================================
/* Get the current mode and phase */
// (22) #define PPGETPHASE	_IOR(PP_IOCTL, 0x99, int)
  int the_ppphase;
  char the_ppphase_bin8[9]; 
  
  int result09 = ioctl(fd_ada, PPGETPHASE, &the_ppphase);
  if (result09 != 0)
  {
    perror ("PPGETPHASE");
    close (fd_ada);
    printf("Call FAILED. Get the current phase PPGETPHASE. fd_ada = %d , result09 = %d \n", fd_ada, result09);
    exit(1); 
  } else {
    printf("Get PPGETPHASE current parport phase: fd_ada = %d, ", fd_ada);
    convert_int2bin8(the_ppphase, the_ppphase_bin8);
    printf("the_phase: INT= %d BIN= %s = ", the_ppphase, the_ppphase_bin8);
   
    switch (the_ppphase) {
          case 0 :
               printf("IEEE1284_PH_FWD_DATA  \n");
               break;
          case 1 :
               printf("IEEE1284_PH_FWD_DATA  \n");
               break;
          case 2 :
               printf("IEEE1284_PH_TERMINATE  \n");
               break;
          case 3 :
               printf("IEEE1284_PH_NEGOTIATION \n");
               break;
          case 4 :
               printf("IEEE1284_PH_HBUSY_DNA \n");
               break;
          case 5 :
               printf("IEEE1284_PH_REV_IDLE  \n");
               break;
          case 6 :
               printf("IEEE1284_PH_HBUSY_DAVAIL  \n");
               break;
          case 7 :
               printf("IEEE1284_PH_REV_DATA \n");
               break;
          case 8 :
               printf("IEEE1284_PH_ECP_SETUP \n");
               break;
          case 9:
               printf("IEEE1284_PH_ECP_FWD_TO_REV \n");
               break;
          case 10 :
               printf("IEEE1284_PH_ECP_REV_TO_FWD \n");
               break;
          case 11:
               printf("IEEE1284_PH_ECP_DIR_UNKNOWN \n");
               break;
          default:
               printf("ERROR: Unknown phase for PARPORT \n");
       } // END switch..case
       
  }  // END if..else
  
return(result09);
}
// NO. 10
// ========================================================
int ada_ioctl_ppdatadir_dataport(int fd_ada, int datadirection) {
// ========================================================
/* Data line direction: non-zero for input mode. */
// (14) #define PPDATADIR	_IOW(PP_IOCTL, 0x90, int)// 
// PPDATADIR : IFaceC.int := 144;	-- HEX 0x90 Data line direction

int result10 = ioctl(fd_ada, PPDATADIR, &datadirection);
  if (result10 != 0)
  {
    perror ("PPDATADIR");
    close (fd_ada);
    printf("Call FAILED. Set datadirection PPDATADIR: non-zero/zero for input/outpot mode. fd_ada = %d , datadirection = %d , result10 = %d \n", fd_ada, datadirection, result10);
    exit(1); 
  } else {
    printf("Set PPDATADIR parport data direction: fd_ada = %d, datadirection = %d = ", fd_ada, datadirection);
   
  
    if (datadirection == 0) {
      datadirection = PPDATADIR_OUT;
      printf("PPDATADIR_OUT \n");
    } else {
      datadirection = PPDATADIR_IN;
      printf("PPDATADIR_IN \n");
    }
  }

return(result10);
}
// NO. 11
// ========================================================
int ada_ioctl_ppwdata_writedataregister(int fd_ada, int datatowrite) {
// ========================================================
/* Read/write data */
// DONE (7) #define PPRDATA		_IOR(PP_IOCTL, 0x85, unsigned char)
// DONE (5) #define PPWDATA		_IOW(PP_IOCTL, 0x86, unsigned char)

// PPRDATA		: IFaceC.int  := 133; -- HEX 0x85 Read data port  BIN= 10000101
// PPWDATA		: IFaceC.int  := 134; -- HEX 0x86 Write data port BIN= 10000110  
  
  int result11;
  char datatowrite_bin8[9];
  
  // TEST data input from terminal
  // printf("(5) Enter an integer between 0 and 255 : ");
  // scanf("%d", &datatowrite);
  
  if (((int)datatowrite < 0) || ((int)datatowrite > 255)) {
    printf("Call FAILED. Data to write out of range [0..255], datatowrite = %d \n", (int)datatowrite);
    close (fd_ada);
    exit(1);  
  } else {  
    
    result11 = ioctl(fd_ada, PPWDATA, &datatowrite);
    if (result11 != 0)  {
        perror ("PPWDATA");
        close (fd_ada);
        printf("Call FAILED. Parallel port write data PPWDATA. result11 = %d \n", result11);
        exit(1);  
    } else {
        convert_int2bin8(datatowrite, datatowrite_bin8);
        printf("Write\t PPWDATA \t: UCHAR= %c \tINT= %d \tHEX= 0x%x \tBIN= %s\n", 
            datatowrite, datatowrite, datatowrite, datatowrite_bin8);
    }
    
  }
  
return(result11);
}  
// ========================================================
// NO. 11.1  STREAM DATA TO WRITE
int ada_ioctl_streamdata_writedataregister(int fd_ada, char *stream_datatowrite) {
// ========================================================
  int result; 
  char chartowrite;
  char chartowrite_bin8[9];
  
  printf("Write stream data char-by-char to parport: '%s' \n", stream_datatowrite);
  do {
       chartowrite = *stream_datatowrite;
       convert_int2bin8(chartowrite, chartowrite_bin8);
       printf("\tWrite\t PPWDATA \t: UCHAR= %c \tINT= %d \tHEX= 0x%x \tBIN= %s\n", 
           chartowrite, chartowrite, chartowrite, chartowrite_bin8);
    
       stream_datatowrite++;
  } while (*stream_datatowrite != '\0');  // loop until null character 
  
  result = 0;
return(result);
}
// NO. 12
// ========================================================
int ada_ioctl_pprdata_readdataregister(int fd_ada) {
// ========================================================
/* Read/write data */

// PPRDATA		: IFaceC.int  := 133; -- HEX 0x85 Read data port
// PPWDATA		: IFaceC.int  := 134; -- HEX 0x86 Write data port 

  unsigned char pprdata_val;
  char pprdata_bin8[9];
 
  int result12 = ioctl(fd_ada, PPRDATA, &pprdata_val); 
  if (result12 != 0)
    {
      perror("fd_ada");
      printf("Call FAILED. Read PPRDATA for fd_ada = %d, port_ada: %s, result12 = %d \n", fd_ada, port_ada, result12);
      exit(1);
    } else {
      convert_int2bin8(pprdata_val, pprdata_bin8);
      printf("Read\t PPRDATA \t: UCHAR= %c \tINT= %d \tHEX= 0x%x \tBIN= %s\n", 
          pprdata_val, pprdata_val, pprdata_val, pprdata_bin8);
    }
  
return(result12); 
}
// NO. 13
// ========================================================
int ada_ioctl_pprstatus_readstatusregister(int fd_ada) {
// ========================================================
/* Read status */
// DONE (8) #define PPRSTATUS	_IOR(PP_IOCTL, 0x81, unsigned char)

// PPRSTATUS	: IFaceC.int := 129; -- HEX 0x81 Read status
  
  unsigned char pprstatus_val;
  char pprstatus_bin8[9];
  
  int result13 = ioctl(fd_ada, PPRSTATUS, &pprstatus_val); 
  if (result13 != 0)
    {
      perror("fd_ada");
      printf("Call FAILED. Read PPRSTATUS for fd_ada = %d, port_ada: %s, result13 = %d \n", fd_ada, port_ada, result13);
      exit(1);
    } else {
       convert_int2bin8(pprstatus_val, pprstatus_bin8);
       printf("Read\t PPRSTATUS \t: UCHAR= %c \tINT= %d \tHEX= 0x%x \tBIN= %s ", 
           pprstatus_val, pprstatus_val, pprstatus_val, pprstatus_bin8);
    
       switch (pprstatus_val) {
          case 8 :
               printf("PARPORT_STATUS_ERROR \n");
               break;
          case 16 :
               printf("PARPORT_STATUS_SELECT \n");
               break;
          case 32 :
               printf("PARPORT_STATUS_PAPEROUT \n");
               break;
          case 64 :
               printf("PARPORT_STATUS_ACK \n");
               break;
          case 128 :
               printf("PARPORT_STATUS_BUSY \n");
               break;
          default:
               printf("ERROR: Unknown PARPORT_STATUS \n");
       } // END switch..case
       
    } // END if..else
  
return(result13); 
}
// NO. 14
// ========================================================
int ada_ioctl_ppwcontrol_writecontrolregister(int fd_ada, int controltowrite) {
// ========================================================
/* Read/write control */
// DONE (9)  #define PPRCONTROL	_IOR(PP_IOCTL, 0x83, unsigned char)
// DONE (10) #define PPWCONTROL	_IOW(PP_IOCTL, 0x84, unsigned char)
  
// PPRCONTROL	: IFaceC.int := 131; -- HEX 0x83 Read control
// PPWCONTROL : IFaceC.int := 132; -- HEX 0x84 Write control  
  
  int result14;
  char controltowrite_bin8[9];
   
  if ((controltowrite < 0) || ((int)controltowrite > 255))
  {
    printf("(14) FAILED. Control to write is out of range [0..255], controltowrite = %d \n", (int)controltowrite);
    close (fd_ada);
    exit(1);  
  } else {  
    result14 = ioctl(fd_ada, PPWCONTROL, &controltowrite); 
  }
    
  if (result14 != 0)
    {
      perror("fd_ada");
      printf("Call FAILED. Write PPWCONTROL for fd_ada = %d, port_ada: %s, result14 = %d \n", fd_ada, port_ada, result14);
      exit(1);
    } else {
      convert_int2bin8(controltowrite, controltowrite_bin8);
      printf("Write\t PPWCONTROL \t: UCHAR= %c \tINT= %d \t\tHEX= 0x%x \tBIN= %s\n", 
           controltowrite, controltowrite, controltowrite, controltowrite_bin8);
    }

return (result14);
}
// NO. 15
// ========================================================
int ada_ioctl_pprcontrol_readcontrolregister(int fd_ada) {
// ========================================================
/* Read/write control */

// PPRCONTROL	: IFaceC.int := 131; -- HEX 0x83 Read control
// PPWCONTROL : IFaceC.int := 132; -- HEX 0x84 Write control    
  
  unsigned char pprcontrol_val;
  char pprcontrol_bin8[9];
  int result15 = ioctl(fd_ada, PPRCONTROL, &pprcontrol_val); 
  if (result15 != 0)
    {
      perror("fd_ada");
      printf("Call FAILED. Read PPRCONTROL for fd_ada = %d, port_ada: %s, result15 = %d \n", fd_ada, port_ada, result15);
      exit(1);
    } else {
      convert_int2bin8(pprcontrol_val, pprcontrol_bin8);
      printf("Read\t PPRCONTROL \t: UCHAR= %c \tINT= %d \t\tHEX= 0x%x \tBIN= %s ", 
           pprcontrol_val, pprcontrol_val, pprcontrol_val, pprcontrol_bin8);
    
      switch (pprcontrol_val) {
          case 1 :
               printf("PARPORT_CONTROL_STROBE \n");
               break;
          case 2 :
               printf("PARPORT_CONTROL_AUTOFD \n");
               break;
          case 4 :
               printf("PARPORT_CONTROL_INIT \n");
               break;
          case 8 :
               printf("PARPORT_CONTROL_SELECT \n");
               break;
          default:
               printf("ERROR: Unknown PARPORT_CONTROL \n");
       } // END switch..case
    
   } // END if..else
  
return(result15); 
}
// NO. 16
// ========================================================
int ada_ioctl_ppfcontrol_frob1(void) {
// ========================================================
// DONE (4) (6) #define PPFCONTROL _IOW(PP_IOCTL, 0x8e, struct ppdev_frob_struct)
  
// PPFCONTROL : IFaceC.int := 142; -- HEX 0x8e Frob control
  
  frob.mask = OUTPUTENABLE;   // HEX=0x02 BIN= 00000010  INT= 2 
  frob.val  = OUTPUTENABLE;   // HEX=0x02 BIN= 00000010  INT= 2 
  
  int result16 = ioctl(fd_ada, PPFCONTROL, &frob);
  if (result16 != 0) {
    perror ("PPFCONTROL");
    close (fd_ada);
    printf("Call FAILED. Assert latch's OUTPUTENABLE PPFCONTROL frob signal, result16 = %d \n", result16);
    exit(1); 
  } else {
    printf("Assert PPFCONTROL frob1 with frob.mask and frob.val = (OUTPUTENABLE). \n");
  }  
return(result16);  
}
  
// NO. 17
// ========================================================
int ada_ioctl_ppfcontrol_frob2(void) {
// ========================================================
// DONE (4) (6) #define PPFCONTROL _IOW(PP_IOCTL, 0x8e, struct ppdev_frob_struct)  

// PPFCONTROL : IFaceC.int := 142; -- HEX 0x8e Frob control  BIN= 10001110
  
  frob.mask = OUTPUTENABLE | OUTPUTLATCH;  // HEX= 0x06 BIN= 00000110 INT= 6
  frob.val  = OUTPUTENABLE | OUTPUTLATCH;
  int result17 = ioctl(fd_ada, PPFCONTROL, &frob);
  if (result17 != 0)
  {
    perror ("PPFCONTROL");
    close (fd_ada);
    printf("(17) FAILED. Toggle the OUTPUTENABLE/OUTPUTLATCH PPFCONTROL signal to latch data, result17 = %d \n", result17);
    exit(1); 
  }  else {
    printf("Assert PPFCONTROL frob2 with frob.mask and frob.val = (OUTPUTENABLE | OUTPUTLATCH). \n");
  }  
  
return (result17);
} 
// NO. 18
// ========================================================
int ada_ioctl_ppwctlonirq_controlport(int fd_ada, int the_interrupt) {
// ========================================================
/* Set control lines when an interrupt occurs. */
// (15) #define PPWCTLONIRQ	_IOW(PP_IOCTL, 0x92, unsigned char)
// PPWCTLONIRQ : IFaceC.int := 146; -- HEX 0x92 Set control lines when an interrupt occurs

  int result18 = ioctl(fd_ada, PPWCTLONIRQ, &the_interrupt);
  if (result18 != 0)
  {
    perror ("PPWCTLONIRQ");
    close (fd_ada);
    printf("Call FAILED. Set/Write control lines interrupt occurs PPWCTLONIRQ. fd_ada = %d, IRQ = %d , result18 = %d \n", fd_ada, the_interrupt, result18);
    exit(1); 
  } else {
    printf("Set/Write control on interrupt occurance PPWCTLONIRQ. fd_ada = %d, IRQ = %d \n", fd_ada, the_interrupt);
  }

return (result18);
}
// NO. 19
// ========================================================
int ada_ioctl_ppclrirq_controlport(int fd_ada, int the_interrupt) {
// ========================================================
/* Clear (and return) interrupt count. */
// (16) #define PPCLRIRQ	_IOR(PP_IOCTL, 0x93, int)  
// PPCLRIRQ	 : IFaceC.int  := 147; -- HEX 0x93 Clear (and return) interrupt count
  
  // printf("(16) IRQ before clear = %d \n", the_interrupt);
  int result19 = ioctl(fd_ada, PPCLRIRQ, &the_interrupt);
  if (result19 != 0)
  {
    perror ("PPCLRIRQ");
    close (fd_ada);
    printf("Call FAILED. Clear IRQ, return) IRQ count PPCLRIRQ. fd_ada = %d, IRQ = %d, IRQ_Count = result19 = %d \n", fd_ada, the_interrupt, result19);
    exit(1); 
  } else {
    printf("Clear IRQ. Set IRQ = 0, on return IRQ count PPCLRIRQ. fd_ada = %d, IRQ = %d \n", fd_ada, the_interrupt);
    
  }

return (result19);
}
// NO. 20 
// ========================================================
int ada_ioctl_ppnegot_mode(int fd_ada, int modetoset) {
// ========================================================
/* Negotiate a particular IEEE 1284 mode. */
// DONE (3) #define PPNEGOT		_IOW(PP_IOCTL, 0x91, int)

// PPNEGOT   : IFaceC.int := 145;	-- HEX 0x91 Negotiate a particular IEEE 1284 mode  
  char modetoset_bin8[9];
  int result20 = ioctl(fd_ada, PPNEGOT, &modetoset);
  if (result20 != 0)
  {
    perror ("PPNEGOT");
    close (fd_ada);
    printf("Call FAILED. Negotiate/configure the_port for mode_ada = %d result20 = %d \n", modetoset, result20);
    exit(1); 
  } else {
    printf("Negotiate/configure the_port for mode_ada = %d = ", modetoset);
    
      convert_int2bin8(modetoset, modetoset_bin8);
      if (modetoset_bin8[7] == '1') { printf("PARPORT_MODE_PCSPP \n"); } 
      if (modetoset_bin8[6] == '1') { printf("PARPORT_MODE_TRISTATE \n"); } 
      if (modetoset_bin8[5] == '1') { printf("PARPORT_MODE_EPP \n"); } 
      if (modetoset_bin8[4] == '1') { printf("PARPORT_MODE_ECP \n"); } 
      if (modetoset_bin8[3] == '1') { printf("PARPORT_MODE_COMPAT \n"); } 
      if (modetoset_bin8[2] == '1') { printf("PARPORT_MODE_DMA	 \n"); } 
      if (modetoset_bin8[1] == '1') { printf("PARPORT_MODE_SAFEININT \n"); } 
  }  
return (result20);
}
// NO. 21
// ========================================================
int ada_ioctl_ppyield_parport(int fd_ada) {
// ========================================================
/* Yield the port (release it if another driver is waiting, then reclaim) */
  // (12) #define PPYIELD		_IO(PP_IOCTL, 0x8d)
  // PPYIELD   : IFaceC.int := 141;	-- HEX 0x8d
  
  int result21 = ioctl(fd_ada, PPYIELD);
  if (result21 != 0)
  {
    perror ("PPYIELD");
    close (fd_ada);
    printf("Call FAILED. Yield the_port %s, PPYIELD, result21 = %d \n", port_ada, result21);
    exit(1); 
  } else {
    printf("Yield the_port %s, PPYIELD. \n", port_ada);
  }  
  return (result21);
}
// NO.22
// ========================================================
int ada_ioctl_ppgettime_usec_parport(int fd) {
// ========================================================
/* Set and get port timeout (struct timeval's) */
// (18) #define PPGETTIME	_IOR(PP_IOCTL, 0x95, struct timeval)

// Set and get port timeout (struct timeval) 
// PPGETTIME : IFaceC.int := 149; -- HEX 0x95
 
// https://linuxhint.com/gettimeofday_c_language/
  time(&the_time);
  the_tminfo = localtime(&the_time);
	strftime(the_strbuffer1, 26, "%Y-%m-%d %H:%M:%S", the_tminfo);
   
  gettimeofday(&current_time, NULL);
  printf("Get parport port time PPGETTIME. fd_ada = %d \n", fd_ada);
  printf("\tDATE-TIME-STAMP: %s", the_strbuffer1);
  printf(".%06ld \n", (long int)current_time.tv_usec);
  // printf("TIME-FROM-EPOCH: seconds.microseconds = %ld.%ld \n", current_time.tv_sec, current_time.tv_usec);
  
  // TO FIX
  // clock_gettime(CLOCK_REALTIME, thetime_nsec_now);
	// printf(".%09ld \t", (long int)thetime_nsec_now.tv_nsec);
                             
  int result22 = ioctl(fd_ada, PPGETTIME);
  if (result22 != 0)
  {
    perror ("PPGETTIME");
    close (fd_ada);
    printf("Call FAILED. Get port time PPGETTIME. fd_ada = %d , result22 = %d \n", fd_ada, result22);
    exit(1); 
  } else {
    // printf("Call Success.Get port time PPGETTIME. fd_ada = %d \n", fd_ada);
    printf("\tTIME-FROM-EPOCH: seconds.microseconds = %ld.%ld \n", current_time.tv_sec, current_time.tv_usec);
  }

return (result22);
}
// NO. 23
// ========================================================
int ada_ioctl_pprelease_parport(void){
// ========================================================
// PPRELEASE : IFaceC.int := 140;	-- HEX 0x8c  
  int result23 = ioctl (fd_ada, PPRELEASE);
  if (result23 != 0)
  {
    perror ("PPRELEASE");
    close (fd_ada);
    printf("Call FAILED. Release the_port %s, PPRELEASE, result23 = %d \n", port_ada, result23);
    exit(1); 
  } else {
    printf("Success. PPRELEASE the parport device: fd_ada = %d, port_ada = %s \n", fd_ada, port_ada);
  }  
return(result23);
}
// NO. 24
// ========================================================
int ada_close_parport(int fd_ada) {
// ========================================================
  int result24 = close(fd_ada);
  if (result24 != 0)
  {
    perror ("close");
    printf("Call FAILED. Close the device file, fd_ada = %d, port_ada: %s, result24 = %d \n", fd_ada, port_ada, result24);
    exit(1); 
  } else {
    printf("Success. CLOSE the parport device: fd_ada = %d, port_ada = %s \n", fd_ada, port_ada);
  }  
return(result24);
}

// NO. X1
// ========================================================
int ada_ioctl_ppexcl_parport(int fd_ada) {
// ========================================================
/* Register device exclusively (must be before PPCLAIM). */
// #define PPEXCL		_IO(PP_IOCTL, 0x8f)
// PPEXCL    : IFaceC.int := 143;	-- HEX 0x8f
  
  int resultX1 = ioctl(fd_ada, PPEXCL);
  if (resultX1 != 0)
  {
    perror ("PPEXCL");
    close (fd_ada);
    printf("(X1) FAILED. Register PPEXCL exclusively the_port %s, resultX1 = %d \n", port_ada, resultX1);
    exit(1); 
  } 

return(resultX1);
}
// NO. X2
// ========================================================
int ada_ioctl_ppsettime_timeoutparport(int fd_ada, int timeout) {
// ========================================================
/* Set and get port timeout (struct timeval's) */
// #define PPSETTIME	_IOW(PP_IOCTL, 0x96, struct timeval) <=== IMPORTANT

// Set and get port timeout (struct timeval's) 
// PPSETTIME : IFaceC.int := 150; -- HEX 0x96

int resultX2 = ioctl(fd_ada, PPSETTIME, &timeout);
if (resultX2 != 0)
  {
    perror ("PPSETTIME");
    close (fd_ada);
    printf("(X2) FAILED. Parport timeout setting PPSETTIME on the_port %s, resultX2 = %d \n", port_ada, resultX2);
    exit(1); 
  } 

return(resultX2);
}

// ========================================================
// ALHAMDULILLAH 3 TIMES WRY.
// ========================================================
