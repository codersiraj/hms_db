FROM mcr.microsoft.com/mssql/server:2022-lts

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!
ENV MSSQL_PID=Developer

WORKDIR /app

# Copy backup and entrypoint
COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["./entrypoint.sh"]
