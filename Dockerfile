#FROM ets-cloud-docker-local.artifactory.platform.manulife.io/ets-dotnet:6-sdk-0.0.1 AS build
FROM ets-cloud-docker-local.artifactory.platform.manulife.io/ets-dotnet:6-sdk-1.1.10 AS build
WORKDIR /home/gwam
COPY . .
USER root
RUN dotnet nuget locals --clear all
RUN dotnet restore --configfile nuget.config "./Example.Api/Example.Api.csproj"
RUN dotnet build "./Example.Api/Example.Api.csproj" -c Release -r debian-x64 -o /home/gwam/build

#ENTRYPOINT ["tail", "-f", "/dev/null"]
FROM build AS publish
RUN dotnet publish "./Example.Api/Example.Api.csproj" -c Release -r debian-x64 -o /home/gwam/publish
EXPOSE 5000

#FROM ets-cloud-docker-local.artifactory.platform.manulife.io/ets-dotnet:6-sdk-0.0.1 AS final
FROM ets-cloud-docker-local.artifactory.platform.manulife.io/ets-dotnet:6-asp-1.1.9 AS final
WORKDIR /home/gwam
USER root
RUN apt-get update; \
    apt-get upgrade -y; \
    rm -rf /var/lib/apt/lists/*
#RUN apt-get remove -y --auto-remove curl
RUN adduser --disabled-password gwam
ENV SERVICE_NAME="gwam"
RUN chown -R $SERVICE_NAME:$SERVICE_NAME /home/gwam
ARG NEWRELIC_KEY
ARG APP_ENV
COPY --from=publish /home/gwam/publish .
# Enable the agent
ENV CORECLR_ENABLE_PROFILING="1"
ENV CORECLR_PROFILER="{36032161-FFC0-4B61-B559-F6C5D41BAE5A}"
ENV CORECLR_NEWRELIC_HOME="/usr/local/newrelic-dotnet-agent"
ENV CORECLR_PROFILER_PATH="/usr/local/newrelic-dotnet-agent/libNewRelicProfiler.so"
ENV NEW_RELIC_LICENSE_KEY ${NEWRELIC_KEY} 
ENV NEW_RELIC_ENVIRONMENT ${APP_ENV}
COPY . /home/gwam/src
EXPOSE 5000
USER gwam
ENV ASPNETCORE_URLS=http://+:5000
ENTRYPOINT ["dotnet", "/home/gwam/publish/Example.Api.dll"]