FROM neo4j:5.3.0

COPY data.enc /tmp
WORKDIR /tmp

ARG ENCRYPTION_KEY

RUN openssl enc -aes-256-cbc -pbkdf2 -d -in data.enc -out data.tar.gz -pass "pass:$ENCRYPTION_KEY"
RUN tar xvzf data.tar.gz -C /tmp