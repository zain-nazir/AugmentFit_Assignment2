# # Build stage
# FROM node:alpine3.18 AS build

# # Set Node.js memory limit for low-memory environments
# ENV NODE_OPTIONS="--max-old-space-size=2560"

# WORKDIR /app

# # Copy package files first for better Docker layer caching
# COPY package*.json ./

# # Install dependencies with memory optimization
# RUN npm ci --silent --no-optional

# # Copy source code
# COPY . .

# # Build the React app
# RUN npm run build

# # Production stage - serve with nginx  
# FROM nginx:1.23-alpine
# WORKDIR /usr/share/nginx/html
# RUN rm -rf *
# COPY --from=build /app/build .
# EXPOSE 80
# ENTRYPOINT ["nginx", "-g", "daemon off;"]

# Use Node.js official image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build the React app
RUN npm run build

# Install serve to serve the built app
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["serve", "-s", "build", "-l", "3000"]