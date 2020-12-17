
package body pkg_aada_ppdev is

-- ========================================================
-- (01) OPEN PARPORT
-- ========================================================
   function GetA_open_parport(port : in AIFaceC.char_array; fd_attrib : in AIFaceC.int) return AIFaceC.int is
   begin

	   ret01 := PAPPDEV.GetC_ada_open_parport(port, fd_attrib);
      if (ret01 = -1) then    -- fd must be nonzero to be a success
         AATIO.Put ("ERROR. OPEN PARPORT. GET_FILE_DESCRIPTOR: fd = ");
		  AATIO.Put (AIFaceC.int'Image(ret01)); AATIO.New_Line;
      end if;
      fd := ret01;

      return(fd);
   end GetA_open_parport;
   -- =====================================================
   -- (02) CLAIM PARPORT
   -- =====================================================
   function GetA_ppclaim_parport(fd : in AIFaceC.int) return AIFaceC.int is
   begin

      ret02 := PAPPDEV.GetC_ada_ioctl_ppclaim_parport(fd);
      if (ret02 /= 0) then
         AATIO.Put ("ERROR. PP_CLAIM: ret02 = ");
         AATIO.Put (AIFaceC.int'Image(ret02));  AATIO.New_Line;
      end if;

      return ret02;
   end GetA_ppclaim_parport;
   -- =====================================================
   -- (03) GET PARPORT HARDWARE CAPABILITIES (PPMODES)
   -- =====================================================
   function GetA_ppgetmodes_parport (fd : AIFaceC.int) return AIFaceC.int is

   begin

      ret03 := PAPPDEV.GetC_ada_ioctl_ppgetmodes_parport(fd);
      if (ret03 /= 0) then
         AATIO.Put ("ERROR. PP_GET_HARDWARE_MODES: ret03 = ");
         AATIO.Put (AIFaceC.int'Image(ret03)); AATIO.New_Line;
   end if;

      return ret03;
   end GetA_ppgetmodes_parport;
   -- =====================================================
   -- (04) SET PARPORT MODE
   -- =====================================================
   function GetA_ppsetmode_parport(fd : in AIFaceC.int; modetoset : in AIFaceC.int) return AIFaceC.int is
   begin

      ret04 := PAPPDEV.GetC_ada_ioctl_ppsetmode_parport(fd, modetoset);
      if (ret04 /= 0) then
         AATIO.Put ("ERROR. PP_SET_MODE: ret04 = ");
         AATIO.Put (AIFaceC.int'Image(ret04));  AATIO.New_Line;
      end if;

      return ret04;
   end GetA_ppsetmode_parport;
   -- =====================================================
   -- (05) GET PARPORT MODE
   -- =====================================================
   function GetA_ppgetmode_current (fd : AIFaceC.int) return AIFaceC.int is

      curr_ppmode : AIFaceC.int := 999;
   begin

      ret05 := PAPPDEV.GetC_ada_ioctl_ppgetmode_current(fd);
      if (ret05 /= 0) then
         AATIO.Put ("ERROR. PP_GET_MODE: ret05 = ");
         AATIO.Put (AIFaceC.int'Image(ret05)); AATIO.New_Line;
      end if;

      return ret05;
   end GetA_ppgetmode_current;
   -- =====================================================
   -- (06) SET PARPORT FLAGS
   -- =====================================================
   function GetA_ppsetflags_parport (fd, flagstoset : AIFaceC.int) return AIFaceC.int is
   begin

      ret06 := PAPPDEV.GetC_ada_ioctl_ppsetflags_parport(fd, flagstoset);
      if (ret06 /= 0) then
         AATIO.Put ("ERROR. PP_SET_FLAGS: ret06 = ");
         AATIO.Put (AIFaceC.int'Image(ret06)); AATIO.New_Line;
      end if;

   return ret06;
   end GetA_ppsetflags_parport;
   -- =====================================================
   -- (07) GET PARPORT FLAGS
   -- =====================================================
   function GetA_ppgetflags_current (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret07 := PAPPDEV.GetC_ada_ioctl_ppgetflags_current(fd);
      if (ret07 /= 0) then
         AATIO.Put ("ERROR. PP_GET_FLAGS: ret07 = ");
         AATIO.Put (AIFaceC.int'Image(ret07)); AATIO.New_Line;
      end if;

      return ret07;
   end GetA_ppgetflags_current;
   -- =====================================================
   -- (08) SET PARPORT PHASE
   -- =====================================================
   function GetA_ppsetphase_parport (fd, phasetoset : AIFaceC.int) return AIFaceC.int is
   begin

      ret08 := PAPPDEV.GetC_ada_ioctl_ppsetphase_parport(fd, phasetoset);
      if (ret08 /= 0) then
         AATIO.Put ("ERROR. PP_SET_PHASE: ret08 = ");
         AATIO.Put (AIFaceC.int'Image(ret08)); AATIO.New_Line;
      end if;

      return ret08;
   end GetA_ppsetphase_parport;
   -- =====================================================
   -- (09) GET PARPORT PHASE
   -- =====================================================
   function GetA_ppgetphase_current (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret09 := PAPPDEV.GetC_ada_ioctl_ppgetphase_current(fd);
      if (ret09 /= 0) then
         AATIO.Put ("ERROR. PP_GET_PHASE: ret09 = ");
         AATIO.Put (AIFaceC.int'Image(ret09)); AATIO.New_Line;
      end if;

      return ret09;
   end GetA_ppgetphase_current;
   -- =====================================================
   -- (10)
   -- =====================================================
   function GetA_ppdatadir_dataport (fd, datadirection : in AIFaceC.int) return AIFaceC.int is
   begin

       ret10 := PAPPDEV.GetC_ada_ioctl_ppdatadir_dataport(fd, datadirection);
       if (ret10 /= 0) then
          AATIO.Put ("ERROR. PP_DATA_DIRECTION: ret10 = ");
          AATIO.Put (AIFaceC.int'Image(ret10));  AATIO.New_Line;
       end if;

       return ret10;
   end GetA_ppdatadir_dataport;
   -- =====================================================
   -- (11)
   -- =====================================================
   function GetA_ppwdata_writedataregister (fd, datatowrite : in AIFaceC.int) return AIFaceC.int is
   begin

      ret11 := PAPPDEV.GetC_ada_ioctl_ppwdata_writedataregister(fd, datatowrite);
      if (ret11 /= 0) then
         AATIO.Put ("ERROR. PP_WRITE_DATA: ret11 = ");
         AATIO.Put (AIFaceC.int'Image(ret11));  AATIO.New_Line;
      end if;

      return ret11;
   end GetA_ppwdata_writedataregister;
   -- =====================================================
   function GetA_streamdata_writedataregister (fd : in AIFaceC.int; stream_datatowrite : in AIFaceC.char_array) return AIFaceC.int is
   begin

      ret11 := PAPPDEV.GetC_ada_ioctl_streamdata_writedataregister(fd, stream_datatowrite);
      if (ret11 /= 0) then
         AATIO.Put ("ERROR. PP_WRITE_STREAMDATA: ret11 = ");
         AATIO.Put (AIFaceC.int'Image(ret11));  AATIO.New_Line;
      end if;

      return ret11;
   end GetA_streamdata_writedataregister;

   -- =====================================================
   -- (12)
   -- =====================================================
   function GetA_pprdata_readdataregister (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret12 := PAPPDEV.GetC_ada_ioctl_pprdata_readdataregister(fd);
      if (ret12 /= 0) then
         AATIO.Put ("ERROR. PP_READ_DATA: ret12 = ");
         AATIO.Put (AIFaceC.int'Image(ret12)); AATIO.New_Line;
      end if;

      return ret12;
   end GetA_pprdata_readdataregister;

   -- =====================================================
   -- (13)
   -- =====================================================
   function GetA_pprstatus_readstatusregister (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret13 := PAPPDEV.GetC_ada_ioctl_pprstatus_readstatusregister(fd);
      if (ret13 /= 0) then
         AATIO.Put ("ERROR. PP_READ_STATUS: ret13 = ");
         AATIO.Put (AIFaceC.int'Image(ret13)); AATIO.New_Line;
      end if;

      return ret13;
   end GetA_pprstatus_readstatusregister;

   -- =====================================================
   -- (14)
   -- =====================================================
   function GetA_ppwcontrol_writecontrolregister (fd, controltowrite : AIFaceC.int) return AIFaceC.int is
   begin

      ret14 := PAPPDEV.GetC_ada_ioctl_ppwcontrol_writecontrolregister(fd, controltowrite);
      if (ret14 /= 0) then
         AATIO.Put ("ERROR. PP_WRITE_CONTROL: ret14 = ");
         AATIO.Put (AIFaceC.int'Image(ret14)); AATIO.New_Line;
      end if;

      return ret14;
   end GetA_ppwcontrol_writecontrolregister;

   -- =====================================================
   -- (15)
   -- =====================================================
   function GetA_pprcontrol_readcontrolregister (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret15 := PAPPDEV.GetC_ada_ioctl_pprcontrol_readcontrolregister(fd);
      if (ret15 /= 0) then
         AATIO.Put ("ERROR. PP_READ_CONTROL: ret15 = ");
         AATIO.Put (AIFaceC.int'Image(ret15)); AATIO.New_Line;
      end if;

      return ret15;
   end GetA_pprcontrol_readcontrolregister;

   -- =====================================================
   -- (16)
   -- =====================================================
   function GetA_ppfcontrol_frob1 return AIFaceC.int is
   begin

      ret16 := PAPPDEV.GetC_ada_ioctl_ppfcontrol_frob1;
      if (ret16 /= 0) then
         AATIO.Put ("ERROR. PP_FROB_CONTROL: ret16 = ");
         AATIO.Put (AIFaceC.int'Image(ret16));  AATIO.New_Line;
      end if;

      return ret16;
   end GetA_ppfcontrol_frob1;
   -- =====================================================
   -- (17)
   -- =====================================================
   function GetA_ppfcontrol_frob2 return AIFaceC.int is
   begin

      ret17 := PAPPDEV.GetC_ada_ioctl_ppfcontrol_frob2;
      if (ret17 /= 0) then
         AATIO.Put ("ERROR. PP_FROB_CONTROL: ret17 = ");
         AATIO.Put (AIFaceC.int'Image(ret17)); AATIO.New_Line;
      end if;

      return ret17;
   end GetA_ppfcontrol_frob2;
   -- =====================================================
   -- (18)
   -- =====================================================
   function GetA_ppwctlonirq_controlport (fd, the_interrupt : AIFaceC.int) return AIFaceC.int is
   begin

      ret18 := PAPPDEV.GetC_ada_ioctl_ppwctlonirq_controlport(fd, the_interrupt);
      if (ret18 /= 0) then
         AATIO.Put ("ERROR. PP_WRITE_CONTROL_ON_IRQ: ret18 = ");
         AATIO.Put (AIFaceC.int'Image(ret18)); AATIO.New_Line;
      end if;

      return ret18;
   end GetA_ppwctlonirq_controlport;
   -- =====================================================
   -- (19)
   -- =====================================================
   function GetA_ppclrirq_controlport (fd, the_interrupt : AIFaceC.int) return AIFaceC.int is
   begin

      ret19 := PAPPDEV.GetC_ada_ioctl_ppclrirq_controlport(fd, the_interrupt);
      if (ret19 /= 0) then
         AATIO.Put ("ERROR. PP_CLEAR_IRQ: ret19 = ");
         AATIO.Put (AIFaceC.int'Image(ret19)); AATIO.New_Line;
      end if;

      return ret19;
   end GetA_ppclrirq_controlport;
   -- =====================================================
   -- (20)
   -- =====================================================
   function GetA_ppnegot_mode(fd_ada, modetoset : in AIFaceC.int) return AIFaceC.int is
   begin

      ret20 := PAPPDEV.GetC_ada_ioctl_ppnegot_mode(fd_ada, modetoset);
      if (ret20 /= 0) then
		  AATIO.Put ("ERROR. PP_NEGOT PARPORT MODE: ret20 = ");
		  AATIO.Put (AIFaceC.int'Image(ret20)); AATIO.New_Line;
	   end if;

      return 20;
   end GetA_ppnegot_mode;
   -- =====================================================
   -- (21)
   -- =====================================================
   function GetA_ppyield_parport (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret21 := PAPPDEV.GetC_ada_ioctl_ppyield_parport(fd);
      if (ret21 /= 0) then
         AATIO.Put ("ERROR. PP_YIELD: ret21 = ");
         AATIO.Put (AIFaceC.int'Image(ret21));  AATIO.New_Line;
      end if;

      return ret21;
   end GetA_ppyield_parport;
   -- =====================================================
   -- (22)
   -- =====================================================
   function GetA_ppgettime_usec_parport (fd : AIFaceC.int) return AIFaceC.int is
   begin

      ret22 := PAPPDEV.GetC_ada_ioctl_ppgettime_usec_parport(fd);
      if (ret22 /= 0) then
         AATIO.Put ("ERROR. PP_GET_TIME: ret22 = ");
         AATIO.Put (AIFaceC.int'Image(ret22)); AATIO.New_Line;
      end if;

      return ret22;
   end GetA_ppgettime_usec_parport;
   -- =====================================================
   -- (23)
   -- =====================================================
   function GetA_pprelease_parport return AIFaceC.int is
   begin

      ret23 := PAPPDEV.GetC_ada_ioctl_pprelease_parport;
      if (ret23 /= 0) then
         AATIO.Put ("ERROR. PP_RELEASE: ret23 = ");
         AATIO.Put (AIFaceC.int'Image(ret23)); AATIO.New_Line;
      end if;

      return ret23;
   end GetA_pprelease_parport;
   -- =====================================================
   -- (24)
   -- =====================================================
   function GetA_close_parport(fd : in AIFaceC.int) return AIFaceC.int is
   begin

      ret24 := PAPPDEV.GetC_ada_close_parport(fd);
      if (ret24 /= 0) then
		  AATIO.Put ("ERROR. CLOSE PARPORT: ret24 = ");
		  AATIO.Put (AIFaceC.int'Image(ret24)); AATIO.New_Line;
	   end if;

      return ret24;
   end GetA_close_parport;
   -- =====================================================
   -- (X1)
   function GetA_ppexcl_parport (fd : in AIFaceC.int) return AIFaceC.int is
   begin

      retX1 := PAPPDEV.GetC_ada_ioctl_ppexcl_parport(fd);
      if (retX1 /= 0) then
		  AATIO.Put ("ERROR. PARPORT EXCLUSIVE ACCESS: retX1 = ");
		  AATIO.Put (AIFaceC.int'Image(retX1)); AATIO.New_Line;
	   end if;

      return retX1;
   end GetA_ppexcl_parport;
   -- =====================================================
   -- (X2)
   function GetA_ppsettime_timeoutparport (fd, timeout : in AIFaceC.int) return AIFaceC.int is
   begin

      retX2 := PAPPDEV.GetC_ada_ioctl_ppsettime_timeoutparport(fd, timeout);
      if (retX2 /= 0) then
		  AATIO.Put ("ERROR. PARPORT SET TIMEOUT: retX2 = ");
		  AATIO.Put (AIFaceC.int'Image(retX2)); AATIO.New_Line;
	   end if;

      return ret26;
   end GetA_ppsettime_timeoutparport;

  -- ======================================================
  begin

    null;
   -- =====================================================
end pkg_aada_ppdev;

