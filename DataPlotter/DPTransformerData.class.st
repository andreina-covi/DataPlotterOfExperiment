Class {
	#name : #DPTransformerData,
	#superclass : #Object,
	#category : #'DataPlotter-Core'
}

{ #category : #adding }
DPTransformerData >> add: collection to: data [

	| dict obj |
	self assert: collection size == 4.
	data ifEmpty: [ data add: Dictionary new ].
	dict := data last.
	dict at: 'changes' ifAbsentPut: [ OrderedCollection new ].
	obj := collection second.
	(dict at: 'changes') add: collection first -> ([ obj asNumber ]
			 on: Error
			 do: [ obj ]).
	collection third = 'yes' ifFalse: [ ^ self ].
	dict
		at: 'components'
		put: (collection fourth splitOn: ' ') asOrderedCollection.
	data add: Dictionary new
]

{ #category : #accessing }
DPTransformerData >> transform: filename [

	^ self transformData: (self transformCSVOnCollection: filename)
]

{ #category : #'as yet unclassified' }
DPTransformerData >> transformCSVOnCollection: filename [

	| file csvReader res stream |
	file := filename asFileReference.
	self assert: file exists.
	stream := file readStream.
	csvReader := NeoCSVReader on: stream.
	res := csvReader
		  skipHeader;
		  addField;
		  addField;
		  addField;
		  addField;
		  upToEnd.
	stream close.
	^ res
]

{ #category : #'as yet unclassified' }
DPTransformerData >> transformData: collection [
	| data |
	data := OrderedCollection new.
	collection do: [ :col | 
		self add: col to: data
	].
	^ data
]
