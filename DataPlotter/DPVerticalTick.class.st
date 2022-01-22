Class {
	#name : #DPVerticalTick,
	#superclass : #RSVerticalTick,
	#category : #'DataPlotter-Plot'
}

{ #category : #rendering }
DPVerticalTick >> createLabelFor: aValue index: index [

	"Create a label and returns it."

	| tick lbl |
	tick := self ticks at: index.
	lbl := self configuration createLabelFor: index.
	self color ifNotNil: [ lbl color: self color ].
	self labelLocation move: lbl on: tick.
	^ lbl
]
