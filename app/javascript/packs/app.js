window.onload = function() {

  const navBtn = document.querySelector('.close-btn');
  const links = document.querySelectorAll('.link');
  const tileContainer = document.querySelector('.tile-container');
  const tiles = document.querySelectorAll('.tiles');

  let timings = [];

  for(let i = 0; i < links.length; i++){
    timings.push(i*200);
  }

  const toggleClass = () => {
    let plus = 0;

    if(tileContainer.className.includes('active')){
      tileContainer.classList.toggle('active');
      plus = 1;
    } else{
      setTimeout(() => {
        tileContainer.classList.toggle('active') ;
      }, timings[timings.length-1]);
    }

    links.forEach((link, i) => {
      setTimeout(() => {
        link.classList.toggle('active');
      }, timings[i+plus]);
    })

    navBtn.classList.toggle('active');
  }

  links.forEach((item, i) => {
    item.addEventListener('click', () => {
      toggleClass();
      tiles.forEach(ele => {
        ele.style.zIndex = null;
      })
      tiles[i].style.zIndex = 9;
    })
  })

  navBtn.addEventListener('click', () => {
    toggleClass();
  })

};