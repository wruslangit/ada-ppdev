-- File	: main_ada_timing.adb
-- Date	: Sun 20 Dec 2020 10:34:19 AM +08
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

with Ada.Real_Time; 
use  Ada.Real_Time;
with Ada.Calendar;
use  Ada.Calendar;
with Ada.Calendar.Formatting;
use  Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones;
use  Ada.Calendar.Time_Zones;

-- ADA STRING MANIPULATION
-- Ada has three(3) types of strings:
-- fixed length, bounded length, unbounded.
with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Strings.Bounded;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Command_Line;

-- WRY CREATED PACKAGES 
with pkg_ada_dtstamp;
-- with pkg_ada_ppdev; -- FOR main_ada_test2.adb
with pkg_aada_ppdev;   -- FOR main_ada_test2.adb

-- ========================================================
procedure main_ada_timing is
   
   -- RENAMING STANDARD PACKAGES FOR CONVENIENCE
   package ATIO    renames Ada.Text_IO;
   package IFaceC  renames Interfaces.C;
   package IFaceCE renames Interfaces.C.Extensions;
   package ACal    renames Ada.Calendar;
   package ACalF   renames Ada.Calendar.Formatting;
   package ACalTZ  renames Ada.Calendar.Time_Zones;
   package ART     renames Ada.Real_Time;
   
   -- RENAMING ADA STRING PACKAGES
   package AS     renames Ada.Strings;
   package ASF    renames Ada.Strings.Fixed;
   package ASB    renames Ada.Strings.Bounded;
   package ASU    renames Ada.Strings.Unbounded;
   package ASUTIO renames Ada.Strings.Unbounded.Text_IO;
   package ACL    renames Ada.Command_Line;  
   
   -- RENAMING WRY CREATED PACKAGES
   package PADTS    renames pkg_ada_dtstamp;
   -- package PAPPDEV renames pkg_ada_ppdev;  -- FOR main_ada_test2.adb
   package PAAPPDEV renames pkg_aada_ppdev;   -- FOR main_ada_test1.adb
   
   Now        : ACal.Time;  
   RTNow      : ART.Time;
   datestring : ASU.Unbounded_String; -- no initialization needed, default empty
   timestring : ASU.Unbounded_String; -- no initialization needed, default empty
      
begin
     
   PADTS.dtstamp; ATIO.Put_Line ("Bismillah 3 times WRY");
   PADTS.dtstamp; ATIO.Put_Line ("Running inside GNAT Studio Community (20200427)");
   -- =====================================================   
     
   -- =====================================================
   -- USUNG ACal.Clock (Ada.Calendar.Clock)
   -- =====================================================
   Now := ACal.Clock;  
   
   -- With Time_Zone offset 
   ATIO.Put (ACalF.Image(Now, False, +08*60));
   ATIO.Put_Line ("             Date Time MYT (+8) = Date Time UTC (0) + 8*60"); 
   
   -- Using delay in Standard Ada package.   
   ATIO.Put_Line("Wait 5 seconds.");
   delay 5.0;
   ATIO.Put_Line("Wait 2 seconds.");
   delay 2.0;
   ATIO. Put_Line("Wait 1 seconds.");
   delay 1.0;
                  PADTS.dtstamp; delay 1.0;  -- second
   ATIO.New_Line; PADTS.dtstamp; delay 0.1;
   ATIO.New_Line; PADTS.dtstamp; delay(0.01);
   ATIO.New_Line; PADTS.dtstamp; delay(0.001); -- millisecond
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_1);
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_01);
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_001); -- microsecond
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_000_1);
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_000_01);
   ATIO.New_Line; PADTS.dtstamp; delay(0.000_000_001); -- nanosecond
   ATIO.New_Line; PADTS.dtstamp; 
   ATIO.New_Line;
   
   -- =====================================================
   -- USING ART.Clock (Ada.Real_Time.Clock)
   -- =====================================================
   RTNow := ART.Clock;
   
   datestring := PADTS.get_datestamp (ART.Clock);
   PADTS.dtstamp; ATIO.Put ("datestring = "); 
   ATIO.Put_Line (ASU.To_String(datestring));
   
   timestring := PADTS.get_timestamp (ART.Clock);
   PADTS.dtstamp; ATIO.Put ("timestring = "); 
   ATIO.Put_Line (ASU.To_String(timestring));
   
   
   -- DELAY 2 SECONDS RUN ONCE (USING ART.Clock)
   PADTS.dtstamp; ATIO.Put_Line ("RTdelay_sec(2)"); 
   PADTS.RTdelay_sec (2);
   
   PADTS.dtstamp; ATIO.Put_Line ("RTdelay_msec(2_000)"); 
   PADTS.RTdelay_msec (2_000);
   
   PADTS.dtstamp; ATIO.Put_Line ("RTdelay_usec(2_000_000)"); 
   PADTS.RTdelay_usec (2_000_000);
   
   PADTS.dtstamp; ATIO.Put_Line ("RTdelay_nsec(2_000_000_000)"); 
   PADTS.RTdelay_nsec (2_000_000_000);
   
   -- TEST DELAY LOOP 10 TIMES EACH (USING ART.Clock)
   -- PADTS.looptest10_RTdelay_sec  (10);
   PADTS.looptest10_RTdelay_sec  (1);
   
   PADTS.looptest10_RTdelay_msec (100);
   PADTS.looptest10_RTdelay_msec (10);
   PADTS.looptest10_RTdelay_msec (1);
   
   PADTS.looptest10_RTdelay_usec (100);
   PADTS.looptest10_RTdelay_usec (10);
   PADTS.looptest10_RTdelay_usec (1);
      
   PADTS.looptest10_RTdelay_nsec (100);
   PADTS.looptest10_RTdelay_nsec (10);
   PADTS.looptest10_RTdelay_nsec (1);
   
-- ========================================================      
   ATIO.New_Line;
   PADTS.dtstamp; ATiO.Put_Line ("Alhamdulillah 3 times WRY");
  
-- ========================================================   
-- Catch every possible error using built-in package Ada.Standard
-- ========================================================
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
end main_ada_timing;
-- ========================================================

