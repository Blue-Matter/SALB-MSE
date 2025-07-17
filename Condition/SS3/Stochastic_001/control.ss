#C file created using an r4ss function
#C file write time: 2025-07-17  14:28:43
#
0 # 0 means do not read wtatage.ss; 1 means read and usewtatage.ss and also read and use growth parameters
1 #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern
4 # recr_dist_method for parameters
1 # not yet implemented; Future usage:Spawner-Recruitment; 1=global; 2=by area
1 # number of recruitment settlement assignments 
0 # unused option
# for each settlement assignment:
#_GPattern	month	area	age
1	1	1	0	#_recr_dist_pattern1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
3 #_Nblock_Patterns
2 3 28 #_blocks_per_pattern
#_begin and end years of blocks
1950 1992 1993 2020
1950 1991 1992 2012 2013 2020
1993 1993 1994 1994 1995 1995 1996 1996 1997 1997 1998 1998 1999 1999 2000 2000 2001 2001 2002 2002 2003 2003 2004 2004 2005 2005 2006 2006 2007 2007 2008 2008 2009 2009 2010 2010 2011 2011 2012 2012 2013 2013 2014 2014 2015 2015 2016 2016 2017 2017 2018 2018 2019 2019 2020 2020
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate;_5=Maunder_M;_6=Age-range_Lorenzen
#_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr;5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
1.3 #_Age(post-settlement)_for_L1;linear growth below this
999 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0 #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
2 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
3 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
# Age Maturity or Age fecundity:
#_Age_0	Age_1	Age_2	Age_3	Age_4	Age_5	Age_6	Age_7	Age_8	Age_9	Age_10	Age_11	Age_12	Age_13	Age_14	Age_15	Age_16	Age_17	Age_18	Age_19	Age_20	Age_21	Age_22	Age_23	Age_24	Age_25
0	0.006	0.023	0.075	0.218	0.49	0.768	0.919	0.975	0.992	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	#_Age_Maturity1
1 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env_var&link	dev_link	dev_minyr	dev_maxyr	dev_PH	Block	Block_Fxn
  0.1	     0.6	 0.30473	  0.30473	  0.04	0	 -2	0	0	0	0	  0	0	0	#_NatM_p_1_Fem_GP_1  
   30	     200	 116.855	  116.855	2.8771	0	 -3	0	0	0	0	0.5	0	0	#_L_at_Amin_Fem_GP_1 
  140	     450	  312.27	   312.27	8.5992	0	 -3	0	0	0	0	0.5	0	0	#_L_at_Amax_Fem_GP_1 
 0.02	     0.3	  0.0926	   0.0926	  0.09	0	 -3	0	0	0	0	0.5	0	0	#_VonBert_K_Fem_GP_1 
   10	      35	      14	      0.2	    99	0	 -3	0	0	0	0	0.5	0	0	#_CV_young_Fem_GP_1  
   10	      35	      32	      0.2	    99	0	 -4	0	0	0	0	0.5	0	0	#_CV_old_Fem_GP_1    
    0	       1	4.45e-06	3.433e-06	   0.8	0	 -2	0	0	0	0	0.5	0	0	#_Wtlen_1_Fem_GP_1   
    0	       4	     3.2	   3.2623	   0.8	0	 -2	0	0	0	0	0.5	0	0	#_Wtlen_2_Fem_GP_1   
    0	      60	       0	       15	   0.8	0	 -3	0	0	0	0	  0	0	0	#_Mat50%_Fem_GP_1    
   -3	       3	      -3	    -0.25	   0.8	0	 -3	0	0	0	0	  0	0	0	#_Mat_slope_Fem_GP_1 
   -3	       3	       1	        1	   0.8	0	 -3	0	0	0	0	  0	0	0	#_Eggs_alpha_Fem_GP_1
   -3	       3	       0	        0	   0.8	0	 -3	0	0	0	0	  0	0	0	#_Eggs_beta_Fem_GP_1 
  0.1	     0.6	 0.30473	  0.30473	  0.04	0	 -2	0	0	0	0	  0	0	0	#_NatM_p_1_Mal_GP_1  
   50	     200	 115.452	  115.452	2.8771	0	 -3	0	0	0	0	0.5	0	0	#_L_at_Amin_Mal_GP_1 
  140	     450	  223.12	   223.12	8.5992	0	 -3	0	0	0	0	0.5	0	0	#_L_at_Amax_Mal_GP_1 
 0.02	     0.3	  0.1522	   0.1522	   0.9	0	 -3	0	0	0	0	0.5	0	0	#_VonBert_K_Mal_GP_1 
   10	      35	      14	     0.12	    99	0	 -3	0	0	0	0	0.5	0	0	#_CV_young_Mal_GP_1  
   10	      35	      32	     0.18	  0.04	0	 -4	0	0	0	0	0.5	0	0	#_CV_old_Mal_GP_1    
    0	       1	4.45e-06	3.433e-06	   0.8	0	 -2	0	0	0	0	0.5	0	0	#_Wtlen_1_Mal_GP_1   
    0	       4	     3.2	   3.2623	   0.8	0	 -2	0	0	0	0	0.5	0	0	#_Wtlen_2_Mal_GP_1   
  0.1	      10	       1	        1	     1	0	 -1	0	0	0	0	  0	0	0	#_CohortGrowDev      
