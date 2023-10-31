extends Node2D
#Adapted from https://github.com/TanaTanoi/l_systems_ruby
var posstack = []
var dirstack = []
var startx = 0
var starty = 0
var curx = 0
var cury = 0 
var direction = 0
var rules = {
   "tree":{
	  "axiom":"0",
	  "angle":45,
	  "rules":{
		 "1":"11",
		 "0":"1[0]0"
	  }
   },
   "triangle":{
	  "axiom":"a",
	  "angle":60,
	  "rules":{
		 "a":"=b-a-b=",
		 "b":"-a=b=a-"
	  }
   },
   "dragon":{
	  "axiom":"fx",
	  "angle":90,
	  "rules":{
		 "x":"x=yf=",
		 "y":"-fx-y"
	  }
   },
   "plant":{
	  "axiom":"x",
	  "angle":-25,
	  "rules":{
		 "x":"f−[[x]=x]=f[=fx]−x",
		 "f":"ff"
	  }
   },
   "koch":{
	  "axiom":"f",
	  "angle":90,
	  "rules":{
		 "f":"f=f-f-f=f"
	  }
   }
}
#for other l-systems change tree below to any of the above rules
var cursys = rules.tree
var curstr = cursys.axiom
var angle = 0 
var length = 10 

func _draw():
	for i in 5:
		stepcurstr()
		drawsystem()

func popstaterotate(angle):
	var position = posstack.pop_back()
	curx = position.x
	cury = position.y
	direction = dirstack.pop_back()
	if direction == null:
		direction = 0
	direction += angle

func stepcurstr():
	var r = cursys.rules 
	var cs = ""
	for i in curstr:
		if r.has(i):
			cs += r[i]
		else:
			cs += i
	curstr = cs 
func pushstaterotate(angle):
	posstack.append({x = curx, y = cury})
	direction += angle
	
func drawsystem():
	curx = startx
	cury = starty
	direction = 0 
	angle = cursys.angle 
	for i in curstr:
		doaction(i,angle)

func doaction(char,angle):
	match char:
		"1","0","a","b","f": 
			#change 500,500 to set x and y position of the representation
			drawline(curx, cury, direction, length, 500,500)
		"[":
			pushstaterotate(angle)
		"]":
			popstaterotate(angle)
		"=":
			direction += angle 
		"-":
			direction -= angle

func drawline(startx,starty,dir,len,posx=0,posy=0):
	var theta = dir*(PI/180.0)
	var endx  = sin(theta)*len+startx
	var endy = cos(theta)*-len+starty
	curx = endx
	cury = endy
	#print(str(startx)+"  "+str(starty))
	#print(str(endx)+"  "+str(endy))
	draw_line(Vector2(posx+startx,posy+starty),Vector2(posx+endx,posy+endy),Color(255, 0, 0), 1)
func _process(delta):
	pass

