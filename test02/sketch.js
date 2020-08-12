let com;
let avgvel;

let particles = [];


function setup() {
	createCanvas(windowWidth, windowHeight);
	frameRate(60);
	colorMode(HSB, 1, 1, 1);
	//console.log(com);

	com = createVector(height/2,width/2);
	avgvel = createVector(10, 10);

	for(var i = 0; i<100; i++) {
		particles.push(
			{
					pos: createVector(random(0,width), random(0, height)),
					vel: createVector(random(-1, 1), random(-1, 1)),
					color: {h: i/20, s: random(0,1), b:random(0,1)},
					mass: 1,
					vmax: 3,
					dvmax: 0.05,
					minsep: 25,
					maxalign: 200,
					maxcohesion: 200,
					dstfalloff: 2,
					weights: {sep: 1.5, align: 10, cohesion: 10}
			}
		);
	}
}


function draw() {
	background(0);
	strokeWeight(8);

		particles.forEach((p, i) => {

			let acc = createVector(0, 0);

			//seperate
			let sepdir = createVector(0, 0);
			let sepcount = 0;

			let aligndir = createVector(0, 0);
			let aligncount = 0;

			let cohesiondir = createVector(0, 0);
			let cohesioncount = 0;
			particles.forEach((foo, i) => {
				//seperate
				let dist = p5.Vector.dist(p.pos, foo.pos);
				if(dist < p.minsep) {
					sepcount++;
					let delta  = p5.Vector.sub(p.pos, foo.pos);
					delta.normalize();
					delta.div(pow(dist, p.dstfalloff));
					sepdir.add(delta);
				}

				//align
				if(dist < p.maxalign) {
					aligndir.add(foo.vel);
					aligncount++;
				}

				//cohesion
				if(dist < p.maxcohesion) {
					cohesiondir.add(foo.pos);
					cohesioncount++;
				}
			});
			if(sepcount) {
				sepdir.div(sepcount);
				sepdir.normalize();
				sepdir.mult(p.vmax);
				sepdir.sub(p.vel);
				sepdir.limit(p.dvmax);
				sepdir.mult(p.weights.sep);

				//if(!i) console.log("SEP: ", sepdir.mag());
				acc.add(sepdir);
			}


			//align
			if(aligncount) {
				aligndir.normalize();
				aligndir.mult(p.vmax);
				aligndir.sub(p.vel);
				aligndir.limit(p.dvmax);
				aligndir.mult(p.weights.align);

				//if(!i) console.log("ALIGN: ", aligndir.mag());
				acc.add(aligndir);
			}


			//cohesion
			if(cohesioncount) {
				cohesiondir.div(cohesioncount);
				let delta = p5.Vector.sub(p.pos, cohesiondir);
				delta.normalize();
				delta.mult(p.vmax);
				let cohesionvel = p5.Vector.sub(delta, p.vel);
				cohesionvel.limit(p.dvmax);
				cohesionvel.mult(p.weights.cohesion);
				//if(!i) console.log("COHESION: ", cohesionvel.mag());
				acc.add(cohesionvel);
			}

			p.vel.add(acc);
			p.vel.limit(p.vmax);
			p.pos.add(p.vel);

			if(p.pos.x > width) p.pos.x -= width;
			if(p.pos.x < 0) p.pos.x += width;

			if(p.pos.y > height) p.pos.y -= height;
			if(p.pos.y < 0) p.pos.y += height;

			stroke(p.color.h, p.color.s, p.color.b);
			point(p.pos.x, p.pos.y);
		});
}