1e-06	0.999999	     0.5	      0.5	   0.5	0	-99	0	0	0	0	  0	0	0	#_FracFemale_GP_1    
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; 2=Ricker (2 parms); 3=std_B-H(2); 4=SCAA(2);5=Hockey(3); 6=B-H_flattop(2); 7=Survival(3);8=Shepard(3);9=Ricker_Power(3);10=B-H_a,b(4)
0 # 0/1 to use steepness in initial equ recruitment calculation
0 # future feature: 0/1 to make realized sigmaR a function of SR curvature
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn # parm_name
   6	   8	6.78196	      7	  99	0	 1	0	0	0	0	0	0	0	#_SR_LN(R0)  
0.21	0.99	0.70611	0.70611	0.06	2	-2	0	0	0	0	0	0	0	#_SR_BH_steep
   0	 1.5	    0.2	    0.2	  99	6	-5	0	0	0	0	0	0	0	#_SR_sigmaR  
  -1	   1	      0	      0	  99	6	-3	0	0	0	0	0	0	0	#_SR_regime  
   0	   2	      0	     -1	   1	6	-3	0	0	0	0	0	0	0	#_SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1979 # first year of main recr_devs; early devs can preceed this era
2019 # last year of main recr_devs; forecast devs start in following year
4 #_recdev phase
1 # (0/1) to read 13 advanced options
0 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
-4 #_recdev_early_phase
0 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
1 #_lambda for Fcast_recr_like occurring before endyr+1
1965.3 #_last_yr_nobias_adj_in_MPD; begin of ramp
1982 #_first_yr_fullbias_adj_in_MPD; begin of plateau
2015.7 #_last_yr_fullbias_adj_in_MPD
2022.9 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
0.8458 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
0 #_period of cycles in recruitment (N parms read below)
-5 #min rec_dev
5 #max rec_dev
0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
#Fishing Mortality info
0.2 # F ballpark
2017 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
1.9 # max F or harvest rate, depends on F_Method
3 # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#
#_Q_setup for fleets with cpue or survey data
#_fleet	link	link_info	extra_se	biasadj	float  #  fleetname
    1	1	0	0	0	1	#_SPN_1         
    3	1	1	1	0	0	#_CAN_3         
    4	1	1	1	0	0	#_JPN_ERLY_4    
    5	1	1	1	0	0	#_JPN_LATE_5    
    7	1	1	1	0	0	#_CHT_EARLY_7   
    8	1	1	1	0	0	#_CHT_LATE_8    
    9	1	1	1	0	0	#_MOR_9         
   12	1	1	1	0	0	#_US_Survey_12  
   13	1	1	1	0	0	#_PORT_Survey_13
   14	1	1	1	0	0	#_Age-1         
   15	1	1	1	0	0	#_Age-2         
   16	1	1	1	0	0	#_Age-3         
   17	1	1	1	0	0	#_Age-4         
   18	1	1	1	0	0	#_Age-5+        
   19	1	0	0	0	1	#_Combined_CPUE 
-9999	0	0	0	0	0	#_terminator    
#_Q_parms(if_any);Qunits_are_ln(q)
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
  -20	 -10	-10.9983	-10.9981	 2.2	0	 -1	  0	0	0	0	0	0	0	#_LnQ_base_SPN_1(1)           
  -10	  -5	-7.04759	-7.04721	1.41	0	  1	104	0	0	0	0	0	0	#_LnQ_base_CAN_3(3)           
 -0.3	 0.3	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_CAN_3(3)          
  -10	  -5	-7.24191	-7.24141	1.45	0	  1	  0	0	0	0	0	0	0	#_LnQ_base_JPN_ERLY_4(4)      
 -0.3	   0	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_JPN_ERLY_4(4)     
  -10	  -2	-6.37215	-6.37178	1.27	0	  1	  0	0	0	0	0	0	0	#_LnQ_base_JPN_LATE_5(5)      
