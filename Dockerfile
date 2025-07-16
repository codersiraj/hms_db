FROM mcr.microsoft.com/mssql/server:2022-lts

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!

WORKDIR /app

# Copy .bak file from repo to image
COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["/entrypoint.sh"]