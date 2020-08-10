FROM debian:stretch

LABEL maintainer="lam87@cornell.edu"

ENV CPANMIRROR=http://cpan.cpantesters.org
# based on the vagrant provision.sh script by Nick Morales <nm529@cornell.edu>

# open port 8080
#
EXPOSE 8080

# create directory layout
#
RUN mkdir -p /home/production/public/sgn_static_content
RUN mkdir -p /home/production/tmp/solgs
RUN mkdir -p /home/production/archive
RUN mkdir -p /home/production/public/images/image_files
RUN chown -R www-data /home/production/public
RUN mkdir -p /home/production/tmp
RUN chown -R www-data /home/production/tmp
RUN mkdir -p /home/production/archive/breedbase
RUN chown -R www-data /home/production/archive
RUN mkdir -p /home/production/blast/databases/current
RUN mkdir -p /home/production/cxgn
RUN mkdir -p /home/production/cxgn/local-lib
RUN mkdir -p /home/production/cache
RUN chown -R www-data /home/production/cache
RUN mkdir /etc/starmachine
RUN mkdir /var/log/sgn

WORKDIR /home/production/cxgn


# add cran backports repo and required deps
#
RUN echo "deb http://lib.stat.cmu.edu/R/CRAN/bin/linux/debian stretch-cran35/" >> /etc/apt/sources.list

# install system dependencies
#
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update -y --allow-unauthenticated
RUN apt-get upgrade -y
RUN apt-get install build-essential pkg-config apt-utils gnupg2 curl -y
# key for cran-backports (not working though)
#
# RUN bash -c "apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' 1>/key.out   2> /key.err"

#RUN apt-get update --fix-missing -y
RUN apt-get update -y

RUN apt-get install -y aptitude
RUN aptitude install -y libterm-readline-zoid-perl nginx starman emacs gedit vim less sudo htop git dkms linux-headers-4.9.0-11-amd64 perl-doc ack-grep make xutils-dev nfs-common lynx xvfb ncbi-blast+ libmunge-dev libmunge2 munge slurm-wlm slurmctld slurmd libslurm-perl libssl-dev graphviz lsof imagemagick mrbayes muscle bowtie bowtie2 blast2 postfix mailutils libcupsimage2 postgresql libglib2.0-dev libglib2.0-bin screen apt-transport-https wget
RUN aptitude install libgdal-dev libproj-dev libudunits2-dev -y

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get -y install postgresql-12 postgresql-client-12

RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus

RUN chmod 777 /var/spool/ \
    && mkdir /var/spool/slurmstate \
    && chown slurm:slurm /var/spool/slurmstate/ \
    && /usr/sbin/create-munge-key \
    && ln -s /var/lib/slurm-llnl /var/lib/slurm

RUN apt-get install r-base r-base-dev libopenblas-base -y --allow-unauthenticated

# required for R-package spdep, and other dependencies of agricolae
#
RUN apt-get install libudunits2-dev libproj-dev libgdal-dev -y

# copy some tools that don't have a Debian package
#
COPY tools/gcta/gcta64  /usr/local/bin/
COPY tools/quicktree /usr/local/bin/
COPY tools/sreformat /usr/local/bin/

# copy imagemagick policy with higher resource limits
COPY imagemagick_policy.xml /etc/ImageMagick-6/policy.xml

# copy code repos. Run the prepare.pl script to clone them
# before the build
# This also adds the Mason website skins
#
ADD repos /home/production/cxgn

COPY slurm.conf /etc/slurm-llnl/slurm.conf

COPY sgn_local_docker.conf /home/production/cxgn/sgn/
COPY starmachine.conf /etc/starmachine/
COPY slurm.conf /etc/slurm-llnl/slurm.conf

# XML::Simple dependency
#
RUN apt-get install libexpat1-dev -y

# HTML::FormFu
#
RUN apt-get install libcatalyst-controller-html-formfu-perl -y

# Cairo Perl module needs this:
#
RUN apt-get install libcairo2-dev -y

# GD Perl module needs this:
#
RUN apt-get install libgd2-xpm-dev -y

# postgres driver DBD::Pg needs this:
#
RUN apt-get install libpq-dev -y

# MooseX::Runnable Perl module needs this:
#
RUN apt-get install libmoosex-runnable-perl -y

RUN apt-get install libgdbm3 libgdm-dev -y
RUN apt-get install nodejs -y