-0.35	   0	       0	       0	  99	0	-44	  0	0	0	0	0	0	0	#_Q_extraSD_JPN_LATE_5(5)     
  -10	  -5	-7.66868	-7.66717	1.53	0	  1	  0	0	0	0	0	0	0	#_LnQ_base_CHT_EARLY_7(7)     
 -0.1	0.13	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_CHT_EARLY_7(7)    
  -10	  -5	-6.81965	-6.81945	1.36	0	  1	  0	0	0	0	0	0	0	#_LnQ_base_CHT_LATE_8(8)      
 -0.1	 0.1	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_CHT_LATE_8(8)     
  -15	  -7	-10.7678	-10.7674	2.15	0	  1	103	0	0	0	0	0	0	#_LnQ_base_MOR_9(9)           
 -0.1	 0.1	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_MOR_9(9)          
  -10	  -5	-6.53546	-6.53452	1.31	0	  1	104	0	0	0	0	0	0	#_LnQ_base_US_Survey_12(12)   
 -0.2	 0.2	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_US_Survey_12(12)  
  -15	  -5	-11.0189	-11.0182	 2.2	0	  1	104	0	0	0	0	0	0	#_LnQ_base_PORT_Survey_13(13) 
 -0.3	 0.3	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_PORT_Survey_13(13)
  -10	  -3	-6.47089	-6.47086	1.29	0	  1	104	0	0	0	0	0	0	#_LnQ_base_Age-1(14)          
 -0.2	 0.2	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_Age-1(14)         
  -10	  -3	-6.01871	-6.01864	 1.2	0	  1	104	0	0	0	0	0	0	#_LnQ_base_Age-2(15)          
 -0.3	 0.3	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_Age-2(15)         
  -10	  -3	-5.47123	-5.47109	1.09	0	  1	104	0	0	0	0	0	0	#_LnQ_base_Age-3(16)          
 -0.4	 0.1	       0	       0	  99	0	-44	  0	0	0	0	0	0	0	#_Q_extraSD_Age-3(16)         
   -7	  -3	-5.05355	-5.05338	1.01	0	  1	104	0	0	0	0	0	0	#_LnQ_base_Age-4(17)          
 -0.1	 0.1	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_Age-4(17)         
  -10	  -3	-6.06534	-6.06493	1.21	0	  1	  0	0	0	0	0	0	0	#_LnQ_base_Age-5+(18)         
 -0.2	 0.2	       0	       0	  99	0	 -4	  0	0	0	0	0	0	0	#_Q_extraSD_Age-5+(18)        
  -15	 -10	-5.22775	-12.6537	2.53	0	 -1	  0	0	0	0	0	0	0	#_LnQ_base_Combined_CPUE(19)  
# timevary Q parameters
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
-1	1	-0.161691	0	0.5	0	 7	#_LnQ_base_CAN_3(3)_ENV_add          
-1	1	-0.133548	0	0.5	0	 7	#_LnQ_base_MOR_9(9)_ENV_add          
-1	1	        0	0	0.5	0	-5	#_LnQ_base_US_Survey_12(12)_ENV_add  
-1	1	        0	0	0.5	0	-7	#_LnQ_base_PORT_Survey_13(13)_ENV_add
-1	1	 -0.24414	0	0.5	0	 7	#_LnQ_base_Age-1(14)_ENV_add         
-1	1	-0.187444	0	0.5	0	 7	#_LnQ_base_Age-2(15)_ENV_add         
-1	1	        0	0	0.5	0	-5	#_LnQ_base_Age-3(16)_ENV_add         
-1	1	 0.116029	0	0.5	0	 7	#_LnQ_base_Age-4(17)_ENV_add         
# info on dev vectors created for Q parms are reported with other devs after tag parameter section
#
#_size_selex_patterns
#_Pattern	Discard	Male	Special
24	 2	0	0	#_1 SPN_1          
24	 2	0	0	#_2 US_2           
24	 2	0	0	#_3 CAN_3          
24	 2	0	0	#_4 JPN_ERLY_4     
 5	-4	0	4	#_5 JPN_LATE_5     
 5	-2	0	1	#_6 PORT_6         
24	 2	0	0	#_7 CHT_EARLY_7    
 5	-7	0	7	#_8 CHT_LATE_8     
24	 0	0	0	#_9 MOR_9          
 1	 0	0	0	#_10 HRPN_10       
 5	-2	0	2	#_11 OTH_11        
 5	 0	0	2	#_12 US_Survey_12  
 5	 0	0	6	#_13 PORT_Survey_13
 0	 0	0	0	#_14 Age-1         
 0	 0	0	0	#_15 Age-2         
 0	 0	0	0	#_16 Age-3         
 0	 0	0	0	#_17 Age-4         
 0	 0	0	0	#_18 Age-5+        
 5	 0	0	2	#_19 Combined_CPUE 
