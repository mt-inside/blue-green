FROM scratch

ARG COLOUR

COPY blue-green /

EXPOSE 8080

ENTRYPOINT ["/blue-green"]

ENV COLOUR=$COLOUR
