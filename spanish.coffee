# ------------------------------ SPANISH ---------------------------------
vtype = (verb) -> 
  verb.substr(-2, 2)
    
base = (verb) ->
  verb.substr(0, verb.length - 2)

gerund = (verb) ->
  if (vtype(verb) == 'ar')
        base(verb) + 'ando'
  else
       base(verb) + 'iendo'


pastParticipleBase = (verb) ->
  if (vtype(verb) == 'ar')
        base(verb) + 'ad'
  else
       base(verb) + 'id'
        
# Befejezett melléknévi igenév        
participo = (verb) ->
  pastParticipleBase(verb) + 'o'
            
spanishIndicatives = {
                0: ['yo'],
                1: ['tú'],
                2 : ['él',
                'ella',
                'usted'],
                3 : ['nosotros',
                'nosotras'],
                4: ['vosotros',
                'vosotras'],
                5 : ['ellos',
                'ellas',
                'ustedes']
                }

englishIndicative = {
                     0 : ['I'],
                     1: ['you'],
                     2: ['he', 'she', 'it', 'you (inf)']
                     3: ['we'],
                     4: ['you all'],
                     5: ['they', 'you all (inf)']
                     }

translationFromEnglish =  {
                           'I': 'yo',
                           'you': 'tú',
                           'he': 'él',
                           'she': 'ella',
                           'it': '',
                           'you (inf)': 'usted',
                           'we': 'nosotros / nosotras',
                           'you all': 'vosotros / vosotras',
                           'they': 'ellos / ellas',
                           'you all (inf)': 'ustedes',
                           'speak': 'hablar',
                           'eat': 'comer',
                           'live': 'vivir',
                           'love': 'amar',
                           'split': 'partir',
                           'study': 'estudiar',
                           'talk': 'hablar',
                           'enter': 'entrar'
}

present = (verb, tense) ->
    if (verb == 'ir')
        return ['voy', 'vas', 'va', 'vamos', 'vais', 'van'][tense]
    if (verb == 'haber')
        return ['he', 'has', 'ha', 'hemos', 'habéis', 'han'][tense]
    base(verb) + {
                  'ar': ['o', 'as', 'a', 'amos', 'áis', 'an'],
                  'er': ['o', 'es', 'e', 'emos', 'éis', 'en'],
                  'ir': ['o', 'es', 'e', 'imos', 'ís', 'en']
                  }[vtype(verb)][tense]


imperfect = (verb, tense) ->
    base(verb) + {
                  'ar': ['aba', 'abas', 'aba', 'ábamos', 'abais', 'aban'],
                  'er': ['ía', 'ías', 'ía', 'íamos', 'íais', 'ían'],
                  'ir':  ['ía', 'ías', 'ía', 'íamos', 'íais', 'ían']
                  }[vtype(verb)][tense]


preterite = (verb, tense) ->
    if (verb == 'ir' || verb == 'ser')
        return ['fui', 'fuiste', 'fue', 'fuimos', 'fuisteis', 'fueron'][tense]
    base(verb) + {
                  'ar': ['é', 'aste', 'ó', 'amos', 'asteis', 'aron'],
                  'er': ['í', 'iste', 'ió', 'imos', 'isteis', 'ieron'],
                  'ir':  ['í', 'iste', 'ió', 'imos', 'isteis', 'ieron']
                  }[vtype(verb)][tense]
        

imperative = (verb, tense) ->
    base(verb) + {
                  'ar': ['', 'a', 'e', 'emos', 'ad', 'en'],
                  'er': ['', 'e', 'a', 'amos', 'ed', 'an'],
                  'ir':  ['', 'e', 'a', 'amos', 'id', 'an'],
                  }[vtype(verb)][tense]


negativeImperative = (verb, tense) ->
    base(verb) + {
                  'ar': ['', 'es', 'e', 'emos', 'éis', 'en'],
                  'er': ['', 'as', 'a', 'amos', 'áís', 'an'],
                  'ir':  ['', 'as', 'a', 'amos', 'áis', 'an'],
                  }[vtype(verb)][tense]
    
future = (verb, tense) ->
    exceptions = {
                  'querer': 'querr', 'haber': 'habr', 'saber': 'sabr', 'poder': 'podr',
                  'caber': 'cabr', 'hacer': 'har', 'decir': 'dir', 'poner': 'pondr', 'venir': 'vendr',
                  'tener': 'tendr', 'salir': 'saldr', 'valer': 'valdr'
                  }
    if exceptions[verb]
        verbMod = exceptions[verb]
    else
        verbMod = verb
    verbMod +  ['é', 'ás', 'á', 'emos', 'éis', 'án'][tense]
        

