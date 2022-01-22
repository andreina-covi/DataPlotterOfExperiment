Class {
	#name : #DPPersonalizedPlot,
	#superclass : #RSAbstractPlot,
	#instVars : [
		'personalizedShapes'
	],
	#category : #'DataPlotter-Plot'
}

{ #category : #accessing }
DPPersonalizedPlot >> createdShapes [

	^ personalizedShapes 
]

{ #category : #initialization }
DPPersonalizedPlot >> defaultShape [

	^ RSEllipse new noPaint
]

{ #category : #accessing }
DPPersonalizedPlot >> personalizedShapes [

	personalizedShapes ifNil: [ | color |
		color := self computeColor.
		personalizedShapes := (1 to: xValues size)
		            collect: [ :notUsed | 
			            self shape copy
				            radius: 2;
				            color: color ]
		            as: RSGroup.
		 ].
	^ personalizedShapes 
]

{ #category : #accessing }
DPPersonalizedPlot >> personalizedShapes: shapes [ 
	personalizedShapes := shapes
]

{ #category : #rendering }
DPPersonalizedPlot >> renderIn: canvas [

	
	self checkAssertion.
	personalizedShapes := self personalizedShapes.
	xValues doWithIndex: [ :xt :i |  | newPoint yt et |
		et := personalizedShapes at: i.
		yt := yValues at: i.
		newPoint := self scalePoint: xt @ yt.
		(self isPointWellDefined: newPoint) ifTrue: [ 
			et model: xt @ yt.
			et translateTo: newPoint.
			canvas add: et ] ]
]
