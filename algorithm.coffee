define "algorithm", ['linear_interpolator'], (LinearInterpolator) ->
  # Algorithm in SQL and Ruby (the Ruby version can be used for tuning and testing)
  class Algorithm
  
    log: (x) ->
      alert(x) if @logging
    
    compute_forget_timestamp_delta: ->
        counter_delta = @counter-@last_tried_counter
        timestamp_delta = @timestamp-@last_tried_at
        # Waiting 10 seconds withouth doing anything is about as effective for forgetting
        # as answering something.
        if counter_delta*10 > timestamp_delta

          forget_timestamp_delta = counter_delta * 10
        else
          forget_timestamp_delta = timestamp_delta
        return forget_timestamp_delta    


    estimate_short_term: (forget_timestamp_delta) ->
        # Compute short term memory
        if @failed_tries < 0.1
          last_short_term = 0.99
        else
          last_short_term = 0.95

        short_term_virtual_counter_delta = forget_timestamp_delta / 10.0 +
          @inverse_short_memory_table.at(last_short_term)
        @estimated_short_term = @short_memory_table.at(short_term_virtual_counter_delta)
        return @estimated_short_term
    
      estimate_long_term: (forget_timestamp_delta) ->
        long_term_virtual_counter_delta = forget_timestamp_delta / 10.0 / @forgetting_time +      
          @inverse_long_memory_table.at(@long_term_after_result)
        @last_estimated_long_term = @long_memory_table.at(long_term_virtual_counter_delta)
        @log({
          last_estimated_long_term : @last_estimated_long_term,
          inv : @inverse_long_memory_table.at(@long_term_after_result),
          long_term_virtual_counter_delta: long_term_virtual_counter_delta,
          long_term_after_result: @long_term_after_result
          })
        return @last_estimated_long_term
      
      normalize: (x) ->
        return 0 if x < 0.0
        return 1 if x > 1.0
        return x
      
      update_long_term: ->
        if @estimated_short_term + @last_estimated_long_term > 1
          @estimated_short_term = 1 - @last_estimated_long_term
        
        if @failed_tries < 0.1
          @long_term_after_result = @normalize(0.95 - @estimated_short_term + @last_estimated_long_term * 0.05)
        else
          @long_term_after_result =  @normalize(@last_estimated_long_term / 2.0)
        
        @forgetting_time *= (1 - @last_estimated_long_term) / (1 - @long_term_after_result)
      
      algorithm: ->
        @log @last_tried_counter
        if @failed_tries == null
          @log "first"
          @estimated_short_term = 0.0
          @forgetting_time = 1.0
          @last_estimated_long_term = 0.0
          return 0.2
        
        # Use the information from last success / failure
        @update_long_term()
        @log "after_update_long_term: " + {forgetting_time : @forgetting_time, long_term_after_result : @long_term_after_result}.inspect
        forget_timestamp_delta = @compute_forget_timestamp_delta()
        @estimated_short_term = @estimate_short_term(forget_timestamp_delta)
        @estimate_long_term(forget_timestamp_delta)
        @last_estimated_knowledge = @normalize(@last_estimated_long_term + @estimated_short_term)
        
        @log {
          timestamp: @timestamp,
          forget_timestamp_delta : forget_timestamp_delta,
          estimated_short_term : @estimated_short_term,
          last_estimated_knowledge : @last_estimated_knowledge
        }
        return @last_estimated_knowledge

      # params can be used for tuning parameters for evaluation
      constructor: (params={}) ->
        @counter = 0
        @timestamp = 0
        @confidence = 0
        @last_tried_counter = null
        @last_tried_at = null
        @failed_tries = null
        @last_estimated_knowledge = null
        @last_estimated_long_term = null

        @logging = params["logging"]

        @short_memory_table = new LinearInterpolator({
          0: 1, 1 : 0.9, 5 : 0.7, 7 : 0.2, 10 : 0.01, 100 : 0.001,
          100000 : 0
        })
        
        @inverse_short_memory_table = new LinearInterpolator({
          1: 0, 0.9 : 1, 0.7 : 5, 0.2 : 7, 0.01 : 10, 0.0001 : 100,
          0 : 100000
        })
           
        @long_memory_table = new LinearInterpolator({
              0: 1,
              100000 : 0.99, 
              1100000 : 0.98,
              1110000 : 0.95,
              1111000 : 0.1,
              10000000000 : 0,
            })
                
        @inverse_long_memory_table = new LinearInterpolator({
              1 : 0,
              0.99 : 100000, 
              0.98 : 1100000,
              0.95 : 1110000,
              0.1 : 1111000,
              0 : 10000000000,
            })

      predict_at: (timestamp, counter) ->
        @timestamp = timestamp
        @counter = counter
        @algorithm()
      
      fail_after: (timestamp_delta, counter_delta) ->
        @fail_at(@timestamp + timestamp_delta, @counter + counter_delta)
      
      fail_at: (timestamp, counter, strength=1) ->
        @counter = counter
        @timestamp = timestamp
        @last_estimated_knowledge = @algorithm()
        @failed_tries ||= 0
        @failed_tries += strength
        @after_algorithm()
      
      success_after: (timestamp_delta, counter_delta) ->
        @success_at(@timestamp + timestamp_delta, @counter + counter_delta)
      
      success_at: (timestamp, counter, strength=1) ->
        @counter = counter
        @timestamp = timestamp
        @last_estimated_knowledge = @algorithm()
        @failed_tries *= 1-strength
        @after_algorithm()
      
      update: (score, timestamp, counter, strength=1) ->
        @counter = counter
        @timestamp = timestamp
        @last_estimated_knowledge = @algorithm()
        @failed_tries ||= 0
        @failed_tries += (1-score) * strength - score * @failed_tries * strength
        @confidence += strength
        @after_algorithm()
      

      after_algorithm: ->
        @last_tried_at = @timestamp
        @last_tried_counter = @counter
      
      
      sql_algorithm: (counter, timestamp) ->
        counter_delta = "(#{counter}-last_tried_counter)"
        timestamp_delta = "(#{timestamp}-last_tried_at)"
        forget_timestamp = "(#{counter_delta}*60 > #{timestamp_delta}) ? (#{counter_delta} * 60) : #{timestamp_delta}"
        forget_multiplier = "1 / log(#{timestamp_delta}/60/60/24)"
        return "(failed_tries is NULL) ? 0.2 : ((falied_tries > 0) ? last_estimated_knowledge : sqrt(last_estimated_knowledge)) * #{forget_multipier})"
