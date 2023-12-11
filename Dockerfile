# Use Freesurfer 7.4.1 as the base image
FROM freesurfer/freesurfer:7.4.1

# Install dependencies for Meshlab
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:zarquon42/meshlab \
    && apt-get update

# Install Meshlab
RUN apt-get install -y meshlab

# Copy the script file into the image
COPY create_3d_brain.sh /usr/local/bin/create_3d_brain.sh
COPY meshlab_close_decimate.mlx /usr/local/bin/meshlab_close_decimate.mlx
COPY meshlab_smoothing.mlx /usr/local/bin/meshlab_smoothing.mlx
COPY license.txt /usr/local/freesurfer/license.txt

# Make the script executable
RUN chmod +x /usr/local/bin/create_3d_brain.sh

# Set environment variables
ENV FREESURFER_HOME=/usr/local/freesurfer
ENV MESHLAB_HOME=/path/to/meshlab
ENV PATH=$FREESURFER_HOME:$MESHLAB_HOME:$PATH

# Entry point (optional)
ENTRYPOINT ["/usr/local/bin/create_3d_brain.sh"]