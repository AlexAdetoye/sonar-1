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



# install openSCAP
RUN yum -y install openscap openscap-scanner openscap-utils

# install Trivy
RUN curl -sfL https://github.com/aquasecurity/trivy/releases/download/v0.12.0/trivy_0.12.0_Linux-64bit.tar.gz | tar -xz -C /usr/local/bin

# install Sonarqube Scanner
RUN curl -o sonar-scanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.4.0.2170-linux.zip \
    && unzip sonar-scanner.zip \
    && mv sonar-scanner-4.4.0.2170-linux /opt/sonar-scanner \
    && ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

CMD ["bash

