#!/bin/bash -e
# 3dprintyourbrain, adapted script by skjerns, original by miykael
# usage: create_3d_brain_docker.sh subject_name.nii.gz
###############################################
set -e  # exit on error


export FSLOUTPUTTYPE=NIFTI_GZ
# Main folder for the whole project
if [ -f "$1" ]; then
    subjT1="$1"
# Else check if it exists in the 'share' subdirectory
elif [ -f "/opt/share/$1" ]; then
    subjT1="/opt/share/$1"
else
    echo "Error: File $1 not found in current directory or share/$1"
    exit 1
fi
echo
echo "-----------------------------------------------"
echo "STARTING RECONSTRUCTION, CAN TAKE SEVERAL HOURS"
echo "-----------------------------------------------"
echo
sleep 3

start_time=$(date +%s)

export subjT1
export MAIN_DIR=$HOME/3dbrains

# Name of the subject
export subject=$(echo "$subjT1" | rev | cut -f 1 -d '/' | rev | cut -f 1 -d '.')

# Path to the subject (output folder)
export SUBJECTS_DIR=$MAIN_DIR/${subject}/output

#==========================================================================================
#2. Create Surface Model with FreeSurfer
#==========================================================================================
mkdir -p $MAIN_DIR/${subject}/
mkdir -p $SUBJECTS_DIR/mri/orig
mri_convert ${subjT1} $SUBJECTS_DIR/mri/orig/001.mgz
recon-all -subjid "output" -all -time -log logfile -nuintensitycor-3T -sd "$MAIN_DIR/${subject}/" -parallel

#==========================================================================================
#3. Create 3D Model of Cortical and Subcortical Areas
#==========================================================================================

# CORTICAL
# Convert output of step (2) to fsl-format
mris_convert --combinesurfs $SUBJECTS_DIR/surf/lh.pial $SUBJECTS_DIR/surf/rh.pial \
             $SUBJECTS_DIR/cortical.stl

# SUBCORTICAL
mkdir -p $SUBJECTS_DIR/subcortical
# First, convert aseg.mgz into NIfTI format
mri_convert $SUBJECTS_DIR/mri/aseg.mgz $SUBJECTS_DIR/subcortical/subcortical.nii

# Second, binarize all areas that you're not interested and inverse the binarization
mri_binarize --i $SUBJECTS_DIR/subcortical/subcortical.nii \
             --match 2 3 24 31 41 42 63 72 77 51 52 13 12 43 50 4 11 26 58 49 10 17 18 53 54 44 5 80 14 15 30 62 \
             --inv \
             --o $SUBJECTS_DIR/subcortical/bin.nii

# Third, multiply the original aseg.mgz file with the binarized files
fslmaths.fsl $SUBJECTS_DIR/subcortical/subcortical.nii \
         -mul $SUBJECTS_DIR/subcortical/bin.nii \
         $SUBJECTS_DIR/subcortical/subcortical.nii.gz

# Fourth, copy original file to create a temporary file
cp $SUBJECTS_DIR/subcortical/subcortical.nii.gz $SUBJECTS_DIR/subcortical/subcortical_tmp.nii.gz

# Fifth, unzip this file
gunzip -f $SUBJECTS_DIR/subcortical/subcortical_tmp.nii.gz

# Sixth, check all areas of interest for wholes and fill them out if necessary
for i in 7 8 16 28 46 47 60 251 252 253 254 255
do
    mri_pretess $SUBJECTS_DIR/subcortical/subcortical_tmp.nii \
    $i \
    $SUBJECTS_DIR/mri/norm.mgz \
    $SUBJECTS_DIR/subcortical/subcortical_tmp.nii
done

# Seventh, binarize the whole volume
fslmaths.fsl $SUBJECTS_DIR/subcortical/subcortical_tmp.nii -bin $SUBJECTS_DIR/subcortical/subcortical_bin.nii

# Eighth, create a surface model of the binarized volume with mri_tessellate
mri_tessellate $SUBJECTS_DIR/subcortical/subcortical_bin.nii.gz 1 $SUBJECTS_DIR/subcortical/subcortical

# Ninth, convert binary surface output into stl format
mris_convert $SUBJECTS_DIR/subcortical/subcortical $SUBJECTS_DIR/subcortical.stl

# last, apply preprocessing by smoothing and combining the meshes
# and decimating to 290.000 vertices (tinkercad limit is 300.000)
python3 /opt/post_process_mesh.py $SUBJECTS_DIR

cp $SUBJECTS_DIR/final.stl /opt/share/$subject.stl

#==========================================================================================
# Cleanup
#==========================================================================================
rm -R -- $SUBJECTS_DIR/*/
rm $SUBJECTS_DIR/logfile
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
formatted_time=$(printf "%02d:%02d:%02d" $((elapsed_time/3600)) $((elapsed_time%3600/60)) $((elapsed_time%60)))
echo
echo "n---------------------------------"
echo "Finished after $formatted_time. Output can be found at $subject.stl"
