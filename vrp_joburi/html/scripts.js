var jobulica;

$(document).ready(function(){
  // Partial Functions
  function closeMain() {
    $(document.getElementById("job")).fadeOut();
  }
  function openMain() {
    $(document.getElementById("job")).fadeIn();
    $(document.getElementById("job")).css("display", "block");
  }
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Open & Close main bank window
    if(item.openNUI == true) {
      //jobulica = item.job;
      openMain();
    }
    if(item.openNUI == false) {
      closeMain();
    }
    jobulica = item.jobes
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 8 ) {
      $.post('http://vrp_joburi/close', JSON.stringify({}));
    }
    if (data.which == 27 ) {
      $.post('http://vrp_joburi/close', JSON.stringify({}));
    }
  };
  $(document.getElementById("angajeaza")).click(function(){
    closeMain();
    $.post('http://vrp_joburi/angajeaza', JSON.stringify({
     jobulica})
    );
    localStorage.clear();
  });
  $(document.getElementById("demisioneaza")).click(function(){
    closeMain();
    $.post('http://vrp_joburi/demisioneaza', JSON.stringify({
     jobulica})
    );
    localStorage.clear();
  });
});