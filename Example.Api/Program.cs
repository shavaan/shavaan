using Microsoft.AspNetCore.Mvc;
using System.Net.Security;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddLogging();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapGet("/greeting", ([FromQuery] string name, [FromServices] ILogger<Program> logger) =>
{
    logger.LogInformation($"Sending greeting to {name}.");

    return $"Hello {name}, from a DevSecOps World!";
});

app.Run();

public partial class Program { }