FROM node:18-alpine AS builder

WORKDIR /app

RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=yarn.lock,target=yarn.lock \
    yarn install --pure-lockfile

COPY . .
RUN yarn build && yarn install --pure-lockfile --prod

FROM node:18-alpine

WORKDIR /app
EXPOSE 3000

COPY --from=builder /app/package.json /app/next.config.js /app/yarn.lock ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next

CMD ["npm", "run", "start"]