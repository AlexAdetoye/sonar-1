FROM node:18.13.0

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

#RUN yum install openscap-scanner -y
#RUN um install scap-security-guide -y

# Bundle app source
COPY . .

EXPOSE 8080
CMD ["node", "server"]
#CMD [ "npm", "start" ]

# Installing OpenSCAP
RUN yum update -y
  && yum install -y openscap
  && yum install -y openscap-scanner
  && yum install -y scap-security-guide

# Installing Trivy
RUN export TRIVY_VERSION=$(wget -qO - "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
RUN echo $TRIVY_VERSION
RUN yum install -y https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.rpm

# Install Sonarqube Scanner
# From https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip. This is the latest version of sonar scanner
RUN aws s3 cp s3://jenkins-binaries-213141505949/sonar-scanner-cli-4.7.0.2747-linux.zip /tmp \
  && cd /tmp \
  && unzip -q sonar-scanner-cli-4.7.0.2747-linux.zip \
  && mv sonar-scanner-cli-4.7.0.2747-linux /usr/lib/sonar-scanner \
  && rm -rf sonar-scanner-cli-4.7.0.2747-linux.zip \
  && ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner 

# Set up the properties file
ENV SONAR_SCANNER_OPTS="-Dsonar.host.url=http://34.209.138.82:9000/projects/favorite"

# Run Sonar Scanner
ENV SONAR_RUNNER_HOME=/usr/local/bin/sonar-scanner

# Verifying successful install of OpenSCAP, and Trivy Libraries
RUN oscap --version && trivy --version && sonar-scanner --version

