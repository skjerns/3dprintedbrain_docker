<img title="" src="md_images_README/2efa073ae1febbac075f02acdfe2260b49f12e63.png" alt="2021-09-11 10.44.37.jpg" width="493" data-align="left">

# 3D print your brain using Docker

A Docker image to create readily 3D-printable brains from T1 MRI scans. You just need to build the Docker image and then run a command with the NIFTI file of a participant and will get a readily reconstructed STL mesh for 3D printing. This is an updated & extended version of [miykael/3dprintyourbrain](https://github.com/miykael/3dprintyourbrain) adapted to work using Docker. 

The actual process is as simple as running these two commands 

```bash
docker build --tag 3dprintedbrain .
docker run -it -v ./:opt/share 3dprintedbrain subject.nii
```

**Prerequisites**:

- [Docker](https://www.docker.com/products/docker-desktop/) client installed

- Freesurfer license (it's [free](https://surfer.nmr.mgh.harvard.edu/registration.html))

- [T1 MRI](https://en.wikipedia.org/wiki/Magnetic_resonance_imaging_of_the_brain) of your brain in NIFTI format (.nii or .nii.gz)

# Instructions

## 1. Install Docker

Follow the instructions here to install Docker for your system (if not already installed). It is available for all major operating system.

* [Install Docker Desktop on Mac ](https://docs.docker.com/desktop/install/mac-install/)

* [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)

* [Install Docker Desktop on Linux](https://docs.docker.com/desktop/install/linux-install/)

## 2. Clone the repository and build docker image

Clone this repository by running

`git clone git@github.com:skjerns/3dprintedbrain_docker.git`

Then put your freesurfer license in the cloned repository. You can get the `license.txt` for free at [FreeSurfer Registration form](https://surfer.nmr.mgh.harvard.edu/registration.html).

Navigate into the newly cloned repository and build the docker image by running the following command. 

`docker build --tag 3dprintedbrain .`

## 3. Run extraction step

Put your `subject.nii` or `subject.nii.gz` file into the cloned repository. If your data is in DICOM format, you can easily convert it using `dcm2nii`. A .nii is a NIFTI File that contains all the brain data of a participant.

Now simply run

`docker run -it -v ./:opt/share 3dprintedbrain subject.nii`

This will run the script that automatically runs `recon-all` and extracts the brain structures, then smoothes them and puts them into one `subject.stl`. This process will take a couple of hours usually.

As a final result, there should be a `subject.stl` in your cloned repository folder which you can 3D print!

## 4. Print the stand and connect to the Brain

1. I use small metal rods  to connect the [stand](https://github.com/skjerns/3dprintyourbrain/blob/master/stand.stl) and the brain. Just find one in your local DIY store, 2mm is good. For a beginning you can also sacrifice a fork and break off a fork tine and use that as a connector. Then you can either drill holes for connection or model them directly into the 3D model. Just connecting it via PLA (3D print) will not work, as it's not stable enough. Neither can you print the entire thing at once, you need to print the stand and brain separately for stability.
2. For modelling and adaptations I use http://tinkercad.com , else Meshlab or Blender also work fine but are a bit more complex. Using these tools you can easily pre-model the hole that you want to use to connect the stand to the brain.
3. So far I printed everything using http://treatstock.co.uk at 45% size, which is also the ratio the stand will fit nicely. Most brains will be around 7-8cm length when using 45% scaling. Cost for printing ranged from 10-30€, depending on the color and material (ie. wood is more expensive than PLA, so is translucent or glow-in-the-dark PLA. Cheapest is probably always gray or silver.)

If you have further questions, feel free to open an issue. Connecting the stand to the brain is the most fidgety of all the steps in the guide and requires some trying out yourself.

<img src="./md_assets/d0b4d2576c06abc6906e0ea98ce6b0b75e08e493.jpg" title="" alt="2021-09-11 09.13.41.jpg" width="367">

## appendix

(The previous version of this README using WSL2 for Windows can be found [here](./README_wsl_version.md))
