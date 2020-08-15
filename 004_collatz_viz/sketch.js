let n;
let angle;
let segLen;

let cpos;
let npos;
let dir;
let collatzNums = [];

let strokecolor;
let clinc;
let csinc;


function setup() {
	createCanvas(480, 480);
	background(0);
	colorMode(HSL,1,1,1);
	strokeWeight(2);
	stroke(255);
	frameRate(60);

	n = 1;
	angle = PI/8;
	segLen = 8;
	strokecolor = {"h": 0, "s": 0.0, "l": 1, "a":0.8};
}
function draw() {
	translate(width/2,height/2);
	for(let i = 0; i<10; i++)
	drawC();
}
function drawC() {
	if(collatzNums.length == 0){
		console.log(strokecolor);
		cpos = createVector(0,0);
		npos;
		dir = createVector(1,1);
		collatzNums = collatz(n++);
		//background(0,0,0,0.01);
		strokecolor.l = 1.0;
		strokecolor.s = 0.0;

		clinc = (strokecolor.l-0.2) / collatzNums.length;
		csinc = (1-strokecolor.s) / collatzNums.length;
	}
	let num = collatzNums.shift();
	[cpos, npos, dir] = nextPos(cpos, dir, num % 2 == 0);

	//strokecolor.s = (num % 16) / 15;
	strokecolor.h += 1/99;
	if(strokecolor.h>1)strokecolor.h -= 1;
	strokecolor.l -= clinc;
	strokecolor.s += csinc;

	stroke(strokecolor.h, strokecolor.s, strokecolor.l, strokecolor.a);
	line(cpos.x, cpos.y, npos.x, npos.y);
	cpos = npos;
}


function nextPos(cpos, dir, even) {
	dir.rotate(even ? angle : -angle);
	dir.setMag(segLen);
	let npos = p5.Vector.add(cpos, dir);
	return [cpos,npos, dir];
}

function collatz(n) {
	let c = [];
	do {
		c.unshift(n);
		n = (n % 2 == 0) ?  n/2 : (3*n)+1;
	}while(n!=1);
	c.unshift(1);
	return c;
}
