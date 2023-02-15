<img title="" src="./md_assets/3a5b470407b7d8dcfb1e6cfee7a785ca425898a8.jpg" alt="2021-09-11 10.44.37.jpg" width="203" data-align="left">

# 3D print your brain using WSL (Windows 10)

This is an updated version of [miykael/3dprintyourbrain](https://github.com/miykael/3dprintyourbrain) adapted to work under Windows using the Subsystem for Linux (WSL2 using Ubuntu).

For this project I'm using

1. [Ubuntu 18 on WSL2 (Windows 10)](https://ubuntu.com/wsl)

2. [FreeSurfer 7-dev](https://surfer.nmr.mgh.harvard.edu/fswiki/FS7_wsl_ubuntu)

3. [MeshLab 2020.09 for Windows](https://github.com/cnr-isti-vclab/meshlab/releases/download/Meshlab-2020.09/MeshLab2020.09-windows.exe)

4. NIFTI T1 image of a brain

I adapted the script in such a way that you can simply use the following command and retrieve a fully reconstructed brain from a NIFTI file.

```
sh create_3d_brain.sh subjectname.nii.gz
```

## How to use this repo

### 1. Install requirements

#### 1.1 Setup WSL

 Setup WSL and install Ubuntu 18 according to this article [WSL | Ubuntu](https://ubuntu.com/wsl)

#### 1.2 Install FreeSurfer in Ubuntu

Inside WSL, run the following commands to install Freesurfer

```shell
# url might change, let me know if this is the case
wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer_ubuntu18-7-dev_amd64.deb
sudo apt-get update
sudo apt-get --yes install ./freesurfer_ubuntu18-7-dev_amd64.deb
echo "export FREESURFER_HOME=/usr/local/freesurfer/7-dev" >> $HOME/.bashrc
echo "export FS_LICENSE=$HOME/license.txt" >> $HOME/.bashrc
echo "source /usr/local/freesurfer/7-dev/SetUpFreeSurfer.sh" >> $HOME/.bashrc
```

Register your copy of FreeSurfer here [FreeSurfer Registration form](https://surfer.nmr.mgh.harvard.edu/registration.html) and place the license.txt in your WSL home directory. The easiest way to do this is to open WSL via command line `wsl`, then switch to your home directory `cd ~` and then open the regular windows explorer inside your WSL home directory with `explorer.exe .`. Now copy your `license.txt` to this folder

#### 1.3. Install MeshLab 2020.09 for Windows

Inside the Windows host machine, install [MeshLab 2020.09](https://github.com/cnr-isti-vclab/meshlab/releases/download/Meshlab-2020.09/MeshLab2020.09-windows.exe). It's important to use this version as it's the last version containing the MeshLab Server. Running MeshLab inside WSL seems tricky and may require to add XGD window support. So instead we just use a Windows installation of MeshLab and do not install it in WSL.

### 2. Setup the script

Copy the contents of this repository inside your home dir in WSL.

Your home dir should look like this

![](https://github.com/skjerns/3dprintyourbrain/blob/master/md_assets/2021-07-28-09-50-41-image.png?raw=true)

type `nano create_3d_brain.sh` and check if the MESHLAB_SERVER in line 8 points to the correct location of your `meshlabserver.exe` on your windows machine

### 3. Run the script

Copy your NIFTI file (`subjectname.nii.gz`) to the home dir and simply run `sh create_3d_brain.sh subjectsname.nii.gz`. The whole process will take a few hours, depending on your machine speed. In the end there should be a `final.stl` in the folder `~/3dbrains/subjectname/output/final.stl`

Have fun with it :)

## 4. Print the stand and connect to the Brain

1. I use small metal rods  to connect the [stand](https://github.com/skjerns/3dprintyourbrain/blob/master/stand.stl) and the brain. Just find one in your local DIY store, 2mm is good. For a beginning you can also sacrifice a fork and break off a fork tine and use that as a connector. Then you can either drill holes for connection or model them directly into the 3D model. Just connecting it via PLA (3D print) will not work, as it's not stable enough. Neither can you print the entire thing at once, you need to print the stand and brain separately for stability.
2. For modelling and adaptations I use http://tinkercad.com , else Meshlab or Blender also work fine but are a bit more complex. Using these tools you can easily pre-model the hole that you want to use to connect the stand to the brain.
3. So far I printed everything using http://treatstock.co.uk at 45% size, which is also the ratio the stand will fit nicely. Most brains will be around 7-8cm length when using 45% scaling. Cost for printing ranged from 10-30€, depending on the color and material (ie. wood is more expensive than PLA, so is translucent or glow-in-the-dark PLA. Cheapest is probably always gray or silver.)

If you have further questions, feel free to open an issue. Connecting the stand to the brain is the most fidgety of all the steps in the guide and requires some trying out yourself.

<img src="./md_assets/d0b4d2576c06abc6906e0ea98ce6b0b75e08e493.jpg" title="" alt="2021-09-11 09.13.41.jpg" width="367">
