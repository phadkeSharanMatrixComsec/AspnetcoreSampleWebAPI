# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the official ASP.NET Core build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["AspnetcoreSampleWebAPI.csproj", "./"]
RUN dotnet restore "AspnetcoreSampleWebAPI.csproj"
COPY . .
RUN dotnet build "AspnetcoreSampleWebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspnetcoreSampleWebAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspnetcoreSampleWebAPI.dll"]
