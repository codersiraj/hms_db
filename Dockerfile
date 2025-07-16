FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Sirajsql4041!
ENV MSSQL_PID=Developer

WORKDIR /app

COPY HMS.bak /HMS.bak
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["./entrypoint.sh"]
