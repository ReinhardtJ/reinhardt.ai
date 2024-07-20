FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["YourBlazorApp.csproj", "./"]
RUN dotnet restore "YourBlazorApp.csproj"
COPY . .
RUN dotnet build "YourBlazorApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "YourBlazorApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YourBlazorApp.dll"]
