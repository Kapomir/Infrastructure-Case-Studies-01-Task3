FROM node:20-alpine
WORKDIR /app

COPY package.json package.json
COPY src ./src
COPY scripts ./scripts

RUN node scripts/build.js

ENV PORT=4174
EXPOSE 4174

CMD ["node", "scripts/serve.js"]
