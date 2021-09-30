let adicionar = document.getElementById('texto');
let botao = document.getElementById('bta');
let xbota = document.getElementsByClassName('remov');
let lista = document.getElementById('ul');

function newElemente(){
    let li = document.createElement("li");
    let xbot = document.createElement('button');
    xbot.innerHTML = "X"
    let text = document.createTextNode(adicionar.value);
    xbot.className = "remov";
    li.appendChild(xbot);
    li.appendChild(text);
    lista.appendChild(li);
    btnEvent();
    adicionar.value ="";
}
function remuv (){
    this.parentElement.remove();
}

function btnEvent(){
    for (i = 0; i < xbota.length; i++){
        xbota[i].addEventListener('click', remuv);
    }
}

botao.addEventListener('click', newElemente);
btnEvent();
