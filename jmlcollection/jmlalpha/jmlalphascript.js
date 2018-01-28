var music = new Audio('jmlalphademo.mp3');

(function () {
  var properties = {
    defaultBackground: "#FFDFB2",
    lightColor1: "#FF0072",
    lightColor2: "#FF8A7B",
    lightColor3: "#FF8A7B",
    lightColor4: "#FF8A7B",
    lightColor5: "#FF8A7B",
    lightColor6: "#FF8A7B",
    lightColor7: "#FF8A7B",
    lightIntensity1: 0.4,
    lightIntensity2: 0.5,
    lightIntensity3: 0.45,
    lightIntensity4: 0.4,
    lightIntensity5: 0.6000000000000001,
    lightIntensity6: 0.55,
    lightIntensity7: 0.55,
    cameraX: -1370,
    cameraY: 360,
    cameraZ: -500,
    cameraLookX: 2100,
    cameraLookY: 580,
    cameraLookZ: 800,
    overlayBlur: 0
  };
  var part1 = {
    "cameraX": -1370,
    "cameraY": 360,
    "cameraZ": -500,
    "cameraLookX": 2100,
    "cameraLookY": 580,
    "cameraLookZ": 800
  };
  var part2 = {
    "cameraX": -70,
    "cameraY": 360,
    "cameraZ": 2970,
    "cameraLookX": 5350,
    "cameraLookY": 4480,
    "cameraLookZ": -8960
  };
  var part3 = {
    "cameraX": 1010,
    "cameraY": 360,
    "cameraZ": 2100,
    "cameraLookX": -2020,
    "cameraLookY": 580,
    "cameraLookZ": -10000
  };
  var part4 = {
    "cameraX": 1660,
    "cameraY": 2950,
    "cameraZ": 6430,
    "cameraLookX": 0,
    "cameraLookY": 0,
    "cameraLookZ": 0
  };
  var part5 = {
    "cameraX": 3620,
    "cameraY": 1450,
    "cameraZ": -720,
    "cameraLookX": 0,
    "cameraLookY": 0,
    "cameraLookZ": 0
  };
  var part6 = {
    "cameraX": -1370,
    "cameraY": 360,
    "cameraZ": 1250,
    "cameraLookX": 150,
    "cameraLookY": -290,
    "cameraLookZ": 360
  };
  var part7 = {
    "cameraX": 580,
    "cameraY": 580,
    "cameraZ": 2310,
    "cameraLookX": 6650,
    "cameraLookY": 5350,
    "cameraLookZ": -1370
  };
  var part8 = {
    "cameraX": 580,
    "cameraY": 1230,
    "cameraZ": 2310,
    "cameraLookX": 2750,
    "cameraLookY": 10000,
    "cameraLookZ": -4190
  };
  var part9 = {
    "cameraX": 360,
    "cameraY": 150,
    "cameraZ": 1880,
    "cameraLookX": -290,
    "cameraLookY": 800,
    "cameraLookZ": -10000
  };

  // var gui = new dat.GUI({ load: JSON });
  // gui.addColor(properties, 'defaultBackground');
  // gui.addColor(properties, 'lightColor1');
  // gui.addColor(properties, 'lightColor2');
  // gui.addColor(properties, 'lightColor3');
  // gui.addColor(properties, 'lightColor4');
  // gui.addColor(properties, 'lightColor5');
  // gui.addColor(properties, 'lightColor6');
  // gui.addColor(properties, 'lightColor7');
  // gui.add(properties, 'lightIntensity1', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity2', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity3', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity4', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity5', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity6', 0, 1).step(0.05);
  // gui.add(properties, 'lightIntensity7', 0, 1).step(0.05);
  // gui.add(properties, 'cameraX', -10000, 10000).step(10);
  // gui.add(properties, 'cameraY', -10000, 10000).step(10);
  // gui.add(properties, 'cameraZ', -10000, 10000).step(10);
  // gui.add(properties, 'cameraLookX', -10000, 10000).step(10);
  // gui.add(properties, 'cameraLookY', -10000, 10000).step(10);
  // gui.add(properties, 'cameraLookZ', -10000, 10000).step(10);
  // gui.remember(properties);

  var startTime;

  var overlay1 = document.getElementById('overlay1');
  var overlay2 = document.getElementById('overlay2');
  var overlay3 = document.getElementById('overlay3');
  var overlay4 = document.getElementById('overlay4');
  var overlay5 = document.getElementById('overlay5');
  var overlay6 = document.getElementById('overlay6');
  var overlay7 = document.getElementById('overlay7');
  var overlay8 = document.getElementById('overlay8');
  var overlay9 = document.getElementById('overlay9');
  var overlay10 = document.getElementById('overlay10');
  var container = document.getElementById('container');
  var demo = document.getElementById('demo');
  var start = document.getElementById('start');
  var startBtn = document.getElementById('startBtn');

  var scene = new THREE.Scene();

  var camera = new THREE.PerspectiveCamera(65, window.innerWidth / window.innerHeight, 1, 100000);

  var renderer = new THREE.WebGLRenderer({
    antialias: true
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setClearColor(new THREE.Color(properties.defaultBackground));
  document.getElementById('demo').appendChild(renderer.domElement)

  window.addEventListener('resize', function () {
    renderer.setSize(window.innerWidth, window.innerHeight);
  });

  var mesh;
  var geometry;
  var material = new THREE.MeshLambertMaterial({ color: 0xFFFFFF });
  material.emissive = new THREE.Color('rgb(198,229,217)');
  material.emissiveIntensity = 0.1;
  //material.flatShading = true;

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
  scene.fog = new THREE.Fog(new THREE.Color(properties.defaultBackground), 1000, 10000);

  var light1 = new THREE.PointLight(new THREE.Color(properties.lightColor1), properties.lightIntensity1);
  light1.position.set(0, 0, 0);
  scene.add(light1);
  var light2 = new THREE.PointLight(new THREE.Color(properties.lightColor2), properties.lightIntensity2);
  light2.position.set(10000, 1000, 0);
  scene.add(light2);
  var light3 = new THREE.PointLight(new THREE.Color(properties.lightColor3), properties.lightIntensity3);
  light3.position.set(-10000, -1000, 0);
  scene.add(light3);
  var light4 = new THREE.PointLight(new THREE.Color(properties.lightColor4), properties.lightIntensity4);
  light4.position.set(1000, 10000, 0);
  scene.add(light4);
  var light5 = new THREE.PointLight(new THREE.Color(properties.lightColor5), properties.lightIntensity5);
  light5.position.set(-1000, -10000, 0);
  scene.add(light5);
  var light6 = new THREE.PointLight(new THREE.Color(properties.lightColor6), properties.lightIntensity6);
  light6.position.set(1000, 0, -10000);
  scene.add(light6);
  var light7 = new THREE.PointLight(new THREE.Color(properties.lightColor7), properties.lightIntensity7);
  light7.position.set(-1000, 0, 10000);
  scene.add(light7);

  overlay1.style.opacity = 1;

  // ANIMATEz
  var phase = 0;
  var len = 11296;

  function animate(s) {
    s = s - startTime;
    console.log(phase, s);
    requestAnimationFrame(animate);

    if (s > len && phase == 0) {
      // start phase 2
      phase++;
      properties = Object.assign(properties, part2);
      overlay1.style.opacity = 0;
      overlay2.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 1) {
      // start phase 3
      phase++;
      properties = Object.assign(properties, part3);
      overlay2.style.opacity = 0;
      overlay3.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 2) {
      // start phase 4
      phase++;
      properties = Object.assign(properties, part4);
      overlay3.style.opacity = 0;
      overlay4.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 3) {
      // start phase 5
      phase++;
      properties = Object.assign(properties, part5);
      overlay4.style.opacity = 0;
      overlay5.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 4) {
      phase++;
      properties = Object.assign(properties, part6);
      overlay5.style.opacity = 0;
      overlay6.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 5) {
      phase++;
      properties = Object.assign(properties, part7);
      overlay6.style.opacity = 0;
      overlay7.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 6) {
      phase++;
      properties = Object.assign(properties, part8);
      overlay7.style.opacity = 0;
      overlay8.style.opacity = 1;
    }
    if (s > len * (phase + 1) && phase == 7) {
      phase++;
      properties = Object.assign(properties, part9);
      overlay8.style.opacity = 0;
      overlay9.style.opacity = 1;
      setTimeout(function () {
        demo.style.opacity = 0;
      }, len / 2);
    }
    if (s > len * (phase + 1) && phase == 8) {
      phase++;
      overlay9.style.opacity = 0;
      overlay10.style.opacity = 1;
    }

    switch (phase) {
      case 0:
        console.log('update cam');
        properties.cameraY += 0.5;
        break;
      case 1:
        properties.cameraLookX += 1;
        properties.cameraLookZ += 1;
        break;
      case 2:
        properties.cameraZ -= .5;
        break;
      case 3:
        properties.cameraY -= .5;
        break;
      case 4:
        properties.cameraZ -= .5;
        break;
      case 5:
        properties.cameraLookX += .25;
        properties.cameraLookZ += .25;
        break;
      case 6:
        properties.cameraY += .25;
        break;
      case 7:
        properties.cameraLookZ += .5;
        break;
      case 8:
        properties.cameraZ -= .5;
        break;
    }

    light1.color = new THREE.Color(properties.lightColor1);
    light3.color = new THREE.Color(properties.lightColor2);
    light3.color = new THREE.Color(properties.lightColor3);
    light4.color = new THREE.Color(properties.lightColor4);
    light5.color = new THREE.Color(properties.lightColor5);
    light6.color = new THREE.Color(properties.lightColor6);
    light7.color = new THREE.Color(properties.lightColor7);
    light1.intensity = properties.lightIntensity1 * (1 + Math.abs(Math.sin(s / 100) / 40));
    light2.intensity = properties.lightIntensity2 * (1 + Math.abs(Math.cos(s / 100) / 40));
    light3.intensity = properties.lightIntensity3 * (1 + Math.abs(Math.sin(s / 100) / 40));
    light4.intensity = properties.lightIntensity4 * (1 + Math.abs(Math.cos(s / 100) / 40));
    light5.intensity = properties.lightIntensity5 * (1 + Math.abs(Math.sin(s / 100) / 40));
    light6.intensity = properties.lightIntensity6 * (1 + Math.abs(Math.cos(s / 100) / 40));
    light7.intensity = properties.lightIntensity7 * (1 + Math.abs(Math.sin(s / 100) / 40));

    camera.position.y = properties.cameraY;
    camera.position.z = properties.cameraZ;
    camera.position.y = properties.cameraY;
    camera.lookAt(new THREE.Vector3(properties.cameraLookX, properties.cameraLookY, properties.cameraLookZ));

    renderer.setClearColor(new THREE.Color(properties.defaultBackground));
    scene.fog.color = new THREE.Color(properties.defaultBackground);

    properties.overlayBlur += (0.5 - Math.random()) / 2;
    if (properties.overlayBlur < 0) properties.overlayBlur = 0;
    if (properties.overlayBlur > 7) properties.overlayBlur = 7;
    // overlay1.style.border = '50px solid red';
    console.log(properties.overlayBlur);
    overlay1.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay2.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay3.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay4.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay5.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay6.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay7.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay8.style.filter = 'blur(' + properties.overlayBlur + 'px)';
    overlay9.style.filter = 'blur(' + properties.overlayBlur + 'px)';

    renderer.render(scene, camera);
  }

  startBtn.addEventListener('click', function () {
    if (container.requestFullscreen) {
      container.requestFullscreen();
    } else if (container.msRequestFullscreen) {
      container.msRequestFullscreen();
    } else if (container.mozRequestFullScreen) {
      container.mozRequestFullScreen();
    } else if (container.webkitRequestFullscreen) {
      container.webkitRequestFullscreen();
    }

    startTime = performance.now();
    startBtn.remove();
    start.style.opacity = 0;
    demo.style.opacity = 1;
    animate(startTime);
    music.play();
  })
  //})
})();
