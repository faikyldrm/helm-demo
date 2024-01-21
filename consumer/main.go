package main

import (
	"log"
	"os"

	amqp "github.com/rabbitmq/amqp091-go"
)

func main() {
	server := os.Getenv("AMQP_SERVER")
	if server == "" {
		hitPanic("Empty server adress")
	}
	port := os.Getenv("AMQP_PORT")
	if port == "" {
		hitPanic("Empty server port")
	}
	user := os.Getenv("AMQP_USER")
	if user == "" {
		hitPanic("Empty username")
	}
	password := os.Getenv("AMQP_PASSWORD")
	if password == "" {
		hitPanic("Empty user password")
	}
	queName := os.Getenv("QUE_NAME")
	if queName == "" {
		queName = "defaultQue"
	}
	amqpServerURL := createURL(server, port, user, password)
	connectRabbitMQ, err := amqp.Dial(amqpServerURL)
	if err != nil {
		hitPanic(err.Error())
	}
	defer connectRabbitMQ.Close()
	channelRabbitMQ, err := connectRabbitMQ.Channel()
	if err != nil {
		hitPanic(err.Error())
	}
	defer channelRabbitMQ.Close()
	msgs := consumeMessage(channelRabbitMQ,
		queName, // queue
		"",      // consumer
		true,    // auto-ack
		false,   // exclusive
		false,   // no-local
		false,   // no-wait
		nil,     // args
	)
	for d := range msgs {
		log.Printf(" Message: %s", d.Body)
	}

}
func hitPanic(message string) {
	panic(message)
}
func createURL(url string, port string, username string, password string) string {
	return "amqp://" + username + ":" + password + "@" + url + ":" + port
}
func consumeMessage(channelRabbitMQ *amqp.Channel, queName string, consumer string, autoAck bool, exclusive bool, noLocal bool, noWait bool, args amqp.Table) <-chan amqp.Delivery {

	log.Printf("let's try listening")
	msgs, err := channelRabbitMQ.Consume(
		queName,   // queue
		consumer,  // consumer
		autoAck,   // auto-ack
		exclusive, // exclusive
		noLocal,   // no-local
		noWait,    // no-wait
		args,      // args
	)
	if err != nil {
		hitPanic("Can't listen que because: " + err.Error())
	}
	return msgs
}
