#!/bin/csh -f

  echo " "
  echo " "
  echo "============================================="
  echo "============================================="
  echo " "
  echo "    precip Adjustment "
  echo " "
  echo "============================================="
  echo "============================================="
  echo " "

  if (-e pr_XML) \rm pr_XML

  set pr_opts = (pr_threshold_in pr_conserve_in pr_threshold_out pr_conserve_out pr_freqadj_in)

  if (!("$targVar" =~ "pr*")) then
    echo "    precip adjustment can not be done for $targVar = $targVar. "
    exit 0
  else

  echo "    Options for Precip INPUT:"
  echo " "

# pr_threshold_in  

  set varvals = ("'us_trace' (0.01 in./day)" "'global_trace' (0.1 mm/day)" "'zero' (0 precipitation)")
  set dinfo = "precip input data, what threshold value is to be used to distinguish between dry days and wet days?"
  source $QueryVals
  set opt = ($kval)
  echo "$opt" >> $INtxt
  set pr_threshold_in = ($opt[1])
  echo "opt = $opt => pr_threshold_in = $pr_threshold_in, pr_adjustment.csh ">> $INtxt.key

# pr_freqadj_in

  echo " "
  echo  ">>  FREQUENCY ADJUSTMENT? "
  echo " "
  echo  ">>  Do you want to adjust the training predictor precip timeseries"
  echo  ">>  to have the same frequency of wet days as the training target timeseries?"
  echo -n ">>  Enter y for 'yes' ; Enter n or hit the 'Enter' key for 'no' :  "
  set freqadj=$<
  echo $freqadj >> $INtxt
  echo "freqadj = $freqadj, pr_adjustment.csh" >> $INtxt.key

  if ($freqadj != "y") then
    set pr_freqadj_in = "'off'"
    echo "    Training predictor timeseries wet day FREQUENCY will not be adjusted."
  else
    set pr_freqadj_in = "'on'"
    echo "    Training predictor timeseries wet day FREQUENCY will be adjusted."
  endif
  echo " "
  sleep 1

# pr_conserve_in

  if ($pr_threshold_in != "'zero'" || $pr_freqadj_in == "'on'") then

    echo  ">>  CONSERVE INPUT? "
    echo " "
    echo  ">>  When adjusting the input precip timeseries, "
    echo  ">>  do you want to conserve total precip amount?"
    echo -n ">>  Enter y for 'yes' ; Enter n or hit the 'Enter' key for 'no' :  "
    set conserve_in=$<
    echo $conserve_in >> $INtxt
    echo "conserve_in = $conserve_in, pr_adjustment.csh" >> $INtxt.key
  
    if ($conserve_in != "y") then
      set pr_conserve_in = "'off'"
      echo "    Input total precip amount will not be conserved."
    else
      set pr_conserve_in = "'on'"
      echo "    Input total precip amount will be conserved."
    endif
    echo " "
    sleep 1

  else
    set pr_conserve_in = "'off'"
  endif

  echo "    Options for Precip downscaled OUTPUT:"
  echo " "

# pr_threshold_out  

  set varvals = ("'us_trace' (0.01 in./day)" "'global_trace' (0.1 mm/day)" "'zero' (0 precipitation)")
  set dinfo = "downscaled precip output timeseries, what threshold value is to be used to distinguish between dry days and wet days?"
  source $QueryVals
  set opt = ($kval)
  echo "$opt" >> $INtxt
  set pr_threshold_out = ($opt[1])
  echo "opt = $opt => pr_threshold_out = $pr_threshold_out, pr_adjustment.csh" >> $INtxt.key

# pr_conserve_out

  if ($pr_threshold_out != "'zero'") then

    echo ">>  CONSERVE OUTPUT? "
    echo ">>  When adjusting the downscaled output precip timeseries, "
    echo ">>    do you want to conserve total precip amount?"
    echo -n ">>  Enter y for 'yes' ; Enter n or hit the 'Enter' key for 'no' :  "
    set conserve_out=$<
    echo $conserve_out >> $INtxt
    echo "conserve_out = $conserve_out, pr_adjustment.csh" >> $INtxt.key
  
    if ($conserve_out != "y") then
      set pr_conserve_out = "'off'"
      echo "    Downscaled output total precip amount will not be conserved."
    else
      set pr_conserve_out = "'on'"
      echo "    Downscaled output total precip amount will be conserved."
    endif
    echo " "
    sleep 1

  else
    set pr_conserve_out = "'off'"
  endif


cat > pr_XML<<EOF
        <pr_opts>
           <pr_threshold_in>$pr_threshold_in</pr_threshold_in>
           <pr_freqadj_in>$pr_freqadj_in</pr_freqadj_in>
           <pr_conserve_in>$pr_conserve_in</pr_conserve_in>
           <pr_threshold_out>$pr_threshold_out</pr_threshold_out>
           <pr_conserve_out>$pr_conserve_out</pr_conserve_out>
        </pr_opts>
EOF

#--------------------------------------------------------------------------------------------
# NOTE 
# apply_0_mask will be FOR ESPRESSO OR BEYOND, BUT NOT FOR darkchocolate
# apply_0_mask not yet implemented
#  set apply_0_mask = "'off'"
#cat > pr_XML<<EOF
#        <pr_opts>
#           <pr_threshold_in>$pr_threshold_in</pr_threshold_in>
#           <pr_freqadj_in>$pr_freqadj_in</pr_freqadj_in>
#           <pr_conserve_in>$pr_conserve_in</pr_conserve_in>
#           <pr_threshold_out>$pr_threshold_out</pr_threshold_out>
#           <pr_conserve_out>$pr_conserve_out</pr_conserve_out>
#           <apply_0_mask>$apply_0_mask</apply_0_mask>
#        </pr_opts>
#EOF
# END NOTE 
#--------------------------------------------------------------------------------------------
# NOTE 

  endif

exit 0