#
#_age_selex_patterns
#_Pattern	Discard	Male	Special
11	0	0	0	#_1 SPN_1          
11	0	0	1	#_2 US_2           
15	0	0	1	#_3 CAN_3          
15	0	0	1	#_4 JPN_ERLY_4     
15	0	0	1	#_5 JPN_LATE_5     
15	0	0	1	#_6 PORT_6         
15	0	0	1	#_7 CHT_EARLY_7    
15	0	0	1	#_8 CHT_LATE_8     
15	0	0	1	#_9 MOR_9          
15	0	0	1	#_10 HRPN_10       
15	0	0	1	#_11 OTH_11        
15	0	0	1	#_12 US_Survey_12  
15	0	0	1	#_13 PORT_Survey_13
11	0	0	0	#_14 Age-1         
11	0	0	0	#_15 Age-2         
11	0	0	0	#_16 Age-3         
11	0	0	0	#_17 Age-4         
11	0	0	0	#_18 Age-5+        
15	0	0	1	#_19 Combined_CPUE 
#
#_SizeSelex
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE	env-var	use_dev	dev_mnyr	dev_mxyr	dev_PH	Block	Blk_Fxn  #  parm_name
 51	  120	  53.7298	  53.7298	10.75	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_1_SPN_1(1)          
-10	  0.5	-0.979825	 -1.14458	 0.14	0	  3	0	0	0	0	  0	0	0	#_SizeSel_P_2_SPN_1(1)          
 -5	    7	  3.71864	  3.71864	 0.74	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_3_SPN_1(1)          
  0	   15	  8.58415	  8.61259	 1.49	0	  3	0	0	0	0	  0	0	0	#_SizeSel_P_4_SPN_1(1)          
-15	    0	      -14	      -14	  2.8	0	 -1	0	0	0	0	  0	0	0	#_SizeSel_P_5_SPN_1(1)          
-10	    5	 -2.56418	     -2.6	 0.78	6	  6	0	0	0	0	  0	0	0	#_SizeSel_P_6_SPN_1(1)          
 50	317.5	       50	       50	   99	0	 -2	0	0	0	0	  0	1	2	#_SizeSel_PRet_1_SPN_1(1)       
 -1	   40	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_2_SPN_1(1)       
-10	 1000	      999	      999	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PRet_3_SPN_1(1)       
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_4_SPN_1(1)       
 -1	   60	       50	       50	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_1_SPN_1(1)       
 -1	    2	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_2_SPN_1(1)       
  0	    1	     0.77	     0.77	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_3_SPN_1(1)       
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_4_SPN_1(1)       
 50	  170	  72.8278	  72.8278	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_1_US_2(2)           
-15	    5	 -7.52502	 -1.49221	5.131	6	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_2_US_2(2)           
 -5	   10	  2.98181	  2.98181	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_3_US_2(2)           
  2	   12	  6.58103	  5.80657	   99	0	  3	0	0	0	0	  0	0	0	#_SizeSel_P_4_US_2(2)           
-15	    0	      -14	      -14	   99	0	 -1	0	0	0	0	  0	0	0	#_SizeSel_P_5_US_2(2)           
 -8	    0	 -1.29281	-0.445054	3.578	6	  6	0	0	0	0	  0	0	0	#_SizeSel_P_6_US_2(2)           
 15	317.5	       50	       50	   99	0	 -2	0	0	0	0	  0	2	2	#_SizeSel_PRet_1_US_2(2)        
 -1	   40	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_2_US_2(2)        
-10	 1000	      999	      999	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PRet_3_US_2(2)        
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_4_US_2(2)        
 -1	   60	       50	       50	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_1_US_2(2)        
 -1	    2	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_2_US_2(2)        
  0	    1	     0.77	     0.77	   99	0	 -2	0	0	0	0	  0	3	2	#_SizeSel_PDis_3_US_2(2)        
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_4_US_2(2)        
100	317.5	  146.646	  211.666	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_1_CAN_3(3)          
  1	   15	       15	       15	   99	0	 -3	0	0	0	0	  0	0	0	#_SizeSel_P_2_CAN_3(3)          
-15	   15	  7.27548	  8.09292	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_3_CAN_3(3)          
-15	    0	       -5	       -5	   99	0	 -3	0	0	0	0	  0	0	0	#_SizeSel_P_4_CAN_3(3)          
-15	    5	      -15	      -15	   99	0	 -1	0	0	0	0	  0	0	0	#_SizeSel_P_5_CAN_3(3)          
 -5	   15	       15	       15	   99	0	 -6	0	0	0	0	  0	0	0	#_SizeSel_P_6_CAN_3(3)          
 50	317.5	       50	    188.3	   99	0	 -2	0	0	0	0	  0	1	2	#_SizeSel_PRet_1_CAN_3(3)       
 -1	   40	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_2_CAN_3(3)       
