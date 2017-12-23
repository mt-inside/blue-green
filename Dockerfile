FROM scratch

COPY blue-green /

EXPOSE 8080

CMD ["/blue-green"]
