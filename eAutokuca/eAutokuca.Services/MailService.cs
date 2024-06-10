using eAutokuca.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using RabbitMQ.Client;

namespace eAutokuca.Services
{
    public class MailService : IMailService
    {
        private readonly string serverAddress = Environment.GetEnvironmentVariable("SERVER_ADDRESS") ?? "smtp.gmail.com";
        private readonly string mailSender = Environment.GetEnvironmentVariable("MAIL_SENDER") ?? "autokucalena@gmail.com";
        private readonly string mailPass = Environment.GetEnvironmentVariable("MAIL_PASS") ?? "iszgskdnofylaxqo";
        private readonly int port = int.Parse(Environment.GetEnvironmentVariable("MAIL_PORT") ?? "587");
        public async Task startConnection(MailObject obj)
        {
            var hostname = "localhost";

            var factory = new ConnectionFactory { HostName = hostname };
                //UserName = username, Password = password };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "email_sending",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);




            var body = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(obj));

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "email_sending",
                                 basicProperties: null,
                                 body: body);
        }

    }
}
