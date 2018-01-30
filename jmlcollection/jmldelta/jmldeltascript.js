var music = new Audio('jmldeltademo.mp3');
new THREE.ImageUtils.loadTexture('jmldeltacredits.png');
new THREE.ImageUtils.loadTexture('jmldeltafist.png');
new THREE.ImageUtils.loadTexture('jmldeltajml.png');
new THREE.ImageUtils.loadTexture('jmldeltanoise.png');
new THREE.ImageUtils.loadTexture('jmldeltadelta.png');

(function () {
  // INIT
  var defaultBackground = 0x1a0a00;
  var startTime;

  var overlay1 = document.getElementById('overlay1');
  var overlay2 = document.getElementById('overlay2');
  var overlay3 = document.getElementById('overlay3');
  var overlay4 = document.getElementById('overlay4');
  var demo = document.getElementById('demo');
  var start = document.getElementById('start');
  var startBtn = document.getElementById('startBtn');

  var scene = new THREE.Scene();

  var camera = new THREE.PerspectiveCamera(65, window.innerWidth / window.innerHeight, 1, 100000);
  camera.position.x = 0;
  camera.position.z = -3000;
  camera.position.y = -3000;
  camera.lookAt(new THREE.Vector3(400, 0, 0));

  var renderer = new THREE.WebGLRenderer({
    antialias: true
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setClearColor(defaultBackground);
  document.getElementById('demo').appendChild(renderer.domElement)

  window.addEventListener('resize', function () {
    renderer.setSize(window.innerWidth, window.innerHeight);
  });

  var mesh;
  var geometry;
  var material = new THREE.MeshLambertMaterial({ color: 0xFFFFFF });
  material.flatShading = true;

  var x, y, z, w, h, d;
  for (var i = 0; i < 3; i++) {
    w = (i == 0 ? 8004 : (i == 1 ? 250 : 300));
    h = (i == 1 ? 6040 : (i == 2 ? 250 : 300));
    d = (i == 2 ? 21400 : (i == 0 ? 150 : 200));
    for (var k = 0; k < 40; k++) {
      x = i == 0
        ? 4050 + Math.cos(k / 9) * Math.sin(k / 4) * Math.tan(k / 8) * 10000
        : 2100 + Math.sin(k / 8) * Math.tan(k / .3) * Math.cos(-k / 8) * 5000;
      y = i == 1
        ? 4200 + Math.cos(k / 8) * Math.tan(k / 40) * 10000
        : 1800 + Math.sin(k / 9) * Math.tan(k) * 2000;
      z = i == 2
        ? 4100 + Math.sin(k / 8) * 5000
        : 2200 + Math.cos(k / 9) * Math.tan(k / 30) * 2000;
      geometry = new THREE.BoxGeometry(w, h, d);
      mesh = new THREE.Mesh(geometry, material);
      mesh.position.x = x;
      mesh.position.y = y;
      mesh.position.z = z;
      scene.add(mesh);
    }
  }
  scene.fog = new THREE.Fog(defaultBackground, 1000, 10000);

  var light = new THREE.PointLight(0x665544, .3);
  light.position.set(0, 0, 0);
  scene.add(light);
  var light = new THREE.PointLight(0x552200, .3);
  light.position.set(10000, 1000, 0);
  scene.add(light);
  var light = new THREE.PointLight(0x334400, .3);
  light.position.set(-10000, -1000, 0);
  scene.add(light);
  var light = new THREE.PointLight(0x552200, .3);
  light.position.set(1000, 10000, 0);
  scene.add(light);
  var light = new THREE.PointLight(0x334400, .3);
  light.position.set(-1000, -10000, 0);
  scene.add(light);
  var light = new THREE.PointLight(0x220000, .3);
  light.position.set(1000, 0, -10000);
  scene.add(light);
  var light = new THREE.PointLight(0x002200, .3);
  light.position.set(-1000, 0, 10000);
  scene.add(light);

  // ANIMATEz
  var phase = 0;
  /// debug
  /*
      phase = 4
      camera.position.x = 350;
      camera.position.z = 800;
      camera.position.y = -1500;
      overlay4.style.opacity = 0;
      overlay5.style.opacity = 1;
  //*/

  function animate(s) {
    s = s - startTime;
    console.log(s);
    requestAnimationFrame(animate);
    if (s > 22000 && phase == 0) {
      // start phase 2
      phase++;
      camera.position.x = -200;
      camera.position.z = 100;
      camera.position.y = -1100;
      //overlay1.style.opacity = 0;
      overlay2.style.opacity = 1;
    }
    if (s > 44000 && phase == 1) {
      // start phase 3
      phase++;
      camera.position.x = 200;
      camera.position.z = -2000;
      camera.position.y = 100;
      overlay2.style.opacity = 0;
      overlay3.style.opacity = 1;
    }
    if (s > 66000 && phase == 2) {
      // start phase 4
      phase++;
      camera.position.x = 200;
      camera.position.z = 2000;
      camera.position.y = 300;
      overlay3.style.opacity = 0;
      overlay4.style.opacity = 1;
    }
    if (s > 88000 && phase == 3) {
      // start phase 5
      phase++;
      camera.position.x = 350;
      camera.position.z = 800;
      camera.position.y = -1500;
      overlay4.style.opacity = 0;
      overlay5.style.opacity = 1;
    }
    if (s > 110000 && phase == 4) {
      phase++;
      scene = new THREE.Scene();
    }

    switch (phase) {
      case 0:
        camera.position.x += .4;
        camera.position.z += .5;
        break;
      case 1:
        camera.position.x -= .4;
        camera.position.y -= .4;
        break;
      case 2:
        camera.position.z += .4;
        camera.position.y += .4;
      case 3:
        camera.position.z -= .5;
        camera.position.y += .5;
      case 4:
        camera.position.x += .15;
        camera.position.z += .15;
        camera.position.y -= .15;
        break;
    }
    renderer.render(scene, camera);
  }

  startBtn.addEventListener('click', function () {
    if (demo.requestFullscreen) {
      demo.requestFullscreen();
    } else if (demo.msRequestFullscreen) {
      demo.msRequestFullscreen();
    } else if (demo.mozRequestFullScreen) {
      demo.mozRequestFullScreen();
    } else if (demo.webkitRequestFullscreen) {
      demo.webkitRequestFullscreen();
    }

    startTime = performance.now();
    startBtn.remove();
    overlay1.style.opacity = .7;
    start.style.opacity = 0;
    animate(startTime);
    music.play();
  })
})();
