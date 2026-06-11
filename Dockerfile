FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY PersonalProfile/PersonalProfile.csproj PersonalProfile/
RUN dotnet restore PersonalProfile/PersonalProfile.csproj

COPY . .
RUN dotnet publish PersonalProfile/PersonalProfile.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "PersonalProfile.dll"]