Class {
	#name : #DPBarPlot,
	#superclass : #RSBarPlot,
	#instVars : [
		'colors'
	],
	#category : #'DataPlotter-Plot'
}

{ #category : #accessing }
DPBarPlot >> colors: collection [
	colors := collection 
]

{ #category : #rendering }
DPBarPlot >> createBarFor: aPoint index: index [

	^ self shape copy
		  model: (self modelFor: aPoint);
		  color: (colors ifNil: [self computeColor] ifNotNil: [ colors at: index ]);
		  fromRectangle: (self computeRectagleFor: aPoint index: index);
		  yourself
]
