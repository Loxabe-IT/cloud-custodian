FROM python:3.7.4-slim-stretch

LABEL name="c7n-org" \
      description="Cloud Custodian Organization Runner" \
      repository="http://github.com/cloud-custodian/cloud-custodian" \
      homepage="http://github.com/cloud-custodian/cloud-custodian" \
      maintainer="Custodian Community <https://cloudcustodian.io>"

# Transfer Custodian source into container by directory
# to minimize size.
# Note: build root is the root of the checkout.

#Install GIT
RUN apt-get update && \
apt-get install -y git

RUN git clone https://github.com/cloud-custodian/cloud-custodian.git

WORKDIR /cloud-custodian

RUN adduser --disabled-login custodian
RUN apt-get --yes update && apt-get --yes upgrade \
 && apt-get --yes install build-essential \
 && pip3 install -r requirements.txt  . \
 && pip3 install -r tools/c7n_gcp/requirements.txt tools/c7n_gcp \
 && pip3 install -r tools/c7n_azure/requirements.txt tools/c7n_azure \
 && pip3 install tools/c7n_org \
 && apt-get --yes remove build-essential \
 && apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -Rf /var/cache/apt/ \
 && rm -Rf /var/lib/apt/lists/* \
 && rm -Rf /root/.cache/ \
 && mkdir /output \
 && chown custodian: /output

# Install Java

RUN mkdir -p /usr/share/man/man1
RUN apt-get update && \
apt-get install -y default-jre 

#Install SSH
RUN apt-get update && \
apt-get install -y openssh-server

#Remove custodian files
RUN rm -Rf /cloud-custodian/ 

#Install AWS CLI
RUN pip3 install awscli
USER custodian
WORKDIR /home/custodian
ENV LC_ALL="C.UTF-8" LANG="C.UTF-8"
VOLUME ["/home/custodian"]
#ENTRYPOINT ["/usr/local/bin/c7n-org"]
CMD ["--help"]

