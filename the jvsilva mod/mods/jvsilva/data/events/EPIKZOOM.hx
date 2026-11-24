function onEvent(event) {
    if (event.event.name == "EPIKZOOM") {
        defaultCamZoom = event.event.params[0];
    }
}
