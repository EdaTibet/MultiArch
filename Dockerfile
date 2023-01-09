FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine3.17 AS build
WORKDIR /src
COPY ["MultiArch/MultiArch.csproj", "MultiArch/"]
RUN dotnet restore "MultiArch/MultiArch.csproj"
COPY . .
WORKDIR "/src/MultiArch"
RUN dotnet build "MultiArch.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MultiArch.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MultiArch.dll"]