-10	 1000	      999	       10	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PRet_3_CAN_3(3)       
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_4_CAN_3(3)       
 -1	   60	       10	       10	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_1_CAN_3(3)       
 -1	    2	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_2_CAN_3(3)       
  0	    1	     0.77	     0.77	   99	0	 -2	0	0	0	0	  0	3	2	#_SizeSel_PDis_3_CAN_3(3)       
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_4_CAN_3(3)       
 55	317.5	   137.92	  211.666	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_1_JPN_ERLY_4(4)     
-15	 -0.5	 -6.10557	 -6.09552	  1.2	6	  4	0	0	0	0	  0	0	0	#_SizeSel_P_2_JPN_ERLY_4(4)     
 -5	   15	  7.47039	  8.09292	   99	0	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_3_JPN_ERLY_4(4)     
-10	   15	  4.29623	  4.21396	  0.9	6	  3	0	0	0	0	  0	0	0	#_SizeSel_P_4_JPN_ERLY_4(4)     
-15	    0	      -14	      -15	   99	0	 -1	0	0	0	0	  0	0	0	#_SizeSel_P_5_JPN_ERLY_4(4)     
 -5	    5	 0.645671	    0.637	 0.19	6	  6	0	0	0	0	  0	0	0	#_SizeSel_P_6_JPN_ERLY_4(4)     
 51	  125	      125	      125	   99	0	 -2	0	0	0	0	  0	1	2	#_SizeSel_PRet_1_JPN_ERLY_4(4)  
 -1	   40	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_2_JPN_ERLY_4(4)  
-10	 1000	      999	       10	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PRet_3_JPN_ERLY_4(4)  
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_4_JPN_ERLY_4(4)  
 -1	   60	       10	       10	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_1_JPN_ERLY_4(4)  
 -1	    2	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_2_JPN_ERLY_4(4)  
  0	    1	     0.77	     0.77	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_3_JPN_ERLY_4(4)  
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_4_JPN_ERLY_4(4)  
  0	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_JPN_LATE_5(5)     
 -1	   55	       -1	       65	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_JPN_LATE_5(5)     
  0	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_PORT_6(6)         
 -1	   55	       -1	       65	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_PORT_6(6)         
 55	  200	  77.5273	  77.4947	   30	6	 -3	0	0	0	0	  0	1	2	#_SizeSel_P_1_CHT_EARLY_7(7)    
-10	   -3	 -6.07845	 -6.07857	 0.61	6	  4	0	0	0	0	  0	0	0	#_SizeSel_P_2_CHT_EARLY_7(7)    
 -5	   15	 -3.54505	 -3.54633	1.419	6	 -4	0	0	0	0	  0	1	2	#_SizeSel_P_3_CHT_EARLY_7(7)    
 -5	    5	-0.999972	-0.999992	  0.2	6	  3	0	0	0	0	  0	0	0	#_SizeSel_P_4_CHT_EARLY_7(7)    
-15	    0	      -14	      -15	   99	0	 -1	0	0	0	0	  0	0	0	#_SizeSel_P_5_CHT_EARLY_7(7)    
 -5	   15	  8.47088	   8.4719	 0.85	6	  6	0	0	0	0	  0	0	0	#_SizeSel_P_6_CHT_EARLY_7(7)    
 50	  125	       50	       50	   99	0	 -2	0	0	0	0	  0	1	2	#_SizeSel_PRet_1_CHT_EARLY_7(7) 
 -1	   40	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_2_CHT_EARLY_7(7) 
-10	 1000	      999	      999	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PRet_3_CHT_EARLY_7(7) 
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PRet_4_CHT_EARLY_7(7) 
 -1	   60	       10	       50	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_1_CHT_EARLY_7(7) 
 -1	    2	        1	        1	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_2_CHT_EARLY_7(7) 
  0	    1	     0.77	     0.77	   99	0	 -2	0	0	0	0	  0	0	0	#_SizeSel_PDis_3_CHT_EARLY_7(7) 
 -1	    2	        0	        0	   99	0	 -4	0	0	0	0	  0	0	0	#_SizeSel_PDis_4_CHT_EARLY_7(7) 
  1	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_CHT_LATE_8(8)     
 -1	   55	       -1	       55	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_CHT_LATE_8(8)     
 80	  180	  125.414	   130.17	26.03	0	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_1_MOR_9(9)          
-15	   -5	 -11.4412	 -11.4412	 2.29	6	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_2_MOR_9(9)          
  0	   15	  5.97955	  6.24631	 1.25	0	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_3_MOR_9(9)          
  0	   15	  6.34617	   6.1778	 1.24	0	  3	0	0	0	0	0.5	0	0	#_SizeSel_P_4_MOR_9(9)          
