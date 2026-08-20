FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
RUN npm install -g serve@14.2.6
COPY --from=builder /app/dist ./dist

ENV PORT=3000
EXPOSE 3000

# --no-port-switching: serve must fail loudly if PORT is unavailable,
# not silently rebind to a random port the ALB isn't pointed at.
CMD serve -s dist -l ${PORT} --no-port-switching
