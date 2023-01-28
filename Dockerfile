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



