require ['spanish'], (spanish) ->
    sentences = spanish.sentences
    test "sentences", () ->
        equal JSON.stringify(
             sentences({'person' : '0'})), '["I","yo"]'
        equal JSON.stringify(
            sentences({'tense' : 'present', 'verb' : 'speak', 'person' : '0'})),
            '["I speak.","Yo hablo."]'
        equal JSON.stringify(
            sentences({'tense' : 'present', 'verb' : 'speak', 'person' : 2, 'hidei': true, 'reverse': true})),
            '["Habla.","He speaks."]'
        equal JSON.stringify(
            sentences({'tense' : 'simple past', 'verb' : 'speak', 'person' : '2'})),
            '["He spoke.","Él habló."]'
        equal JSON.stringify(
            sentences({'tense' : 'going to', 'verb' : 'speak', 'person' : '1'})),
            '["You are going to speak.","Tú vas a hablar."]'
        equal JSON.stringify(
            sentences({'tense' : 'going to', 'verb' : 'speak', 'person' : '1', 'hidei': 'true'})),
            '["You are going to speak.","Vas a hablar."]'    
        equal JSON.stringify(
            sentences({'tense' : 'present perfect', 'verb' : 'eat', 'person' : '0'})),
            '["I have eaten.","Yo he comido."]'
        equal JSON.stringify(
            sentences({'tense' : 'past continuous', 'verb' : 'eat', 'person' : '2'})),
            '["He was eating.","Él comía."]'
        equal JSON.stringify(
            sentences({'tense' : 'past continuous', 'verb' : 'live', 'person' : '2'})),
            '["He was living.","Él vivía."]'

        equal JSON.stringify(
            sentences({'tense' : 'past perfect continuous', 'verb' : 'study', 'person' : '1'})),
            '["You have been studying.","Tú habías estudiado."]'
        equal JSON.stringify(
            sentences({'tense' : 'future simple', 'verb' : 'talk', 'person' : '1'})),
            '["You will talk.","Tú hablarás."]'    
        equal JSON.stringify(
            sentences({'tense' : 'future perfect', 'verb' : 'talk', 'person' : '1'})),
            '["You will have talked.","Tú habrás hablado."]'  
        equal JSON.stringify(
            sentences({'tense' : 'conditional', 'verb' : 'talk', 'person' : '1'})),
            '["You would talk.","Tú hablarías."]'
         equal JSON.stringify(
            sentences({'tense' : 'imperative', 'verb' : 'enter', 'person' : '1'})),
            '["Enter!","Entra!"]' 
          equal JSON.stringify(
            sentences({'tense' : 'negative imperative', 'verb' : 'enter', 'person' : '1'})),
            '["Do not enter!","No entres!"]' 
          equal JSON.stringify(
            sentences({'tense' : 'negative imperative', 'verb' : 'enter', 'person' : '1', 'reverse': true})),
            '["No entres!","Do not enter!"]' 

