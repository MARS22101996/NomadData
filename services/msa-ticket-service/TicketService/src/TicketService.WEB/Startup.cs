﻿using System;
using System.IO;
using System.Text;
using AutoMapper;
using EpamMA.CircuitBreaker;
using EpamMA.CircuitBreaker.Models;
using EpamMA.Communication.Infrastructure;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using TicketService.WEB.Infrastructure.DI;
using LoggingNuget.Module;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.PlatformAbstractions;
using Microsoft.IdentityModel.Tokens;
using NLog;
using NLog.Extensions.Logging;
using NLog.Web;
using Swashbuckle.AspNetCore.Swagger;
using TicketService.WEB.Filters;

namespace TicketService.WEB
{
    public class Startup
    {
        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", true, true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();

            env.ConfigureNLog("NLog.config");
        }

        public IConfigurationRoot Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<CommunicationOptions>(Configuration.GetSection("CommunicationOptions"));

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            DependencyResolver.Resolve(services, Configuration);
            services.AddSingleton<IConfiguration>(Configuration);

            services.AddCors(o => o.AddPolicy("Cors", builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));

            services.AddMvc(options =>
            {
                options.Filters.Add(typeof(ErrorFilter));
            });

            services.AddLogging();
            services.AddAutoMapper();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Version = "v1", Title = "Ticket Service API" });
                c.IncludeXmlComments(GetXmlCommentsPath(PlatformServices.Default.Application));
            });

            services
                .Configure<TokenValidationParameters>(Configuration.GetSection("TokenValidationParameters"))
                .Configure<TokenValidationParameters>(options =>
                {
                    var signingKey = new SymmetricSecurityKey(
                        Encoding.ASCII.GetBytes(Configuration["TokenValidationParameters:SecretKey"]));
                    options.IssuerSigningKey = signingKey;
                });

            services
                .Configure<CircuitBreakerOptions>(Configuration.GetSection("CircuitBreakerOptions"));

        }

        public void Configure(
            IApplicationBuilder app,
            IHostingEnvironment env,
            ILoggerFactory loggerFactory,
            IOptions<TokenValidationParameters> tokenValidationOptions,
            IOptions<CircuitBreakerOptions> circuitBreakerOptions)
        {
            loggerFactory.AddNLog();
            app.AddNLogWeb();

            app.UseCircuitBreaker(
                circuitBreakerOptions.Value.ExceptionsAllowedBeforeBreaking,
                TimeSpan.FromSeconds(circuitBreakerOptions.Value.DurationOfBreakInSeconds),
                loggerFactory.CreateLogger<CircuitBreakerMiddleware>());

            ConfigLogManager();

            app.UseServiceCorrelationId();

            loggerFactory.AddConsole(Configuration.GetSection("Logging"));
            loggerFactory.AddDebug();

            app.UseCircuitBreaker(1, TimeSpan.FromSeconds(10), loggerFactory.CreateLogger<CircuitBreakerMiddleware>());

            app.UseJwtBearerAuthentication(new JwtBearerOptions
            {
                AutomaticAuthenticate = true,
                AutomaticChallenge = true,
                TokenValidationParameters = tokenValidationOptions.Value
            });

            app.UseMvc();

            app.UseSwagger();

            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "V1 Docs");
            });
        }

        private string GetXmlCommentsPath(ApplicationEnvironment appEnvironment)
        {
            return Path.Combine(appEnvironment.ApplicationBasePath, $"{appEnvironment.ApplicationName}.xml");
        }

        private void ConfigLogManager()
        {
            LogManager.Configuration.Variables["configDir"] = Path.Combine(Directory.GetCurrentDirectory(), "Logs");
        }
    }
}