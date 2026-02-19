# Use the official .NET image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["TaAlt.sln", "."]
COPY ["src/TaAlt.Api/TaAlt.Api.csproj", "src/TaAlt.Api/"]
RUN dotnet restore "TaAlt.sln"
COPY . .
WORKDIR "/src/src/TaAlt.Api"
RUN dotnet build "TaAlt.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TaAlt.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TaAlt.Api.dll"]
