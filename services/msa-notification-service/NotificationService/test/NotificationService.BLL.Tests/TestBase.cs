﻿using AutoMapper;
using Microsoft.Extensions.Logging;
using Moq;
using NotificationService.WEB.Infrastructure.Automapper;

namespace NotificationService.BLL.Tests
{
    public class TestBase
    {
        protected IMapper GetMapper()
        {
            var config = new AutoMapperConfiguration();

            return config.Configure().CreateMapper();
        }

        protected Mock<ILogger<T>> GetLoggerMock<T>() where T : class
        {
            return new Mock<ILogger<T>>();
        }
    }
}