WORKDIR /home/production/cxgn/sgn

ENV PERL5LIB=/home/production/cxgn/local-lib/:/home/production/cxgn/local-lib/lib/perl5:/home/production/cxgn/sgn/lib:/home/production/cxgn/cxgn-corelibs/lib:/home/production/cxgn/Phenome/lib:/home/production/cxgn/Cview/lib:/home/production/cxgn/ITAG/lib:/home/production/cxgn/biosource/lib:/home/production/cxgn/tomato_genome/lib:/home/production/cxgn/Chado/chado/lib:/home/production/cxgn/Bio-Chado-Schema/lib:.

# run the Build.PL to install the R dependencies...
#
ENV HOME=/home/production
ENV PGPASSFILE=/home/production/.pgpass
RUN echo "R_LIBS_USER=/home/production/cxgn/R_libs" >> /etc/R/Renviron
RUN mkdir -p /home/production/cxgn/sgn/R_libs
ENV R_LIBS_USER=/home/production/cxgn/R_libs
#RUN rm /home/production/cxgn/sgn/static/static
#RUN rm /home/production/cxgn/sgn/static/s
#RUN rm /home/production/cxgn/sgn/documents

RUN bash /home/production/cxgn/sgn/js/install_node.sh

#INSTALL OPENCV IMAGING LIBRARY
RUN apt-get install -y python3-dev python-pip python3-pip python-numpy
RUN apt-get install -y libgtk2.0-dev libgtk-3-0 libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libhdf5-serial-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libxvidcore-dev libatlas-base-dev gfortran libgdal-dev exiftool libzbar-dev cmake

RUN apt-get install -y python3-virtualenv \
    && pip3 install virtualenv virtualenvwrapper \
    && python3 -m virtualenv --python=/usr/bin/python3 /home/production/cv \
    && . /home/production/cv/bin/activate \
    && pip3 install imutils matplotlib pillow statistics PyExifTool pytz pysolar scikit-image scikit-learn packaging pyzbar pandas tensorflow "numpy<1.17" \
    && pip3 install -U keras-tuner

RUN . /home/production/cv/bin/activate \
    && cd /home/production/cxgn/opencv \
    && mkdir build \
    && cd /home/production/cxgn/opencv/build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D OPENCV_EXTRA_MODULES_PATH=/home/production/cxgn/opencv_contrib/modules \
        -D PYTHON3_EXECUTABLE=$(which python3) \
        -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
        -D BUILD_EXAMPLES=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D OPENCV_GENERATE_PKGCONFIG=YES .. \
    && make -j 4 \
    && make install \
    && ldconfig

RUN mv /usr/local/lib/python3.5/site-packages/cv2/python-3.5/cv2.cpython-35m-x86_64-linux-gnu.so /usr/local/lib/python3.5/site-packages/cv2/python-3.5/cv2.so \
    && ln -s /usr/local/lib/python3.5/site-packages/cv2/python-3.5/cv2.so /home/production/cv/lib/python3.5/site-packages/cv2.so

RUN g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_multi.cpp -o /usr/bin/stitching_multi `pkg-config opencv4 --cflags --libs` \
    && g++ /home/production/cxgn/DroneImageScripts/cpp/stitching_single.cpp -o /usr/bin/stitching_single `pkg-config opencv4 --cflags --libs`

#RUN python3 -m virtualenv --python=/usr/bin/python3 /home/production/mrcnn \
#    && . /home/production/mrcnn/bin/activate \
#    && pip3 install tensorflow==1.5.0 keras==2.1.5 "numpy<1.17" scipy matplotlib scikit-image Pillow cython h5py imgaug IPython[all] "six>=1.15.0" \
#    && git clone https://github.com/matterport/Mask_RCNN.git \
#    && cd Mask_RCNN \
#    #&& pip3 install -r requirements.txt \
#    && pip3 install "setuptools>=46.4.0" \
#    && python3 setup.py install

# INSTALL REML F90 SUITE
RUN wget -r -np -R "index.html*" http://nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/ \
    && chmod 777 nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/* \
    && scp nce.ads.uga.edu/html/projects/programs/Linux/64bit_AMD/* /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
RUN ln -s /home/production/cxgn/starmachine/bin/starmachine_init.d /etc/init.d/sgn

# start services when running container...
ENTRYPOINT /bin/bash /entrypoint.sh
