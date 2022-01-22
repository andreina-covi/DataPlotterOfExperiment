Class {
	#name : #DPPlotter,
	#superclass : #Object,
	#instVars : [
		'colors',
		'scales'
	],
	#category : #'DataPlotter-Core'
}

{ #category : #running }
DPPlotter >> addPlotOf: assoc on: canvas [

	| chart points vertical "horizontal" group |
	assoc value ifEmpty: [ ^ self ].
	chart := RSChart new.
	chart extent: 300 @ 25.
	group := RSGroup new.
	chart
		container: group;
		colors: (NSScale ordinal range: { (self colors at: assoc key) });
		minValueY: 0.
	points := assoc value.
	chart lineX: (points collect: #x) y: (points collect: #y).
	chart decorations removeAll.
	chart addDecoration:
		(vertical := RSVerticalTick new numberOfTicks: 3).
	"vertical configuration tickSize: chart extent x negated."
	"chart addDecoration: (horizontal := RSHorizontalTick new).
	horizontal configuration tickSize: chart extent y negated."
	chart addDecoration: (RSYLabelDecoration new
			 title: assoc key;
			 rotationAngle: 90;
			 offset: -25 @ 0).
	chart build.
	canvas add: group asShape
]

{ #category : #'as yet unclassified' }
DPPlotter >> colorDictionary [

	^ Dictionary new
		  at: 'A'
		  put: (Color r: 1.0 g: 0.6275659824046921 b: 0.823069403714565);
		  at: 'B' put: (Color
				   r: 0.0039100684261974585
				   g: 0.270772238514174
				   b: 0.3098729227761486);
		  at: 'C'
		  put: (Color r: 0.5767350928641252 g: 0.0 b: 0.4662756598240469);
		  at: 'D'
		  put: (Color r: 0.9687194525904204 g: 1.0 b: 0.33724340175953077);
		  at: 'E'
		  put: (Color r: 0.0 g: 0.5063538611925709 b: 0.541544477028348);
		  at: 'RO' put: (Color
				   r: 0.12121212121212122
				   g: 0.4662756598240469
				   b: 0.7057673509286413);
		  at: 'TO'
		  put: (Color r: 1.0 g: 0.4975562072336266 b: 0.05474095796676442);
		  at: 'TR' put: (Color
				   r: 0.5493646138807429
				   g: 0.33724340175953077
				   b: 0.29423264907135877);
		  at: 'RA' put: (Color
				   r: 0.08993157380254155
				   g: 0.7448680351906158
				   b: 0.8113391984359726);
		  at: 'RK' put: (Color
				   r: 0.6197458455522972
				   g: 0.855327468230694
				   b: 0.8983382209188661);
		  at: 'F' put: (Color
				   r: 0.3919843597262952
				   g: 0.7683284457478006
				   b: 0.9296187683284457);
		  at: 'e'
		  put: (Color r: 0.95 g: 0.21994134897360704 b: 0.20039100684261973);
		  at: 's'
		  put: (Color r: 0.0 g: 1.0 b: 0.6695992179863147);
		  at: 'v' put: (Color
				   r: 0.33724340175953077
				   g: 0.02737047898338221
				   b: 0.3919843597262952);
		  at: 'w' put: (Color
				   r: 0.28641251221896386
				   g: 0.2981427174975562
				   b: 0.635386119257087);
		  at: 'x' put: (Color
				   r: 0.7761485826001955
				   g: 0.7956989247311828
				   b: 0.9374389051808406);
		  at: 'y' put: (Color r: 1.0 g: 0.85 b: 1.0);
		  at: 'z'
		  put: (Color r: 1.0 g: 0.8113391984359726 b: 0.823069403714565);
		  yourself
]

{ #category : #accessing }
DPPlotter >> colors [

	colors ifNil: [ colors := self colorDictionary ].
	^ colors
]

{ #category : #running }
DPPlotter >> fill: dict1 with: dict2 [

	dict1 associations
		reject: [ :assoc | assoc key = 'components' ]
		thenDo: [ :assoc | 
			| points size |
			points := assoc value.
			size := points size.
			dict2
				at: assoc key
				ifPresent: [ :n | points add: size @ n ]
				ifAbsent: [ 
					self assert: points isNotEmpty.
					points add: size @ points last y ] ]
]

{ #category : #running }
DPPlotter >> getComponentChart: collection on: chart [

	($v to: $z) reverse , #( $e ) doWithIndex: [ :s :i |
		| data prevSize |
		prevSize := 2.
		data := OrderedCollection new.
		collection do: [ :arr | 
			| index |
			index := arr indexOf: s asString.
			index > 0 ifTrue: [ data add: prevSize + (arr indexOf: s asString) ].
			prevSize := prevSize + arr size + 2 ].
		s = $e ifFalse: [ 
			data do: [ :n | 
				chart addPlot: (RSLinePlot new
						 color: (self colors at: s asString);
						 width: 3;
						 x: { 
								 n.
								 (n + 1) }
						 y: ((Array new: 2) atAllPut: i * 2)) ] ] ]
]

{ #category : #running }
DPPlotter >> getComponentChart: collection on: chart given: dictionary [

	| col |
	col := OrderedCollection new.
	($v to: $z) reverse , #( $e ) doWithIndex: [ :s :i | 
		| data prevSize |
		prevSize := 2.
		data := OrderedCollection new.
		collection do: [ :arr | 
			| index |
			index := arr indexOf: s asString.
			index > 0 ifTrue: [ data add: prevSize + (arr indexOf: s asString) ].
			prevSize := prevSize + arr size + 2 ].
		s = $e ifFalse: [ 
			data ifNotEmpty: [ col add: s ].
			data do: [ :n | 
				chart addPlot: (RSLinePlot new
						 color: (self colors at: s asString);
						 width: 3;
						 x: { 
								 n.
								 (n + 1) }
						 y: ((Array new: 2) atAllPut: i * 2)) ] ] ].
	(dictionary at: 'y') addAll: col reverse
]

{ #category : #running }
DPPlotter >> getTimelineDataOf: collection [

	| prev data |
	data := OrderedDictionary new
		        at: 'TO' put: OrderedCollection new;
		        at: 'RK' put: OrderedCollection new;
		        at: 'RA' put: OrderedCollection new;
		        at: 'TR' put: OrderedCollection new;
		        at: 'RO' put: OrderedCollection new;
		        yourself.
	collection doWithIndex: [ :t :index | 
		| aux |
		aux := t ifNil: [ prev ] ifNotNil: [ t ].
		prev = aux ifFalse: [ 
			prev ifNil: [ (data at: aux) add: 0 ] ifNotNil: [ 
				(data at: prev) add: index.
				(data at: aux) add: index ] ].
		prev := aux ].
	(data at: prev) add: collection size.
	^ data
]

{ #category : #running }
DPPlotter >> graph: collection on: canvas [

	| graphNumericData textData componentsData |
	graphNumericData := OrderedDictionary newFrom:
		                    (($A to: $E) collect: [ :s | 
			                     s asString -> OrderedCollection new ]).
	textData := OrderedCollection new.
	componentsData := OrderedCollection new.
	"graphicData at: 'components' put: OrderedCollection new."
	collection select: #notEmpty thenDo: [ :dict | 
		| d |
		d := (dict at: 'changes') asDictionary.
		self fill: graphNumericData with: d.
		textData add: (d at: 'F' ifAbsent: [ nil ]).
		componentsData add: (dict at: 'components') ].
	self graphNumericData: graphNumericData on: canvas.
	self graphText: (self getTimelineDataOf: textData) on: canvas given: (collection select: #notEmpty) size.
	self
		graphComponents: componentsData
		on: canvas
]

{ #category : #running }
DPPlotter >> graphBarExecution: data on: chart [

	| x prev bar colorBars |
	prev := 2.
	x := OrderedCollection new
		     add: 2;
		     yourself.
	colorBars := OrderedCollection new add: (self colors at: 's'); yourself.
	x addAll: (data collect: [ :c | 
			 | n |
			 n := prev + c size + 2.
			 prev := n.
			 colorBars add: (c first = 'e'
					  ifTrue: [ self colors at: 'e' ]
					  ifFalse: [ self colors at: 's' ]).
			 n ]).
	bar := DPBarPlot new
		       x: x y: ((Array new: x size) atAllPut: 0.5);
		       barSize: 1;
		       colors: colorBars.
	chart addPlot: bar
]

{ #category : #running }
DPPlotter >> graphBarExecution: data on: chart given: dictionary [

	| x prev bar colorBars |
	prev := 2.
	x := OrderedCollection new
		     add: 2;
		     yourself.
	colorBars := OrderedCollection new
		             add: (self colors at: 's');
		             yourself.
	x addAll: (data collect: [ :c | 
			 | n |
			 n := prev + c size + 2.
			 prev := n.
			 colorBars add: (c first = 'e'
					  ifTrue: [ self colors at: 'e' ]
					  ifFalse: [ self colors at: 's' ]).
			 n ]).
	bar := DPBarPlot new
		       x: x y: ((Array new: x size) atAllPut: 0.5);
		       barSize: 1;
		       colors: colorBars.
	chart addPlot: bar.
	(dictionary at: 'y') add: 'Execution'.
		dictionary at: 'x' put: x
]

{ #category : #running }
DPPlotter >> graphComponents: componentsData on: canvas [

	| data group compo |
	data := componentsData collect: [ :col | 
		        col collect: [ :s | s -> 1 ] ].
	group := (data collect: [ :col | 
		          | pie cont |
		          cont := RSGroup new.
		          pie := RSPie new
			                 objects: col;
			                 slice: #value;
			                 sliceColor: [ :slice | self colors at: slice model key ];
			                 container: cont.
		          pie sliceShape
			          externalRadius: 12;
			          innerRadius: 9;
			          segmentSpacing: 0.5.
		         " pie sliceColor: NSScale category20."
		          pie build.
		          cont asShape ]) asGroup.
	RSHorizontalLineLayout new on: group.
	"gapSize: 15;"
	compo := RSComposite new.
	compo shapes: group.
	"compo extent: 300 @ 20."
	compo adjustToChildren.
	canvas add: compo
]

{ #category : #running }
DPPlotter >> graphHyperparametersTuning: data on: chart [

	| sizes allXs prevNum changes |
	sizes := data collect: [ :d | (d at: 'components') size ].
	prevNum := 1.
	allXs := (#( 1 ) , (sizes collect: [ :s | 
		           | n |
		           n := prevNum + s + 2.
		           prevNum := n.
		           n ])) allButLast.
	changes := data collect: [ :d | (d at: 'changes') asDictionary ].
	($A to: $F) doWithIndex: [ :c :index | 
		| x s plot shapes |
		x := OrderedCollection new.
		s := OrderedCollection new.
		allXs with: changes do: [ :i :dict | 
			dict at: c asString ifPresent: [ :n | 
				x add: i.
				s add: n ] ].
		shapes := self shapesFor: c asString given: s.
		plot := DPPersonalizedPlot new
			        x: x y: ((Array new: x size) atAllPut: index * -2);
			        personalizedShapes: shapes.
		chart addPlot: plot ]
]

{ #category : #running }
DPPlotter >> graphHyperparametersTuning: data on: chart given: dictionary [

	| sizes allXs prevNum changes |
	sizes := data collect: [ :d | (d at: 'components') size ].
	prevNum := 1.
	allXs := (#( 1 ) , (sizes collect: [ :s | 
		           | n |
		           n := prevNum + s + 2.
		           prevNum := n.
		           n ])) allButLast.
	changes := data collect: [ :d | (d at: 'changes') asDictionary ].
	($A to: $F) doWithIndex: [ :c :index | 
		| x s plot shapes |
		x := OrderedCollection new.
		s := OrderedCollection new.
		allXs with: changes do: [ :i :dict | 
			dict at: c asString ifPresent: [ :n | 
				x add: i.
				s add: n ] ].
		shapes := self shapesFor: c asString given: s.
		plot := DPPersonalizedPlot new
			        x: x y: ((Array new: x size) atAllPut: index * -2);
			        personalizedShapes: shapes.
		chart addPlot: plot.
		(dictionary at: 'y') add: c ]
]

{ #category : #running }
DPPlotter >> graphNumericData: dictionary on: canvas [

	dictionary associationsDo: [ :assoc | 
		self addPlotOf: assoc on: canvas ]
]

{ #category : #running }
DPPlotter >> graphText: dictionary on: canvas given: size [

	| plt group x |
	plt := RSChart new extent: 300 @ 20.
	group := RSGroup new.
	plt container: group.
	x := 0 to: dictionary size.
	dictionary associations
		select: [ :assoc | assoc value notEmpty ]
		thenDo: [ :assoc | 
			plt addPlot: (RSLinePlot new
					 color: (self colors at: assoc key);
					 width: 6;
					 x: assoc value y: ((Array new: assoc value size) atAllPut: 1)) ].
	plt decorations removeAll.
	plt addDecoration: (RSYLabelDecoration new
			 title: 'F';
			 rotationAngle: 90;
			 offset: -25 @ 0).
	plt addDecoration: (RSHorizontalTick new
			 numberOfTicks: size;
			 integer). ";
			 fromNames: (1 to: size)"
	plt build.
	"plt plots doWithIndex: [ :p :index | 
		p line @ (RSLabeled new
			 text: [ 'RO' ];
			 fontSize: 3;
			 lowColor: Color black;
			 highlightable;
			 locationDo: [ :loc | loc middle ]) ]."
	canvas add: group asShape
]

{ #category : #running }
DPPlotter >> graphVisualization: collection on: canvas [

	| data chart group col dictionary |
	data := collection select: #notEmpty.
	col := data collect: [ :dict | dict at: 'components' ].
	chart := RSChart new.
	group := RSGroup new.
	chart container: group.
	chart extent: 400 @ 100.
	dictionary := Dictionary new
		              at: 'x' put: OrderedCollection new;
		              at: 'y' put: OrderedCollection new;
		              yourself.
	self getComponentChart: col on: chart given: dictionary.
	self graphBarExecution: col on: chart given: dictionary.
	self graphHyperparametersTuning: data on: chart given: dictionary.
	chart decorations removeAll.
	chart
		addDecoration: (DPVerticalTick new fromNames: (dictionary at: 'y') reverse);
		addDecoration: (DPHorizontalTick new
				 ticksData: (dictionary at: 'x');
				 fromNames:
					 ((1 to: (dictionary at: 'x') size) collect: [ :n | n asString ])). "fromNames: #( v w x y z e A B C D E F )"
	"labelRotation: 0"
	"numberOfTicks: 12;" ", #( 'Execution' )"
	chart build.
	canvas add: group asShape adjustToChildren
]

{ #category : #running }
DPPlotter >> run: data [

	| canvas |
	canvas := RSCanvas new.
	"data do: [ :col | self graph: col on: canvas ]."
	self graphVisualization: data on: canvas.
	RSVerticalLineLayout on: canvas shapes.
	canvas @ RSCanvasController.
	^ canvas
]

{ #category : #accessing }
DPPlotter >> scales [

	scales ifNil: [ 
		scales := Dictionary new
			          at: 'A' put: (NSScale linear
					           domain: #( 1 100 );
					           range: #( 1 5 ));
			          at: 'B' put: (NSScale linear
				           domain: #( 1 100 );
				           range: #( 1 5 ));
			          at: 'C' put: (NSScale linear
				           domain: #( 1 100 );
				           range: #( 1 5 ));
			          at: 'D' put: (NSScale linear
				           domain: #( 0.01 1 );
				           range: #( 1 5 ));
			          at: 'E' put: (NSScale linear
				           domain: #( 100 4000 );
				           range: #( 1 5 ));
			          yourself ].
	^ scales
]

{ #category : #running }
DPPlotter >> shapesFor: name given: integerOrStrings [
	^ name = 'F' 
	ifTrue: [ integerOrStrings collect: [ :str | 
			RSShapeFactory triangle 
				size: 5;
				color: (self colors at: str)
			 ] ]
	ifFalse: [ 
	integerOrStrings collect: [ :i |  
		RSShapeFactory ellipse 
			color: (self colors at: name);
			radius: ((self scales at: name) scale: i).
		 ] ]
]
