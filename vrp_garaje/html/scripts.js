$(document).ready(function(){
  // Partial Functions
  function closeMain() {
    $(document.getElementById("politie")).css("display", "none");
    $(document.getElementById("medici")).css("display", "none");
    $(document.getElementById("jandarmerie")).css("display", "none");
    $(document.getElementById("sri")).css("display", "none");
    $(document.getElementById("ups")).css("display", "none");
    $(document.getElementById("pizza")).css("display", "none");
    $(document.getElementById("mecanici")).css("display", "none");
    $(document.getElementById("taxi")).css("display", "none");
    $(document.getElementById("bankdriver")).css("display", "none");
    $(document.getElementById("rosal")).css("display", "none");
    $(document.getElementById("transport")).css("display", "none");
    $(document.getElementById("elicopterems")).css("display", "none");
  }
  function openMain() {
    $(document.getElementById("politie")).css("display", "block");
  }
  function openMain2() {
    $(document.getElementById("medici")).css("display", "block");
  }
  function openMain4() {
    $(document.getElementById("jandarmerie")).css("display", "block");
  }
  function openMain5() {
    $(document.getElementById("sri")).css("display", "block");
  }
  function openMain6() {
    $(document.getElementById("ups")).css("display", "block");
  }
  function openMain7() {
    $(document.getElementById("pizza")).css("display", "block");
  }
  function openMain8() {
    $(document.getElementById("mecanici")).css("display", "block");
  }
  function openMain9() {
    $(document.getElementById("taxi")).css("display", "block");
  }
  function openMain10() {
    $(document.getElementById("bankdriver")).css("display", "block");
  }
  function openMain11() {
    $(document.getElementById("rosal")).css("display", "block");
  }
  function openMain12() {
    $(document.getElementById("transport")).css("display", "block");
  }
  function openMain13() {
    $(document.getElementById("elicopterems")).css("display", "block");
  }
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main bank window
    if(item.openNUI == true) {
      openMain();
    }
    if(item.openNUI == false) {
      closeMain();
    }
    if(item.openNUI3 == true) {
      openMain2();
    }
    if(item.openNUI4 == true) {
      openMain4();
    }
    if(item.openNUI5 == true) {
      openMain5();
    }
    if(item.openNUI6 == true) {
      openMain6();
    }
    if(item.openNUI7 == true) {
      openMain7();
    }
    if(item.openNUI8 == true) {
      openMain8();
    }
    if(item.openNUI9 == true) {
      openMain9();
    }
    if(item.openNUI10 == true) {
      openMain10();
    }
    if(item.openNUI11 == true) {
      openMain11();
    }
    if(item.openNUI12 == true) {
      openMain12();
    }
    if(item.openNUI13 == true) {
      openMain13();
    }
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 8 ) {
      $.post('http://vrp_garaje/close', JSON.stringify({}));
    }
    if (data.which == 27 ) {
      $.post('http://vrp_garaje/close', JSON.stringify({}));
    }
  };
  $(document.getElementById("1")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "police2"})
    );
  });
  $(document.getElementById("2")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "police3"})
    );
  });
  $(document.getElementById("3")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "jaguarxfrs"})
    );
  });
  $(document.getElementById("4")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "sheriff"})
    );
  });
  $(document.getElementById("5")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "riot"})
    );
  });
  $(document.getElementById("6")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "pol718"})
    );
  });
  $(document.getElementById("7")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "polgs350"})
    );
  });
  $(document.getElementById("30")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "polrs"})
    );
  });
  $(document.getElementById("31")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "ambulance"})
    );
  });
  $(document.getElementById("50")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "fbi"})
    );
  });
  $(document.getElementById("51")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "insurgent2"})
    );
  });
  $(document.getElementById("52")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "riot"})
    );
  });
  $(document.getElementById("80")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "fbi"})
    );
  });
  $(document.getElementById("90")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "burrito"})
    );
  });
  $(document.getElementById("100")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "vwcaddy"})
    );
  });
  $(document.getElementById("102")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "towtruck"})
    );
  });
  $(document.getElementById("104")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "prius"})
    );
  });
  $(document.getElementById("106")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "stockade"})
    );
  });
  $(document.getElementById("108")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "trash"})
    );
  });
  $(document.getElementById("110")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "pony2"})
    );
  });
  $(document.getElementById("112")).click(function(){
    $.post('http://vrp_garaje/close', JSON.stringify({}));
    $.post('http://vrp_garaje/spawnvehsdf', JSON.stringify({
     masina: "polmav"})
    );
  });
});