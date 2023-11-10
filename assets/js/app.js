// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import "flowbite"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
let liveFileInput = document.querySelector('#file-input');
let form = document.querySelector('form');

function submitUploadForm() {
  // Submit the Live File Input
  let liveFileInputForm = new FormData();
  liveFileInputForm.append('file', liveFileInput.files[0]);

  fetch('/upload_endpoint', {
    method: 'POST',
    body: liveFileInputForm,
  })
  .then(response => response.json())
  .then(data => {
    // Handle the response from the Live File Input submission
    console.log(data);
  })
  .catch(error => {
    console.error('Error:', error);
  });

  // Submit the Form
  let formData = new FormData(form);

  fetch('/form_endpoint', {
    method: 'POST',
    body: formData,
  })
  .then(response => response.json())
  .then(data => {
    // Handle the response from the form submission
    console.log(data);
  })
  .catch(error => {
    console.error('Error:', error);
  });
}

document.querySelector('#submit-button').addEventListener('click', submitUploadForm);

window.addEventListener('phx:page-loading-stop', (event) => {
  // trigger flowbite events
  window.document.dispatchEvent(new Event("DOMContentLoaded", {
    bubbles: true,
    cancelable: true
  }));
});