-15	    5	      -15	      -15	   99	0	 -1	0	0	0	0	0.5	0	0	#_SizeSel_P_5_MOR_9(9)          
 -5	    5	 -1.22956	 -1.74589	 0.35	0	  5	0	0	0	0	0.5	0	0	#_SizeSel_P_6_MOR_9(9)          
120	  280	  185.331	      200	   99	0	  3	0	0	0	0	  0	0	0	#_SizeSel_P_1_HRPN_10(10)       
  0	  135	  29.9071	        5	   99	0	  3	0	0	0	0	  0	0	0	#_SizeSel_P_2_HRPN_10(10)       
  0	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_OTH_11(11)        
 -1	   55	       -1	       65	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_OTH_11(11)        
  1	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_US_Survey_12(12)  
 -1	   55	       -1	       55	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_US_Survey_12(12)  
  1	   55	        1	        0	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_PORT_Survey_13(13)
 -1	   55	       -1	       55	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_PORT_Survey_13(13)
  1	   55	        1	        1	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_1_Combined_CPUE(19) 
 -1	   55	       -1	       55	   99	0	-99	0	0	0	0	  0	0	0	#_SizeSel_P_2_Combined_CPUE(19) 
#_AgeSelex
0	25	 0	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_SPN_1(1)  
0	25	25	25	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_SPN_1(1)  
0	25	 0	 0	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_US_2(2)   
0	25	25	25	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_US_2(2)   
0	25	 1	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_Age-1(14) 
0	25	 1	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_Age-1(14) 
0	25	 2	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_Age-2(15) 
0	25	 2	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_Age-2(15) 
0	25	 3	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_Age-3(16) 
0	25	 3	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_Age-3(16) 
0	25	 4	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_Age-4(17) 
0	25	 4	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_Age-4(17) 
0	25	 5	 1	99	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_1_Age-5+(18)
0	25	25	 1	98	0	-99	0	0	0	0	0	0	0	#_AgeSel_P_2_Age-5+(18)
# timevary selex parameters 
#_LO	HI	INIT	PRIOR	PR_SD	PR_type	PHASE
 50	  120	  88.1963	   148.93	29.79	0	 3	#_SizeSel_P_1_SPN_1(1)_BLK1repl_1950         
 50	  120	  84.1677	  102.525	20.51	0	 3	#_SizeSel_P_1_SPN_1(1)_BLK1repl_1993         
 -5	    7	   4.1756	  13.8683	 2.77	0	 3	#_SizeSel_P_3_SPN_1(1)_BLK1repl_1950         
 -5	    7	  3.74394	  8.39113	 1.68	0	 3	#_SizeSel_P_3_SPN_1(1)_BLK1repl_1993         
 50	  250	       50	      222	   99	0	-6	#_SizeSel_PRet_1_SPN_1(1)_BLK1repl_1950      
 55	  250	      119	      225	   99	0	-6	#_SizeSel_PRet_1_SPN_1(1)_BLK1repl_1993      
 50	  170	  82.9586	      222	   99	0	 3	#_SizeSel_P_1_US_2(2)_BLK1repl_1950          
 50	  170	  88.4136	      225	   99	0	 3	#_SizeSel_P_1_US_2(2)_BLK1repl_1993          
-15	    5	-0.315562	-0.406503	5.131	6	 3	#_SizeSel_P_2_US_2(2)_BLK1repl_1950          
-15	    5	 -7.07905	 -6.19244	1.687	6	 3	#_SizeSel_P_2_US_2(2)_BLK1repl_1993          
 -5	   10	  4.45075	    3.715	   99	0	 3	#_SizeSel_P_3_US_2(2)_BLK1repl_1950          
 -5	   10	  5.81099	    3.715	   99	0	 3	#_SizeSel_P_3_US_2(2)_BLK1repl_1993          
 50	  250	       50	      222	   99	0	-6	#_SizeSel_PRet_1_US_2(2)_BLK2repl_1950       
 50	  250	      119	      225	   99	0	-6	#_SizeSel_PRet_1_US_2(2)_BLK2repl_1992       
 50	  250	  115.813	      225	   99	0	 6	#_SizeSel_PRet_1_US_2(2)_BLK2repl_2013       
  0	    1	    0.786	    0.786	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1993       
  0	    1	    0.733	    0.733	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1994       
  0	    1	    0.757	    0.757	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1995       
  0	    1	    0.769	    0.769	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1996       
  0	    1	    0.761	    0.761	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1997       
  0	    1	    0.722	    0.722	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1998       
  0	    1	    0.748	    0.748	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_1999       
  0	    1	    0.721	    0.721	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2000       
  0	    1	    0.696	    0.696	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2001       
  0	    1	    0.777	    0.777	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2002       
  0	    1	     0.75	     0.75	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2003       
  0	    1	    0.748	    0.748	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2004       
  0	    1	    0.745	    0.745	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2005       
  0	    1	    0.751	    0.751	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2006       
  0	    1	    0.735	    0.735	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2007       
  0	    1	     0.75	     0.75	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2008       
  0	    1	     0.77	     0.77	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2009       
  0	    1	    0.756	    0.756	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2010       
  0	    1	    0.706	    0.706	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2011       
  0	    1	    0.696	    0.696	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2012       
  0	    1	    0.653	    0.653	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2013       
  0	    1	    0.716	    0.716	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2014       
  0	    1	    0.691	    0.691	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2015       
  0	    1	    0.663	    0.663	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2016       
  0	    1	    0.669	    0.669	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2017       
  0	    1	    0.744	    0.744	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2018       
  0	    1	    0.774	    0.774	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2019       
  0	    1	    0.721	    0.721	   99	0	-6	#_SizeSel_PDis_3_US_2(2)_BLK3repl_2020       
