# Use freesurfer the base image
FROM freesurfer/freesurfer:7.4.1

# Copy your custom script into the container
COPY ./create_3d_brain_docker.sh /opt/create_3d_brain_docker.sh
COPY ./post_process_mesh.py /opt/post_process_mesh.py
COPY ./license.txt /usr/local/freesurfer/license.txt

# install python and PyMeshLab
RUN yum install -y python3-pip
RUN pip3 install pymeshlab==2021.10

# Set the working directory
WORKDIR /opt

#Make your custom script executable (if needed)
RUN ["chmod", "+x", "/opt/create_3d_brain_docker.sh"]

# Define the entry point for your container
ENTRYPOINT ["/opt/create_3d_brain_docker.sh"]
CMD ["--smooth", "100", "--decimate", "290000"]


