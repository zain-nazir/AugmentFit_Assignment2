# ---------- Build Stage ----------
FROM node:18-slim AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN node --max-old-space-size=8192 $(which npm) run build

# ---------- Production Stage ----------
FROM node:18-alpine AS production

WORKDIR /app

RUN npm install -g serve

# Copy build files from previous stage
COPY --from=builder /app/build ./build

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