100	317.5	    317.5	      222	   99	0	-3	#_SizeSel_P_1_CAN_3(3)_BLK1repl_1950         
100	  200	  176.019	      225	   99	0	 3	#_SizeSel_P_1_CAN_3(3)_BLK1repl_1993         
  0	   15	  10.7155	    3.715	   99	0	 3	#_SizeSel_P_3_CAN_3(3)_BLK1repl_1950         
  0	   15	  7.54799	    3.715	   99	0	 3	#_SizeSel_P_3_CAN_3(3)_BLK1repl_1993         
 50	  250	       50	      222	   99	0	-6	#_SizeSel_PRet_1_CAN_3(3)_BLK1repl_1950      
 55	  250	      119	      225	   99	0	-6	#_SizeSel_PRet_1_CAN_3(3)_BLK1repl_1993      
  0	    1	     0.85	     0.85	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1993      
  0	    1	    0.856	    0.856	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1994      
  0	    1	    0.857	    0.857	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1995      
  0	    1	    0.719	    0.719	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1996      
  0	    1	    0.765	    0.765	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1997      
  0	    1	    0.798	    0.798	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1998      
  0	    1	    0.735	    0.735	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_1999      
  0	    1	     0.79	     0.79	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2000      
  0	    1	    0.761	    0.761	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2001      
  0	    1	    0.609	    0.609	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2002      
  0	    1	    0.682	    0.682	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2003      
  0	    1	    0.559	    0.559	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2004      
  0	    1	    0.565	    0.565	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2005      
  0	    1	    0.577	    0.577	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2006      
  0	    1	    0.485	    0.485	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2007      
  0	    1	     0.55	     0.55	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2008      
  0	    1	     0.48	     0.48	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2009      
  0	    1	    0.531	    0.531	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2010      
  0	    1	    0.529	    0.529	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2011      
  0	    1	    0.618	    0.618	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2012      
  0	    1	     0.55	     0.55	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2013      
  0	    1	    0.857	    0.857	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2014      
  0	    1	    0.329	    0.329	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2015      
  0	    1	      0.6	      0.6	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2016      
  0	    1	    0.734	    0.734	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2017      
  0	    1	    0.509	    0.509	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2018      
  0	    1	    0.455	    0.455	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2019      
  0	    1	    0.564	    0.564	   99	0	-6	#_SizeSel_PDis_3_CAN_3(3)_BLK3repl_2020      
 55	317.5	  202.678	      225	   99	0	 3	#_SizeSel_P_1_JPN_ERLY_4(4)_BLK1repl_1950    
 55	  315	  205.195	      225	   99	0	 3	#_SizeSel_P_1_JPN_ERLY_4(4)_BLK1repl_1993    
  1	   15	  8.74609	    12.86	  4.8	6	 3	#_SizeSel_P_3_JPN_ERLY_4(4)_BLK1repl_1950    
 -5	   15	   8.0407	    3.715	   99	0	 3	#_SizeSel_P_3_JPN_ERLY_4(4)_BLK1repl_1993    
 10	  250	       55	      222	   99	0	-6	#_SizeSel_PRet_1_JPN_ERLY_4(4)_BLK1repl_1950 
 51	  250	      119	      225	   99	0	-6	#_SizeSel_PRet_1_JPN_ERLY_4(4)_BLK1repl_1993 
100	  200	  136.052	      136	   27	6	 3	#_SizeSel_P_1_CHT_EARLY_7(7)_BLK1repl_1950   
100	  250	  166.936	      167	   33	6	 3	#_SizeSel_P_1_CHT_EARLY_7(7)_BLK1repl_1993   
  0	   15	  4.73949	  4.77691	0.954	6	 3	#_SizeSel_P_3_CHT_EARLY_7(7)_BLK1repl_1950   
  0	   15	  6.75589	  6.75646	 1.35	6	 3	#_SizeSel_P_3_CHT_EARLY_7(7)_BLK1repl_1993   
 10	  250	       50	      222	   99	0	-6	#_SizeSel_PRet_1_CHT_EARLY_7(7)_BLK1repl_1950
 51	  250	      119	      225	   99	0	-6	#_SizeSel_PRet_1_CHT_EARLY_7(7)_BLK1repl_1993
