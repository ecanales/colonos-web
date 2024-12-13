function bloquearboton(botonid, botonidspinner) {
    console.log(botonid);
    document.getElementById(botonid).style.display = "none";
    document.getElementById(botonidspinner).style.visibility = "visible";
}

function showLoading() {
    console.log("dentro de showLoading");
    document.getElementById('loadingOverlay').style.display = 'flex';
    setTimeout(closeLoading, 10000);
}

function closeLoading() {
    console.log("saliendo de showLoading");
    document.getElementById('loadingOverlay').style.display = 'none';
    
}