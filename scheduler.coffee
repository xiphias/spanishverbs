define "scheduler", ['algorithm'], (Algoritm) ->
	class Scheduler
		mapToKey: (m) ->
			JSON.stringify(_.map(_.keys(m).sort(), (x) -> [x, m[x]]))

		constructor: (allPossibilities) ->
			@allPossibilities = allPossibilities
			@stats = {}
			@counter = 0
			@numEvents = 0
			@squaredError = 0.0
			@probCache = {}
			@subKeys = {}  # Subkeys for a key are arrays of [subKeyFeatures, subKeyKey] arrays

		# Root Average Mean Square Prediction Error 
		benchmark: ->
			Math.sqrt(@squaredError / @numEvents)


		getOrNewAlgoritm: (features) ->
			key = @mapToKey(features)
			if not @stats[key]
				@stats[key] = new Algoritm()
			algorithm = @stats[key]

		# TODO: implement partial features
		userEvent: (event) ->
			@counter += 1
			features = event.features
			if not features
				#alert("no features for event " + JSON.stringify(event))
				return
			prob = @probability(features, event.timestamp)
			goodValue = event.good ? 1 : 0
			@squaredError += (goodValue - prob)*(goodValue - prob)
			@numEvents += 1
			@probCache = {}

			#algorithm = @getOrNewAlgoritm(features)
			#algorithm.update(goodValue, @counter, event.timestamp)

			s = maxs = _.keys(features).length
			featuresWithSize = {}
			featuresWithSize[s] = [[features, @mapToKey(features), goodValue, 1]]
			while s > 0
				smallerFeatures = {}
				for [currentFeatures, currentKey, currentGoodValue] in featuresWithSize[s]
					algorithm = @getOrNewAlgoritm(currentFeatures)
					strength = Math.pow(s/maxs + 0.000001, 0.6)
					strength2 = Math.pow(s/maxs + 0.000001, -0.5)
					value2 = (goodValue - 0.5) * strength2 + 0.5
					algorithm.update(value2, @counter, event.timestamp, strength)
					for [smallerFeature, newKey] in @getSubKeys(currentFeatures, currentKey)
						if not smallerFeatures[newKey]
							smallerFeatures[newKey] = [smallerFeature, newKey, goodValue, 1]
						else
							smallerFeatures[newKey][3] += 1
							if currentGoodValue
								smallerFeatures[newKey][2] += 1
				s -= 1
				featuresWithSize[s] = _.values(smallerFeatures)

		getSubKeys: (features, key) ->
			allSubKeyPairs = @subKeys[key]
			if not allSubKeyPairs
				allSubKeyPairs = []
				for takeFeature in _.keys(features)
					takenValue = features[takeFeature]
					delete features[takeFeature]
					allSubKeyPairs.push([_.clone(features), @mapToKey(features)])
					features[takeFeature] = takenValue
				@subKeys[key] = allSubKeyPairs
			return allSubKeyPairs

		probabilityWithConfidence: (features, timestamp, key) ->
			key ?= @mapToKey(features)
			if @probCache[key]
				return @probCache[key]
			
			sum = 0.0
			sum2 = 0.0
			sum2p = 0.5
			product = 1.0
			n = 0
			origN = 0
			r = [0, 0]

			if @stats[key]
				r = [@stats[key].predict_at(@counter + 1, timestamp), @stats[key].confidence]
				@probCache[key] = r
				#prob = r[0]
				#conf = r[1]
				#count = conf * 100

				#sum += prob * count
				#n += count
				#origN += 1 
			
			for subKeyPair in @getSubKeys(features, key)
				probWithConf = @probabilityWithConfidence(subKeyPair[0], timestamp, subKeyPair[1])
				prob = probWithConf[0]
				conf = probWithConf[1]
				count = Math.pow(conf, 0.2)
				sum += prob * count
				#sum2 += Math.pow(prob, sum2p)
				#product *= prob
				n += count
				origN += 1

			if n == 0
				r2 = [0, 0]
			else
				#r =  Math.pow(product, (1.0 / n))
				#r = (Math.pow(product, (1.0 / n)) * 1.0/ 10) + (9.0/10 * sum / n)
				r2 = [0.9 * sum / n, Math.pow(origN / n, -10)/2]
				#r = 0.9 * Math.pow(sum2 / n, 1.0/sum2p)
			if r[1] == 0
				r3 = r2
			else if r[1] < 1  and r2[1] > 0.9
			    r3 = [(r2[0]+r[0])/2, r[1]]
			else
				r3 = r
			@probCache[key] = r3
			return r3


		probability: (features, timestamp, key) ->
			@probabilityWithConfidence(features, timestamp, key)[0]


		# Returns the features of the best result with its' probability
		best: (timestamp) ->
			best = @allPossibilities[0]
			bestProbability = @probability(best, timestamp)

			for possibility in @allPossibilities
				probability = @probability(possibility, timestamp)

				if probability < 0.8
					if bestProbability > 0.8 or bestProbability < probability
						best = possibility
						bestProbability = probability
				else
					if probability < bestProbability
						best = possibility
						bestProbability = probability
			return {features: best, probability: bestProbability}
