FROM microsoft/dotnet:2.1.403-sdk AS builder
WORKDIR /build
# Copy all files
COPY . ./
RUN dotnet restore
RUN dotnet tool install -g ZKEACMS.Publisher
# Release ZKEACMS.WebHost
WORKDIR /build/src/ZKEACMS.WebHost
ENV PATH "$PATH:/root/.dotnet/tools"
RUN publish-zkeacms

# Build runtime image
FROM microsoft/dotnet:2.1.5-aspnetcore-runtime
WORKDIR /zkeacms
COPY --from=builder /build/src/ZKEACMS.WebHost/bin/Release/PublishOutput .
EXPOSE 80
ENTRYPOINT ["dotnet", "ZKEACMS.WebHost.dll"]
