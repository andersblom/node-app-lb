FROM node:20.18.0-alpine AS base

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install 

COPY . .

FROM base AS dev
EXPOSE 3000
CMD ["npm", "run", "dev"]

# build application
FROM base AS builder

WORKDIR /usr/src/app

RUN npm run build

# build for production
FROM builder AS prod

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

ENV NODE_ENV="production"

RUN npm install --production

COPY --from=builder /usr/src/app/dist .

EXPOSE 3000

CMD ["npm", "run", "start"]
