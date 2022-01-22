Class {
	#name : #DPHorizontalTick,
	#superclass : #RSHorizontalTick,
	#instVars : [
		'ticksData'
	],
	#category : #'DataPlotter-Plot'
}

{ #category : #rendering }
DPHorizontalTick >> createLabelFor: aValue index: index [
	"Create a label and returns it."
	| tick lbl |
	tick := self ticks at: index.
	lbl := self configuration createLabelFor: index.
	self color ifNotNil: [ lbl color: self color ].
	self labelLocation move: lbl on: tick.
	^ lbl
]

{ #category : #accessing }
DPHorizontalTick >> ticksData [

	niceLabel step isZero ifTrue: [ niceLabel step: 1 ].
	^ ticksData ifNil: [ niceLabel min to: niceLabel max by: niceLabel step ] ifNotNil: [ ticksData  ]
]

{ #category : #accessing }
DPHorizontalTick >> ticksData: collection [
	ticksData := collection 
]
