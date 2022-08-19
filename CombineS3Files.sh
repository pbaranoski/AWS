#!/usr/bin/bash
#
######################################################################################
# Name:  CombineS3Files.sh
#
# Desc: Combine S3 Files test script
#

######################################################################################
set +x

#############################################################
# Establish log file  
#############################################################
TMSTMP=`date +%Y%m%d.%H%M%S`
LOGNAME=/app/IDRC/XTR/CMS/logs/CombineS3Files_${TMSTMP}.log
RUNDIR=/app/IDRC/XTR/CMS/scripts/run/
DATADIR=/app/IDRC/XTR/CMS/data/



touch ${LOGNAME}
chmod 666 ${LOGNAME} 2>> ${LOGNAME} 

echo "################################### " >> ${LOGNAME}
echo "CombineS3Files.sh started at `date` " >> ${LOGNAME}
echo "" >> ${LOGNAME}

#############################################################
# THIS ONE SCRIPT SETS ALL DATABASE NAMES VARIABLES 
#############################################################
source ${RUNDIR}SET_XTR_ENV.sh >> ${LOGNAME}

bucket=aws-hhs-cms-eadg-bia-ddom-extracts-nonrpod
combinedFilename=blbtn_clm_ext_20220812.091145.csv.gz
filePrefix=blbtn_clm_ext_20220812.091145
filesize=1000000000

echo "Start Combining S3 files " >> ${LOGNAME}

echo "Delete combined file from S3." >> ${LOGNAME}

aws s3 rm s3://${bucket}/xtr/DEV/${combinedFilename} >> ${LOGNAME} 2>&1

echo "Run python program combineS3Files.py" >> ${LOGNAME}	
	
${PYTHON_COMMAND} ${RUNDIR}combineS3Files.py --bucket ${bucket} --folder 'xtr/DEV/' --prefix ${filePrefix} --output 'xtr/DEV/'${combinedFilename} --filesize ${filesize}   >> ${LOGNAME} 2>&1


#############################################################
# script clean-up
#############################################################
echo "" >> ${LOGNAME}
echo "CombineS3Files.sh completed successfully." >> ${LOGNAME}

echo "Ended at `date` " >> ${LOGNAME}
echo "" >> ${LOGNAME}
exit $RET_STATUS