conditional = (verb, tense) ->
    exceptions = {
                  'querer': 'querr', 'haber': 'habr', 'saber': 'sabr', 'poder': 'podr',
                  'caber': 'cabr', 'hacer': 'har', 'decir': 'dir', 'poner': 'pondr', 'venir': 'vendr',
                  'tener': 'tendr', 'salir': 'saldr', 'valer': 'valdr'
                  }
    if exceptions[verb]
        verbMod = exceptions[verb]
    else
        verbMod = verb
    verbMod + ['ía', 'ías', 'ía', 'íamos', 'íais', 'ían'][tense]
       
        
englishs = (verb) ->
  if (verb == 'have')
        'has'
  else
      verb + 's'

pastEnglish = (verb, person) ->
  if (verb == 'be')
        return ['was', 'were', 'was', 'were', 'were', 'were'][person]
  exceptions = {'speak' : 'spoke', 'eat': 'ate', 'split' : 'split', 'love' : 'loved'}
  if exceptions[verb]
        exceptions[verb]
  else
            verb + 'ed'


perfectEnglish = (verb) ->
  exceptions = {'speak' : 'spoken', 'eat': 'eaten', 'split' : 'split', 'love' : 'loved'}
  if exceptions[verb]
        exceptions[verb]
  else
            verb + 'ed'

presentEnglish = (verb, person) ->
            if (verb == 'be')
              a = ['am', 'are', 'is', 'are', 'are', 'are']
              a[person]
            else if (person == '2')
                englishs(verb)
            else
                verb
                
String::capitalize = -> @substr(0, 1).toUpperCase() + @substr(1)
continuousEnglish = (verb) ->
    verb + 'ing'

sentences = (features) ->
    englishI = englishIndicative[features['person']][0]
    spanishI = translationFromEnglish[englishI]
    reverseIfNecessary = (a) ->
      if (features['reverse'])
            [a[1], a[0]]
      else
          a
    if !features['verb']
        reverseIfNecessary([englishI, spanishI])
    else
        verbENoConj = features['verb']
        verbSNoConj = translationFromEnglish[verbENoConj]
        if features['tense'] == 'imperative'
             return reverseIfNecessary([verbENoConj.capitalize() + '!',
                 imperative(verbSNoConj, features['person']).capitalize() + '!'])
        if features['tense'] == 'negative imperative'
             return reverseIfNecessary(['Do not ' + verbENoConj + '!',
                 'No ' + negativeImperative(verbSNoConj, features['person']) + '!'])

        if features['tense'] == 'simple past'
            verbE = pastEnglish(verbENoConj, features['person'])
            verbS = preterite(verbSNoConj, features['person'])
        else if features['tense'] == 'going to'
            verbE =  presentEnglish('be', features['person']) + ' going to ' + verbENoConj
            verbS = present('ir', features['person']) + ' a ' + verbSNoConj
        else if features['tense'] == 'present perfect'
            verbE =  presentEnglish('have', features['person']) + ' ' + perfectEnglish(verbENoConj)
            verbS = present('haber', features['person']) +
                            ' ' + participo(verbSNoConj)
        
        else if features['tense'] == 'past continuous'
            verbE =  pastEnglish('be', features['person']) + ' ' + continuousEnglish(verbENoConj)
            verbS = imperfect(verbSNoConj, features['person'])
        else if features['tense'] == 'past perfect continuous'
            verbE =  presentEnglish('have', features['person']) + ' been ' + continuousEnglish(verbENoConj)
            verbS = imperfect('haber', features['person']) + ' ' + participo(verbSNoConj)
        else if features['tense'] == 'future simple'
            verbE =  'will ' + verbENoConj
            verbS = future(verbSNoConj, features['person'])
        else if features['tense'] == 'future perfect'
            verbE =  'will have ' + perfectEnglish(verbENoConj)
            verbS = future('haber', features['person']) + ' ' + participo(verbSNoConj)
        else if features['tense'] == 'conditional'
            verbE =  'would ' + verbENoConj
            verbS = conditional(verbSNoConj, features['person'])
        else
            verbE = presentEnglish(verbENoConj, features['person'])
            verbS = present(verbSNoConj, features['person'])
        if features['hidei']
                reverseIfNecessary([englishI.capitalize() + ' ' + verbE + '.',
                 verbS.capitalize() + '.'])
        else
                reverseIfNecessary([englishI.capitalize() + ' ' + verbE + '.',
                 spanishI.capitalize() + ' ' + verbS + '.'])
        
        
test "sentences", () ->
    equal JSON.stringify(
         sentences({'person' : '0'})), '["I","yo"]'
    equal JSON.stringify(
        sentences({'tense' : 'present', 'verb' : 'speak', 'person' : '0'})),
        '["I speak.","Yo hablo."]'
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
