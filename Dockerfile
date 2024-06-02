# Use the official Node.js image as a base
FROM node:14

# Create and set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install express express-fileupload body-parser mysql ejs req-flash dotenv --save

# Copy the rest of the application code to the working directory
COPY . .

# Define a volume to persist data
VOLUME /public/assets/img

# Expose the port that the app runs on
EXPOSE 2000

# Command to run the application using npx
CMD ["npx", "nodemon", "app.js"]