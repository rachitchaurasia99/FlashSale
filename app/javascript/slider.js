function showSlide(jndex, index) {
  let deals = document.getElementsByClassName('image-slider')
  let slides = []
  for (i = 0; i < deals[jndex].childNodes.length; i++) {
    if (deals[jndex].childNodes[i].className == 'slider_image') {
      slides.push(deals[jndex].childNodes[i])
    }
  }
  let dots = document.getElementsByClassName('dot')
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = 'none';
    dots[i].className.replace(' active', '')
  }
  slides[index].style.display = "block";
  dots[index].className += " active";
}

function showAllSlides() {
  let deals = document.getElementsByClassName('image-slider')
  for (i = 0; i < deals.length; i++) {
    showSlide(i, 0)
  }
}

window.onLoad = showAllSlides()
