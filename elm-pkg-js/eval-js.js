exports.init = async function(app) {

    console.log("Hello! Starting eval-js")

    app.ports.sendDataToJS.subscribe(function(data) {
      // Check if the Web Worker feature is available in the browser
      console.log("DATA_FROM_ELM", data)
      if (window.Worker) {

          // Create a Blob from the JavaScript code (string) and create a URL for it
          var blob = new Blob([data.replace('_Debug_toAnsiString(true,','_Debug_toAnsiString(false,' )], { type: 'application/javascript' });
          var url = URL.createObjectURL(blob);

          // Instantiate a new Web Worker object with the blob URL
          const myWorker = new Worker(url);

          // Define an onmessage handler to receive messages from the worker
          myWorker.onmessage = (e) => {
              console.log('FROM WORKER', e.data);
              app.ports.receiveFromJS.send(JSON.stringify(e.data));
          };

          // Define an onerror handler to catch errors from the worker
          myWorker.onerror = (e) => {
              console.error('Error from worker:', e.message);
          };
      } else {
          console.error('Web Worker is not supported in your browser.');
      }
    });
};