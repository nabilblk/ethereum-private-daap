FROM node:0.12

RUN git clone https://github.com/etherparty/explorer
RUN cd /explorer && npm install
RUN cd /explorer && npm install -g grunt-cli

WORKDIR /explorer

EXPOSE 8000

CMD ["npm", "start"]
