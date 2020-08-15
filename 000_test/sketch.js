function setup() {
	createCanvas(480, 480);
	frameRate(30);
	colorMode(HSB,1,1,1);
	background(0);
	for(var i=0; i<5; i++) {
		lines.push(
			{
				cx: width/2,
				cy: height/2,
				w: (i+1)*width/7,
				h: (i+1)*height/7,
				speedFast: 20+i*10,
				speedSlow: 60+i*20,
				md: 0.3 - i/100,
				sp: 0,
				ep: i/10,
				sfe: false,
				color: {h:i/5, s:0.9, l:1},
				hspeed: i/240
			}
		);

	}
}

var lines = [];

function draw() {
	background(0,0,0,0.1);
	noFill()
	strokeWeight(2);
	//framePos = (frameCount % 60)/60;
  for(var i=0; i<lines.length; i++) {
		lines[i] = updateLine(lines[i]);
		stroke(lines[i].color.h,lines[i].color.s,lines[i].color.l);
		arc(lines[i].cx,lines[i].cy, lines[i].w, lines[i].h, lines[i].sp, lines[i].ep);
	}

}

function updateLine(l) {
	if(l.ep - l.sp < l.md) l.sfe = false;
	if(l.ep - l.sp > 2*PI-l.md) l.sfe = true;
	if(l.sfe) {
		l.sp += (2*PI)/l.speedFast;
		l.ep += (2*PI)/l.speedSlow;
	} else {
		l.ep += (2*PI)/l.speedFast;
		l.sp += (2*PI)/l.speedSlow;
	}
	l.color.h = (l.color.h + l.hspeed) % 1;
	return l;
}
