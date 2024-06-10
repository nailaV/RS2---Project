﻿

using RabbitMQ.Client.Events;

using RabbitMQ.Client;

using System.Text;

using Newtonsoft.Json;

using eAutokucaRabbitMQ;
 
var hostname = //Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? 
    "localhost";

//var username = Environment.GetEnvironmentVariable("RABBITMQ_USER") ?? "user";

//var password = Environment.GetEnvironmentVariable("RABBITMQ_PASS") ?? "pass";

var factory = new ConnectionFactory { HostName = hostname };
   // UserName = username, Password = password };

using var connection = factory.CreateConnection();

using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "email_sending",

                     durable: false,

                     exclusive: false,

                     autoDelete: false,

                     arguments: null);

Console.WriteLine("Listening to messages....");

var consumer = new EventingBasicConsumer(channel);

consumer.Received += (model, ea) =>

{

    var body = ea.Body.ToArray();

    var message = Encoding.UTF8.GetString(body);

    var entitet = JsonConvert.DeserializeObject<MailObjekat>(message);

    MailSending.posaljiMail(entitet!);

};

channel.BasicConsume(queue: "email_sending",

                     autoAck: true,

                     consumer: consumer);

Thread.Sleep(Timeout.Infinite);

Console.ReadLine();
