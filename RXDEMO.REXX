/* REXX  */
/* Main program */                              
say 'Generating random customer ID...'          
customer_id = generateCustomerID()              
say 'Unique customer ID generated:' customer_id 
exit                                            
                                                
/* Function to generate random number */        
generateCustomerID: procedure                   
  random_number = RANDOM(1000, 9999)            
  timestamp = TIME('S')                         
  customer_id = 'A' || random_number || timestamp
  return customer_id 
