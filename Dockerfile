# Use the official Freesurfer docker image from MGH as a base
FROM freesurfer/freesurfer:7.3.2@sha256:af1f78ae2fae323470ff49a29b2a94cf51f129d50b7d60a094eed2c7d0f07438

# Install hostname command
RUN dnf makecache && dnf install -y hostname

# Create directories for inputs and outputs
RUN mkdir -p /ENIGMA-TS/inputs
RUN mkdir -p /ENIGMA-TS/outputs

# Add ENIGMA_TS_T1 scripts
RUN mkdir /ENIGMA-TS/ENIGMA_TS_T1_pipeline
COPY *.sh /ENIGMA-TS/ENIGMA_TS_T1_pipeline/

# Make all directories 777
RUN chmod -R 777 /ENIGMA-TS

# Add ENIGMA wrapper scripts
COPY enigma_wrapscripts.zip /tmp/
RUN unzip /tmp/enigma_wrapscripts.zip -d /ENIGMA-TS && \
    sed -i "s%/Applications/freesurfer/7.1.0%/usr/local/freesurfer%" /ENIGMA-TS/enigma_wrapscripts/bash/recon-all.sh

# Set workdir to /ENIGMA_TS_T1_pipeline
WORKDIR /ENIGMA-TS/ENIGMA_TS_T1_pipeline