# info on dev vectors created for selex parms are reported with other devs after tag parameter section
#
0 #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
# Tag loss and Tag reporting parameters go next
0 # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# Input variance adjustments factors: 
#_factor	fleet	value
    4	 1	50.8445	#_Variance_adjustment_list1 
    4	 2	65.4502	#_Variance_adjustment_list2 
    4	 3	25.5113	#_Variance_adjustment_list3 
    4	 4	12.1531	#_Variance_adjustment_list4 
    4	 5	34.2908	#_Variance_adjustment_list5 
    4	 6	9.52038	#_Variance_adjustment_list6 
    4	 7	55.6654	#_Variance_adjustment_list7 
    4	 8	9.42982	#_Variance_adjustment_list8 
    4	 9	 13.513	#_Variance_adjustment_list9 
    4	10	12.7849	#_Variance_adjustment_list10
-9999	 0	      0	#_terminator                
#
2 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 37 changes to default Lambdas (default value is 1.0)
#_like_comp	fleet	phase	value	sizefreq_method
    1	 1	1	1e-04	1	#_Surv_SPN_1_Phz1                          
    1	 3	1	    1	1	#_Surv_CAN_3_Phz1                          
    1	 4	1	    1	1	#_Surv_JPN_ERLY_4_Phz1                     
    1	 5	1	    1	1	#_Surv_JPN_LATE_5_Phz1                     
    1	 6	1	    1	1	#_Surv_PORT_6_Phz1                         
    1	 7	1	    1	1	#_Surv_CHT_EARLY_7_Phz1                    
    1	 8	1	    1	1	#_Surv_CHT_LATE_8_Phz1                     
    1	 9	1	    1	1	#_Surv_MOR_9_Phz1                          
    1	12	1	    1	1	#_Surv_US_Survey_12_Phz1                   
    1	13	1	    1	1	#_Surv_PORT_Survey_13_Phz1                 
    1	14	1	    1	1	#_Surv_Age-1_Phz1                          
    1	15	1	    1	1	#_Surv_Age-2_Phz1                          
    1	16	1	    1	1	#_Surv_Age-3_Phz1                          
    1	17	1	    1	1	#_Surv_Age-4_Phz1                          
    1	18	1	    1	1	#_Surv_Age-5+_Phz1                         
    1	19	1	    0	1	#_Surv_Combined_CPUE_Phz1                  
    2	 1	1	    0	1	#_discard_SPN_1_Phz1                       
    2	 2	1	    0	1	#_discard_US_2_Phz1                        
    2	 3	1	    0	1	#_discard_CAN_3_Phz1                       
    2	 4	1	    0	1	#_discard_JPN_ERLY_4_Phz1                  
    2	 5	1	    0	1	#_discard_JPN_LATE_5_Phz1                  
    2	 6	1	    0	1	#_discard_PORT_6_Phz1                      
    2	 7	1	    0	1	#_discard_CHT_EARLY_7_Phz1                 
    2	 8	1	    0	1	#_discard_CHT_LATE_8_Phz1                  
    2	 9	1	    0	1	#_discard_MOR_9_Phz1                       
    2	10	1	    0	1	#_discard_HRPN_10_Phz1                     
    2	11	1	    0	1	#_discard_OTH_11_Phz1                      
    4	 1	1	    1	1	#_length_SPN_1_sizefreq_method_1_Phz1      
    4	 2	1	    1	1	#_length_US_2_sizefreq_method_1_Phz1       
    4	 3	1	    1	1	#_length_CAN_3_sizefreq_method_1_Phz1      
    4	 4	1	    1	1	#_length_JPN_ERLY_4_sizefreq_method_1_Phz1 
    4	 5	1	    1	1	#_length_JPN_LATE_5_sizefreq_method_1_Phz1 
    4	 6	1	    1	1	#_length_PORT_6_sizefreq_method_1_Phz1     
    4	 7	1	    1	1	#_length_CHT_EARLY_7_sizefreq_method_1_Phz1
    4	 8	1	    1	1	#_length_CHT_LATE_8_sizefreq_method_1_Phz1 
    4	 9	1	    1	1	#_length_MOR_9_sizefreq_method_1_Phz1      
    4	10	1	    1	1	#_length_HRPN_10_sizefreq_method_1_Phz1    
-9999	 0	0	    0	0	#_terminator                               
#
0 # 0/1 read specs for more stddev reporting
#
999
