FROM node:8

COPY abi /opt/pg-graphql/abi
COPY bin /opt/pg-graphql/bin
COPY graphql /opt/pg-graphql/graphql
COPY lib /opt/pg-graphql/lib
COPY libexec /opt/pg-graphql/libexec
COPY sql /opt/pg-graphql/sql
COPY .babelrc /opt/pg-graphql/.babelrc
COPY addr.json /opt/pg-graphql/addr.json
COPY package.json /opt/pg-graphql/package.json
COPY Profile /opt/pg-graphql/Profile

WORKDIR /opt/pg-graphql
RUN npm install
