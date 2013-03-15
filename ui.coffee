require ['spanish', 'db', 'scheduler'], (spanish, db, Scheduler) ->

  now = -> new Date().getTime() / 1000
  # -------------------- UI -------------------------
  app = angular.module 'myapp', ['ui']

  app.controller "MainCtrl", ($scope) ->
      $scope.verbs = spanish.regularVerbs
      $scope.showTests = false
      $scope.logs = []
      allPossibleFeatures = spanish.allPossibleFeatures()
      scheduler = new Scheduler(allPossibleFeatures)
      $scope.ask = () ->
          best = scheduler.best(now())
          $scope.features = best.features
          ss = spanish.sentences($scope.features)
          if $scope.features.reverse
            $scope.originalLanguage = 'Spanish'
            $scope.targetLanguage = 'English'
          else
            $scope.originalLanguage = 'English'
            $scope.targetLanguage = 'Spanish'
          $scope.originalSentence = ss[0]    
          $scope.targetSentence = ss[1]
          $scope.targetShown = false
      $scope.set = (h) ->
        for key of h
          $scope[key] = h[key]
      setResults = (results) ->
          $scope.logs = results


      setSchedulerAndResults = (results) ->
        $scope.$apply ->
          setResults(results)
          for result in results
            scheduler.userEvent(JSON.parse(result.properties))
          $scope.benchmark = scheduler.benchmark()
          $scope.ask()
      $scope.pressed = (good) ->
        features = $scope.features
        result = {
                  features: $scope.features, good: good, originalSentence: $scope.originalSentence,
                  targetSentence: $scope.targetSentence, timestamp: now()
                  }
        db.spanishLog(JSON.stringify(result), result.timestamp, setResults)
        scheduler.userEvent(result)
        $scope.benchmark = scheduler.benchmark()
        $scope.ask()
      db.showLogs setSchedulerAndResults

  $ ->            
    angular.bootstrap document, ["myapp"]

# Web server: C:\downloads\tinyweb>tiny c:\Users\Adam\Documents\GitHub\spanishverbs 8000

# TODO:
# Try on mobile phone using a web server / copying files
# Faster loading
# Generate reference card
# ?Make database of sentence pairs, feature sets and features for prediction state
# ?Port new word algorithms from Ruby to JS or pure SQL

# DONE:
# Make sentence pairs from features

 