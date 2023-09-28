exports.init =  async function(app) {

     console.log("Hello! Starting_TEST_PORTS")


     app.ports.sendData.subscribe(function(data) {
            console.log("Data from Elm: ", data);
            //app.ports.receiveData.send("Hey Elm!");
        });

}