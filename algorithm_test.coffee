require ["algorithm"], (Algorithm) ->

  test "Algoritm:compute_forget_timestamp", ->
      a = new Algorithm()
      a.counter = 1
      a.last_tried_counter = 0
      a.timestamp = 6
      a.last_tried_at = 0
      equal a.compute_forget_timestamp_delta(), 10
    
      a = new Algorithm()
      a.counter = 1
      a.last_tried_counter = 0
      a.timestamp = 11
      a.last_tried_at = 0
      equal a.compute_forget_timestamp_delta(), 11
    
  test "Algoritm:estimate_short_term", ->
      a = new Algorithm()
      a.failed_tries = 0
      ok a.estimate_short_term(100000) < 1
      ok a.estimate_short_term(100000) >= 0

    
  test "Algoritm:algorithm", ->
      a = new Algorithm()
      a.logging = false

      # Empty < 0.3

      a.success_after(0, 0)
      a.success_after(10, 1)

      # Instant retry of success > 0.5
      ok a.last_estimated_knowledge >  0.5
      ok a.predict_at 10, 1 > 0.5
      ok a.predict_at 1000, 2 < 0.5
      ok a.predict_at 11, 1000 < 0.5
      ok a.predict_at 10, 1 > 0.5
      a = new Algorithm()
      a.logging = false


      a.fail_after(0, 0)
      ok a.predict_at(1, 1) > 0.1
      a.success_after(10, 1)
      a.success_after(2*24*60*60, 1)
      # Failure, success, retry after 2 days < 0.6
      ok a.last_estimated_knowledge < 0.6
        
      a = new Algorithm()
      a.logging = false

      a.fail_after(0, 0)
      a.success_after(10, 1)
      a.success_after(24*60*60, 1)
      a.success_after(24*60*60, 1)
      a.success_after(24*60*60, 1)
      # Failure, success, success after 1 day, success after 1 more day, after 1 more day > 0.8
      ok a.last_estimated_knowledge > 0.8
  
