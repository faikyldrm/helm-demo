package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/gorilla/mux"
	amqp "github.com/rabbitmq/amqp091-go"
)

var channelRabbitMQ *amqp.Channel
var queName string
var ctx context.Context

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
	queName = os.Getenv("QUE_NAME")
	if queName == "" {
		queName = "defaultQue"
	}
	webPort := "8080"
	amqpServerURL := createURL(server, port, user, password)
	connectRabbitMQ, err := amqp.Dial(amqpServerURL)
	if err != nil {
		hitPanic(err.Error())
	}
	//defer connectRabbitMQ.Close()
	channelRabbitMQ, err = connectRabbitMQ.Channel()
	if err != nil {
		hitPanic(err.Error())
	}
	queueDeclare(channelRabbitMQ, queName, false, false, false, false, nil)
	//defer channelRabbitMQ.Close()
	ctx = context.TODO()
	r := mux.NewRouter()
	r.HandleFunc("/sendtestmessage", sendMessages).Methods("GET")
	r.HandleFunc("/healthcheck", healthCheck).Methods("GET")
	r.HandleFunc("/funccheck", funcCheck).Methods("GET")
	err = http.ListenAndServe(":"+webPort, r)
	if err != http.ErrServerClosed {
		log.Println("Error starting HTTP server")
	}
}

func hitPanic(message string) {
	panic(message)
}
func createURL(url string, port string, username string, password string) string {
	return "amqp://" + username + ":" + password + "@" + url + ":" + port
}

func queueDeclare(channelRabbitMQ *amqp.Channel, queName string, durable bool, autoDelete bool, exclusive bool, noWait bool, args amqp.Table) {
	_, err := channelRabbitMQ.QueueDeclare(
		queName,    // queue name
		durable,    // durable
		autoDelete, // auto delete
		exclusive,  // exclusive
		noWait,     // no wait
		args,       // arguments
	)
	if err != nil {
		hitPanic(err.Error())
	}
}
func publishMessage(ctx context.Context, channelRabbitMQ *amqp.Channel, exchangeKey string, queName string, mandatory bool, immediate bool, msg amqp.Publishing) {
	err := channelRabbitMQ.PublishWithContext(ctx,
		exchangeKey, // exchange
		queName,     // routing key
		mandatory,   // mandatory
		immediate,   // immediate
		msg)
	if err != nil {
		hitPanic(err.Error())
	}
}
func sendMessages(w http.ResponseWriter, r *http.Request) {
	for i := 0; i < 100; i++ {
		publishMessage(ctx, channelRabbitMQ, "", queName, false, false, amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte("Message count:" + strconv.Itoa(i)),
		})
		log.Printf("Message sent: " + strconv.Itoa(i))
		w.Write([]byte("Message sent: " + strconv.Itoa(i) + "\n"))
	}

}
func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("ok"))
}
func funcCheck(w http.ResponseWriter, r *http.Request) {
	result := channelRabbitMQ.IsClosed()
	if result {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Not OK"))

	} else {

		w.Write([]byte("OK"))
	}

}
