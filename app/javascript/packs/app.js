window.onload = function() {

  const closeBtn = document.querySelector('.close-btn');
  const navTiles = document.querySelectorAll('.nav-tile');
  const tileContainer = document.querySelector('.tile-container');
  const tiles = document.querySelectorAll('.tile');
  const primaryHeadings = document.querySelectorAll('.primary-heading');
  const projectBoxChildren = document.querySelector(".projects-content").children;
  const projectBoxChildrenArray = [].slice.call(projectBoxChildren);


  // Toggle 'active' class for tile container, nav tile, and close button
  let timings = [];

  for(let i = 0; i < navTiles.length; i++){
    timings.push(i*200);
  }

  const toggleClass = () => {
    let plus = 0;

    if(tileContainer.className.includes('active'))  {
      tileContainer.classList.toggle('active');
      plus = 1;
    } else{
      setTimeout(() => {
        tileContainer.classList.toggle('active') ;
      }, timings[timings.length-1]);
    }

    navTiles.forEach((navTile, i) => {
      setTimeout(() => {
        navTile.classList.toggle('active');
      }, timings[i+plus]);
    })

    closeBtn.classList.toggle('active');
  }


  // Add click event listener for each nav tile
  navTiles.forEach((item, i) => {

    item.addEventListener('click', () => {

      toggleClass();

      tiles.forEach(ele => {
        // Set z-index to null for all main tiles except the one which had its nav tile clicked
        ele.style.zIndex = null;

      })

      // When nav tile is clicked, add z-index of 9 to the corresponding main tile, add animated classes
      tiles[i].style.zIndex = 9;
      const tileHeading = (tiles[i]).querySelector("h1");
      tileHeading.classList.add('animated-fadeInDown');
      console.log(tiles[i])
      
      // If clicked tile is Projects tile, add animated class to project-box children
      if(tiles[i].className.includes("tile projects")) {
        projectBoxChildrenArray.forEach(child => {
          child.classList.add("animated-bounce");
        })
      } else {
        return;
      }
    
    })

  })


  // Close button event listener
  closeBtn.addEventListener('click', () => {
    
    toggleClass();
    
    // When Close button is clicked, remove animated classes from h1 and project-box elements
    primaryHeadings.forEach(primaryHeading => {
      if(primaryHeading.className.includes('animated-fadeInDown')) {
        primaryHeading.classList.remove('animated-fadeInDown');
      } else {
        return;
      }
    })

    projectBoxChildrenArray.forEach(child => {
      if(child.className.includes('animated-bounce')) {
        child.classList.remove('animated-bounce');
      } else {
        return;
      }
    })

  })
};